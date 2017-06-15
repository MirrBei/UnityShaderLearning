using UnityEngine;

namespace First_edition._5084_02_Code.Code.Scripts
{
    public class SpriteAnimator : MonoBehaviour 
    {
	
        float timeValue = 0.0f;

	
        // Update is called once per frame
        void FixedUpdate () 
        {
            timeValue = Mathf.Ceil(Time.time % 16);
            transform.GetComponent<Renderer>().material.SetFloat("_TimeValue", timeValue);
        }
    }
}
