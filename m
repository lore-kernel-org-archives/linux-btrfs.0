Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBC3C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FC0820825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="itBt42wo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FC0820825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbeKJG7r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 01:59:47 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46224 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbeKJG7r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 01:59:47 -0500
Received: by mail-yw1-f67.google.com with SMTP id v5-v6so2129940ywa.13
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 13:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sHmxJhctdfS2kkrOEMTFZd18H7GYP63b6C1/CllDL10=;
        b=itBt42wo4AX9NF2pqDxK/De9WgQnO7EibPxa4e203SdPAGHCfhFnsiQich7ATVxz/B
         PajA00xDNKZ3AdndkgPC1qbNDJEoMGfxzwWtaJUSCgRV7deBedRIPxrsgsxDMwOiBgJ9
         0L94/ZNxomkFIvGulbP44ebbRJzCegkHWWIWsM0DDk4TmOlpnsYn2Z5zBbuvXnd4kuUi
         Vb6nkZp37j7F9kx5iAzj+8mKPUlemN52uo1Tzfib/63SWvHYnWg7/+x8CXBHxe0DmNcQ
         sM2VJwQvOd6cmCcp425M+f4aZryydNx+/ZzNxHq5+LUOI2TNcLr/LCH//u9Nc3fn53ut
         DuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sHmxJhctdfS2kkrOEMTFZd18H7GYP63b6C1/CllDL10=;
        b=DX4i686X7CYtgS49CyUB8Ajc6gfWc+xEfKO+090Wxxu7kv5kBV7yDzS2IZ2kjpHq5S
         YNNPIukMq5hUMz18B2bCnxBFY2v09OENjnmFAoZVwygm4jxIG3E0YipfQljVjE+ikq75
         7TyKTc29x9FH8gX979uCeC7xcGLTz+s5wMLUleRRBfJabFM3bpe3vUBicxUo5MKL+Q7Y
         vJn3lhBUIbu1yT6HtBdH5FuEOnYIJO1ggNGuQdOvW1InJVcE+dUL782SwVjp2jdlfLwC
         W6i/VqBA/B3v/SKhihc0h/tHWgMIM2BoBU8udVzLTdSlnNqwlLw5MiBp6Y+nMsm7fL1j
         Ymkg==
X-Gm-Message-State: AGRZ1gKV1O9VnE8mKrulwrpAYMAibTj/NnTW/Wb9RJlyCfnuLwkD0wj9
        PUZYHCq7UJYYPbvgNgKOusjWHQ==
X-Google-Smtp-Source: AJdET5cKDdk+yyczmvAITs4/eiM/itv6CipjuZRZS4RN6271EjxkTZil0GVBTxWCzcdUGER7qCjNUA==
X-Received: by 2002:a0d:fac5:: with SMTP id k188-v6mr10394834ywf.150.1541798245035;
        Fri, 09 Nov 2018 13:17:25 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:42b3])
        by smtp.gmail.com with ESMTPSA id u134-v6sm9785300ywf.86.2018.11.09.13.17.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 13:17:24 -0800 (PST)
Date:   Fri, 9 Nov 2018 16:17:23 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Mark Fasheh <mfasheh@suse.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v15.1 04/13] btrfs: dedupe: Introduce function to remove
 hash from in-memory tree
Message-ID: <20181109211723.fclu6e3mtzs3xcn3@macbook-pro-91.dhcp.thefacebook.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
 <20181106064122.6154-5-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106064122.6154-5-lufq.fnst@cn.fujitsu.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 06, 2018 at 02:41:13PM +0800, Lu Fengqi wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Introduce static function inmem_del() to remove hash from in-memory
