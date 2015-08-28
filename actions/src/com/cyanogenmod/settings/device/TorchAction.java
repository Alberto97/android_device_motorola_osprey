/*
 * Copyright (c) 2015 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.cyanogenmod.settings.device;

import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.Parameters;
import android.util.Log;

public class TorchAction implements SensorAction {
    private static final String TAG = "CMActions";

    private static final int TURN_SCREEN_ON_WAKE_LOCK_MS = 500;

    private Camera cam;
    private Parameters p;
    private boolean isTorchOn = false;

    public TorchAction() {
        cam = Camera.open();   
    }

    @Override
    public void action() {  
        p = cam.getParameters();
        if(isTorchOn){
           p.setFlashMode(Parameters.FLASH_MODE_OFF);
           cam.setParameters(p);
           cam.stopPreview();
           cam.release();
        } else {
           p.setFlashMode(Parameters.FLASH_MODE_TORCH);
           cam.setParameters(p);
           cam.startPreview();
        }
    }
}
