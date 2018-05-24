Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46185 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965014AbeEXMqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 08:46:34 -0400
Date: Thu, 24 May 2018 14:43:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] btrfs: add helper function describe_block_group()
Message-ID: <20180524124349.GF6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523063508.18695-1-anand.jain@oracle.com>
 <20180523063508.18695-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523063508.18695-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 02:35:06PM +0800, Anand Jain wrote:
> Improve on describe_relocation() add a common helper function to describe
> the block groups.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v3->v4: Just pass full flag name in the define DESCRIBE_FLAG(flag,..),
> 	 so that it can be used at couple of more places.
> 	Rename describe_block_groups() to btrfs_describe_block_groups().
> 	Drop useless return u32.
> v3:	Born.
> 
>  fs/btrfs/relocation.c | 30 +++---------------------------
>  fs/btrfs/volumes.c    | 36 ++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h    |  1 +
>  3 files changed, 40 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 879b76fa881a..0434cebc2ea2 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4320,37 +4320,13 @@ static struct reloc_control *alloc_reloc_control(void)
>  static void describe_relocation(struct btrfs_fs_info *fs_info,
>  				struct btrfs_block_group_cache *block_group)
>  {
> -	char buf[128];		/* prefixed by a '|' that'll be dropped */
> -	u64 flags = block_group->flags;
> +	char buf[128];
>  
> -	/* Shouldn't happen */
> -	if (!flags) {
> -		strcpy(buf, "|NONE");
> -	} else {
> -		char *bp = buf;
> -
> -#define DESCRIBE_FLAG(f, d) \
> -		if (flags & BTRFS_BLOCK_GROUP_##f) { \
> -			bp += snprintf(bp, buf - bp + sizeof(buf), "|%s", d); \
> -			flags &= ~BTRFS_BLOCK_GROUP_##f; \
> -		}
> -		DESCRIBE_FLAG(DATA,     "data");
> -		DESCRIBE_FLAG(SYSTEM,   "system");
> -		DESCRIBE_FLAG(METADATA, "metadata");
> -		DESCRIBE_FLAG(RAID0,    "raid0");
> -		DESCRIBE_FLAG(RAID1,    "raid1");
> -		DESCRIBE_FLAG(DUP,      "dup");
> -		DESCRIBE_FLAG(RAID10,   "raid10");
> -		DESCRIBE_FLAG(RAID5,    "raid5");
> -		DESCRIBE_FLAG(RAID6,    "raid6");
> -		if (flags)
> -			snprintf(bp, buf - bp + sizeof(buf), "|0x%llx", flags);
> -#undef DESCRIBE_FLAG
> -	}
> +	btrfs_describe_block_groups(block_group->flags, buf, sizeof(buf));
>  
>  	btrfs_info(fs_info,
>  		   "relocating block group %llu flags %s",
> -		   block_group->key.objectid, buf + 1);
> +		   block_group->key.objectid, buf);
>  }
>  
>  /*
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b6757b53c297..44f4799bf06f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -126,6 +126,42 @@ const char *get_raid_name(enum btrfs_raid_types type)
>  	return btrfs_raid_array[type].raid_name;
>  }
>  
> +void btrfs_describe_block_groups(u64 bg_flags, char *buf, u32 size_buf)
> +{
> +	int i;
> +	u32 ret;
> +	char *bp = buf;
> +	u64 flags = bg_flags;
> +
> +	if (!flags) {
> +		snprintf(bp, size_buf, "%s", "NONE");

This could be strcpy as the original code did, but that's a minor issue.

> +		return;
> +	}
> +
> +#define DESCRIBE_FLAG(f, d) \
> +	do { \
> +		if (flags & f) { \
> +			bp += snprintf(bp, buf - bp + size_buf, "%s|", d); \
> +			flags &= ~f; \
> +		} \
> +	} while (0)
> +
> +	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_DATA, "data");
> +	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_SYSTEM, "system");
> +	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_METADATA, "metadata");
> +	DESCRIBE_FLAG(BTRFS_AVAIL_ALLOC_BIT_SINGLE, "single");
> +	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
> +		DESCRIBE_FLAG(btrfs_raid_array[i].bg_flag,
> +			      btrfs_raid_array[i].raid_name);
> +#undef DESCRIBE_FLAG

Yeah, that's it, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
