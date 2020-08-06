import PickupableObject.PickupableObject;
import InteractableObjectBase;

class APlayer:ACharacter
{
    UPROPERTY(DefaultComponent)
    UCameraComponent PlayerCamera;
    default PlayerCamera.SetRelativeLocation(FVector(0,0,65));

    UPROPERTY(DefaultComponent,Attach=PlayerCamera)
    USceneComponent ObjectHoldingPoint;
    default ObjectHoldingPoint.SetRelativeLocation(FVector(50,30,-20));

     UPROPERTY(DefaultComponent,Attach=PlayerCamera)
    USceneComponent ObjectDropPoint;
    default ObjectDropPoint.SetRelativeLocation(FVector(90,10,40));

    default bUseControllerRotationPitch=true;
    // An input component that we will set up to handle input from the player 
    // that is possessing this pawn.
    UPROPERTY(DefaultComponent)
    UInputComponent ScriptInputComponent;

    UPROPERTY()
    APickuableObjectBase CurrentlyHeldItem;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
    SetupInput();
    }

    UFUNCTION()
    void SetupInput()
    {

        ScriptInputComponent.BindAxis(n"MoveForward", FInputAxisHandlerDynamicSignature(this, n"OnMoveForwardAxisChanged"));
        ScriptInputComponent.BindAxis(n"MoveRight", FInputAxisHandlerDynamicSignature(this, n"OnMoveRightAxisChanged"));

        ScriptInputComponent.BindAxis(n"LookUp", FInputAxisHandlerDynamicSignature(this, n"OnLookUp"));
        ScriptInputComponent.BindAxis(n"Turn", FInputAxisHandlerDynamicSignature(this, n"OnLookRight"));

        ScriptInputComponent.BindAction(n"Jump", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"OnJumpPressed"));
        ScriptInputComponent.BindAction(n"Interact", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"OnInteractPressed"));
        ScriptInputComponent.BindAction(n"DropItem", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"DropCurrentItem"));
        ScriptInputComponent.BindAction(n"UseObject", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"OnUseObject"));
         ScriptInputComponent.BindAction(n"PickUpItem", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"OnPickUpPressed"));
    }

    UFUNCTION()
    void OnMoveForwardAxisChanged(float AxisValue)
    {
        FRotator YawOnlyRotation = FRotator(0.0f, GetControlRotation().Yaw, 0.0f);

        AddMovementInput( YawOnlyRotation.GetForwardVector(), AxisValue);
    }

    UFUNCTION()
    void OnMoveRightAxisChanged(float AxisValue)
    {
        AddMovementInput(ControlRotation.RightVector, AxisValue);
    }

    UFUNCTION()
    void OnLookUp(float AxisValue)
    {
       AddControllerPitchInput(AxisValue);
    }

    
    UFUNCTION()
    void OnLookRight(float AxisValue)
    {
        AddControllerYawInput(AxisValue);
    }

    UFUNCTION()
    void OnUseObject(FKey key)
    {
        if(CurrentlyHeldItem!=nullptr)
        {
            CurrentlyHeldItem.BeUsed();
        }
    }

    UFUNCTION()
    void OnJumpPressed(FKey Key)
    {
        if(CanJump())
        {
            Jump();
        }
    }

 UFUNCTION()
    void OnPickUpPressed(FKey Key)
    {
        TArray<AActor> ToIgnore;
        ToIgnore.Add(this);
        FHitResult Hit;
        System::LineTraceSingle(PlayerCamera.GetWorldLocation(),PlayerCamera.GetWorldRotation().ForwardVector*600+PlayerCamera.GetWorldLocation(),ETraceTypeQuery::Camera,false,ToIgnore, EDrawDebugTrace::None,Hit,true);
        if(Hit.bBlockingHit)
        {      
            if(Hit.Actor!=nullptr)
            {
               if(CanPickupItem() && Cast<APickuableObjectBase>(Hit.Actor)!=nullptr)
               {
                   if(Cast<APickuableObjectBase>(Hit.Actor).CanBePickedUp)
                   { 
                       PickupItem(Cast<APickuableObjectBase>(Hit.Actor));       
                   }             
               }
            }
        }
    }

    UFUNCTION()
    void OnInteractPressed(FKey Key)
    {
        TArray<AActor> ToIgnore;
        ToIgnore.Add(this);
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
        
    }


    UFUNCTION()
    void PickupItem(APickuableObjectBase item)
    {
        item.BePickedUp();
        item.AttachToComponent(ObjectHoldingPoint);
        item.SetActorLocation(item.AttachmentLocationOffset+ObjectHoldingPoint.GetWorldLocation());
        item.PlayerCamera=PlayerCamera;
        item.HoldingActor=this;
        CurrentlyHeldItem=item;
    }

    UFUNCTION()
    void DropCurrentItem(FKey key)
    {
        if(CurrentlyHeldItem!=nullptr)
        {
            CurrentlyHeldItem.SetActorLocation(ObjectDropPoint.GetWorldLocation());
            CurrentlyHeldItem.DetachFromActor();          
            CurrentlyHeldItem.BeDropped();
            CurrentlyHeldItem.PlayerCamera=nullptr;
            CurrentlyHeldItem.HoldingActor=nullptr;
            CurrentlyHeldItem=nullptr;
        }
    }

    UFUNCTION(BlueprintPure)
    bool CanPickupItem()
    {
        return (CurrentlyHeldItem==nullptr);
    }
}