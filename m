From: Brian Rogers <brian@xyzw.org>
Subject: RAID0 limiting disk utilization
Date: Wed, 27 Oct 2010 23:55:22 -0700
Message-ID: <4CC91E5A.7080503@xyzw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed that if I have single-device allocation for data in a 
multi-device btrfs filesystem, a balance operation will convert the data 
to RAID0. This is true even if '-d single' is specified explicitly when 
creating the filesystem. Then it wants to continue using RAID0 for 
future data allocations, and I run out of space once there's no longer 
two drives with space available.

I hit this problem when adding to an existing single-device filesystem. 
I ran a balance to mirror my metadata on multiple drives, and that had 
the side-effect of not letting me use all my space, since one device is 
considerably bigger than the other two combined.

$ sudo btrfs f show
Label: 'Aux'  uuid: 35a08a97-4f96-4549-b7c0-18380bbf00e0
         Total devices 3 FS bytes used 510.78GB
         devid    3 size 133.09GB used 131.01GB path /dev/sda4
         devid    1 size 465.76GB used 310.01GB path /dev/sdb1
         devid    2 size 74.52GB used 73.00GB path /dev/sdc1

Btrfs Btrfs v0.19

$ btrfs f df /aux
Data, RAID0: total=357.00GB, used=357.00GB
Data: total=153.00GB, used=152.91GB
System, RAID1: total=8.00MB, used=56.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=2.00GB, used=896.57MB

I think btrfs should fall back to single-device allocation when striped 
allocation fails. Does that sound like a reasonable policy? Without such 
a change, there can be a lot of reported free space that can't be used.

