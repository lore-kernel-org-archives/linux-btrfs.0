Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:46116 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdIMM6R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 08:58:17 -0400
Received: by mail-oi0-f42.google.com with SMTP id x190so808720oix.3
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 05:58:17 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <chris@colorremedies.com>
Date: Wed, 13 Sep 2017 14:58:16 +0200
Message-ID: <CAJCQCtTbYvz3hRbOcS=0U39DaukSZ4J4idC5D-fg7HsOn+B5=w@mail.gmail.com>
Subject: discard and rollback
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been running discard mount option continuously for about 9 months
with an HP Spectre which contains a SAMSUNG MZVLV256HCHP-000H1 as
reported by smartctl. There have been no problems.

However I realize today that within seconds of a super being updated
with a new root tree, the old address returns nothing:

[chris@f26h ~]$ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
btrfs-progs v4.12
node 84258750464 level 1 items 2 free 491 generation 200994 owner 1
fs uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec
chunk uuid 1df72dcf-f515-404a-894a-f7345f988793
    key (EXTENT_TREE ROOT_ITEM 0) block 84258783232 (5142748) gen 200994
    key (452 INODE_ITEM 0) block 84258881536 (5142754) gen 200994
[chris@f26h ~]$ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
btrfs-progs v4.12
checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=84258750464, have=0
ERROR: failed to read 84258750464
[chris@f26h ~]$

This suggests a problem for automatic recovery, should it be needed at
next mount, as well as the use of 'usebackuproot'. And it could make
Btrfs much more fragile than it would otherwise be.

It's not broken, so I have no fix proposal. Of course discard is not
the default mount option, and a viable work around is fstrim.timer
executed once a week or even once per hour. Possibly a better option
is a delayed discard list. i.e. current discard list accumulates
discards for e.g. 5 minutes, and then current list becomes a static
delayed list, and a new current list is started. After another 5
minutes, delayed list is executed for discards, and current list
becomes delayed list. That way discarded blocks are a minimum of 5
minutes old.

I guess there are security implications by delaying discard, so there
might be a use case for non-delayed discards (?)


-- 
Chris Murphy
