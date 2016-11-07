Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43021 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751982AbcKGQ7P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 11:59:15 -0500
Date: Mon, 7 Nov 2016 17:58:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make block group flags in balance printks
 human-readable
Message-ID: <20161107165841.GQ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161104072654.13411-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161104072654.13411-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2016 at 08:26:54AM +0100, Adam Borowski wrote:
> They're not even documented anywhere, letting users with no recourse but
> to RTFS.  It's no big burden to output the bitfield as words.

Ok. Below are some comments (and style nitpicks).

> Also, display unknown flags as hex.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  fs/btrfs/relocation.c | 34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 0ec8ffa..388216f 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4326,6 +4326,34 @@ static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
>  }
>  
>  /*
> + * explain bit flags, prefixed by a '|' that'll be dropped
> + */
> +static void describe_block_group_flags(char *buf, u64 flags)
> +{
> +	if (!flags)

	if (!flags) {

> +		*buf += sprintf(buf, "|NONE");

Should it be just 'buf'? Otherwise this stores 5 after 'E', which gets
overwritten by 0 at the end but still. Unless I'm missing something.

	} else {

> +	else {
> +#define DESCRIBE_FLAG(f, d) \
> +			if (flags & BTRFS_BLOCK_GROUP_##f) { \
> +				buf += sprintf(buf, "|%s", d); \
> +				flags &= ~BTRFS_BLOCK_GROUP_##f; \
> +			}
> +		DESCRIBE_FLAG(DATA,     "data");
> +		DESCRIBE_FLAG(SYSTEM,   "system");
> +		DESCRIBE_FLAG(METADATA, "metadata");
> +		DESCRIBE_FLAG(RAID0,    "raid0");
> +		DESCRIBE_FLAG(RAID1,    "raid1");
> +		DESCRIBE_FLAG(DUP,      "dup");
> +		DESCRIBE_FLAG(RAID10,   "raid10");
> +		DESCRIBE_FLAG(RAID5,    "raid5");
> +		DESCRIBE_FLAG(RAID6,    "raid6");

An #undef should go here.

> +		if (flags)
> +			buf += sprintf(buf, "|0x%llx", flags);
> +	}
> +	*buf = 0;
> +}
> +
> +/*
>   * function to relocate all extents in a block group.
>   */
>  int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
> @@ -4337,6 +4365,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
>  	int ret;
>  	int rw = 0;
>  	int err = 0;
> +	char flags_str[128];

This could be a problem. The relocation can trigger deep call chains
when doing IO, that need stack. I'd rather avoid the static buffer,
please switch it to kmalloc. As this is not a critical allocation, the
fallback would be to print just the raw value as now.

Also, please use snprintf. This would need extra variable to track
number of already printed chars, but should be easy, schematically like:

	remaining = BUFFERSIZE;

	ret = snprintf(buf, remaining, "...");
	remaining -= ret;
	buf += ret;

>  
>  	rc = alloc_reloc_control(fs_info);
>  	if (!rc)
> @@ -4381,9 +4410,10 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
>  		goto out;
>  	}
>  
> +	describe_block_group_flags(flags_str, rc->block_group->flags);
>  	btrfs_info(extent_root->fs_info,
> -		   "relocating block group %llu flags %llu",
> -		   rc->block_group->key.objectid, rc->block_group->flags);
> +		   "relocating block group %llu flags %s",
> +		   rc->block_group->key.objectid, flags_str+1);
>  
>  	btrfs_wait_block_group_reservations(rc->block_group);
>  	btrfs_wait_nocow_writers(rc->block_group);
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
