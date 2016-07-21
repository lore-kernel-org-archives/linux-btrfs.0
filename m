Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26296 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbcGUPcs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 11:32:48 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix memory leak of block group cache
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1469061234-15337-1-git-send-email-bo.li.liu@oracle.com>
 <1469061852-21185-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
Message-ID: <9300daf6-000a-7bfa-f7a8-c0b418cbd6ba@fb.com>
Date: Thu, 21 Jul 2016 11:32:26 -0400
MIME-Version: 1.0
In-Reply-To: <1469061852-21185-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/20/2016 08:44 PM, Liu Bo wrote:
> While processing delayed refs, we may update block group's statistics
> and attach it to cur_trans->dirty_bgs, and later writing dirty block
> groups will process the list, which happens during
> btrfs_commit_transaction().
>
> For whatever reason, the transaction is aborted and dirty_bgs
> is not processed in cleanup_transaction(), we end up with memory leak
> of these dirty block group cache.
>
> Since btrfs_start_dirty_block_groups() doesn't make it go to the commit
> critical section, this also adds the cleanup work inside it.

It's the start_drity_block_groups() hunt that worries me a bit:

> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 50bd683..7a35c9d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3698,6 +3698,8 @@ again:
>  			goto again;
>  		}
>  		spin_unlock(&cur_trans->dirty_bgs_lock);
> +	} else if (ret < 0) {
> +		btrfs_cleanup_dirty_bgs(cur_trans, root);
>  	}
>
>  	btrfs_free_path(path);
>

We have checks in here to make sure only one process runs 
btrfs_start_dirty_block_groups() but that doesn't mean that only one 
process its messing around with the cache inode.  Is there any reason we 
can't let this cleanup wait for the cleanup_transaction code?

btrfs_run_delayed_refs() already aborts when it fails.

-chris


