Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47349 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753133AbcKNQhv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 11:37:51 -0500
Date: Mon, 14 Nov 2016 17:37:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3-onstack] btrfs: make block group flags in balance
 printks human-readable
Message-ID: <20161114163747.GO12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5821D634.4070204@applied-asynchrony.com>
 <20161111235959.8102-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161111235959.8102-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 12, 2016 at 12:59:59AM +0100, Adam Borowski wrote:
> They're not even documented anywhere, letting users with no recourse but
> to RTFS.  It's no big burden to output the bitfield as words.
> 
> Also, display unknown flags as hex.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  fs/btrfs/relocation.c | 41 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index c4af0cd..57d867d 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4333,6 +4333,43 @@ static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
>  }
>  
>  /*
> + * printk the block group being relocated
> + */
> +static void describe_relocation(struct btrfs_fs_info *fs_info,
> +				struct btrfs_block_group_cache *block_group)
> +{
> +	char buf[128]; // prefixed by a '|' that'll be dropped

Oh right, moving the buffer to the function is the right way.

As my main objection is addressed, we can proceed to the codinstyle.
Please don't use the // comments.

> +	u64 flags = block_group->flags;
> +
> +	if (unlikely(!flags)) // shouldn't happen

add explicit { ... } if there's an multi-statement else block, drop
'unlikely'

> +		strcpy(buf, "|NONE");
> +	else {
> +		char *bp = buf;

newline between declarations and code

> +#define DESCRIBE_FLAG(f, d) \
> +		if (flags & BTRFS_BLOCK_GROUP_##f) { \
> +			bp += snprintf(bp, buf - bp + sizeof(buf), "|%s", d); \
> +			flags &= ~BTRFS_BLOCK_GROUP_##f; \
> +		}
> +		DESCRIBE_FLAG(DATA,     "data");
> +		DESCRIBE_FLAG(SYSTEM,   "system");
> +		DESCRIBE_FLAG(METADATA, "metadata");
> +		DESCRIBE_FLAG(RAID0,    "raid0");
> +		DESCRIBE_FLAG(RAID1,    "raid1");
> +		DESCRIBE_FLAG(DUP,      "dup");
> +		DESCRIBE_FLAG(RAID10,   "raid10");
> +		DESCRIBE_FLAG(RAID5,    "raid5");
> +		DESCRIBE_FLAG(RAID6,    "raid6");
> +		if (unlikely(flags))

drop 'unlikely'

> +			snprintf(buf, buf - bp + sizeof(buf), "|0x%llx", flags);
> +#undef DESCRIBE_FLAG
> +	}
> +
> +	btrfs_info(fs_info,
> +		   "relocating block group %llu flags %s",
> +		   block_group->key.objectid, buf+1);

		   block_group->key.objectid, buf + 1);

space around a binary operator

> +}
> +
> +/*
>   * function to relocate all extents in a block group.
>   */
>  int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
> @@ -4388,9 +4425,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
>  		goto out;
>  	}
>  
> -	btrfs_info(extent_root->fs_info,
> -		   "relocating block group %llu flags %llu",
> -		   rc->block_group->key.objectid, rc->block_group->flags);
> +	describe_relocation(extent_root->fs_info, rc->block_group);
>  
>  	btrfs_wait_block_group_reservations(rc->block_group);
>  	btrfs_wait_nocow_writers(rc->block_group);
> -- 
> 2.10.2
> 
> This is a version that uses a temp buffer on the stack, but does it in a
> separate function so it doesn't cost us anything when deep call chains are
> involved.  While balance that can trigger deep call chain, it's not called
> deeply itself.
> 
> This approach is simpler than mucking with allocs and avoids code
> duplication that would be needed for handling failed alloc.

Agreed.
