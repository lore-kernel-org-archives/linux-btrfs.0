Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve1eur01on0137.outbound.protection.outlook.com ([104.47.1.137]:64096
	"EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbcGUC3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 22:29:22 -0400
From: =?iso-8859-2?Q?Libor_Klep=E1=E8?= <libor.klepac@bcom.cz>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Send-recieve performance
Date: Wed, 20 Jul 2016 09:15:30 +0000
Message-ID: <2282942.pRaJJzEdHC@libor-nb>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
we use backuppc to backup our hosting machines.

I have recently migrated it to btrfs, so we can use send-recieve for offsite backups of our backups.

I have several btrfs volumes, each hosts nspawn container, which runs in /system subvolume and has backuppc data in /backuppc subvolume
.
I use btrbk to do snapshots and transfer.
Local side is set to keep 5 daily snapshots, remote side to hold some history. (not much yet, i'm using it this way for few weeks).

If you know backuppc behaviour: for every backup (even incremental), it creates full directory tree of each backed up machine even if it has no modified files and places one small file in each, which holds some info for backuppc. 
So after few days i ran into ENOSPACE on one volume, because my metadata grow, because of inlineing.
I switched from mdata=DUP to mdata=single (now I see it's possible to change inline file size, right?).

My problem is, that on some volumes, send-recieve is relatively fast (rate in MB/s or hundreds of kB/s) but on biggest volume (biggest in space and biggest in contained filesystem trees) rate is just 5-30kB/s.

Here is btrbk progress copyed
785MiB 47:52:00 [12.9KiB/s] [4.67KiB/s]

ie. 758MB in 48 hours.

Reciever has high IO/wait - 90-100%, when i push data using btrbk.
When I run dd over ssh it can do 50-75MB/s.

Sending machine is debian jessie with kernel 4.5.0-0.bpo.2-amd64 (upstream 4.5.3) , btrfsprogs 4.4.1. It is virtual machine running on volume exported from MD3420, 4 SAS disks in RAID10.

Recieving machine is debian jessie on Dell T20 with 4x3TB disks in MD RAID5 , kernel is 4.4.0-0.bpo.1-amd64 (upstream 4.4.6), btrfsprgos 4.4.1

BTRFS volumes were created using those listed versions.

Sender:
---------
#mount | grep hosting
/dev/sdg on /mnt/btrfs/hosting type btrfs (rw,noatime,space_cache,subvolid=5,subvol=/)
/dev/sdg on /var/lib/container/hosting type btrfs (rw,noatime,space_cache,subvolid=259,subvol=/system)
/dev/sdg on /var/lib/container/hosting/var/lib/backuppc type btrfs (rw,noatime,space_cache,subvolid=260,subvol=/backuppc)

#btrfs filesystem usage /mnt/btrfs/hosting
Overall:
    Device size:                 840.00GiB
    Device allocated:            815.03GiB
    Device unallocated:           24.97GiB
    Device missing:                  0.00B
    Used:                        522.76GiB
    Free (estimated):            283.66GiB      (min: 271.18GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:710.98GiB, Used:452.29GiB
   /dev/sdg      710.98GiB

Metadata,single: Size:103.98GiB, Used:70.46GiB
   /dev/sdg      103.98GiB

System,DUP: Size:32.00MiB, Used:112.00KiB
   /dev/sdg       64.00MiB

Unallocated:
   /dev/sdg       24.97GiB

# btrfs filesystem show /mnt/btrfs/hosting
Label: 'BackupPC-BcomHosting'  uuid: edecc92a-646a-4585-91a0-9cbb556303e9
        Total devices 1 FS bytes used 522.75GiB
        devid    1 size 840.00GiB used 815.03GiB path /dev/sdg

#Reciever:
#mount | grep hosting
/dev/mapper/vgPecDisk2-lvHostingBackupBtrfs on /mnt/btrfs/hosting type btrfs (rw,noatime,space_cache,subvolid=5,subvol=/)

#btrfs filesystem usage /mnt/btrfs/hosting/
Overall:
    Device size:                 896.00GiB
    Device allocated:            604.07GiB
    Device unallocated:          291.93GiB
    Device missing:                  0.00B
    Used:                        565.98GiB
    Free (estimated):            313.62GiB      (min: 167.65GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 55.80MiB)

Data,single: Size:530.01GiB, Used:508.32GiB
   /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs   530.01GiB

Metadata,single: Size:74.00GiB, Used:57.65GiB
   /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs    74.00GiB

System,DUP: Size:32.00MiB, Used:80.00KiB
   /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs    64.00MiB

Unallocated:
   /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs   291.93GiB

#btrfs filesystem show /mnt/btrfs/hosting/
Label: none  uuid: 2d7ea471-8794-42ed-bec2-a6ad83f7b038
        Total devices 1 FS bytes used 564.56GiB
        devid    1 size 896.00GiB used 604.07GiB path /dev/mapper/vgPecDisk2-lvHostingBackupBtrfs



What can i do about it? I tried to defragment /backuppc subvolume (without recursive option), should i do it for all snapshots/subvolumes on both sides? 
Should upgrade to 4.6.x kernel help (there is 4.6.3 in backports)?

Thanks for any answer.

With regards,

Libor



