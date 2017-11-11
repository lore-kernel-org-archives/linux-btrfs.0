Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:42994 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750904AbdKKByD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 20:54:03 -0500
Subject: Re: discard on SSDs quickly causes backup trees to vanish
To: Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
Date: Sat, 11 Nov 2017 02:54:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/11/2017 12:52 AM, Chris Murphy wrote:
> Hardware:
> HP Spectre which contains a SAMSUNG MZVLV256HCHP-000H1, which is an NVMe drive.
> 
> Kernels:
> various but definitely 4.12.0 through 4.13.10
> 
> Problem:
> Within seconds of the super being updated to point to a new root tree,
> the old root tree cannot be read with btrfs-debug-tree.

Is this a problem, or is this just expected, by design?

> Example:
> 
> 
> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
> btrfs-progs v4.13.3
> node 84258750464 level 1 items 2 free 491 generation 200994 owner 1
> fs uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec
> chunk uuid 1df72dcf-f515-404a-894a-f7345f988793
>     key (EXTENT_TREE ROOT_ITEM 0) block 84258783232 (5142748) gen 200994
>     key (452 INODE_ITEM 0) block 84258881536 (5142754) gen 200994
> 
> (wait 10-40 seconds while file system is in use)

After the superblock is written, this space is freed up to be
overwritten by new writes immediately...

> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
> btrfs-progs v4.13
> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=84258750464, have=0
> ERROR: failed to read 84258750464
> [chris@f26h ~]$

Even when not using discard, there might be new data in that place now,
when the file system is in use...

> This suggests a problem for any kind of automatic recovery, should it
> be needed at next mount time, following a crash or power failure, as
> well as rendering the usebackuproot useless.

Maybe the name backuproot is useless, because it's not a backup at all.

Only the most recent previous one is if you have to mount a filesystem
directly after some bug hosed your tree of trees during a final commit
when umounting just before?

> I think until discard mount option has some kind of delay (generation
> based perhaps), so that at least the various backup trees, in
> particular the root tree, is not immediately subject to discard, that
> the Btrfs wiki needs to suggest the discard mount option is unsafe on
> SSD.
> 
> While I have not experienced any other problems in roughly a year of
> using discard and Btrfs on this hardware, if I had needed a rollback
> offered by use of a backup tree, they simply wouldn't have been
> available, and I'd have been hosed.
> (Needs testing on LVM thinp to see if discard causes a similar problem
> with Btrfs on LVM thinly provisioned volumes, even with hard drives.)

I actually start wondering why this option exists at all. I mean, even
when it seems you get a working filesystem back with it, there can be
metadata and data in all corners of the filesystem that already has been
overwritten?

It was introduced in commit af31f5e5b "Btrfs: add a log of past tree
roots" and the only information we get is "just in case we somehow lose
the roots", which is an explanation for adding this feature that does
not really tell me much about it.

-- 
Hans van Kranenburg
