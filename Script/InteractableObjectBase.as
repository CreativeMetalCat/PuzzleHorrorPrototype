class InteractableObjectBase:AActor
{
    UFUNCTION(BlueprintEvent)
    void OnInteraction(AActor Interactor,UActorComponent InteractedComponent){}
}