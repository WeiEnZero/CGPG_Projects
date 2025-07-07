using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

public class BlendAmtChange : MonoBehaviour
{

    private Material _mat;
    // Start is called before the first frame update
    void Start()
    {
        _mat = GetComponent<MeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        //_mat.SetFloat("_BlendAmt", (1f + Mathf.Sin(Time.time)) / 2f);

        //float yPos = transform.position.y;

        // Example: Use Mathf.Sin for natural looping or normalize large values
        //float blendValue = Mathf.Clamp01((Mathf.Sin(yPos) + 1f));

        //_mat.SetFloat("_BlendAmt", blendValue);

    }
}
