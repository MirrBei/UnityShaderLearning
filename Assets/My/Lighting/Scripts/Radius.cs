using UnityEngine;

namespace My.Scripts
{
    [ExecuteInEditMode]
    public class Radius : MonoBehaviour
    {
        [SerializeField] private Material _radiusMaterial;
        [SerializeField] private float _radius;
        [SerializeField] private Color _color;
        [SerializeField] private float _radiusWidth;

        // Update is called once per frame
        private void Update()
        {
            _radiusMaterial.SetVector("_Center", transform.position);
            _radiusMaterial.SetFloat("_Radius", _radius);
            _radiusMaterial.SetColor("_RadiusColor", _color);
            _radiusMaterial.SetFloat("_RadiusWidth", _radiusWidth);
        }
    }
}