Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757093AbdJKHl0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 03:41:26 -0400
Subject: Re: [PATCH v2] btrfs: Use bd_dev to generate index when
 dev_state_hashtable add items.
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1507686941-46390-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fd4dd396-7a10-a675-da37-78c41297caaa@suse.com>
Date: Wed, 11 Oct 2017 10:41:24 +0300
MIME-Version: 1.0
In-Reply-To: <1507686941-46390-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.10.2017 04:55, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> Fix bug of
> <f8f84b2dfda5> (<btrfs: index check-integrity state hash by a dev_t>).
> 
> Description of this bug:
> Use MOUNT_OPTIONS="-o check_int" when run xfstest, device can not be
> mount successfully. So xfstest can not run.

You haven't described what causes the bug but rather how to reproduce it
? Describe what is the difference between using ->bdev and bdev->bd_dev.
And how using one or the other affects the integrity checks and why
those checks fail.

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
