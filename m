Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:38765 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab3BTFA3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 00:00:29 -0500
Received: by mail-da0-f49.google.com with SMTP id t11so3314821daj.22
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2013 21:00:28 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 00:00:28 -0500
Message-ID: <CALJXSJpxVPeQa4v9w7Z1SOjVNNSAm4F1F3rbDdzThNmzV2JtGA@mail.gmail.com>
Subject: bio too big/checksum errors during LVM pvmove
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I get many checksum errors *during* pvmove operations, such as:

[13954.139079] bio too big device dm-4 (72 > 8)
[13954.139091] bio too big device dm-4 (16 > 8)
[13954.139104] bio too big device dm-4 (56 > 8)
[14040.223812] bio too big device dm-4 (64 > 8)
[14040.223818] btrfs_dev_stat_print_on_error: 9 callbacks suppressed
...
[14175.389937] btrfs: bdev /dev/mapper/btrfs2 errs: wr 0, rd 1196,
flush 0, corrupt 0, gen 0
[14175.389956] btrfs csum failed ino 508725 extent 3219001344 csum
1636590654 wanted 2132898075 mirror 0
[14206.788000] bio too big device dm-4 (64 > 8)
[14206.788011] btrfs: bdev /dev/mapper/btrfs2 errs: wr 0, rd 1197,
flush 0, corrupt 0, gen 0
[14206.788035] btrfs csum failed ino 508725 extent 3219001344 csum
3779168556 wanted 2132898075 mirror 0
[14227.853863] bio too big device dm-4 (64 > 8)
[14227.853870] btrfs: bdev /dev/mapper/btrfs2 errs: wr 0, rd 1198,
flush 0, corrupt 0, gen 0
[14227.853884] btrfs csum failed ino 508725 extent 3219001344 csum
895061498 wanted 2132898075 mirror 0
...

My setup is:
sda3 \
sdb3   \__  md0 RAID5 __ LVM2 PV __ Cryptsetup LV __ BTRFS
sdc3   /
sdd3 /

I pv-moved from md0 to md0 (alloc=anywhere to make room for pvresize)
pvmove -v --alloc=anywhere /dev/md1:95793-99632 /dev/md1:70107-74032

During pvmove some program crash with SIGBUS. However, after pvmove
completes, everything comes back to normal as if nothing has ever
happened. I restart crashed program and they work just fine, now
errors.

A scrub from initramfs completes without any error, I don't think this
has a relation to my other issue (Kernel panic on scrub) as my root is
directly on /dev/sd[abcd]4 and both do kernel panic when a scrub is
started when the system is booted.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