> dedupe tree.
> And implement btrfs_dedupe_del() and btrfs_dedup_disable() interfaces.
> 
> Also for btrfs_dedupe_disable(), add new functions to wait existing
> writer and block incoming writers to eliminate all possible race.
> 
> Cc: Mark Fasheh <mfasheh@suse.de>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c | 131 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 125 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index 784bb3a8a5ab..951fefd19fde 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -170,12 +170,6 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> -int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
> -{
> -	/* Place holder for bisect, will be implemented in later patches */
> -	return 0;
> -}
> -
>  static int inmem_insert_hash(struct rb_root *root,
>  			     struct inmem_hash *hash, int hash_len)
>  {
> @@ -317,3 +311,128 @@ int btrfs_dedupe_add(struct btrfs_fs_info *fs_info,
>  		return inmem_add(dedupe_info, hash);
>  	return -EINVAL;
>  }
> +
> +static struct inmem_hash *
> +inmem_search_bytenr(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
> +{
> +	struct rb_node **p = &dedupe_info->bytenr_root.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct inmem_hash *entry = NULL;
> +
> +	while (*p) {
> +		parent = *p;
> +		entry = rb_entry(parent, struct inmem_hash, bytenr_node);
> +
> +		if (bytenr < entry->bytenr)
> +			p = &(*p)->rb_left;
> +		else if (bytenr > entry->bytenr)
> +			p = &(*p)->rb_right;
> +		else
> +			return entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Delete a hash from in-memory dedupe tree */
> +static int inmem_del(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
> +{
> +	struct inmem_hash *hash;
> +
> +	mutex_lock(&dedupe_info->lock);
> +	hash = inmem_search_bytenr(dedupe_info, bytenr);
> +	if (!hash) {
> +		mutex_unlock(&dedupe_info->lock);
> +		return 0;
> +	}
> +
> +	__inmem_del(dedupe_info, hash);
> +	mutex_unlock(&dedupe_info->lock);
> +	return 0;
> +}
> +
> +/* Remove a dedupe hash from dedupe tree */
> +int btrfs_dedupe_del(struct btrfs_fs_info *fs_info, u64 bytenr)
> +{
> +	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
> +
> +	if (!fs_info->dedupe_enabled)
> +		return 0;
> +
> +	if (WARN_ON(dedupe_info == NULL))
> +		return -EINVAL;
> +
> +	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
> +		return inmem_del(dedupe_info, bytenr);
> +	return -EINVAL;
> +}
> +
> +static void inmem_destroy(struct btrfs_dedupe_info *dedupe_info)
> +{
> +	struct inmem_hash *entry, *tmp;
> +
> +	mutex_lock(&dedupe_info->lock);
> +	list_for_each_entry_safe(entry, tmp, &dedupe_info->lru_list, lru_list)
> +		__inmem_del(dedupe_info, entry);
> +	mutex_unlock(&dedupe_info->lock);
> +}
> +
> +/*
> + * Helper function to wait and block all incoming writers
> + *
> + * Use rw_sem introduced for freeze to wait/block writers.
> + * So during the block time, no new write will happen, so we can
> + * do something quite safe, espcially helpful for dedupe disable,
> + * as it affect buffered write.
> + */
> +static void block_all_writers(struct btrfs_fs_info *fs_info)
> +{
> +	struct super_block *sb = fs_info->sb;
> +
> +	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
> +	down_write(&sb->s_umount);
> +}
> +
> +static void unblock_all_writers(struct btrfs_fs_info *fs_info)
> +{
> +	struct super_block *sb = fs_info->sb;
> +
> +	up_write(&sb->s_umount);
> +	percpu_up_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
> +}

Please use the sb_ helpers, don't open code this.

> +
> +int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_dedupe_info *dedupe_info;
> +	int ret;
> +
> +	dedupe_info = fs_info->dedupe_info;
> +
> +	if (!dedupe_info)
> +		return 0;
> +
> +	/* Don't allow disable status change in RO mount */
> +	if (fs_info->sb->s_flags & MS_RDONLY)
> +		return -EROFS;
> +
> +	/*
> +	 * Wait for all unfinished writers and block further writers.
> +	 * Then sync the whole fs so all current write will go through
> +	 * dedupe, and all later write won't go through dedupe.
> +	 */
> +	block_all_writers(fs_info);
> +	ret = sync_filesystem(fs_info->sb);
> +	fs_info->dedupe_enabled = 0;
> +	fs_info->dedupe_info = NULL;
> +	unblock_all_writers(fs_info);

This is awful, don't do this.  Thanks,

Josef
