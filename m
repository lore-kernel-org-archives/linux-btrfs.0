From: Mark Murawski <markm-lists@intellasoft.net>
Subject: btrfs device delete missing problem
Date: Fri, 04 May 2012 21:36:22 -0400
Message-ID: <4FA48416.3070705@intellasoft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Using the latest mason git (and kernel 3.3.4)

stan {~} root# btrfs  filesystem show
Label: none  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 7.09GB
         devid    2 size 9.31GB used 9.09GB path /dev/sdd6
         devid    1 size 9.31GB used 9.09GB path /dev/sdg6

Label: none  uuid: b142f575-df1c-4a57-8846-a43b979e2e09
         Total devices 9 FS bytes used 1.35TB
         devid    8 size 1.36TB used 1.07TB path /dev/sda
         devid    7 size 1.36TB used 1.07TB path /dev/sde
         devid    2 size 465.76GB used 134.00GB path /dev/sdb
         devid    4 size 149.05GB used 0.00 path /dev/sdc
         devid    9 size 465.76GB used 161.00GB path /dev/sdf
         devid    3 size 149.05GB used 0.00 path /dev/sdh
         devid    5 size 920.34GB used 616.03GB path /dev/sdd7
         devid    6 size 920.34GB used 616.03GB path /dev/sdg7
         *** Some devices missing

stan {~} root# btrfs device delete missing /storage
May  5 05:28:40 stan kernel: btrfs: relocating block group 0 flags 2
stan {~} root#

stan {~} root# btrfs  filesystem show
Label: none  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 7.09GB
         devid    1 size 9.31GB used 9.09GB path /dev/sdg6
         devid    2 size 9.31GB used 9.09GB path /dev/sdd6

Label: none  uuid: b142f575-df1c-4a57-8846-a43b979e2e09
         Total devices 9 FS bytes used 1.35TB
         devid    3 size 149.05GB used 0.00 path /dev/sdh
         devid    6 size 920.34GB used 616.03GB path /dev/sdg7
         devid    9 size 465.76GB used 161.00GB path /dev/sdf
         devid    7 size 1.36TB used 1.07TB path /dev/sde
         devid    5 size 920.34GB used 616.03GB path /dev/sdd7
         devid    4 size 149.05GB used 0.00 path /dev/sdc
         devid    2 size 465.76GB used 134.00GB path /dev/sdb
         devid    8 size 1.36TB used 1.07TB path /dev/sda
         *** Some devices missing
