using System.Collections.Generic;
using UnityEngine;

public class Cities : MonoBehaviour
{
    private List<City> citiesList = new List<City>();

    private void Start()
    {
        foreach (var city in GetComponentsInChildren<City>())
        {
            citiesList.Add(city);
        }
    }

    public List<Vector4> GetCityCenters()
    {
        List<Vector4> result = new List<Vector4>();

        foreach (var city in citiesList)
        {
            result.Add(city.transform.position);
        }

        return result;
    }

    public List<float> GetCityRadiuses()
    {
        List<float> result = new List<float>();

        foreach (var city in citiesList)
        {
            result.Add(city.Radius);
        }

        return result;
    }

    public int Count()
    {
        return citiesList.Count;
    }
}