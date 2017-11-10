Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:50486 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbdKJXwi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 18:52:38 -0500
Received: by mail-ot0-f169.google.com with SMTP id 15so9512233otj.7
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 15:52:38 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <chris@colorremedies.com>
Date: Fri, 10 Nov 2017 16:52:37 -0700
Message-ID: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
Subject: discard on SSDs quickly causes backup trees to vanish
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hardware:
HP Spectre which contains a SAMSUNG MZVLV256HCHP-000H1, which is an NVMe drive.

Kernels:
various but definitely 4.12.0 through 4.13.10

Problem:
Within seconds of the super being updated to point to a new root tree,
the old root tree cannot be read with btrfs-debug-tree. Example:


$ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
btrfs-progs v4.13.3
node 84258750464 level 1 items 2 free 491 generation 200994 owner 1
fs uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec
chunk uuid 1df72dcf-f515-404a-894a-f7345f988793
    key (EXTENT_TREE ROOT_ITEM 0) block 84258783232 (5142748) gen 200994
    key (452 INODE_ITEM 0) block 84258881536 (5142754) gen 200994

(wait 10-40 seconds while file system is in use)

$ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
btrfs-progs v4.13
checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=84258750464, have=0
ERROR: failed to read 84258750464
[chris@f26h ~]$

This suggests a problem for any kind of automatic recovery, should it
be needed at next mount time, following a crash or power failure, as
well as rendering the usebackuproot useless.

I think until discard mount option has some kind of delay (generation
based perhaps), so that at least the various backup trees, in
particular the root tree, is not immediately subject to discard, that
the Btrfs wiki needs to suggest the discard mount option is unsafe on
SSD.

While I have not experienced any other problems in roughly a year of
using discard and Btrfs on this hardware, if I had needed a rollback
offered by use of a backup tree, they simply wouldn't have been
available, and I'd have been hosed.

(Needs testing on LVM thinp to see if discard causes a similar problem
with Btrfs on LVM thinly provisioned volumes, even with hard drives.)



-- 
Chris Murphy
