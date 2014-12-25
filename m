Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45926 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaLYBUo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:20:44 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 09BD03EE16B
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:20:43 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 0C3E1AC021C
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:20:42 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id AB1F31DB8048
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:20:41 +0900 (JST)
Message-ID: <549B6662.8010105@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 10:20:34 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 2/8] Move group_profile_str() in utils.c
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it> <1418847252-14184-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-3-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/18 5:14, Goffredo Baroncelli wrote:
> This is a preparation patch.
> Move the group_profile_str() function from cmds-filesystem.c to utils.c
> to be re-used from other modules (in this case from mkfs.c)
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   cmds-filesystem.c | 22 ----------------------
>   utils.c           | 22 ++++++++++++++++++++++
>   utils.h           |  2 ++
>   3 files changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 253f105..d1afeba 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -157,28 +157,6 @@ static char *group_type_str(u64 flag)
>   	}
>   }
>   
> -static char *group_profile_str(u64 flag)
> -{
> -	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
> -	case 0:
> -		return "single";
> -	case BTRFS_BLOCK_GROUP_RAID0:
> -		return "RAID0";
> -	case BTRFS_BLOCK_GROUP_RAID1:
> -		return "RAID1";
> -	case BTRFS_BLOCK_GROUP_RAID5:
> -		return "RAID5";
> -	case BTRFS_BLOCK_GROUP_RAID6:
> -		return "RAID6";
> -	case BTRFS_BLOCK_GROUP_DUP:
> -		return "DUP";
> -	case BTRFS_BLOCK_GROUP_RAID10:
> -		return "RAID10";
> -	default:
> -		return "unknown";
> -	}
> -}
> -
>   static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
>   {
>   	u64 count = 0;
> diff --git a/utils.c b/utils.c
> index 2a92416..19049bb 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2450,3 +2450,25 @@ int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
>   	}
>   	return 1;
>   }
> +
> +char *group_profile_str(u64 flag)
> +{
> +	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
> +	case 0:
> +		return "single";
> +	case BTRFS_BLOCK_GROUP_RAID0:
> +		return "RAID0";
> +	case BTRFS_BLOCK_GROUP_RAID1:
> +		return "RAID1";
> +	case BTRFS_BLOCK_GROUP_RAID5:
> +		return "RAID5";
> +	case BTRFS_BLOCK_GROUP_RAID6:
> +		return "RAID6";
> +	case BTRFS_BLOCK_GROUP_DUP:
> +		return "DUP";
> +	case BTRFS_BLOCK_GROUP_RAID10:
> +		return "RAID10";
> +	default:
> +		return "unknown";
> +	}
> +}
> diff --git a/utils.h b/utils.h
> index 289e86b..bb8a449 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -161,4 +161,6 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
>   
>   int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
>   
> +char *group_profile_str(u64 flag);
> +
>   #endif
> 

