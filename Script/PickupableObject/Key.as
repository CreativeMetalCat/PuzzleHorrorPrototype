import PickupableObject.StaticMeshPickableObject;

class AKey:AStaticMeshPickapableObject
{
    default Mesh.StaticMesh = Asset("/Game/MP_Keys/Meshes/MSH_Key_07.MSH_Key_07");

    default AttachmentLocationOffset = FVector(0,20,0);

    /*Set it to -1 to open any lock*/
    UPROPERTY()
    int KeyId = 0;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Mesh.SetWorldScale3D(FVector(0.5f,0.5f,0.5f));
    }

    UFUNCTION(BlueprintOverride)
    bool BeUsed() override
    {
        if(HoldingActor!=nullptr&&PlayerCamera!=nullptr)
        {
            TArray<AActor> ToIgnore;
            ToIgnore.Add(this);
            ToIgnore.Add(HoldingActor);
            FHitResult Hit;
            System::LineTraceSingle(PlayerCamera.GetWorldLocation(),PlayerCamera.GetWorldRotation().ForwardVector*600+PlayerCamera.GetWorldLocation(),ETraceTypeQuery::Camera,false,ToIgnore, EDrawDebugTrace::None,Hit,true);
            if(Hit.bBlockingHit)
            {      
                if(Hit.Actor!=nullptr)
                {
                    if(Cast<InteractableObjectBase>(Hit.Actor)!=nullptr)
                    {
                        Cast<InteractableObjectBase>(Hit.Actor).OnInteraction(this, Hit.Component);
                    }
                }
            }
            return true;
        }
        else
        {
            return false;
        }
    }

}