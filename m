Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbaCCSCo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 13:02:44 -0500
Date: Mon, 3 Mar 2014 19:02:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Rakesh Pandit <rakesh@tuxera.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: free path if we don't find root item
Message-ID: <20140303180242.GF7004@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140228172705.GA3536@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140228172705.GA3536@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 28, 2014 at 07:27:06PM +0200, Rakesh Pandit wrote:
> In btrfs_find_last_root before returning with -ENOENT (if root item is
> not found) free path and also remove btrfs_release_path before
> btrfs_free_path because btrfs_free_path anyway calls it.
> 
> Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
> ---
>  root-tree.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/root-tree.c b/root-tree.c
> index 858fe2f..f16f0ba 100644
> --- a/root-tree.c
> +++ b/root-tree.c
> @@ -40,8 +40,10 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
>  	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
>  	if (ret < 0)
>  		goto out;
> -	if (path->slots[0] == 0)
> +	if (path->slots[0] == 0) {
> +		btrfs_free_path(path);

I'll change it to

		ret = -ENOENT;
		goto out;

that's the pattern commonly used.

>  		return -ENOENT;
> +	}
>  
>  	BUG_ON(ret == 0);
>  	l = path->nodes[0];
> @@ -56,7 +58,6 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
>  	memcpy(key, &found_key, sizeof(found_key));
>  	ret = 0;
>  out:
> -	btrfs_release_path(path);
>  	btrfs_free_path(path);
>  	return ret;
>  }
> @@ -120,7 +121,6 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>  	write_extent_buffer(l, item, ptr, sizeof(*item));
>  	btrfs_mark_buffer_dirty(path->nodes[0]);
>  out:
> -	btrfs_release_path(path);
>  	btrfs_free_path(path);
>  	return ret;
>  }
