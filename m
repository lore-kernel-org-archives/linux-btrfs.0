Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15683 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbaKEUeT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Nov 2014 15:34:19 -0500
Message-ID: <545A89B7.3000602@fb.com>
Date: Wed, 5 Nov 2014 15:33:59 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix race when cleaning unused block groups
References: <1415217364-32108-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1415217364-32108-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/05/2014 02:56 PM, Filipe Manana wrote:
> We have a race while deleting unused block groups that causes extents written
> by past generations/transactions to be rewritten by the current transaction
> before that transaction is committed. The steps that lead to this issue:
>
> 1) At transaction N one or more block groups became unused and we added them
>     to the list fs_info->unused_bgs;
>
> 2) While still at transaction N we write btree extents to block group X and the
>     transaction is committed;
>
> 3) The cleaner kthread is awaken and calls btrfs_delete_unused_bgs() to go through
>     the list fs_info->unused_bgs and remove unused block groups;
>
> 4) Transaction N + 1 starts;
>
> 5) At transaction N + 1, block group X becomes unused and is added to the list
>     fs_info->unused_bgs - this implies delayed refs were run, so we had the
>     following function calls: btrfs_run_delayed_refs() -> __btrfs_free_extent()
>     -> update_block_group(). The update_block_group() function grabs the lock
>     fs_info->unused_bgs_lock, adds block group X to fs_info->unused_bgs and
>     releases that lock;
>
> 6) The cleaner kthread, while at btrfs_delete_unused_bgs(), sees block group X
>     added by transaction N + 1 because it's doing a loop that finishes only when
>     the list fs_info->unused_bgs is empty and locks and unlocks the spinlock
>     fs_info->unused_bgs_lock on each iteration. So it deletes the block group
>     and its respective chunk is released. Even if it didn't do the lock/unlock
>     per iteration, it could still see block group X in the list, because the
>     cleaner kthread might call btrfs_delete_unused_bgs() multiple times (for
>     example if there are several snapshots to delete);
>
> 7) A new block group X' is created for data, and it's associated to the same chunk
>     that block group X was associated to;
>

Actually this can't happen, we search the commit root for a free dev 
extent, so if block group X` get's mapped to a dev extent that was 
deleted in the same transaction as it was free'd in then that is a 
different problem.

> 8) Extents from block group X' are allocated for file data and for example an fsync
>     makes the file data be effectively written to disk;
>

Also if a new block group is allocated fsync() will trigger a full 
transaction commit.  So thinking about this more I'm not entirely sure 
there is actually a problem here.  Did you observe this issue?  Are you 
sure it's because of this change and not just exacerbated by it?  Thanks,

Josef
