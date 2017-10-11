Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752781AbdJKJRB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 05:17:01 -0400
Subject: Re: [PATCH v3] btrfs: Use bd_dev to generate index when
 dev_state_hashtable add items.
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1507711467-50249-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6bf1ac45-4c29-e60a-ce55-041948c6a940@suse.com>
Date: Wed, 11 Oct 2017 12:16:57 +0300
MIME-Version: 1.0
In-Reply-To: <1507711467-50249-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.10.2017 11:44, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> Fix missing modify of
> commit f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev_t").
> Function btrfsic_dev_state_hashtable_lookup use dev_t to generate hashval
> when lookup a btrfsic_dev_state in hash table. So when add a
> btrfsic_dev_state into hash table, it should also use dev_t.

Your description contradicts the actual code as of a957fd420ca8.
btrfsic_block_hashtable_lookup creates the hash like so:

const unsigned int hashval =
            (((unsigned int)(dev_bytenr >> 16)) ^

             ((unsigned int)((uintptr_t)bdev))) &

             (BTRFSIC_BLOCK_HASHTABLE_SIZE - 1)

and bdev is being passed as an argument. And hashtable_add also uses the
pointer of the bdev, which seems correct. So what's the deal here?

> 
> Reproduce of this bug:
> Use MOUNT_OPTIONS="-o check_int" when run xfstest, device can not be
> mount successfully. So xfstest can not run. 
> 
> changelog:
> v1->v2: Add how to reproduce this bug.
> v2->v3: Add description of this bug.
> 
> Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/check-integrity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 9d3854839038..86d79bc4cfb3 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -613,7 +613,7 @@ static void btrfsic_dev_state_hashtable_add(
>  		struct btrfsic_dev_state_hashtable *h)
>  {
>  	const unsigned int hashval =
> -	    (((unsigned int)((uintptr_t)ds->bdev)) &
> +	    (((unsigned int)((uintptr_t)ds->bdev->bd_dev)) &
>  	     (BTRFSIC_DEV2STATE_HASHTABLE_SIZE - 1));
>  
>  	list_add(&ds->collision_resolving_node, h->table + hashval);
> 
