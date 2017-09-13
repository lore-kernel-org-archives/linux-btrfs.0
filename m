Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:43032 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdIMNJC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 09:09:02 -0400
Received: by mail-oi0-f42.google.com with SMTP id r20so1084696oie.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 06:09:02 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 13 Sep 2017 15:09:01 +0200
Message-ID: <CAJCQCtRu=MW78-pFdMNzUUEZDb2-7-TmJ3w1H343NxoCw1OOGg@mail.gmail.com>
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
executed once a week or even once per hour.

Possibly better would be a delayed discard list. i.e. current discard
list accumulates
discards for e.g. 5 minutes, and then current list becomes a static
delayed list, and a new current list is started. After another 5
minutes, delayed list is executed for discards, and current list
becomes delayed list. That way discarded blocks are a minimum of 5
minutes old.

I guess there are security implications by delaying discard, so there
might be a use case for non-delayed discards (?)



-- 
Chris Murphy
