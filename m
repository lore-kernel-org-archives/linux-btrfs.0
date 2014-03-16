Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45512 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaCPWUg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 18:20:36 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:42187 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WPJPw-0003JQ-NK by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Mar 2014 15:20:35 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WPJPu-0005yu-8g
	for linux-btrfs@vger.kernel.org; Sun, 16 Mar 2014 15:20:26 -0700
Date: Sun, 16 Mar 2014 15:20:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140316222026.GU16946@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: How to handle a RAID5 arrawy with a failing drive? 
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just created this array:
polgara:/mnt/btrfs_backupcopy# btrfs fi show
Label: backupcopy  uuid: 7d8e1197-69e4-40d8-8d86-278d275af896
        Total devices 10 FS bytes used 220.32GiB
        devid    1 size 465.76GiB used 25.42GiB path /dev/dm-0
        devid    2 size 465.76GiB used 25.40GiB path /dev/dm-1
        devid    3 size 465.75GiB used 25.40GiB path /dev/mapper/crypt_sde1
        devid    4 size 465.76GiB used 25.40GiB path /dev/dm-3
        devid    5 size 465.76GiB used 25.40GiB path /dev/dm-4
        devid    6 size 465.76GiB used 25.40GiB path /dev/dm-5
        devid    7 size 465.76GiB used 25.40GiB path /dev/dm-6
        devid    8 size 465.76GiB used 25.40GiB path /dev/mapper/crypt_sdj1
        devid    9 size 465.76GiB used 25.40GiB path /dev/dm-9
        devid    10 size 465.76GiB used 25.40GiB path /dev/dm-8

And clearly it has issues with one of the drives.

I have a copy that is still going on to it.

Last I tried to boot a raid5 btrfs array with a drive missing, that didn't work at all.

Since this array is still running, what are my options?
I can't tell btrfs to replace drive sde1 with a new drive I plugged in
because the code doesn't exist, correct?
If I yank, sde1 and reboot, the array will not come back up from what I understand,
or is that incorrect?
Do rebuilds work at all with a missing drive to a spare drive?

This is with 3.14.0-rc5.

Do I have other options?
(data is not important at all, I just want to learn how to deal with such a case
with the current code)

[59532.543415] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 162, rd 2444, flush 0, corrupt 0, gen 0
[59547.654888] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 162, rd 2445, flush 0, corrupt 0, gen 0
[59547.655755] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 162, rd 2446, flush 0, corrupt 0, gen 0
[59552.096038] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 162, rd 2447, flush 0, corrupt 0, gen 0
[59552.096613] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 162, rd 2448, flush 0, corrupt 0, gen 0
[59557.124736] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 162, rd 2449, flush 0, corrupt 0, gen 0
[59557.125569] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 162, rd 2450, flush 0, corrupt 0, gen 0
[59572.694548] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59572.695757] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 163, rd 2450, flush 0, corrupt 0, gen 0
[59572.696295] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59572.696976] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 164, rd 2450, flush 0, corrupt 0, gen 0
[59572.697693] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59572.698397] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2450, flush 0, corrupt 0, gen 0
[59586.844083] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2451, flush 0, corrupt 0, gen 0
[59586.844614] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2452, flush 0, corrupt 0, gen 0
[59587.087696] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2453, flush 0, corrupt 0, gen 0
[59587.088378] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2454, flush 0, corrupt 0, gen 0
[59587.188784] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2455, flush 0, corrupt 0, gen 0
[59587.189280] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2456, flush 0, corrupt 0, gen 0
[59587.189737] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 165, rd 2457, flush 0, corrupt 0, gen 0
[59612.829235] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59612.829871] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 166, rd 2457, flush 0, corrupt 0, gen 0
[59612.830767] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59612.831397] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 167, rd 2457, flush 0, corrupt 0, gen 0
[59612.832220] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59612.832848] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 168, rd 2457, flush 0, corrupt 0, gen 0
[59648.014743] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59648.015221] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 169, rd 2457, flush 0, corrupt 0, gen 0
[59648.015694] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
[59648.016154] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 170, rd 2457, flush 0, corrupt 0, gen 0
[59648.017249] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1

By the way, I found this very amusing:
polgara:/mnt/btrfs_backupcopy# smartctl -i /dev/sde
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.14.0-rc5-amd64-i915-preempt-20140216c] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               /14:0:0:
Product:              0
User Capacity:        600,332,565,813,390,450 bytes [600 PB]
Logical block size:   774843950 bytes
Physical block size:  1549687900 bytes

I have a 600PB drive for sale, please make me offers :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
