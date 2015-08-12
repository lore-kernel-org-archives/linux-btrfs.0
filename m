Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.rus.uni-stuttgart.de ([129.69.192.2]:48929 "EHLO
	mx2.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbbHLNRq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 09:17:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.rus.uni-stuttgart.de (Postfix) with ESMTP id 0F089200CC
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 15:08:01 +0200 (CEST)
Received: from mx2.rus.uni-stuttgart.de ([127.0.0.1])
	by localhost (mx2.rus.uni-stuttgart.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cq2bggvFNqcf for <linux-btrfs@vger.kernel.org>;
	Wed, 12 Aug 2015 15:07:59 +0200 (CEST)
Received: from diaspora.rus.uni-stuttgart.de (diaspora.rus.uni-stuttgart.de [129.69.13.139])
	by mx2.rus.uni-stuttgart.de (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 15:07:59 +0200 (CEST)
Date: Wed, 12 Aug 2015 15:07:58 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: RAID0 wrong (raw) device?
Message-ID: <20150812130758.GA26529@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I have 2 identical servers with 2 x 2 Hitachi (HGST) SATA disks (and some
other disks) which are mirrored with drbd.
On top of this drbd setup I have created a btrfs RAID0 filesystem.
The problem now is, that btrfs shows the raw device instead of the drbd
device.

root@toy02:~# mkfs.btrfs /dev/drbd2 /dev/drbd3
root@toy02:~# mount btrfs filesystem label /dev/drbd2 data
root@toy02:~# mount /dev/drbd2 /data


root@toy02:~# df -T /data
Filesystem     Type   1K-blocks      Used  Available Use% Mounted on
/dev/sdb       btrfs 3906909856 140031696 3765056176   4% /data

root@toy02:~# btrfs filesystem show /data
Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
        Total devices 2 FS bytes used 129.81GiB
        devid    3 size 1.82TiB used 67.03GiB path /dev/drbd2
        devid    4 size 1.82TiB used 67.03GiB path /dev/sdb

Btrfs v3.12

==> btrfs shows the wrong (raw) device /dev/sdb instead of /dev/drbd3 !


root@toy02:~# uname -a; lsb_release -a
Linux toy02 3.13.0-61-generic #100-Ubuntu SMP Wed Jul 29 11:21:34 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 14.04.3 LTS
Release:        14.04
Codename:       trusty


root@toy02:~# find /dev -ls | grep drbd
 47453    0 brw-rw----   1 root     disk              Aug 12 14:51 /dev/drbd3
 47433    0 brw-rw----   1 root     disk              Aug 11 14:00 /dev/drbd2
 14706    0 drwxr-xr-x   4 root     root           80 Aug 10 14:17 /dev/drbd
 14713    0 drwxr-xr-x   2 root     root          100 Aug 12 13:40 /dev/drbd/by-res
 41685    0 lrwxrwxrwx   1 root     root           11 Aug 12 14:51 /dev/drbd/by-res/d3 -> ../../drbd3
 42759    0 lrwxrwxrwx   1 root     root           11 Aug 11 14:00 /dev/drbd/by-res/d2 -> ../../drbd2
 14707    0 drwxr-xr-x   3 root     root           60 Aug 10 14:17 /dev/drbd/by-disk
 14708    0 drwxr-xr-x   3 root     root           60 Aug 10 14:17 /dev/drbd/by-disk/disk
 14709    0 drwxr-xr-x   2 root     root          100 Aug 12 13:40 /dev/drbd/by-disk/disk/by-id
 41682    0 lrwxrwxrwx   1 root     root           17 Aug 12 14:51 /dev/drbd/by-disk/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2AX -> ../../../../drbd3
 42756    0 lrwxrwxrwx   1 root     root           17 Aug 11 14:00 /dev/drbd/by-disk/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2XX -> ../../../../drbd2
 41681    0 lrwxrwxrwx   1 root     root            8 Aug 12 14:51 /dev/block/147:3 -> ../drbd3
 42755    0 lrwxrwxrwx   1 root     root            8 Aug 11 14:00 /dev/block/147:2 -> ../drbd2

root@toy02:~# find /dev -ls | grep HGST
 41682    0 lrwxrwxrwx   1 root     root           17 Aug 12 14:51 /dev/drbd/by-disk/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2AX -> ../../../../drbd3
 42756    0 lrwxrwxrwx   1 root     root           17 Aug 11 14:00 /dev/drbd/by-disk/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2XX -> ../../../../drbd2
 63889    0 lrwxrwxrwx   1 root     root            9 Aug 12 13:42 /dev/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2AX -> ../../sdb
  7429    0 lrwxrwxrwx   1 root     root            9 Aug 10 16:45 /dev/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2XX -> ../../sdd



root@toy02:~# hdparm -I /dev/sdb| grep Number:
        Model Number: HGST HUS724020ALA640
        Serial Number: PN2134P5G2P2AX

root@toy02:~# hdparm -I /dev/sdd| grep Number:
        Model Number: HGST HUS724020ALA640
        Serial Number: PN2134P5G2P2XX

root@toy02:~# hdparm -I /dev/sde| grep Number:
        Model Number: HGST HUS724020ALA640
        Serial Number: PN2134P5G2P2AX

/dev/sdb and /dev/sde have the same serial number!
But there are really only 2 HGST drives in the server (and some other
seagate disks, non-relevant here).

root@toy02:~# find /dev -ls | grep sde 
 10391    0 brw-rw----   1 root     disk              Aug 10 16:45 /dev/sde
  8360    0 lrwxrwxrwx   1 root     root            9 Aug 10 16:45 /dev/disk/by-path/pci-0000:08:00.0-scsi-0:1:2:0 -> ../../sde
  8355    0 lrwxrwxrwx   1 root     root            6 Aug 10 16:45 /dev/block/8:64 -> ../sde

root@toy02:~# find /dev -ls | grep sdb
 10382    0 brw-rw----   1 root     disk              Aug 12 13:42 /dev/sdb
 68794    0 lrwxrwxrwx   1 root     root            9 Aug 12 13:42 /dev/disk/by-uuid/411af13f-6cae-4f03-99dc-5941acb3135b -> ../../sdb
 12410    0 lrwxrwxrwx   1 root     root            9 Aug 12 13:42 /dev/disk/by-path/pci-0000:08:00.0-sas-0x1221000002000000-lun-0 -> ../../sdb
 68791    0 lrwxrwxrwx   1 root     root            9 Aug 12 13:42 /dev/disk/by-label/data -> ../../sdb
 63890    0 lrwxrwxrwx   1 root     root            9 Aug 12 13:42 /dev/disk/by-id/wwn-0x5000cca24ec137db -> ../../sdb
 63889    0 lrwxrwxrwx   1 root     root            9 Aug 12 13:42 /dev/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2AX -> ../../sdb
 12403    0 lrwxrwxrwx   1 root     root            6 Aug 12 13:42 /dev/block/8:16 -> ../sdb

/dev/sdb and /dev/sde are in reality the same physical disk!


-- 
Ullrich Horlacher              Informationssysteme und Serverbetrieb
IZUS/TIK                       E-Mail: horlacher@rus.uni-stuttgart.de
Universitaet Stuttgart         Tel:    ++49-711-68565868
Allmandring 30a                Fax:    ++49-711-682357
70550 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20150812130758.GA26529@rus.uni-stuttgart.de>
