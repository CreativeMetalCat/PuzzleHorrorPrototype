import InteractableObjectBase;
import PickupableObject.LockBase;

class ADoorBase:InteractableObjectBase
{
    UPROPERTY()
    ALockBase Lock;

    /*If true door will act as lock for itself*/
    UPROPERTY()
    bool SelfLock=false;

    UPROPERTY()
    int SelfLockKeyId=0;

    UPROPERTY()
    bool Locked=false;

    UPROPERTY()
    bool Opened=false;

    UPROPERTY()
    float MoveTime=1.2f;

     UPROPERTY(DefaultComponent)
    UAudioComponent MoveSound;
    default MoveSound.Sound = Asset("/Game/Sounds/hl2/doors/wood_move1.wood_move1");
    default MoveSound.AutoActivate=false;

    UPROPERTY(DefaultComponent)
    UAudioComponent MoveStopSound;
    default MoveStopSound.Sound = Asset("/Game/Sounds/hl2/doors/wood_stop1.wood_stop1");
    default MoveStopSound.AutoActivate=false;

    UPROPERTY(DefaultComponent)
    UAudioComponent LockedSound;
    default LockedSound.Sound = Asset("/Game/Sounds/hl2/doors/default_locked.default_locked");
    default LockedSound.AutoActivate=false;

    UPROPERTY(DefaultComponent)
    UAudioComponent UnLockedSound;
    default UnLockedSound.Sound = Asset("/Game/Sounds/Lock/lock_creaking.lock_creaking");
    default UnLockedSound.AutoActivate=false;


    FTimerHandle MovementTimer;
    
    UPROPERTY(DefaultComponent, RootComponent)
    UStaticMeshComponent Mesh;
    default Mesh.StaticMesh = Asset("/Game/ScienceLab/Meshes/Rooms/Doors/SM_Door01.SM_Door01");

    /* The overridden construction script will run when needed. */
	UFUNCTION(BlueprintOverride)
	void ConstructionScript()
	{
        /*If we have lock that means door must be locked*/
        if(Lock!=nullptr){Locked=true;}

		if(!Locked)
        {
            if(Opened)
            {
                Mesh.SetRelativeRotation(FRotator(0,90,0));
            }
            else
            {
                 Mesh.SetRelativeRotation(FRotator(0,0,0));
            }
        }
	}

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if(System::TimerExistsHandle(MovementTimer))
        {
            float Percent = System::GetTimerElapsedTimeHandle(MovementTimer)/MoveTime;
            if(Opened)
            {
                 Mesh.SetRelativeRotation(FRotator(0,90-(90*Percent),0));
            }
            else
            {
                Mesh.SetRelativeRotation(FRotator(0,90*Percent,0));
            }
        }
    }

    UFUNCTION()
    void Open()
    {
        if(Lock!=nullptr)
        {
            if(!Lock.Locked){Lock=nullptr;Locked=false;}
        }
        if(!System::TimerExistsHandle(MovementTimer))
        {
            if(!Locked)
            {
                MoveSound.Play();
                MovementTimer = System::SetTimer(this,n"FinishedMovement",MoveTime,false);
            }
            else
            {
                LockedSound.Play();
            }
        }
    }

     UFUNCTION()
     void FinishedMovement()
     {
         MoveStopSound.Play();
         Opened=!Opened;
     }

    UFUNCTION(BlueprintOverride)
    void OnInteraction(AActor Interactor, UActorComponent InteractedComponent) override
    {
        if(SelfLock&&Cast<AKey>(Interactor)!=nullptr)
        {
            int id = Cast<AKey>(Interactor).KeyId;
            if(id==SelfLockKeyId||id==-1)
            {
                Locked = false;
                UnLockedSound.Play();
            }
        }
        Open();
    }
}