Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933515AbeAKNEf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 08:04:35 -0500
Subject: Re: [PATCH] btrfs: return 0 for success in
 btrfs_alloc_data_chunk_ondemand
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
References: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6781fba1-d6c6-fa10-67e0-93eef47795f8@suse.com>
Date: Thu, 11 Jan 2018 15:04:31 +0200
MIME-Version: 1.0
In-Reply-To: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.01.2018 18:55, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> My delayed refs rsv patches uncovered a problem in
> btrfs_alloc_data_chunk_ondemand where we don't clear ret before
> returning, so we could have whatever left over value we had from trying
> to do a chunk allocation or whatever that may have failed.  Since we
> know we've succeeded at this point just unconditionally return 0.  This
> fixed the xfstests failures I was seeing with my delayed refs rsv
> patches.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dbae25d882de..33c9efbfc9a7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4387,8 +4387,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
>  	trace_btrfs_space_reservation(fs_info, "space_info",
>  				      data_sinfo->flags, bytes, 1);
>  	spin_unlock(&data_sinfo->lock);
> -
> -	return ret;
> +	return 0;
>  }
>  

While this patch indeed seems to fix some failure I was seeing with
non-empty delalloc resv I fail to see why returning 1 could cause them.

In btrfs_check_data_free_space we only check if ret is < 0 and after
that we call btrfs_qgroup_reserve_data so this can't cause an issue.

Then we have usage in btrfs_zero_range which is a new code and is not
really used-per se in the tests that I saw failing.

So the last remaining possible culprit is the usage in btrfs_fallocate
(and indeed adding printk's shows that everytime a test fail we indeed
returned 1 from alloc_data_chunk. However, looking at the code in
fallocate ret is always overwritten before being checked. So how exactly
is returning a positive value influencing the freeing of per-inode block
rsvs?

>  int btrfs_check_data_free_space(struct inode *inode,
> 
