Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44167 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaLPGXz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 01:23:55 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 6813F3EE0AE
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 15:23:54 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 71D3AAC0191
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 15:23:53 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 20915E08001
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 15:23:53 +0900 (JST)
Message-ID: <548FCF71.7040200@jp.fujitsu.com>
Date: Tue, 16 Dec 2014 15:21:37 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, <kreijack@inwind.it>,
        <1i5t5.duncan@cox.net>, <rwhite@pobox.com>, <lists@colorremedies.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] Btrfs: raid56: simplify the parameter of nr_parity_stripes().
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com> <e6e28a35915d9bb147edb3b8767d27d10ab78ac3.1418203063.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <e6e28a35915d9bb147edb3b8767d27d10ab78ac3.1418203063.git.yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/12/11 17:31), Dongsheng Yang wrote:
> We just need the type of a chunk to calculate the number of parity stripes,
> but we have to pass a structure of lookup_map to it. This will prevent some
> callers to use it where there is no a convenient lookup_map to be passed.
> 
> This patch replace the parameter of struct map_lookup * with a profile type.
> Then we can use it more easily.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Although patch 1/3 and patch 3/3 is being discussed, at least
this patch (patch 2/3) looks fine to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> ---
>   fs/btrfs/raid56.h  | 8 ++++----
>   fs/btrfs/volumes.c | 2 +-
>   2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
> index ea5d73b..68ac9d3 100644
> --- a/fs/btrfs/raid56.h
> +++ b/fs/btrfs/raid56.h
> @@ -19,11 +19,11 @@
>   
>   #ifndef __BTRFS_RAID56__
>   #define __BTRFS_RAID56__
> -static inline int nr_parity_stripes(struct map_lookup *map)
> +static inline int nr_parity_stripes(u64 type)
>   {
> -	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
> +	if (type & BTRFS_BLOCK_GROUP_RAID5)
>   		return 1;
> -	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
> +	else if (type & BTRFS_BLOCK_GROUP_RAID6)
>   		return 2;
>   	else
>   		return 0;
> @@ -31,7 +31,7 @@ static inline int nr_parity_stripes(struct map_lookup *map)
>   
>   static inline int nr_data_stripes(struct map_lookup *map)
>   {
> -	return map->num_stripes - nr_parity_stripes(map);
> +	return map->num_stripes - nr_parity_stripes(map->type);
>   }
>   #define RAID5_P_STRIPE ((u64)-2)
>   #define RAID6_Q_STRIPE ((u64)-1)
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f61278f..aa3a907 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5174,7 +5174,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
>   
>   			/* RAID[56] write or recovery. Return all stripes */
>   			num_stripes = map->num_stripes;
> -			max_errors = nr_parity_stripes(map);
> +			max_errors = nr_parity_stripes(map->type);
>   
>   			raid_map = kmalloc_array(num_stripes, sizeof(u64),
>   					   GFP_NOFS);
> 

