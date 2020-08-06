import PickupableObject.StaticMeshPickableObject;

class APhone : AStaticMeshPickapableObject
{
    default Mesh.StaticMesh = Asset("/Game/ScienceLab/Meshes/OfficeProps/SM_Phone.SM_Phone");

    UPROPERTY(DefaultComponent)
    UAudioComponent Sound;
    default Sound.Sound = Asset("/Game/Sounds/Radio/scpradio0.scpradio0");
    default Sound.AutoActivate=false;

    default Sound.AttenuationSettings = Asset("/Game/SuperGrid/TutorialLevel/SoundEffects/Attenuation_Ambient.Attenuation_Ambient");

    UFUNCTION(BlueprintOverride)
    bool BeUsed() override
    {
        Print("Phoning");
        if(!Sound.IsPlaying())
        {
            Sound.Play();
        }
        else
        {
            Sound.Stop();
        }
        return true;
    }

    UFUNCTION(BlueprintOverride)
    void OnInteraction(AActor Interactor, UActorComponent InteractedComponent) override
    {
         if(!Sound.IsPlaying())
        {
            Sound.Play();
        }
        else
        {
            Sound.Stop();
        }
    }
}