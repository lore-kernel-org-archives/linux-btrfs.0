Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37089 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753889AbdEZSeQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 14:34:16 -0400
Date: Fri, 26 May 2017 20:33:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: add sanity check of extent item in scrub
Message-ID: <20170526183316.GN30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-7-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526002631.8546-7-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 06:26:31PM -0600, Liu Bo wrote:
> Currently scrub only verify checksum of both metadata and data and
> couldn't detect an invalid extent_item.

This is a different kind of check that scrub was never designed to do.
Scrub just verifies the checksums, not the sructural integrity. This has
been referred to as an "on-line fsck". AFAIK xfs does not use 'scrub' in
the same sense as btrfs, so things are going to be confusing for the
users.

The on-line fsck is still desired, but I'd like to see a discussion how
exactly it should work, whether to extend scrub or add a new ioctl etc.

> This adds sanity check for extent item, now it can check if
> extent_inline_ref_type is valid.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/scrub.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index b0251eb..e87b752 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3058,6 +3058,39 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
>  	return ret < 0 ? ret : 0;
>  }
>  
> +static int check_extent_item(struct extent_buffer *l, int slot,

Please use 'eb' for the extent_buffer.

> +			     struct btrfs_extent_item *ei, int key_type)

key_type should be u8

> +{
> +	unsigned long ptr;
> +	unsigned long end;
> +	struct btrfs_extent_inline_ref *iref;
> +	u64 flags = btrfs_extent_flags(l, ei);
> +	int is_data = !!(flags & BTRFS_EXTENT_FLAG_DATA);
> +	int type;
> +
> +	ptr = (unsigned long)(ei + 1);
> +	if (!is_data &&
> +	    key_type != BTRFS_METADATA_ITEM_KEY)
> +		ptr += sizeof(struct btrfs_tree_block_info);
> +	end = (unsigned long)ei +
> +		btrfs_item_size_nr(l, slot);

This will fit to one line

> +
> +	while (1) {
> +		if (ptr >= end) {
> +			WARN_ON(ptr > end);

Please add some verbose error message or get rid of the WARN_ON
completely if possible.

> +			break;
> +		}
> +
> +		iref = (struct btrfs_extent_inline_ref *)ptr;
> +		type = btrfs_get_extent_inline_ref_type(l, iref, is_data);
> +		if (type < 0)
> +			return type;
> +
> +		ptr += btrfs_extent_inline_ref_size(type);
> +	}
> +	return 0;
> +}
> +
>  static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>  					   struct map_lookup *map,
>  					   struct btrfs_device *scrub_dev,
> @@ -3318,6 +3351,16 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>  				goto next;
>  			}
>  
> +			/* sanity check for extent inline ref type */
> +			if (check_extent_item(l, slot, extent, key.type)) {
> +				btrfs_err(fs_info,
> +					  "scrub: extent %llu(0x%llx) has an invalid extent inline ref type, ignored.",

Strings can be un-indented to the left.

> +					  key.objectid, key.objectid);
> +				spin_lock(&sctx->stat_lock);
> +				sctx->stat.uncorrectable_errors++;

Yeah, this is an example where the uncorrectable_error would gain a new
meaning. We'd need to extend the scrub error reporting so the various
metadata errors get reported properly and not mangled with the rest.

> +				spin_unlock(&sctx->stat_lock);
> +				goto next;
> +			}
>  again:
>  			extent_logical = key.objectid;
>  			extent_len = bytes;
