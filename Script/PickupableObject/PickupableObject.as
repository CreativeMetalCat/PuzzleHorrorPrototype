import InteractableObjectBase;

/*This class does not have any Mesh Components or anything used to render it in world*/
/*They should only be picked up by classes inhering from AChracter, keyword should*/
class APickuableObjectBase:InteractableObjectBase
{

    //Actor that is currently holding this object
    UPROPERTY()
    AActor HoldingActor;

    UPROPERTY()
    FVector AttachmentLocationOffset;
    default AttachmentLocationOffset = FVector(0,0,0);

    UPROPERTY()
    FRotator AttachmentRotationOffset;

    UPROPERTY()
    bool CanBePickedUp=true;

    /*For interaction*/
    UPROPERTY()
    UCameraComponent PlayerCamera;


    UFUNCTION(BlueprintEvent)
    bool Pickup(ACharacter PickingActor,FString AttachmentBoneName)
    {
        this.AttachToActor(PickingActor, FName(AttachmentBoneName));
        return false;
    }

    UFUNCTION(BlueprintEvent)
    bool BeUsed()
    {
        return false;
    }

    UFUNCTION(BlueprintEvent)
    void BePickedUp()
    {
        SetActorEnableCollision(false);
    }

    UFUNCTION(BlueprintEvent)
    void BeDropped()
    {
        SetActorEnableCollision(true);
    }

    UFUNCTION(BlueprintOverride)
    void OnInteraction(AActor Interactor, UActorComponent InteractedComponent) override
    {
        
    }

}