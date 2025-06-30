using OpenTK.Windowing.GraphicsLibraryFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CGPG
{
    public static class ImageUtils
    {
        public static byte[] SetRedColor(byte[] input, int width, int height)
        {
            byte[] output = new byte[input.Length];
            for (int i = 0; i < input.Length; i += 4) // RGBA
            {
                output[i] = 255;  //Red
                output[i + 1] = 0; //Green
                output[i + 2] = 0; //Blue
                output[i + 3] = input[i + 3]; // Keep Alpha
            }

            return output;
        }

        public static byte[] SetGreenColor(byte[] input, int width, int height)
        {
            byte[] output = new byte[input.Length];
            for (int i = 0; i < input.Length; i += 4) // RGBA
            {
                output[i] = 0;  //Red
                output[i + 1] = 255; //Green
                output[i + 2] = 0; //Blue
                output[i + 3] = input[i + 3]; // Keep Alpha
            }

            return output;
        }

        public static byte[] SetBlueColor(byte[] input, int width, int height)
        {
            byte[] output = new byte[input.Length];
            for (int i = 0; i < input.Length; i += 4) // RGBA
            {
                output[i] = 0;  //Red
                output[i + 1] = 0; //Green
                output[i + 2] = 255; //Blue
                output[i + 3] = input[i + 3]; // Keep Alpha
            }

            return output;
        }

        public static byte[] ConvertToGrayscale(byte[] input, int width, int height)
        {
            // Implement here.
            byte[] output = new byte[input.Length];
            for (int i = 0; i < input.Length; i += 4) // RGBA
            {
                output[i] = 0;  //Red
                output[i + 1] = 0; //Green
                output[i + 2] = 0; //Blue
                output[i + 3] = input[i + 3]; // Keep Alpha
            }

            return output;

        }     
    }
}

