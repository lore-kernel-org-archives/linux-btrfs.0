Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57820 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaAEVSN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 16:18:13 -0500
Received: from [192.168.0.2] ([91.115.176.179]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MhiPD-1VmwMR1dVz-00MuKa for
 <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 22:17:40 +0100
Message-ID: <52C9CBEF.2000309@gmx.at>
Date: Sun, 05 Jan 2014 22:17:35 +0100
From: Sulla <Sulla@gmx.at>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com>
In-Reply-To: <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear Chris!

Certainly: I have 3 HDDs, all of which WD20EARS. Originally I wanted to
let btrfs handle all 3 devices directly without making partitions, but
this was impossible, as at least /boot needed to be ext4, at least back
then when I set up the server. And back then btrfs also hadn't raid5-like
functionality, so I decided to put good old partitions and md-Raids and
LVM on them and use btrfs just as plain file-systems on the partitions
provided by LVM.

On the WD disks I thus created 2 partitions each, the first sdX1 being
~500MiB, the rest, 1.9995 TiB is one partition of, sdX2.

I built a Raid1 on the 3 small partitions sdX1 with ext4 for boot, each
disk is bootable with grub installed into the MBR.

I combined the 3 large partitions to a Raid5 of size 3,64TB:

/proc/mdstat reads:
md0 : active raid1 sda1[5] sdb1[4] sdc1[3]
      498676 blocks super 1.2 [3/3] [UUU]
md1 : active raid5 sda2[5] sdb2[4] sdc2[3]
      3904907520 blocks super 1.2 level 5, 8k chunk, algorithm 2 [3/3] [UUU]

the information you requested:
# sudo mdadm -D /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Thu Jul 14 18:49:25 2011
     Raid Level : raid5
     Array Size : 3904907520 (3724.01 GiB 3998.63 GB)
  Used Dev Size : 1952453760 (1862.01 GiB 1999.31 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent
    Update Time : Sun Jan  5 22:07:22 2014
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
         Layout : left-symmetric
     Chunk Size : 8K
           Name : freedom:1  (local to host freedom)
           UUID : 44b72520:a78af6f7:dba13fb3:2203127d
         Events : 576884
    Number   Major   Minor   RaidDevice State
       4       8       18        0      active sync   /dev/sdb2
       5       8        2        1      active sync   /dev/sda2
       3       8       34        2      active sync   /dev/sdc2



I use the Raid5 md1 as physical volume for LVM: pvdisplay gives:
  --- Physical volume ---
  PV Name               /dev/md1
  VG Name               MAIN
  PV Size               3.64 TiB / not usable 2.06 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              953346
  Free PE               6274
  Allocated PE          947072
  PV UUID               WcuEx8-ehJL-xHdf-ElwF-b9s3-dlmM-KZlDNG

I keep a reserve of 6274 4MiB blocks (=24GiB) in case one of the logical
volumes runs out of space...

I created the following logical volumes, named after their intended
mountpoints:
  --- Logical volume ---
  LV Path                /dev/MAIN/ROOT
  LV Name                ROOT
  VG Name                MAIN
  LV UUID                kURJks-xHox-73B5-n02x-eZfS-agDD-n1dtAm
  LV Write Access        read/write
  LV Creation host, time ,
  LV Status              available
  # open                 1
  LV Size                19.31 GiB
  Current LE             4944
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0

and similar:
  --- Logical volume ---
  LV Path                /dev/MAIN/SWAP: 1.8GB
  LV Path                /dev/MAIN/HOME: 18.6GB
  LV Path                /dev/MAIN/TMP: 9.3 GB
  LV Path                /dev/MAIN/DATA1 2.6 TB
  LV Path                /dev/MAIN/DATA2: 0.9 TB


as filesystem I used btrfs during install form an ubuntu server, I don't
recall which, might have been 11.10 or 12.04 (?) for all logical
partitions except swap, of course,

any other information I can supply?
regards, Sulla

- -- 
Cogito cogito ergo cogito sum.
   Ambrose Bierce














-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLJy+8ACgkQR6b2EdogPFupxgCfeDRdeO+PYoQNIjtySAYEmSEr
PNoAoLPNcSqDHsDzM8pAuHlbva7j18MS
=XBOA
-----END PGP SIGNATURE-----
