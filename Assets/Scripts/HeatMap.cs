using UnityEngine;

public class HeatMap : MonoBehaviour
{
    private Material material;

    public Cities cities;

    private void Start()
    {
        material = GetComponent<MeshRenderer>().material;
    }

    private void Update()
    {
        material.SetInt("_Points_Length", cities.Count());
        material.SetVectorArray("_Points", cities.GetCityCenters());
        material.SetFloatArray("_Radiuses", cities.GetCityRadiuses());
    }
}