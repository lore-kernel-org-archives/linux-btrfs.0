Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966342AbeAORQ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 12:16:58 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00ACAAD8B
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 17:16:57 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Remove btrfs_inode::delayed_iput_count
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1516019494-24210-1-git-send-email-nborisov@suse.com>
From: Edmund Nadolski <enadolski@suse.de>
Message-ID: <3188dc79-0fc7-9fc9-b5e9-bc5c2f55d1af@suse.de>
Date: Mon, 15 Jan 2018 10:16:54 -0700
MIME-Version: 1.0
In-Reply-To: <1516019494-24210-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/15/2018 05:31 AM, Nikolay Borisov wrote:
> delayed_iput_count wa supposed to be used to implement, well, delayed
> iput. The idea is that we keep accumulating the number of iputs we do
> until eventually the inode is deleted. Turns out we never really
> switched the delayed_iput_count from 0 to 1, hence all conditional
> code relying on the value of that member being different than 0 was
> never executed. This, as it turns out, didn't cause any problem due
> to the simple fact that the generic inode's i_count member was always
> used to count the number of iputs. So let's just remove the unused
> member and all unused code. This patch essentially provides no
> functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Since the 8089fe62c6 changelog mentions the need for a count, it might
be nice to include a brief code comment about the i_count effect.

Reviewed-by: Edmund Nadolski <enadolski@suse.com>


> ---
>  fs/btrfs/btrfs_inode.h |  1 -
>  fs/btrfs/inode.c       | 17 +++--------------
>  2 files changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 63f0ccc92a71..f527e99c9f8d 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -195,7 +195,6 @@ struct btrfs_inode {
>  
>  	/* Hook into fs_info->delayed_iputs */
>  	struct list_head delayed_iput;
> -	long delayed_iput_count;
>  
>  	/*
>  	 * To avoid races between lockless (i_mutex not held) direct IO writes
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 029399593049..2225f613516c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3252,12 +3252,8 @@ void btrfs_add_delayed_iput(struct inode *inode)
>  		return;
>  
>  	spin_lock(&fs_info->delayed_iput_lock);
> -	if (binode->delayed_iput_count == 0) {
> -		ASSERT(list_empty(&binode->delayed_iput));
> -		list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
> -	} else {
> -		binode->delayed_iput_count++;
> -	}
> +	ASSERT(list_empty(&binode->delayed_iput));
> +	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
>  	spin_unlock(&fs_info->delayed_iput_lock);
>  }
>  
> @@ -3270,13 +3266,7 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
>  
>  		inode = list_first_entry(&fs_info->delayed_iputs,
>  				struct btrfs_inode, delayed_iput);
> -		if (inode->delayed_iput_count) {
> -			inode->delayed_iput_count--;
> -			list_move_tail(&inode->delayed_iput,
> -					&fs_info->delayed_iputs);
> -		} else {
> -			list_del_init(&inode->delayed_iput);
> -		}
> +		list_del_init(&inode->delayed_iput);
>  		spin_unlock(&fs_info->delayed_iput_lock);
>  		iput(&inode->vfs_inode);
>  		spin_lock(&fs_info->delayed_iput_lock);
> @@ -9424,7 +9414,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>  	ei->dir_index = 0;
>  	ei->last_unlink_trans = 0;
>  	ei->last_log_commit = 0;
> -	ei->delayed_iput_count = 0;
>  
>  	spin_lock_init(&ei->lock);
>  	ei->outstanding_extents = 0;
> 
