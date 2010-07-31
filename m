From: Michael Kofler <michael@kofler.info>
Subject: unable to replace defect raid1 device
Date: Sat, 31 Jul 2010 21:04:29 +0200
Message-ID: <4C5473BD.7020508@kofler.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

on Ubuntu 10.10 alpha with btrfs 0.19 and a 2.6.35
(2.6.35-12-generic #17-Ubuntu SMP Mon Jul 26 18:48:06)

I created a btrfs raid 1 system:

# mkfs.btrfs -d raid1 -m raid1 /dev/sdb1 /dev/sdc1

Then I rebooted without disk 3 (/dev/sdc). I was able to mount the btrfs 
with mount -o degraded.

However, I was not able to remove the defect device.

# btrfs device delete /dev/sdc1
ERROR: error removing the device '/dev/sdc1'
# dmesg | tail
...
[  110.524145] btrfs: allowing degraded mounts
[  439.104487] btrfs: unable to go below two devices on raid1

I was able to add a new device (again /dev/sdc1, but on another disk), 
but apparently it was not used as a raid1 device:

# btrfs de add /dev/sdc1 /media/btrfs/
# btrfs fi sh
Label: none  uuid: dc691a5d-187e-4cb4-a94a-d12dabdffde4
	Total devices 3 FS bytes used 3.76GB
	devid    1 size 8.00GB used 5.35GB path /dev/sdb1
	devid    3 size 8.00GB used 0.00 path /dev/sdc1
	*** Some devices missing

Is there a way to replace a defect raid1 device as with mdadm?
Or is this not yet implemented in btrfs?

Best wishes,

	Michael Kofler
