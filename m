Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:37075 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeAUTQ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 14:16:57 -0500
Received: by mail-lf0-f53.google.com with SMTP id f3so7996588lfe.4
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 11:16:56 -0800 (PST)
MIME-Version: 1.0
From: Liwei <xieliwei@gmail.com>
Date: Mon, 22 Jan 2018 03:16:34 +0800
Message-ID: <CAPE0SYzT42vq-pRYctKohr42yK0E+T1sWJv2KPLxp5Cv1z7yqg@mail.gmail.com>
Subject: Damaged Root Tree(s)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

====TLDR====
1. Can I mount a filesystem using one of the roots found with btrfs-find-root?
2. Can btrfs check just fix the damaged root without attempting any
other repairs?
3. If the above is not possible, how should I proceed given that I
seem to have lost both the main and backup roots?

====Background Information====
    I have a 2x10TB raid0 (20TB, raid0 provided by md) volume that (my
theory is) experienced a headcrash while updating the root tree, or
maybe while it was carrying out background defragmentation.

    This occurred while I was setting up redundancy by using LVM
mirroring, so in the logs you'll see some dm errors. Unfortunately the
lost data has not been mirrored yet (what are the chances, given that
the mirror was 97% complete when this happened).

    Running a scrub on the raid shows that I have 1000+ unreadable
sectors, amounting to about 800kB of data. So I've got spare drives
and imaged the offending drive. Currently ddrescue is still trying to
read those sectors, but it seems unlikely that they'll ever succeed.

====Problem====
    So with an imaged copy of the array, I tried remounting the
filesystem, but it refuses to mount even using 'usebackuproot':

With usebackuproot:
[ 1610.788527] device-mapper: raid1: Mirror read failed.
[ 1610.788799] device-mapper: raid1: Mirror read failed.
[ 1610.788939] Buffer I/O error on dev dm-15, logical block
5371800560, async page read
[ 1610.823141] BTRFS: device label edata devid 1 transid 318593
/dev/mapper/datavol-edata
[ 1616.778563] BTRFS info (device dm-15): trying to use backup root at
mount time
[ 1616.778758] BTRFS info (device dm-15): disk space caching is enabled
[ 1617.961152] device-mapper: raid1: Mirror read failed.
[ 1618.238198] device-mapper: raid1: Mirror read failed.
[ 1618.238498] BTRFS warning (device dm-15): failed to read tree root
[ 1618.238700] device-mapper: raid1: Mirror read failed.
[ 1618.238878] device-mapper: raid1: Mirror read failed.
[ 1618.239050] BTRFS warning (device dm-15): failed to read tree root
[ 1618.239207] device-mapper: raid1: Mirror read failed.
[ 1618.239372] device-mapper: raid1: Mirror read failed.
[ 1618.239590] BTRFS warning (device dm-15): failed to read tree root
[ 1618.239775] device-mapper: raid1: Mirror read failed.
[ 1618.240055] device-mapper: raid1: Mirror read failed.
[ 1618.240298] BTRFS warning (device dm-15): failed to read tree root
[ 1618.240492] device-mapper: raid1: Mirror read failed.
[ 1618.240744] device-mapper: raid1: Mirror read failed.
[ 1618.240989] BTRFS warning (device dm-15): failed to read tree root
[ 1618.363234] BTRFS error (device dm-15): open_ctree failed

Without usebackuproot:
[ 2149.015427] device-mapper: raid1: Mirror read failed.
[ 2149.015700] device-mapper: raid1: Mirror read failed.
[ 2149.015840] Buffer I/O error on dev dm-15, logical block
5371800560, async page read
[ 2154.172102] BTRFS info (device dm-15): disk space caching is enabled
[ 2155.325134] device-mapper: raid1: Mirror read failed.
[ 2155.715439] device-mapper: raid1: Mirror read failed.
[ 2155.715795] BTRFS warning (device dm-15): failed to read tree root
[ 2155.851599] BTRFS error (device dm-15): open_ctree failed

    It appears that the damaged data has affected both the main and
backup roots.

    Next I ran btrfs-find-root, which gave me the following:
Superblock thinks the generation is 318593
Superblock thinks the level is 1
Well block 25826479144960(gen: 318346 level: 1) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
Well block 25826450505728(gen: 318345 level: 1) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
Well block 25826461237248(gen: 318344 level: 1) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
Well block 25826479669248(gen: 318342 level: 0) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
Well block 25826479603712(gen: 318342 level: 0) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
Well block 25826468495360(gen: 318342 level: 0) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
Well block 25826465923072(gen: 318342 level: 0) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
Well block 25826477654016(gen: 318341 level: 0) seems good, but
generation/level doesn't match, want gen: 318593 level: 1
...[truncated]

    I tried running btrfs check with the top 5 roots, but only the
first 3 seems to be usable. However, even with the first 3, btrfs
check gives me a lot of:
bytenr mismatch, want=26008292753408, have=0
bytenr mismatch, want=26353175658496, have=0
bytenr mismatch, want=26353188618240, have=0
bytenr mismatch, want=26353513299968, have=0
    and thousands of extent errors, etc. I do see references to
directories within the filesystem though, so I'd think the tree root
is at least pretty good.

    Just to see if btrfs check can reach a usable state, I made a COW
snapshot of the imaged drive, and ran btrfs check --repair. However,
it eventually gives up, and seemed to have wrecked the FS.

    Is there a way to mount/repair the filesystem with the found root
instead? I'd like to copy the files off the image, but prefer not to
use btrfs restore. Can btrfs check just copy the alternative root and
not try to repair anything else?

====Misc info====
# uname -a
Linux tvm 4.14.0-3-amd64 #1 SMP Debian 4.14.13-1 (2018-01-14) x86_64 GNU/Linux
# btrfs --version
btrfs-progs v4.13.3

Thanks for the help!
Liwei
