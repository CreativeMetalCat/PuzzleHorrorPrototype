import PickupableObject.StaticMeshPickableObject;
import PickupableObject.Key;

class ALockBase:AStaticMeshPickapableObject
{
    default Mesh.StaticMesh = Asset("/Game/locks/lock.lock");

    UPROPERTY()
    bool Locked = true;

     UPROPERTY()
     int KeyId=0;

    UPROPERTY(DefaultComponent)
    UAudioComponent OpenSound;
    default OpenSound.AutoActivate=false;
    default OpenSound.Sound = Asset("/Game/Sounds/Lock/lock_open.lock_open");


    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        if(Locked)
        {
            CanBePickedUp=false;
            Mesh.SimulatePhysics=false;
        }
        else
        {
             Mesh.SimulatePhysics=true;
             CanBePickedUp=true;
        }
    }

    UFUNCTION(BlueprintOverride)
    void OnInteraction(AActor Interactor, UActorComponent InteractedComponent) override
    {
        if(Locked)
        {
            if(Cast<AKey>(Interactor)!=nullptr)
            {
                int id = Cast<AKey>(Interactor).KeyId;
                if(id==KeyId||id==-1)
                {
                    Locked=false;
                    OpenSound.Play();
                    CanBePickedUp=true;
                    Mesh.SimulatePhysics=true;
                }
            }
        }
    }
}