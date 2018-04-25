Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbeDYHfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 03:35:39 -0400
Subject: Re: [PATCH] btrfs: kill btrfs_raid_type_names[]
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180425072608.25445-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f4af2694-aeb3-7262-e16f-fbc1fdcd4347@suse.com>
Date: Wed, 25 Apr 2018 10:35:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180425072608.25445-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.04.2018 10:26, Anand Jain wrote:
> Add a new member struct btrfs_raid_attr::raid_name so that
> btrfs_raid_array[] can maintain the name of the raid type,
> and so we can kill btrfs_raid_type_names[].
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Makes sense:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 18 ------------------
>  fs/btrfs/volumes.c     | 15 +++++++++++++++
>  fs/btrfs/volumes.h     |  3 +++
>  3 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 90d28a3727c6..4742734a73d7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7338,24 +7338,6 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
>  	return ret;
>  }
>  
> -static const char *btrfs_raid_type_names[BTRFS_NR_RAID_TYPES] = {
> -	[BTRFS_RAID_RAID10]	= "raid10",
> -	[BTRFS_RAID_RAID1]	= "raid1",
> -	[BTRFS_RAID_DUP]	= "dup",
> -	[BTRFS_RAID_RAID0]	= "raid0",
> -	[BTRFS_RAID_SINGLE]	= "single",
> -	[BTRFS_RAID_RAID5]	= "raid5",
> -	[BTRFS_RAID_RAID6]	= "raid6",
> -};
> -
> -static const char *get_raid_name(enum btrfs_raid_types type)
> -{
> -	if (type >= BTRFS_NR_RAID_TYPES)
> -		return NULL;
> -
> -	return btrfs_raid_type_names[type];
> -}
> -
>  enum btrfs_loop_type {
>  	LOOP_CACHING_NOWAIT = 0,
>  	LOOP_CACHING_WAIT = 1,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9c29fdca9075..04b8d602dc08 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -52,6 +52,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 1,
>  		.devs_increment	= 2,
>  		.ncopies	= 2,
> +		.raid_name	="raid10",
>  	},
>  	[BTRFS_RAID_RAID1] = {
>  		.sub_stripes	= 1,
> @@ -61,6 +62,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 1,
>  		.devs_increment	= 2,
>  		.ncopies	= 2,
> +		.raid_name	="raid1",
>  	},
>  	[BTRFS_RAID_DUP] = {
>  		.sub_stripes	= 1,
> @@ -70,6 +72,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 0,
>  		.devs_increment	= 1,
>  		.ncopies	= 2,
> +		.raid_name	="dup",
>  	},
>  	[BTRFS_RAID_RAID0] = {
>  		.sub_stripes	= 1,
> @@ -79,6 +82,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 0,
>  		.devs_increment	= 1,
>  		.ncopies	= 1,
> +		.raid_name	="raid0",
>  	},
>  	[BTRFS_RAID_SINGLE] = {
>  		.sub_stripes	= 1,
> @@ -88,6 +92,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 0,
>  		.devs_increment	= 1,
>  		.ncopies	= 1,
> +		.raid_name	="single",
>  	},
>  	[BTRFS_RAID_RAID5] = {
>  		.sub_stripes	= 1,
> @@ -97,6 +102,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 1,
>  		.devs_increment	= 1,
>  		.ncopies	= 2,
> +		.raid_name	="raid5",
>  	},
>  	[BTRFS_RAID_RAID6] = {
>  		.sub_stripes	= 1,
> @@ -106,9 +112,18 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  		.tolerated_failures = 2,
>  		.devs_increment	= 1,
>  		.ncopies	= 3,
> +		.raid_name	="raid6",
>  	},
>  };
>  
> +const char *get_raid_name(enum btrfs_raid_types type)
> +{
> +	if (type >= BTRFS_NR_RAID_TYPES)
> +		return NULL;
> +
> +	return btrfs_raid_array[type].raid_name;
> +}
> +
>  const u64 btrfs_raid_group[BTRFS_NR_RAID_TYPES] = {
>  	[BTRFS_RAID_RAID10] = BTRFS_BLOCK_GROUP_RAID10,
>  	[BTRFS_RAID_RAID1]  = BTRFS_BLOCK_GROUP_RAID1,
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index ef220d541d4b..2acd32ce1573 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -342,6 +342,7 @@ struct btrfs_raid_attr {
>  	int tolerated_failures; /* max tolerated fail devs */
>  	int devs_increment;	/* ndevs has to be a multiple of this */
>  	int ncopies;		/* how many copies to data has */
> +	char *raid_name;	/* name of the raid */
nit: const char * ?
>  };
>  
>  extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES];
> @@ -563,6 +564,8 @@ static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
>  	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
>  }
>  
> +const char *get_raid_name(enum btrfs_raid_types type);
> +
>  void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
>  void btrfs_update_commit_device_bytes_used(struct btrfs_transaction *trans);
>  
> 
