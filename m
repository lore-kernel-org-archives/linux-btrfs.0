Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55618 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727392AbeIUTBv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 15:01:51 -0400
Date: Fri, 21 Sep 2018 15:13:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, sunny.s.zhang@oracle.com,
        bo.liu@linux.alibaba.com, nborisov@suse.com
Subject: Re: [PATCH RFC] btrfs: delayed-inode: Use spinlock to protect
 btrfs_inode::delayed_node
Message-ID: <20180921131300.GF5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180919065958.21153-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180919065958.21153-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 02:59:58PM +0800, Qu Wenruo wrote:
> In the following case, we could trigger a use-after-free bug:
> 
>          CPU0                    |               CPU1
> -------------------------------------------------------------------------
> btrfs_remove_delayed_node        | btrfs_get_delayed_node
> |- delayed_node =                | |- node = btrfs_inode->delayed_node;
> |    btrfs_inode->delayed_node   | |
> |- btrfs_release_delaedy_node()  | |
>    |- ref_count_dev_and_test()   | |
>    |- kmem_cache_free()          | |
>       Now delayed node is freed  | |
>                                  | |- refcount_inc(&node->refs)
> 
> In that case sine delayed_node is using kmem cache, such use-after-free
> bug won't directly cause problem, but could leads to corrupted data
> structure of other kmem cache user.
> 
> Fix it by adding btrfs_inode::delayed_node_lock to protect such
> operation.
> 
> Reported-by: sunny.s.zhang <sunny.s.zhang@oracle.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Please don't merge this patch yet.
> 
> The patch caused random slow down for a lot of quick test cases.
> Old tests can be executed in 1s or so now randomly needs near 20s.
> 
> It looks like the spin_lock() with root->inode_lock hold is causing the
> problem but I can't see what's going wrong.
> As the operation done with @delayed_node_lock hold is literatly tiny.
> 
> Any comment on this is welcomed.

I found the original report and discussion, so the resume is that it's
possibly caused by the refcount_t rework and the missing fix
ec35e48b2869599 .

As in time of evict there can be no active operation running and the
crash happened inside atime update. I take the bug in refcounting as a
plausible explanation so your patch does not seem to be necessary,
unless there's a reproducer on a recent kernel.
