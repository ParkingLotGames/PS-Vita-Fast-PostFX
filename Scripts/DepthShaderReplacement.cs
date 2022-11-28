using UnityEngine;

namespace DP.PostProcessing
{
    [ExecuteInEditMode]
    public class DepthShaderReplacement : MonoBehaviour
    {
        [SerializeField] Shader shader;
        void OnEnable()
        {
            var cam = GetComponent<Camera>();
            if (shader != null)
                cam.SetReplacementShader(shader, "");
        }
        
        void OnDisable()
        {
            var cam = GetComponent<Camera>();
                cam.ResetReplacementShader();
        }
        private void Reset()
        {
            shader = Shader.Find("PS Vita/Internal/Normals And Y Depth");
        }
    }
}