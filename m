Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0122.outbound.protection.outlook.com ([104.47.37.122]:4695
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753881AbeCUVxm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 17:53:42 -0400
From: Shane Walton <shane.walton@indepth.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Out of space and incorrect size reported
Date: Wed, 21 Mar 2018 21:53:39 +0000
Message-ID: <4B67E3B8-BF96-43A5-9F0E-91B32496CE7E@indepth.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> uname -a
Linux rockstor 4.4.5-1.el7.elrepo.x86_64 #1 SMP Thu Mar 10 11:45:51 EST 2016 x86_64 x86_64 x86_64 GNU/Linux

> btrfs â€”version 
btrfs-progs v4.4.1

> btrfs fi df /mnt2/pool_homes
Data, RAID1: total=240.00GiB, used=239.78GiB
System, RAID1: total=8.00MiB, used=64.00KiB
Metadata, RAID1: total=8.00GiB, used=5.90GiB
GlobalReserve, single: total=512.00MiB, used=59.31MiB

> btrfs filesystem show /mnt2/pool_homes
Label: 'pool_homes'  uuid: 0987930f-8c9c-49cc-985e-de6383863070
	Total devices 2 FS bytes used 245.75GiB
	devid    1 size 465.76GiB used 248.01GiB path /dev/sda
	devid    2 size 465.76GiB used 248.01GiB path /dev/sdb

Why is the line above "Data, RAID1: total=240.00GiB, used=239.78GiBâ€ almost full and limited to 240 GiB when there is I have 2x 500 GB HDD?  This is all create/implemented with the Rockstor platform and it says the â€œshareâ€ should be 400 GB.

What can I do to make this larger or closer to the full size of 465 GiB (minus the System and Metadata overhead)?

Thanks!

Shaneÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
