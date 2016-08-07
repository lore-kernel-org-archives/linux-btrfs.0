Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34620 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbcHGWom (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Aug 2016 18:44:42 -0400
Received: by mail-io0-f196.google.com with SMTP id i199so5510708ioi.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Aug 2016 15:44:42 -0700 (PDT)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Sun, 7 Aug 2016 18:44:20 -0400
Message-ID: <CAH=dxU4BDgUjuzYsv+Lcd9XedWO_hZ+2x0XpPgp6ZYkxbjO2hA@mail.gmail.com>
Subject: btrfs open_ctree failed - root fs will not mount
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am running Arch Linux on a system with full disk encryption and the
storage is a Samsung 950 Pro NVMe drive (512 GB). The computer is a
couple months old. No bad behavior until now. (I'm only using 21 GB of
the 512 space on the disk.)

    btrfs-progs v4.5.1

Today I was using my system normally and browsing the web. Firefox
stopped responding suddenly and for no apparent reason. Then (KDE)
Plasma stopped responding. I could not log out of KDE.

I killed my user session (pkill -u me), then I tired to startx. At
that point I noticed my root filesystem was read-only.

As a first step, I rebooted. That didn't help anything. I tried
rebooting several more times -- no change.

The root filesystem (btrfs) would not mount. (See error below.) I
booted into a LiveUSB environment and ran this command:

    cryptsetup open --type luks /dev/xxx cryptroot

It opens. Then I ran:

    mount -t btrfs -o
noatime,nodiratime,ssd,compress=lzo,defaults,space_cache,subvolid=257
/dev/mapper/cryptroot /mnt

The error message is shown here:

    [ 2300.967048] BTRFS info (device dm-0): use ssd allocation scheme
    [ 2300.967058] BTRFS info (device dm-0): use lzo compression
    [ 2300.967066] BTRFS info (device dm-0): disk space caching is enabled
    [ 2300.967069] BTRFS: has skinny extents
    [ 2300.995393] BTRFS: error (device dm-0) in
btrfs_replay_log:2413: errno=-22 unknown (Failed to recover log tree)
    [ 2300.997617] BTRFS info (device dm-0): delayed_refs has NO entry
    [ 2300.997673] BTRFS error (device dm-0): cleaner transaction
attach returned -30
    [ 2301.035405] BTRFS: open_ctree failed

It is exactly the same error I saw when trying to boot normally as
mentioned above.

Based on these two links:

> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
> https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log

I decided to take a chance on running this command:

    btrfs rescue zero-log

That worked and I can mount the filesystem.

I ran btrfs check --repair. Here is the output:

    root@broken / # umount /mnt
    root@broken / # btrfs check --repair /dev/mapper/cryptroot
    enabling repair mode
    Checking filesystem on /dev/mapper/cryptroot
    checking extents
    bad metadata [292414476288, 292414492672) crossing stripe boundary
    bad metadata [292414541824, 292414558208) crossing stripe boundary
    bad metadata [292414672896, 292414689280) crossing stripe boundary
    bad metadata [292414869504, 292414885888) crossing stripe boundary
    bad metadata [292415000576, 292415016960) crossing stripe boundary
    bad metadata [292415066112, 292415082496) crossing stripe boundary
    bad metadata [292415131648, 292415148032) crossing stripe boundary
    bad metadata [292415262720, 292415279104) crossing stripe boundary
    bad metadata [292415328256, 292415344640) crossing stripe boundary
    bad metadata [292415393792, 292415410176) crossing stripe boundary
    repaired damaged extent references
    Fixed 0 roots.
    checking free space cache
    cache and super generation don't match, space cache will be invalidated
    checking fs roots
    checking csums
    checking root refs
    checking quota groups
    Ignoring qgroup relation key 258
    Ignoring qgroup relation key 263
    Ignoring qgroup relation key 71776119061217538
    Ignoring qgroup relation key 71776119061217543
    Counts for qgroup id: 257 are different
    our:            referenced 10412273664 referenced compressed 10412273664
    disk:           referenced 10411311104 referenced compressed 10411311104
    diff:           referenced 962560 referenced compressed 962560
    our:            exclusive 10412273664 exclusive compressed 10412273664
    disk:           exclusive 10412273664 exclusive compressed 10412273664
    found 21570773057 bytes used err is 0
    total csum bytes: 19563456
    total tree bytes: 403767296
    total fs tree bytes: 349667328
    total extent tree bytes: 27328512
    btree space waste bytes: 66313360
    file data blocks allocated: 39882014720
    referenced 28043988992
    extent buffer leak: start 20987904 len 16384
    extent buffer leak: start 292688068608 len 16384
    extent buffer leak: start 60915712 len 16384
    extent buffer leak: start 29569581056 len 16384
    extent buffer leak: start 29569597440 len 16384
    extent buffer leak: start 292412063744 len 16384
    extent buffer leak: start 292405870592 len 16384
    extent buffer leak: start 292405936128 len 16384
    extent buffer leak: start 292413964288 len 16384

Then I check dmesg and I see this error information:

    [ 4925.562422] BTRFS info (device dm-0): use ssd allocation scheme
    [ 4925.562432] BTRFS info (device dm-0): use lzo compression
    [ 4925.562440] BTRFS info (device dm-0): disk space caching is enabled
    [ 4925.562444] BTRFS: has skinny extents
    [ 4925.578705] BTRFS error (device dm-0): qgroup generation
mismatch, marked as inconsistent
    [ 4925.584033] BTRFS: checking UUID tree

What should I do next? I'm a simple user.

I already ran memtest86+ overnight using 8 CPU cores in parallel (so
it was a very thorough memory test). There were 0 RAM errors.

I previously used btrfs since 2012 with no issues. I am concerned
about the present issue because I do not understand the cause.
