Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbeDYJ0D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 05:26:03 -0400
Date: Wed, 25 Apr 2018 11:23:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: kill btrfs_raid_type_names[]
Message-ID: <20180425092329.GL21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180425072608.25445-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180425072608.25445-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 03:26:08PM +0800, Anand Jain wrote:
> Add a new member struct btrfs_raid_attr::raid_name so that
> btrfs_raid_array[] can maintain the name of the raid type,
> and so we can kill btrfs_raid_type_names[].
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Ok, nice.

> +		.raid_name	="raid10",

		.raid_name	= "raid10",

spaces around binary operators

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

	const char raid_name[8];

This stores the name in the array that is const, so there's no
indirection and extra pointers.
