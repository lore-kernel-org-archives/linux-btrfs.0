Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48729 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753115AbdJTRyp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 13:54:45 -0400
Date: Fri, 20 Oct 2017 19:52:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: free btrfs_device in place
Message-ID: <20171020175256.GT3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010215103.20828-2-bo.li.liu@oracle.com>
 <20171011181330.17015-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171011181330.17015-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 12:13:30PM -0600, Liu Bo wrote:
> It's pointless to defer it to a kthread helper as we're not under any
> special context.
> 
> A bit more about device's lifetime, filesystems use an exclusive way
> to access devices and hold a reference count on the devices in use.
> Now that we've run blkdev_put() in btrfs_close_bdev(), device->bdev's
> lifetime ends at btrfs_close_bdev(), not free_device(), and %bdev is
> the only thing that others who need to access it really care about.
> 
> Since free_device() only frees the resources of 'struct btrfs_device',
> this change won't result in the problem, ie. others like mkfs and md
> are unable to access the device immediately after we do umount.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> ---
> 
> v2: Clarify the lifetime of device and device->bdev respectively and
>     clear the concern about raising the 'device is in use' problem.

I found my version of the patch, the diff is the same, plus we can now remove
the rcu_work hook

--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -133,7 +133,6 @@ struct btrfs_device {

        struct btrfs_work work;
        struct rcu_head rcu;
-       struct work_struct rcu_work;

        /* readahead state */
        spinlock_t reada_lock;

The changelog is outdated and still mentions the blkdev_put, that's now
obsolete. I'd still want to keep the commit ids for reference. Can you please
merge it to your changelog and resend? Thanks.

"
    Commit "Btrfs: using rcu lock in the reader side of devices list"
    (1f78160ce1b1b8e657e2248118c4d91f881763f0) introdced RCU freeing for
    device structures. In a way that is questionable to say at least.

    One of the strange points is the freeing of device: schedule an RCU
    callback and from that schedule a workqueue callback that actually drops
    the bdev and frees the structure.

    Elswehere in the code we checkpoint the RCU with call_rcu or
    rcu_barrier, although with the extra call to workqueu, there might be
    some pending operations still unfinished. This can lead to a busy device
    after umount, similar to what commit "btrfs: use rcu_barrier() to wait
    for bdev puts at unmount" (bc178622d40d87e75abc131007342429c9b03351)
    fixed.

    Drop the extra step and don't schedule the work. We can free directly
    from the RCU callback. While this means we might do more work on in the
    RCU callback context, ie. calling blkdev_put, this is not an issue. The
    device call_rcu is always preceded by sync and invalidation of the block
    device so we're left only with the lightweight operations.
"
