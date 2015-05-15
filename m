Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934016AbbEOMzp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 08:55:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 341BFADBB
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 12:55:44 +0000 (UTC)
Date: Fri, 15 May 2015 14:55:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix mutex unlock without prior lock on space
 cache truncation
Message-ID: <20150515125543.GC23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430412425-12876-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430412425-12876-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 30, 2015 at 05:47:05PM +0100, Filipe Manana wrote:
> If the call to btrfs_truncate_inode_items() failed and we don't have a block
> group, we were unlocking the cache_write_mutex without having locked it (we
> do it only if we have a block group).
> 
> Fixes: 1bbc621ef284 ("Btrfs: allow block group cache writeout
>                       outside critical section in commit")
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Patch is ok, I have one comment to the transaction abort calls. The
pattern is to put them right after the error is detected so we can
trace it back to the sources based on the reports.

> @@ -231,6 +231,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
>  {
>  	int ret = 0;
>  	struct btrfs_path *path = btrfs_alloc_path();
> +	bool locked = false;
>  
>  	if (!path) {
>  		ret = -ENOMEM;

the context:
		goto fail;

> @@ -269,18 +271,14 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
>  	 */
>  	ret = btrfs_truncate_inode_items(trans, root, inode,
>  					 0, BTRFS_EXTENT_DATA_KEY);
> -	if (ret) {
> -		mutex_unlock(&trans->transaction->cache_write_mutex);
> -		btrfs_abort_transaction(trans, root, ret);
> -		return ret;
> -	}
> +	if (ret)
> +		goto fail;
>  
>  	ret = btrfs_update_inode(trans, root, inode);
>  
> -	if (block_group)
> -		mutex_unlock(&trans->transaction->cache_write_mutex);
> -
>  fail:
> +	if (locked)
> +		mutex_unlock(&trans->transaction->cache_write_mutex);
>  	if (ret)
>  		btrfs_abort_transaction(trans, root, ret);

Now two code paths lead to one abort. We can get ENOMEM from both,
however this kind of error is not really a bug we want to analyze deeper
so I'm fine with it.

Reviewed-by: David Sterba <dsterba@suse.cz>
