Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:37432 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbbGARTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 13:19:39 -0400
From: <edt@aei.ca>
To: <linux-btrfs@vger.kernel.org>
Subject: send/receive broken with btrfs-progs =?iso-8859-1?Q?4.1=3F?=
Date: Wed, 01 Jul 2015 13:19:36 -0400
MIME-Version: 1.0
Message-ID: <df5d2778-d2b2-45eb-83cb-520419bb5975@aei.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

My backups broke sometime after june 26th (about the time btrfs-progs 4.1 
came out).  I am using btrfs-progs from git and 4.1.1 + the 4.2 for-linux 
branch along with a few patches from the list.

The following is based on the wiki at: 
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup

Here is a log of what is happening along with a few subvolume lists

---
btrfs subvolume snapshot -r /snap/homevol 
/snap/homevol/backup.2015-27-3_07-01_07:30
Create a readonly snapshot of '/snap/homevol' in 
'/snap/homevol/backup.2015-27-3_07-01_07:30'

btrfs send -ve /snap/homevol/backup.2015-27-3_07-01_07:30 | btrfs receive 
-v /backup/home
At subvol /snap/homevol/backup.2015-27-3_07-01_07:30
At subvol backup.2015-27-3_07-01_07:30
receiving subvol backup.2015-27-3_07-01_07:30 
uuid=cff4f305-6ef3-234e-ac6d-bdfd87d926d7, stransid=392551

BTRFS_IOC_SEND returned 0
joining genl thread
BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=cff4f305-6ef3-234e-ac6d-bdfd87d926d7, 
stransid=392551

btrfs subvol delete -c /snap/homevol/backup
Delete subvolume (commit): '/snap/homevol/backup'

mv /snap/homevol/backup.2015-27-3_07-01_07:30 /snap/homevol/backup

btrfs subvol list -puq /snap
ID 258 gen 393101 parent 5 top level 5 parent_uuid - uuid 
6447cef2-9b1a-c146-8dc3-b759ed2dd694 path homevol
ID 746 gen 392551 parent 258 top level 258 parent_uuid 
6447cef2-9b1a-c146-8dc3-b759ed2dd694 uuid 
cff4f305-6ef3-234e-ac6d-bdfd87d926d7 path homevol/backup

btrfs subvol list -puq /backup | grep home
ID 2941 gen 2689 parent 5 top level 5 parent_uuid - uuid 
113972bf-ab10-294f-9d6e-587e1ad43726 path home/backup.2015-27-3_07-01_07:30

btrfs subvolume snapshot -r /snap/homevol 
/snap/homevol/backup.2015-27-3_07-01_13:04
Create a readonly snapshot of '/snap/homevol' in 
'/snap/homevol/backup.2015-27-3_07-01_13:04'

btrfs send -ve -p $base $news | btrfs receive -v /backup/home
At subvol /snap/homevol/backup.2015-27-3_07-01_13:04
At snapshot backup.2015-27-3_07-01_13:04
receiving snapshot backup.2015-27-3_07-01_13:04 
uuid=38b701ed-973d-584b-92b7-ff0cdd509ecc, ctransid=393110 
parent_uuid=cb3ad856-ca0f-f744-b7c3-b33f2d5bc8d3, parent_ctransid=392551
ERROR: could not find parent subvolume
---

Why is the parent not found any more?

TIA,
Ed Tomlinson

#btrfs fi usage /snap
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:                   2.71TiB
    Device allocated:             20.00MiB
    Device unallocated:            2.71TiB
    Device missing:                  0.00B
    Used:                            0.00B
    Free (estimated):            273.33PiB      (min: 3.50TiB)
    Data ratio:                       0.00
    Metadata ratio:                   0.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:8.00MiB, Used:0.00B
   /dev/sdd1       8.00MiB

Data,RAID5: Size:806.00GiB, Used:786.82GiB
   /dev/sdd1     403.00GiB
   /dev/sde1     403.00GiB
   /dev/sdf1     403.00GiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdd1       8.00MiB

Metadata,RAID5: Size:14.00GiB, Used:7.00GiB
   /dev/sdd1       7.00GiB
   /dev/sde1       7.00GiB
   /dev/sdf1       7.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdd1       4.00MiB

System,RAID5: Size:16.00MiB, Used:96.00KiB
   /dev/sdd1       8.00MiB
   /dev/sde1       8.00MiB
   /dev/sdf1       8.00MiB

btrfs-progs v4.1-10-g1b1fd2c

Unallocated:
   /dev/sdd1     515.97GiB
   /dev/sde1     515.99GiB
   /dev/sdf1     515.99GiB

#btrfs fi show /backup
Label: 'backupfs'  uuid: 0df1bbd3-b19a-44eb-a9a6-d082c2f61914
        Total devices 1 FS bytes used 1.78TiB
        devid    1 size 3.44TiB used 1.81TiB path /dev/sda1

btrfs-progs v4.1-10-g1b1fd2c

  



