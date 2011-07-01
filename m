From: Anand Jain <Anand.Jain@oracle.com>
Subject: device failure hangs the system
Date: Fri, 01 Jul 2011 17:25:50 +0800
Message-ID: <4E0D929E.7030704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


hi,

Following test case causes my remote system to hard-hang and does
not respond to any key strokes.

-----------
# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: 75ad3c9f-f661-498e-8c13-89d4e4c58312
	Total devices 3 FS bytes used 28.00KB
	devid    1 size 465.76GB used 2.02GB path /dev/sdb
	devid    3 size 465.76GB used 2.01GB path /dev/sdd
	devid    2 size 465.76GB used 1.01GB path /dev/sdc

Btrfs v0.19-35-g1b444cd
------------


Stopping the disk
------------
# echo 1 > /sys/block/sdd/device/delete
------------
------------
# dmesg | tail
sd 3:0:0:0: [sdd] Stopping disk
::
#
------------

------------
# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: 75ad3c9f-f661-498e-8c13-89d4e4c58312
	Total devices 3 FS bytes used 28.00KB
	devid    1 size 465.76GB used 2.02GB path /dev/sdb
	devid    2 size 465.76GB used 1.01GB path /dev/sdc
	*** Some devices missing

Btrfs v0.19-35-g1b444cd
------------

and the following command hangs the system.
-------------
# btrfs fi balance /btrfs
-------------

Any idea if this is an known issue ? OR if there is any better way
to fail a disk (or a loop disk) for testing.

(something similar to cfgadm -c unconfigure in solaris).

Thanks
-Anand

