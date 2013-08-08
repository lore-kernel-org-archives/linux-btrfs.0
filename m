Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:39554 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762Ab3HHLZ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 07:25:26 -0400
Message-ID: <52038024.9020306@jan-o-sch.net>
Date: Thu, 08 Aug 2013 13:25:24 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: allocate prelim_ref with a slab allocater
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1375938259-5015-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375938259-5015-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
On Thu, August 08, 2013 at 07:04 (+0200), Wang Shilong wrote:
> struct __prelim_ref is allocated and freed frequently when
> walking backref tree, using slab allocater can not only
> speed up allocating but also detect memory leaks.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/backref.c | 30 +++++++++++++++++++++++++-----
>  fs/btrfs/backref.h |  2 ++
>  fs/btrfs/super.c   |  8 ++++++++
>  3 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index f7781e6..916e4f1 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -119,6 +119,26 @@ struct __prelim_ref {
>  	u64 wanted_disk_byte;
>  };
>  
> +static struct kmem_cache *prelim_ref_cache;
> +
> +int __init btrfs_prelim_ref_init(void)
> +{
> +	prelim_ref_cache = kmem_cache_create("btrfs_prelim_ref",
> +					sizeof(struct __prelim_ref),
> +					0,
> +					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
> +					NULL);
> +	if (!prelim_ref_cache)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +void btrfs_prelim_ref_exit(void)
> +{
> +	if (prelim_ref_cache)
> +		kmem_cache_destroy(prelim_ref_cache);
> +}
> +
>  /*
>   * the rules for all callers of this function are:
>   * - obtaining the parent is the goal
> @@ -165,7 +185,7 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
>  {
>  	struct __prelim_ref *ref;
>  
> -	ref = kmalloc(sizeof(*ref), gfp_mask);
> +	ref = kmem_cache_alloc(prelim_ref_cache, gfp_mask);
>  	if (!ref)
>  		return -ENOMEM;
>  
> @@ -493,7 +513,7 @@ static void __merge_refs(struct list_head *head, int mode)
>  			ref1->count += ref2->count;
>  
>  			list_del(&ref2->list);
> -			kfree(ref2);
> +			kmem_cache_free(prelim_ref_cache, ref2);
>  		}
>  
>  	}
> @@ -958,7 +978,7 @@ again:
>  			}
>  		}
>  		list_del(&ref->list);
> -		kfree(ref);
> +		kmem_cache_free(prelim_ref_cache, ref);
>  	}
>  
>  out:
> @@ -966,13 +986,13 @@ out:
>  	while (!list_empty(&prefs)) {
>  		ref = list_first_entry(&prefs, struct __prelim_ref, list);
>  		list_del(&ref->list);
> -		kfree(ref);
> +		kmem_cache_free(prelim_ref_cache, ref);
>  	}
>  	while (!list_empty(&prefs_delayed)) {
>  		ref = list_first_entry(&prefs_delayed, struct __prelim_ref,
>  				       list);
>  		list_del(&ref->list);
> -		kfree(ref);
> +		kmem_cache_free(prelim_ref_cache, ref);
>  	}
>  
>  	return ret;
> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> index 8f2e767..a910b27 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -72,4 +72,6 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
>  			  struct btrfs_inode_extref **ret_extref,
>  			  u64 *found_off);
>  
> +int __init btrfs_prelim_ref_init(void);
> +void btrfs_prelim_ref_exit(void);
>  #endif
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b64d762..de7eb3d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -56,6 +56,7 @@
>  #include "rcu-string.h"
>  #include "dev-replace.h"
>  #include "free-space-cache.h"
> +#include "backref.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/btrfs.h>
> @@ -1774,6 +1775,10 @@ static int __init init_btrfs_fs(void)
>  	if (err)
>  		goto free_auto_defrag;
>  
> +	err = btrfs_prelim_ref_init();
> +	if (err)
> +		goto free_prelim_ref;
> +
>  	err = btrfs_interface_init();
>  	if (err)
>  		goto free_delayed_ref;
> @@ -1791,6 +1796,8 @@ static int __init init_btrfs_fs(void)
>  
>  unregister_ioctl:
>  	btrfs_interface_exit();
> +free_prelim_ref:
> +	btrfs_prelim_ref_exit();
>  free_delayed_ref:
>  	btrfs_delayed_ref_exit();
>  free_auto_defrag:
> @@ -1817,6 +1824,7 @@ static void __exit exit_btrfs_fs(void)
>  	btrfs_delayed_ref_exit();
>  	btrfs_auto_defrag_exit();
>  	btrfs_delayed_inode_exit();
> +	btrfs_prelim_ref_exit();
>  	ordered_data_exit();
>  	extent_map_exit();
>  	extent_io_exit();
> 

I generally like the idea of using a custom cache here. What about this one?

 324 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
[...]
 367                 /* additional parents require new refs being added here */
 368                 while ((node = ulist_next(parents, &uiter))) {
 369                         new_ref = kmalloc(sizeof(*new_ref), GFP_NOFS);

That new_ref will also be freed with kmem_cache_free after your patch, I think.

Thanks,
-Jan
