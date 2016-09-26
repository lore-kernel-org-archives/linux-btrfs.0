Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52557 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934775AbcIZQ4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 12:56:53 -0400
Date: Mon, 26 Sep 2016 18:54:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: memset to avoid stale content in btree leaf
Message-ID: <20160926165444.GD16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474663484-23245-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474663484-23245-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2016 at 01:44:44PM -0700, Liu Bo wrote:
> @@ -3732,15 +3734,21 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>  	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
>  		bio_flags = EXTENT_BIO_TREE_LOG;
>  
> -	/* set btree node beyond nritems with 0 to avoid stale content */
> +	/* set btree blocks beyond nritems with 0 to avoid stale content. */
> +	nritems = btrfs_header_nritems(eb);
>  	if (btrfs_header_level(eb) > 0) {
> -		u32 nritems;
> -		unsigned long end;
> -
> -		nritems = btrfs_header_nritems(eb);
>  		end = btrfs_node_key_ptr_offset(nritems);
>  
>  		memset_extent_buffer(eb, 0, end, eb->len - end);
> +	} else {
> +		/*
> +		 * leaf:
> +		 * header 0 1 2 .. N ... data_N .. data_2 data_1 data_0
> +		 */
> +		start = btrfs_item_nr_offset(nritems);

So, AFAICS this also works for empty root nodes (nritems == 0). It's
hidden in leaf_data_end that actually looks at nritems and decides.

Reviewed-by: David Sterba <dsterba@suse.com>

> +		end = btrfs_leaf_data(eb) +
> +		      leaf_data_end(fs_info->tree_root, eb);
> +		memset_extent_buffer(eb, 0, start, end - start);
