Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbbI3Pvb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 11:51:31 -0400
Date: Wed, 30 Sep 2015 17:50:29 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Gabr=EDel_Arth=FAr_P=E9tursson?= <gabriel@system.is>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add stripes filter
Message-ID: <20150930155029.GL11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1443463025.16163.6.camel@system.is>
 <1443479561-785-1-git-send-email-gabriel@system.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1443479561-785-1-git-send-email-gabriel@system.is>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks for the patch. The stripe filter is really helpful. There are
some minor comments below but otherwise the patch looks good.

On Mon, Sep 28, 2015 at 10:32:41PM +0000, Gabríel Arthúr Pétursson wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -849,7 +849,11 @@ struct btrfs_disk_balance_args {
>  	/* BTRFS_BALANCE_ARGS_LIMIT value */
>  	__le64 limit;
>  
> -	__le64 unused[7];
> +	/* btrfs stripes filter */
> +	__le64 sstart;
> +	__le64 send;

Please be more descriptive, eg. min_stripes/max_stripes. The u64 type
seems too much, I think we can fit the stripe count into a 32bit number.
I made a mistake with u64 type for the 'limit' filter but I think that
we can somehow extend it to be two u32 with the min/max meaning as well.
Either way, this is independent of your patch.

> +
> +	__le64 unused[5];
>  } __attribute__ ((__packed__));
>  
>  /*
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3236,6 +3248,12 @@ static int should_balance_chunk(struct btrfs_root *root,
>  		return 0;
>  	}
>  
> +	/* stripes filter */
> +	if ((bargs->flags & BTRFS_BALANCE_ARGS_STRIPES) &&
> +	    chunk_stripes_filter(leaf, chunk, bargs)) {
> +		return 0;
> +	}

Ok, I think that this ordering of the filters is right.

> +
>  	/* soft profile changing mode */
>  	if ((bargs->flags & BTRFS_BALANCE_ARGS_SOFT) &&
>  	    chunk_soft_convert_filter(chunk_type, bargs)) {
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 2ca784a..fb6b89a 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -375,6 +375,7 @@ struct map_lookup {
>  #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
>  #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
>  #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
> +#define BTRFS_BALANCE_ARGS_STRIPES	(1ULL << 6)
>  
>  /*
>   * Profile changing flags.  When SOFT is set we won't relocate chunk if
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index b6dec05..a7819d0 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -218,7 +218,11 @@ struct btrfs_balance_args {
>  	__u64 flags;
>  
>  	__u64 limit;		/* limit number of processed chunks */
> -	__u64 unused[7];

same comment from the ctree.h applies here

> +
> +	__u64 sstart;
> +	__u64 send;
> +
> +	__u64 unused[5];
>  } __attribute__ ((__packed__));
>  
>  /* report balance progress to userspace */
