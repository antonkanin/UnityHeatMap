using System.Collections.Generic;
using UnityEngine;

public class Cities : MonoBehaviour
{
    public GameObject cityPrefab;

    public int CitiesCount;
    
    private List<City> citiesList = new List<City>();
    
    private void Start()
    {
        GenerateCities();
        
        CacheCities();
    }

    private void GenerateCities()
    {
        int count = 0;
        while (count++ < CitiesCount)
        {
            Instantiate(cityPrefab, transform);
        }
    }

    private void CacheCities()
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