Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42101 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753001AbeA3Ogy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 09:36:54 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35AA2AE46
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 14:36:53 +0000 (UTC)
Date: Tue, 30 Jan 2018 15:34:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Streamline btrfs_delalloc_reserve_metadata
 initial operations
Message-ID: <20180130143441.GK19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515766865-13652-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515766865-13652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 04:21:05PM +0200, Nikolay Borisov wrote:
> @@ -6062,19 +6062,19 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  	 * If we have a transaction open (can happen if we call truncate_block
>  	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
>  	 */
> +
>  	if (btrfs_is_free_space_inode(inode)) {
>  		flush = BTRFS_RESERVE_NO_FLUSH;
>  		delalloc_lock = false;
> -	} else if (current->journal_info) {
> -		flush = BTRFS_RESERVE_FLUSH_LIMIT;
> -	}
> +	} else {
> +		if (current->journal_info)
> +			flush = BTRFS_RESERVE_FLUSH_LIMIT;
>  
> -	if (flush != BTRFS_RESERVE_NO_FLUSH &&
> -	    btrfs_transaction_in_commit(fs_info))
> -		schedule_timeout(1);
> +		if (btrfs_transaction_in_commit(fs_info))
> +			schedule_timeout(1);
>  
> -	if (delalloc_lock)
>  		mutex_lock(&inode->delalloc_mutex);
> +	}

Squeezing the condition branches makes the code more readable, I have
only one objection and it's the mutex_lock. It IMHO looks better when
it's a separate branch as it pairs with the unlock:

if (delalloc_lock)
	mutex_lock(...);

...

if (delalloc_lock)
	mutex_unlock(...);

In your version it's implied by the first if that checks
btrfs_is_free_space_inode and delalloc_lock is hidden there.

>  
>  	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
