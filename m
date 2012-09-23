Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64739 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2IWLt1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 07:49:27 -0400
Received: by wibhq12 with SMTP id hq12so760333wib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Sep 2012 04:49:26 -0700 (PDT)
Date: Sun, 23 Sep 2012 14:49:24 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120923114924.GA1975@zambezi.lan>
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
 <505C2E62.2000400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505C2E62.2000400@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 05:07:46PM +0800, Miao Xie wrote:
> div_factor{_fine} has been implemented for two times, and these two functions
> are very similar, so cleanup the reduplicate implement and drop the original
> div_factor(), and then rename div_factor_fine() to div_factor(). So the divisor
> of the new div_factor() is 100, not 10.
> 
> And I move div_factor into a independent file named math.h because it is a
> common math function, may be used by every composition of btrfs.
> 
> Because these functions are mostly used on the hot path, and we are sure
> the parameters are right in the most cases, we don't add complex checks
> for the parameters. But in the other place, we must check and make sure
> the parameters are right. So besides the code cleanup, this patch also
> add a check for the usage of the space balance, it is the only place that
> we need add check to make sure the parameters of div_factor are right till now.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changelog v2 -> v3:
> - drop the original div_factor and rename div_factor_fine to div_factor
> - drop the check of the factor
> 
> Changelog v1 -> v2:
> - add missing check
> ---
>  fs/btrfs/extent-tree.c |   29 ++++++-----------------------
>  fs/btrfs/ioctl.c       |   18 ++++++++++++++++++
>  fs/btrfs/math.h        |   33 +++++++++++++++++++++++++++++++++
>  fs/btrfs/relocation.c  |    2 +-
>  fs/btrfs/transaction.c |    2 +-
>  fs/btrfs/volumes.c     |   30 +++++-------------------------
>  6 files changed, 64 insertions(+), 50 deletions(-)
>  create mode 100644 fs/btrfs/math.h
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a010234..bcb9ced 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -33,6 +33,7 @@
>  #include "volumes.h"
>  #include "locking.h"
>  #include "free-space-cache.h"
> +#include "math.h"
>  
>  #undef SCRAMBLE_DELAYED_REFS
>  
> @@ -648,24 +649,6 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info)
>  	rcu_read_unlock();
>  }
>  
> -static u64 div_factor(u64 num, int factor)
> -{
> -	if (factor == 10)
> -		return num;
> -	num *= factor;
> -	do_div(num, 10);
> -	return num;
> -}
> -
> -static u64 div_factor_fine(u64 num, int factor)
> -{
> -	if (factor == 100)
> -		return num;
> -	num *= factor;
> -	do_div(num, 100);
> -	return num;
> -}
> -
>  u64 btrfs_find_block_group(struct btrfs_root *root,
>  			   u64 search_start, u64 search_hint, int owner)
>  {
> @@ -674,7 +657,7 @@ u64 btrfs_find_block_group(struct btrfs_root *root,
>  	u64 last = max(search_hint, search_start);
>  	u64 group_start = 0;
>  	int full_search = 0;
> -	int factor = 9;
> +	int factor = 90;
>  	int wrapped = 0;
>  again:
>  	while (1) {
> @@ -708,7 +691,7 @@ again:
>  	if (!full_search && factor < 10) {
>  		last = search_start;
>  		full_search = 1;
> -		factor = 10;
> +		factor = 100;
>  		goto again;
>  	}
>  found:
> @@ -3513,7 +3496,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
>  	if (force == CHUNK_ALLOC_LIMITED) {
>  		thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
>  		thresh = max_t(u64, 64 * 1024 * 1024,
> -			       div_factor_fine(thresh, 1));
> +			       div_factor(thresh, 1));
>  
>  		if (num_bytes - num_allocated < thresh)
>  			return 1;
> @@ -3521,12 +3504,12 @@ static int should_alloc_chunk(struct btrfs_root *root,
>  	thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
>  
>  	/* 256MB or 2% of the FS */
> -	thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 2));
> +	thresh = max_t(u64, 256 * 1024 * 1024, div_factor(thresh, 2));
>  	/* system chunks need a much small threshold */
>  	if (sinfo->flags & BTRFS_BLOCK_GROUP_SYSTEM)
>  		thresh = 32 * 1024 * 1024;
>  
> -	if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 8))
> +	if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 80))
>  		return 0;
>  	return 1;
>  }
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9384a2a..d8d53f7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3335,6 +3335,24 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>  
>  			goto do_balance;
>  		}
> +
> +		if ((bargs->data.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->data.usage < 0 || bargs->data.usage > 100)) {
> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
> +
> +		if ((bargs->meta.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->meta.usage < 0 || bargs->meta.usage > 100)) {
> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
> +
> +		if ((bargs->sys.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->sys.usage < 0 || bargs->sys.usage > 100)) {
> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
>  	} else {
>  		bargs = NULL;
>  	}

Why not drop this hunk ...

> diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
> new file mode 100644
> index 0000000..a157665
> --- /dev/null
> +++ b/fs/btrfs/math.h
> @@ -0,0 +1,33 @@
> +
> +/*
> + * Copyright (C) 2012 Fujitsu.  All rights reserved.
> + * Written by Miao Xie <miaox@cn.fujitsu.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#ifndef __BTRFS_MATH_H
> +#define __BTRFS_MATH_H
> +
> +#include <asm/div64.h>
> +
> +static inline u64 div_factor(u64 num, int factor)
> +{
> +	num *= factor;
> +	do_div(num, 100);
> +	return num;
> +}
> +
> +#endif
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index f193096..2254478 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3813,7 +3813,7 @@ restart:
>  			}
>  		}
>  
> -		ret = btrfs_block_rsv_check(rc->extent_root, rc->block_rsv, 5);
> +		ret = btrfs_block_rsv_check(rc->extent_root, rc->block_rsv, 50);
>  		if (ret < 0) {
>  			if (ret != -ENOSPC) {
>  				err = ret;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index cf98dbc..115f054 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -489,7 +489,7 @@ static int should_end_transaction(struct btrfs_trans_handle *trans,
>  {
>  	int ret;
>  
> -	ret = btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 5);
> +	ret = btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 50);
>  	return ret ? 1 : 0;
>  }
>  
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3f4e70e..1fd43a4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -25,7 +25,6 @@
>  #include <linux/capability.h>
>  #include <linux/ratelimit.h>
>  #include <linux/kthread.h>
> -#include <asm/div64.h>
>  #include "compat.h"
>  #include "ctree.h"
>  #include "extent_map.h"
> @@ -36,6 +35,7 @@
>  #include "async-thread.h"
>  #include "check-integrity.h"
>  #include "rcu-string.h"
> +#include "math.h"
>  
>  static int init_first_rw_device(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *root,
> @@ -2325,18 +2325,6 @@ static int chunk_profiles_filter(u64 chunk_type,
>  	return 1;
>  }
>  
> -static u64 div_factor_fine(u64 num, int factor)
> -{
> -	if (factor <= 0)
> -		return 0;
> -	if (factor >= 100)
> -		return num;
> -
> -	num *= factor;
> -	do_div(num, 100);
> -	return num;
> -}
> -
>  static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
>  			      struct btrfs_balance_args *bargs)
>  {
> @@ -2347,7 +2335,8 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
>  	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
>  	chunk_used = btrfs_block_group_used(&cache->item);
>  
> -	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
> +	BUG_ON(bargs->usage < 0 || bargs->usage > 100);
> +	user_thresh = div_factor(cache->key.offset, bargs->usage);
>  	if (chunk_used < user_thresh)
>  		ret = 0;

 ... and leave the check where it was before?

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6019fb2..ff86f91 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2334,8 +2334,13 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
 	chunk_used = btrfs_block_group_used(&cache->item);
 
-	BUG_ON(bargs->usage < 0 || bargs->usage > 100);
-	user_thresh = div_factor(cache->key.offset, bargs->usage);
+	if (bargs->usage == 0)
+		user_thresh = 0;
+	else if (bargs->usage >= 100)
+		user_thresh = cache->key.offset;
+	else
+		user_thresh = div_factor(cache->key.offset, bargs->usage);
+
 	if (chunk_used < user_thresh)
 		ret = 0;

(diff is on top of the patch in question)

This is the most straightforward transformation I can think of.  It
doesn't result in an unnecessary BUG_ON, keeps churn to a minimum and
doesn't change the "style" of the balance ioctl.  (If I were to check
every filter argument that way, btrfs_balance_ioctl() would be very long
and complicated.)

Thanks,

		Ilya
