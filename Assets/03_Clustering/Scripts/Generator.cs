using System.Collections.Generic;
using UnityEngine;

public class Cluster
{
    public List<GameObject> Items = new List<GameObject>();
    public Vector3 Center;

    public Cluster(GameObject gameObject)
    {
        Items.Add(gameObject);
        Center = gameObject.transform.position;
    }
}

public class Generator : MonoBehaviour
{
    [SerializeField] private GameObject objectPrefab = default;

    [SerializeField] private Color[] colors;

    private List<GameObject> _points = new List<GameObject>();

    private List<Cluster> _clusters = new List<Cluster>();

    private void GeneratePoints()
    {
        const uint POINTS_COUNT = 10;

        for (int i = 0; i < POINTS_COUNT; ++i)
        {
            var positon = new Vector3(Random.Range(-5.0f, 5.0f), Random.Range(-5.0f, 5.0f));

            var newObject = Instantiate(objectPrefab, positon, Quaternion.identity, transform);

            _points.Add(newObject);

            _clusters.Add(new Cluster(newObject));
        }
    }

    private void RunClustering()
    {
    }

    void Start()
    {
        GeneratePoints();
    }
}