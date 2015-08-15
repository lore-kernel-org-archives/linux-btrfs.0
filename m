Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1.belwue.de ([129.143.2.12]:58914 "EHLO smtp1.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbHOKJ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 06:09:26 -0400
Received: from fex.belwue.de (fex.belwue.de [129.143.4.198])
	by smtp1.belwue.de with ESMTP id t7FA9OnZ013467
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 12:09:24 +0200 (MEST)
	env-from (framstag@rus.uni-stuttgart.de)
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
	by fex.belwue.de (Postfix) with SMTP id 198A61FF4B
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 12:09:24 +0200 (CEST)
Date: Sat, 15 Aug 2015 12:09:23 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150815100923.GA3877@rus.uni-stuttgart.de>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <55CC488D.4020203@oracle.com>
 <20150813120211.GA24122@rus.uni-stuttgart.de>
 <20150813145556.GA27405@rus.uni-stuttgart.de>
 <55CCC4AB.2080600@oracle.com>
 <20150814073211.GA10650@rus.uni-stuttgart.de>
 <55CE81A6.5070305@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CE81A6.5070305@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2015-08-15 (08:02), Anand Jain wrote:

> First of all there is a known issue in handling multiple paths /
> instances of the same device image in btrfs. Fixing this caused
> regression earlier. And my survey
>     [survey]  BTRFS_IOC_DEVICES_READY return status
> almost told me not to fix the bug.

I have subscribed to this list this week, I am a newbie :-)


> > There is now a new behaviour: after the btrfs mount, I can see shortly the
> > wrong raw device /dev/sde and a few seconds later there is the correct
> > /dev/drbd3 :
> 
> yep possible. but it does not mean that btrfs kernel is using the new 
> path its just a reporting (bug).

What is the reporting bug: /dev/sde or /dev/drbd3?

> > root@toy02:/etc# btrfs filesystem show -m
> > Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
> >          Total devices 2 FS bytes used 109.56GiB
> >          devid    3 size 1.82TiB used 63.03GiB path /dev/drbd2
> >          devid    4 size 1.82TiB used 63.03GiB path /dev/drbd3
> 
> 
> > Still, the kernel sees 3 instead of (really) 2 HGST drives:
> >
> > root@toy02:/etc# hdparm -I /dev/sdb | grep Number:
> >          Model Number:       HGST HUS724020ALA640
> >          Serial Number:      PN2134P5G2P2AX
> >
> > root@toy02:/etc# hdparm -I /dev/sde | grep Number:
> >          Model Number:       HGST HUS724020ALA640
> >          Serial Number:      PN2134P5G2P2AX
> 
> This is important to know but not a btrfs issue. Do you have multiple 
> host paths reaching this this device with serial # PN2134P5G2P2AX ?

root@toy02:~# find /dev -ls | grep PN2134P5G2P2AX
 14354    0 lrwxrwxrwx   1 root     root           17 Aug 14 09:00 /dev/drbd/by-disk/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2AX -> ../../../../drbd3
 13640    0 lrwxrwxrwx   1 root     root            9 Aug 13 16:25 /dev/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2AX -> ../../sdb

root@toy02:~# find /dev -ls | grep sdb
  7417    0 brw-rw----   1 root     disk              Aug 13 16:25 /dev/sdb
 12366    0 lrwxrwxrwx   1 root     root            9 Aug 13 16:25 /dev/disk/by-path/pci-0000:08:00.0-sas-0x1221000002000000-lun-0 -> ../../sdb
 13641    0 lrwxrwxrwx   1 root     root            9 Aug 13 16:25 /dev/disk/by-id/wwn-0x5000cca24ec137db -> ../../sdb
 13640    0 lrwxrwxrwx   1 root     root            9 Aug 13 16:25 /dev/disk/by-id/ata-HGST_HUS724020ALA640_PN2134P5G2P2AX -> ../../sdb
 12356    0 lrwxrwxrwx   1 root     root            6 Aug 13 16:25 /dev/block/8:16 -> ../sdb

root@toy02:~# find /dev -ls | grep sde
 13353    0 brw-rw----   1 root     disk              Aug 13 16:24 /dev/sde
 15725    0 lrwxrwxrwx   1 root     root            9 Aug 13 16:25 /dev/disk/by-uuid/411af13f-6cae-4f03-99dc-5941acb3135b -> ../../sde
 15724    0 lrwxrwxrwx   1 root     root            9 Aug 13 16:25 /dev/disk/by-label/data -> ../../sde
  9394    0 lrwxrwxrwx   1 root     root            9 Aug 13 16:24 /dev/disk/by-path/pci-0000:08:00.0-scsi-0:1:2:0 -> ../../sde
  9387    0 lrwxrwxrwx   1 root     root            6 Aug 13 16:24 /dev/block/8:64 -> ../sde

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum IZUS/TIK         E-Mail: horlacher@tik.uni-stuttgart.de
Universitaet Stuttgart         Tel:    ++49-711-68565868
Allmandring 30a                Fax:    ++49-711-682357
70550 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<55CE81A6.5070305@oracle.com>
