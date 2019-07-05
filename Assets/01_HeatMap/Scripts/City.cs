using UnityEngine;
using Random = UnityEngine.Random;

public class City : MonoBehaviour
{
    public float Radius;

    private Vector2 velocity = Vector2.zero;

    private void Start()
    {
        velocity.x = Random.Range(-1.0f, 1.0f);
        velocity.y = Random.Range(-1.0f, 1.0f);

        velocity.Normalize();

        velocity *= 2.0f;
    }

    private void Update()
    {
        Move();

        CheckBoundaries();
    }

    private void CheckBoundaries()
    {
        var pos = transform.position;

        if (pos.x < -4.0f || pos.x > 4.0f)
        {
            velocity.x *= -1.0f;
        }

        if (pos.y < -4.0f || pos.y > 4.0f)
        {
            velocity.y *= -1.0f;
        }
    }

    private void Move()
    {
        var pos = transform.position;

        pos.x += velocity.x * Time.deltaTime;
        pos.y += velocity.y * Time.deltaTime;

        transform.position = pos;
    }
}