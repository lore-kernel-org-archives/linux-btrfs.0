Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab3F0VdX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 17:33:23 -0400
Date: Thu, 27 Jun 2013 14:33:20 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make the chunk allocator completely tree lockless
Message-ID: <20130627213320.GG10265@lenny.home.zabbo.net>
References: <1372354038-2111-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372354038-2111-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewing as requested!  It certainly looks reasonable, but I don't have
enough history with the code to really say much more than that.

Some questions:

> @@ -8423,6 +8432,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
>  					sizeof(item));
>  		if (ret)
>  			btrfs_abort_transaction(trans, extent_root, ret);
> +		ret = btrfs_finish_chunk_alloc(trans, extent_root,
> +					       key.objectid, key.offset);

Would this moved call site need to worry about the chunk mutex at all?

> +		if (ret)
> +			btrfs_abort_transaction(trans, root, ret);

Did you mean to abort the root here, not the extent_root like the one
above?

> +static int contains_pending_extent(struct btrfs_trans_handle *trans,
> +				   struct btrfs_device *device,
> +				   u64 *start, u64 len)
> +{
> +	struct extent_map *em;
> +	int ret = 0;
> +
> +	list_for_each_entry(em, &trans->transaction->pending_chunks, list) {
> +		struct map_lookup *map;
> +		int i;
> +
> +		map = (struct map_lookup *)em->bdev;
> +		for (i = 0; i < map->num_stripes; i++) {
> +			if (map->stripes[i].dev != device)
> +				continue;
> +			if (map->stripes[i].physical >= *start + len ||
> +			    map->stripes[i].physical + em->orig_block_len <=
> +			    *start)
> +				continue;
> +			*start = map->stripes[i].physical +
> +				em->orig_block_len;
> +			ret = 1;
> +		}
> +	}

Did you want a 'break;' there?  Is it trying to set *start to the last
match rather than returning the first?

> +		ret = btrfs_alloc_dev_extent(trans, device,
> +					     chunk_root->root_key.objectid,
> +					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
> +					     chunk_offset, dev_offset,
> +					     stripe_size);
> +		if (ret)
> +			goto out;

The old code tried to free up previous allocations when one failed, but
it looks like this deferred alloc doesn't.  Do we care?

> -	index = 0;
> -	while (index < map->num_stripes) {
> -		index++;

> +	for (i = 0; i < map->num_stripes; i++) {

*hugs*

- z
