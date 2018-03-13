Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from services.gouders.net ([141.101.32.176]:49730 "EHLO
        services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932704AbeCMKjw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 06:39:52 -0400
Received: from localhost ([193.175.198.193])
        (authenticated bits=0)
        by services.gouders.net (8.14.8/8.14.8) with ESMTP id w2DARPMS006339
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 11:27:25 +0100
From: Dirk Gouders <dirk@gouders.net>
To: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Subject: FS unmountable after RAID/LVM problems
Date: Tue, 13 Mar 2018 09:53:29 +0100
Message-ID: <ghlgew5pbq.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

a somewhat aged RAID array (16 Disks) got into trouble after it has
been powered off because of facility management maintenance tasks.

It then went through some rebuilds loosing three disks on the way and
the whole procedure ended with corrupted volumes.  Volumes with
ext{2,4} filesystems could be fsck'ed and corresponding VMs then
started but a volume with a (probably) BTRFS partition I am not able
to get very far with.  I got no information what filesystems were used
on the corresponding VM but I knew it was an opensSUSE system and
file(1) told me:

# file -s /dev/loop0p1
/dev/loop0p1: BTRFS Filesystem sectorsize 4096, nodesize 16384, leafsize 16384, UUID=a6459a90-ebe3-4c75-97f4-5496eadcc96f, 9141452800/10741612544 bytes used, 1 devices

so I am somewhat sure that it was a BTRFS.

I tried to use some tools on copies of the Volume data and see messages
concerning invalid checksums as well as ones of bad tree block starts
and I'd like to understand what the main issue of that FS might be.

I'll try to present some information and because I worked only on copies
of the corrupted data, I can provide more information or tests on
request. The kernel on the machine I use for diagnosis is
4.16.0-rc5-00004-gfc6eabbbf8ef.

Mounting:

# mount /dev/loop0p1 /mnt/
mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop0p1, missing codepage or helper program, or other error.

dmesg(1) says:

[  176.479080] BTRFS: device fsid a6459a90-ebe3-4c75-97f4-5496eadcc96f devid 1 transid 9858294 /dev/loop0p1
[  186.909100] BTRFS info (device loop0p1): disk space caching is enabled
[  186.990090] BTRFS error (device loop0p1): bad tree block start 2163788338953595011 212353024
[  186.996331] BTRFS error (device loop0p1): bad tree block start 8619112249313723677 212353024
[  187.044482] BTRFS error (device loop0p1): open_ctree failed

find-root:

# btrfs-find-root /dev/loop0p1
Superblock thinks the generation is 9858294
Superblock thinks the level is 1
Found tree root at 848773120 gen 9858294 level 1
Well block 832045056(gen: 9858272 level: 1) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
Well block 831799296(gen: 9858271 level: 1) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
Well block 831520768(gen: 9858270 level: 1) seems good, but generation/level doesn't match, want gen: 9858294 level: 1

...several similar lines that differ only in the block and gen, the
last two lines differ a bit more:

Well block 72089600(gen: 9728190 level: 0) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
Well block 4243456(gen: 3 level: 0) seems good, but generation/level doesn't match, want gen: 9858294 level: 1
Well block 4194304(gen: 2 level: 0) seems good, but generation/level doesn't match, want gen: 9858294 level: 1

When I then try a restore with the first block # of the previous command:

# btrfs restore -t 832045056 -D /dev/loop0p1 /mnt/btrfs/
parent transid verify failed on 832045056 wanted 9858294 found 9858272
parent transid verify failed on 832045056 wanted 9858294 found 9858272
parent transid verify failed on 832045056 wanted 9858294 found 9858272
parent transid verify failed on 832045056 wanted 9858294 found 9858272
Ignoring transid failure
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
Could not open root, trying backup super
parent transid verify failed on 832045056 wanted 9858294 found 9858272
parent transid verify failed on 832045056 wanted 9858294 found 9858272
parent transid verify failed on 832045056 wanted 9858294 found 9858272
parent transid verify failed on 832045056 wanted 9858294 found 9858272
Ignoring transid failure
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
checksum verify failed on 363069440 found DC09290B wanted C630FD61
checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
bytenr mismatch, want=363069440, have=17552567724568668829
Could not open root, trying backup super
ERROR: superblock bytenr 274877906944 is larger than device size 10741612544
Could not open root, trying backup super

Dirk
