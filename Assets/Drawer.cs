using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Drawer : MonoBehaviour
{
    private float drawDistance = 0.0f;
    private float drawingSpeed = 0.5f;
    private bool swapColor = false;

    private Material material;

    private void Start()
    {
        material = GetComponent<MeshRenderer>().material;
    }

    private void OnMouseDown()
    {
        Debug.Log("I was clicked");
        swapColor = true;
    }

    private void Update()
    {
        if (swapColor)
        {
            drawDistance += drawingSpeed * Time.deltaTime;
            

            if (drawDistance > 2.0f)
            {
                swapColor = false;
                drawDistance = 0.0f;
            }
        }
        
        material.SetFloat("_Distance", drawDistance);
    }
}
