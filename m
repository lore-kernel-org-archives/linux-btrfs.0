Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57947 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab3IDL5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 07:57:43 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so326070pad.30
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 04:57:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 4 Sep 2013 13:57:42 +0200
Message-ID: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com>
Subject: Btrfs prog
From: Giuseppe Fierro <giuseppe@fierro.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using btrfs on ubuntu 13.04 with btrfs prog v0.20-rc1
This is my configuration using 2 disks in raid1 mode:

> gspe@jura:/mnt$ sudo btrfs f show
> Label: 'UbuntuDSK'  uuid: f4a3c832-f6ab-4b1d-9eb7-f9ba7d1cba01
> Total devices 2 FS bytes used 205.41GB
> devid    1 size 2.70TB used 214.03GB path /dev/sdb2
> devid    2 size 2.70TB used 214.01GB path /dev/sda2
> Btrfs v0.20-rc1


Some btrfs command behave strange:
If i want to check free space using df, i get:

> gspe@jura:/mnt$ sudo btrfs filesystem df /
> Data, RAID1: total=212.00GB, used=204.42GB
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=36.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=2.00GB, used=1010.04MB
> Metadata: total=8.00MB, used=0.00


If I would like to show the subvolume, i get

> gspe@jura:/mnt$ sudo btrfs subvolume list /
> gspe@jura:/mnt$


nothing is shown!!!

So what's happen to the btrfs prog?

Thanks
Giuseppe Fierro
