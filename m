Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34760 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab2FNLd0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 07:33:26 -0400
Date: Thu, 14 Jun 2012 13:33:16 +0200
From: David Sterba <dave@jikos.cz>
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-btrfs@vger.kernel.org, sensille@gmx.net, chris.mason@fusionio.com
Subject: Re: Massive metadata size increase after upgrade from 3.2.18 to 3.4.1
Message-ID: <20120614113316.GR32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120609013822.6b06a008@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120609013822.6b06a008@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 09, 2012 at 01:38:22AM +0600, Roman Mamedov wrote:
> Before the upgrade (on 3.2.18):
> 
> Metadata, DUP: total=9.38GB, used=5.94GB
> 
> After the FS has been mounted once with 3.4.1:
> 
> Data: total=3.44TB, used=2.67TB
> System, DUP: total=8.00MB, used=412.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=84.38GB, used=5.94GB
> 
> Where did my 75 GB of free space just went?

This is caused by the patch (credits for bisecting it go to Arne)

commit cf1d72c9ceec391d34c48724da57282e97f01122
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri Jan 6 15:41:34 2012 -0500

    Btrfs: lower the bar for chunk allocation

    The chunk allocation code has tried to keep a pretty tight lid on creating new
    metadata chunks.  This is partially because in the past the reservation
    code didn't give us an accurate idea of how much space was being used.

    The new code is much more accurate, so we're able to get rid of some of these
    checks.
---
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3263,27 +3263,12 @@ static int should_alloc_chunk(struct btrfs_root *root,
                if (num_bytes - num_allocated < thresh)
                        return 1;
        }
-
-       /*
-        * we have two similar checks here, one based on percentage
-        * and once based on a hard number of 256MB.  The idea
-        * is that if we have a good amount of free
-        * room, don't allocate a chunk.  A good mount is
-        * less than 80% utilized of the chunks we have allocated,
-        * or more than 256MB free
-        */
-       if (num_allocated + alloc_bytes + 256 * 1024 * 1024 < num_bytes)
-               return 0;
-
-       if (num_allocated + alloc_bytes < div_factor(num_bytes, 8))
-               return 0;
-
        thresh = btrfs_super_total_bytes(root->fs_info->super_copy);

-       /* 256MB or 5% of the FS */
-       thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 5));
+       /* 256MB or 2% of the FS */
+       thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 2));

-       if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 3))
+       if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 8))
                return 0;
        return 1;
 }
---

Originally there were 2 types of check, based on +256M and on
percentage. The former are removed which leaves only the percentage
thresholds. If there's less than 2% of the fs of metadata actually used,
the metadata are reserved exactly to 2%. When acutual usage goes over
2%, there's always at least 20% over-reservation,

   sinfo->bytes_used < div_factor(num_bytes, 8)

ie the threshold is 80%, which may be wasteful for large fs.

So, the metadata chunks are immediately pinned to 2% of the filesystem
after first few writes, and this is what you observe.

Running balance will remove the unused metadata chunks, but only to the
2% level.

[end of analysis]

So what to do now? Simply reverting the +256M checks works and restores
more or less the original behaviour. I don't know the reason why the
patch has been added. The patch preceeding the 'lower-the-bar' is

commit 203bf287cb01a5dc26c20bd3737cecf3aeba1d48
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri Jan 6 15:23:57 2012 -0500

    Btrfs: run chunk allocations while we do delayed refs

    Btrfs tries to batch extent allocation tree changes to improve performance
    and reduce metadata trashing.  But it doesn't allocate new metadata chunks
    while it is doing allocations for the extent allocation tree.
---

"but it doesn't allocate ... while ..." this sounds like the scenario
where over-reservation of metadata would help and avoid ENOSPC. I did
tests that are presumably metadata-hungrly, like heavy snapshoting and
then decowing and watched the metadata growth rate. At most hundred megs
per second on a fast box in the worst case. And it's not a single
operation, probably spans more transactions and doing lots of other
stuff with opportunities to grab more chunks in advance and not leading
to the hypothetical problematic situtation.

I've been working on this for some time, trying to break it, without
"success". The solution I'd propose here is to reintroduce the +256M
checks (or similar threshold value).


david
