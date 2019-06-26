using UnityEngine;

public class HeatMap : MonoBehaviour
{
    public Cities Cities;

    public float Strength;
    
    private Material material;

    private void Start()
    {
        material = GetComponent<MeshRenderer>().material;
    }

    private void Update()
    {
        material.SetInt("_Points_Length", Cities.Count());
        material.SetFloat("_Strength", Strength);
        material.SetVectorArray("_Points", Cities.GetCityCenters());
        material.SetFloatArray("_Radiuses", Cities.GetCityRadiuses());
    }
}