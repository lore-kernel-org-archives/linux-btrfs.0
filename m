Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AD2C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F44B2081C
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F44B2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbeLDPWY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:22:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:33154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbeLDPWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 10:22:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BF72AF6E
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 15:22:20 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: scrub: move scrub_setup_ctx allocation out of
 device_list_mutex
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     fdmanana@suse.com
References: <cover.1543935982.git.dsterba@suse.com>
 <cfd97a36f22e60f29878598673be01f69208fea9.1543935982.git.dsterba@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e0917cec-7d06-6217-16f4-9f83d3ae5ff6@suse.com>
Date:   Tue, 4 Dec 2018 17:22:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <cfd97a36f22e60f29878598673be01f69208fea9.1543935982.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 4.12.18 г. 17:11 ч., David Sterba wrote:
> The scrub context is allocated with GFP_KERNEL and called from
> btrfs_scrub_dev under the fs_info::device_list_mutex. This is not safe
> regarding reclaim that could try to flush filesystem data in order to
> get the memory. And the device_list_mutex is held during superblock
> commit, so this would cause a lockup.
> 
> Move the alocation and initialization before any changes that require
> the mutex.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/scrub.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ffcab263e057..051d14c9f013 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3834,13 +3834,18 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  		return -EINVAL;
>  	}
>  
> +	/* Allocate outside of device_list_mutex */
> +	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
> +	if (IS_ERR(sctx))
> +		return PTR_ERR(sctx);
>  
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>  	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
>  	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
>  		     !is_dev_replace)) {
>  		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto out_free_ctx;
>  	}
>  
>  	if (!is_dev_replace && !readonly &&
> @@ -3848,7 +3853,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>  		btrfs_err_in_rcu(fs_info, "scrub: device %s is not writable",
>  				rcu_str_deref(dev->name));
> -		return -EROFS;
> +		ret = -EROFS;
> +		goto out_free_ctx;
>  	}
>  
>  	mutex_lock(&fs_info->scrub_lock);
> @@ -3856,7 +3862,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  	    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
>  		mutex_unlock(&fs_info->scrub_lock);
>  		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> -		return -EIO;
> +		ret = -EIO;
> +		goto out_free_ctx;
>  	}
>  
>  	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> @@ -3866,7 +3873,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>  		mutex_unlock(&fs_info->scrub_lock);
>  		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> -		return -EINPROGRESS;
> +		ret = -EINPROGRESS;
> +		goto out_free_ctx;
>  	}
>  	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>  
> @@ -3874,16 +3882,9 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  	if (ret) {
>  		mutex_unlock(&fs_info->scrub_lock);
>  		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> -		return ret;
> +		goto out_free_ctx;

Don't we suffer the same issue when calling scrub_workers_get since in
it we do btrfs_alloc_workqueue which also calls kzalloc with GFP_KERNEL?


>  	}
>  
> -	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
> -	if (IS_ERR(sctx)) {
> -		mutex_unlock(&fs_info->scrub_lock);
> -		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> -		scrub_workers_put(fs_info);
> -		return PTR_ERR(sctx);
> -	}
>  	sctx->readonly = readonly;
>  	dev->scrub_ctx = sctx;
>  	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> @@ -3936,6 +3937,11 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  
>  	scrub_put_ctx(sctx);
>  
> +	return ret;
> +
> +out_free_ctx:
> +	scrub_free_ctx(sctx);
> +
>  	return ret;
>  }
>  
> 
