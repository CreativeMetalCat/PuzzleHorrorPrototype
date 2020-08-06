import PickupableObject.PickupableObject;

class AStaticMeshPickapableObject:APickuableObjectBase
{
    UPROPERTY(DefaultComponent, RootComponent)
    UStaticMeshComponent Mesh;
    default Mesh.StaticMesh = Asset("/Engine/BasicShapes/Cone.Cone");
    default Mesh.SimulatePhysics=true;

    UFUNCTION(BlueprintOverride)
    void BePickedUp() override
    {
         SetActorEnableCollision(false);
         Mesh.SimulatePhysics=false;
    }

    UFUNCTION(BlueprintOverride)
    bool BeUsed() override
    {
        return true;
    }

    UFUNCTION(BlueprintOverride)
    void BeDropped() override
    {
        SetActorEnableCollision(true);
        Mesh.SimulatePhysics=true;
    }

      UFUNCTION(BlueprintOverride)
    void OnInteraction(AActor Interactor, UActorComponent InteractedComponent) override
    {
        
    }
}