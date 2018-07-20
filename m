Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731314AbeGTPg5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:36:57 -0400
Date: Fri, 20 Jul 2018 16:48:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 01/22] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20180720144809.GC26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719145006.17532-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 10:49:45AM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2577,12 +2577,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  		spin_unlock(&delayed_refs->lock);
>  		return 1;
>  	}
> -	delayed_refs->num_heads--;
> -	rb_erase(&head->href_node, &delayed_refs->href_root);
> -	RB_CLEAR_NODE(&head->href_node);
> -	spin_unlock(&head->lock);
> +	btrfs_delete_ref_head(delayed_refs, head);
>  	spin_unlock(&delayed_refs->lock);
> -	atomic_dec(&delayed_refs->num_entries);
> +	spin_unlock(&head->lock);

The order of unlocks is reversed, the head is nested to the delayed
refs.

> @@ -7122,22 +7119,9 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>  	if (!mutex_trylock(&head->mutex))
>  		goto out;
>  
> -	/*
> -	 * at this point we have a head with no other entries.  Go
> -	 * ahead and process it.
> -	 */
> -	rb_erase(&head->href_node, &delayed_refs->href_root);
> -	RB_CLEAR_NODE(&head->href_node);
> -	atomic_dec(&delayed_refs->num_entries);
> -
> -	/*
> -	 * we don't take a ref on the node because we're removing it from the
> -	 * tree, so we just steal the ref the tree was holding.
> -	 */
> -	delayed_refs->num_heads--;
> -	if (head->processing == 0)
> -		delayed_refs->num_heads_ready--;
> +	btrfs_delete_ref_head(delayed_refs, head);
>  	head->processing = 0;
> +
>  	spin_unlock(&head->lock);
>  	spin_unlock(&delayed_refs->lock);

The right order eg. here and everywhere else.
