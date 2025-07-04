﻿using CGPG;
using OpenTK.Mathematics;
using OpenTK.Windowing.Common;
using OpenTK.Windowing.Desktop;
using OpenTK.Windowing.GraphicsLibraryFramework;

namespace Week11
{
    public static class Program
    {
        private static Texture? texture;
        private static Geometry? quad1;
        private static Geometry? quad2;

        private static void Main()
        {
            var nativeWindowSettings = new NativeWindowSettings()
            {
                ClientSize = new Vector2i(1200, 600),
                Title = "CGPG - Week 11 - Image Manipulation",
                Flags = ContextFlags.ForwardCompatible,
            };

            var renderer = new Renderer(
                GameWindowSettings.Default, 
                nativeWindowSettings);

            //--------------------------------------------------------//
            // The original image.
            //--------------------------------------------------------//
            quad1 = Shapes.CreateQuad();
            quad1.SetTexture("Resources/sample_image.jpg");

            renderer.AddGeometry(quad1);

            Mat4 trans1 = new Mat4();
            trans1.MakeTranslate(-0.55f, -0.04f, 0);
            quad1.SetMatrix(trans1);
            //--------------------------------------------------------//

            //--------------------------------------------------------//
            // The manipulated image.
            //--------------------------------------------------------//
            quad2 = Shapes.CreateQuad();
            quad2.SetTexture("Resources/sample_image.jpg");

            renderer.AddGeometry(quad2);

            Mat4 trans = new Mat4();
            trans.MakeTranslate(0.55f, -0.04f, 0);
            quad2.SetMatrix(trans);
            //--------------------------------------------------------//

            renderer.OnUpdate = OnUpdateFrame;

            renderer.Run();            
        }

        static void OnUpdateFrame(
            Renderer ren, 
            FrameEventArgs e, 
            KeyboardState keyboard)
        {
            int width = quad1.GetTexture().Width;
            int height = quad1.GetTexture().Height;
            byte[] original_data = quad1.GetTexture().GetRawData();
            byte[] changing_data = quad2.GetTexture().GetRawData();
            if (keyboard.IsKeyPressed(Keys.R))
            {
                // Set a red colour to the changing data and set it to quad2.
                // Set a red colour to the changing data and set it to quad2.
                byte[] updated_data = ImageUtils.SetRedColor(changing_data, width,
                height);
                quad2.SetTexture(updated_data, width, height);
            }
            if (keyboard.IsKeyPressed(Keys.B))
            {
                // Set a red colour to the changing data and set it to quad2.
                // Set a red colour to the changing data and set it to quad2.
                byte[] updated_data = ImageUtils.SetBlueColor(changing_data, width,
                height);
                quad2.SetTexture(updated_data, width, height);
            }
            if (keyboard.IsKeyPressed(Keys.G))
            {
                // Set a red colour to the changing data and set it to quad2.
                // Set a red colour to the changing data and set it to quad2.
                byte[] updated_data = ImageUtils.SetGreenColor(changing_data, width,
                height);
                quad2.SetTexture(updated_data, width, height);
            }
            if (keyboard.IsKeyPressed(Keys.Q))
            {
                // Convert the image to grayscale.
                byte[] updated_data = ImageUtils.ConvertToGrayscale(changing_data, width,
                height);
                quad2.SetTexture(updated_data, width, height);
            }
            if (keyboard.IsKeyPressed(Keys.Space))
            {
                // Reset to the original texture.

                quad2.SetTexture("Resources/sample_image.jpg");
            } 
        }
    }
}
