Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56921 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752080AbeERNPb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 09:15:31 -0400
Date: Fri, 18 May 2018 21:15:16 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix the corruption by reading stale btree blocks
Message-ID: <20180518131515.n23ysksu5x24kchb@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>
 <880e75c4-10fa-8487-7bed-29c7c8c380fc@suse.com>
 <20180516141221.GA6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516141221.GA6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 04:12:21PM +0200, David Sterba wrote:
> On Wed, May 16, 2018 at 11:00:14AM +0300, Nikolay Borisov wrote:
> > 
> > 
> > On 15.05.2018 20:37, Liu Bo wrote:
> > > If a btree block, aka. extent buffer, is not available in the extent
> > > buffer cache, it'll be read out from the disk instead, i.e.
> > > 
> > > btrfs_search_slot()
> > >   read_block_for_search()  # hold parent and its lock, go to read child
> > >     btrfs_release_path()
> > >     read_tree_block()  # read child
> > > 
> > > Unfortunately, the parent lock got released before reading child, so
> > > commit 5bdd3536cbbe ("Btrfs: Fix block generation verification race") had
> > > used 0 as parent transid to read the child block.  It forces
> > > read_tree_block() not to check if parent transid is different with the
> > > generation id of the child that it reads out from disk.
> > > 
> > > A simple PoC is included in btrfs/124,
> > > 
> > > 0. A two-disk raid1 btrfs,
> > > 
> > > 1. Right after mkfs.btrfs, block A is allocated to be device tree's root.
> > > 
> > > 2. Mount this filesystem and put it in use, after a while, device tree's
> > >    root got COW but block A hasn't been allocated/overwritten yet.
> > > 
> > > 3. Umount it and reload the btrfs module to remove both disks from the
> > >    global @fs_devices list.
> > > 
> > > 4. mount -odegraded dev1 and write some data, so now block A is allocated
> > >    to be a leaf in checksum tree.  Note that only dev1 has the latest
> > >    metadata of this filesystem.
> > > 
> > > 5. Umount it and mount it again normally (with both disks), since raid1
> > >    can pick up one disk by the writer task's pid, if btrfs_search_slot()
> > >    needs to read block A, dev2 which does NOT have the latest metadata
> > >    might be read for block A, then we got a stale block A.
> > > 
> > > 6. As parent transid is not checked, block A is marked as uptodate and
> > >    put into the extent buffer cache, so the future search won't bother
> > >    to read disk again, which means it'll make changes on this stale
> > >    one and make it dirty and flush it onto disk.
> > > 
> > > To avoid the problem, parent transid needs to be passed to
> > > read_tree_block().
> > > 
> > > In order to get a valid parent transid, we need to hold the parent's
> > > lock until finish reading child.
> > > 
> > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > 
> > Doesn't this warrant a stable tag and
> > Fixes: 5bdd3536cbbe ("Btrfs: Fix block generation verification race")
> 
> The patch will not apply to < 4.16 as it depends on the addition of
> &first_key check from 581c1760415c4, but yes we need it for stable.

True, we can easily fix the conflicts by removing @first_key, can't
we?

The problem does exist before it.

thanks,
-liubo
