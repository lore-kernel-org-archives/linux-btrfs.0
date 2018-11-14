Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6210EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C0EE22360
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="QhwADKy/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C0EE22360
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbeKOFgC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 00:36:02 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:37048 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725756AbeKOFgC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 00:36:02 -0500
Received: by mail-io1-f65.google.com with SMTP id a3so5901267ioc.4
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 11:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N0rhZHyJ3w6gwUK6Fgf1ejG/EA6LJbkWm81RI8iWHgc=;
        b=QhwADKy/y/yW3zslIOcUCvhr+87jjsH4v1FkaIqjcHCVietNbj18khhS1k56YjyTUY
         UDTkVkWKhF2grUQFTAwH4w6MmGj18bUDV2qD5OZjmxSZ0nsCfHx2yDrBPbNdpWWsIhCZ
         P0Oxyc/0uNXdKZ5k+qB4unMR5HNgMdi+U2bH7Gl/GWrNLthZcC6mLgCJO2fqmvohLx/b
         f9q1oUXIBPBayV1matG/E17H28vL4impJFoWn0P4BCsU+MyuHhfiAGwIzadSmt8uHuGd
         /LHCE6LP+kVy675uRVM53MWkyRX/f6yz5+lXXLAu19jOJvg8PbDRl2VTqTjfhjbuu9cK
         O6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N0rhZHyJ3w6gwUK6Fgf1ejG/EA6LJbkWm81RI8iWHgc=;
        b=OU5WnaYmhcav5O5beKrSyrsuduPkgkG8sg03nZiIaxPiT90BuN2XKYAxVxxYUV31hw
         HDB1m2/lJc7/0TWAS4J9C1vkVlJ7YPO0Pu0UvPabtkN6c+Y6Zs73UvJ6NCPKgVbd+DvM
         JTOCQRiyJfySsbeGKrKU1qhhO5gruqvTAuN4F8cw/IJ8INnnWppEYNi+OyjJMN+xjRGj
         iX7agjyTyyAO6S6TorSu4gkXS+wdo6b6Txrp92O0hSjYPAgilLrNUBrBE6i0jTs7f2bU
         wNHdh0T48SYNUyoc7uQLJiXM/QecspHNU3TtFo0lpCxCJuBijy98FUkJtEm6dPURnqKZ
         z+VQ==
X-Gm-Message-State: AA+aEWZoE8feE6O7ZmjalzhMmiOQaO4F2oGp0V9JSslIPV7g9BSX24Tp
        fNvSDHT3KejeDL05216BFuzavJqYRL8aVw==
X-Google-Smtp-Source: AJdET5eqgTwyTd4Hz+6j/qhLh5UYdVADqfO6/+BkpWertjYebGn51NkoNB3SIqXWHwHQkvlPednmYQ==
X-Received: by 2002:a6b:8c0c:: with SMTP id o12mr2734187iod.0.1542223889956;
        Wed, 14 Nov 2018 11:31:29 -0800 (PST)
Received: from vader ([2620:10d:c090:180::1:2a61])
        by smtp.gmail.com with ESMTPSA id x25-v6sm3265962ita.23.2018.11.14.11.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Nov 2018 11:31:29 -0800 (PST)
Date:   Wed, 14 Nov 2018 11:31:27 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/6] btrfs: remove unused function
 btrfs_sysfs_feature_update()
Message-ID: <20181114193127.GB4173@vader>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <20181114133520.16069-4-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114133520.16069-4-jthumshirn@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 02:35:17PM +0100, Johannes Thumshirn wrote:
> btrfs_sysfs_feature_update() was introduced with commit 444e75169872 (btrfs:
> sysfs: introduce helper for syncing bits with sysfs files) to provide a helper
> which was used in 14e46e04958d (btrfs: synchronize incompat feature bits with
> sysfs files).
> 
> But commit e410e34fad91 (Revert "btrfs: synchronize incompat feature bits with
> sysfs files") reverted 14e46e04958d so btrfs_sysfs_feature_update() ended up
> as an unused function.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/sysfs.c | 33 ---------------------------------
>  fs/btrfs/sysfs.h |  2 --
>  2 files changed, 35 deletions(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 3717c864ba23..a22a7c5f75eb 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -858,39 +858,6 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
>  	return error;
>  }
>  
> -
> -/*
> - * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
> - * values in superblock. Call after any changes to incompat/compat_ro flags
> - */
> -void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
> -		u64 bit, enum btrfs_feature_set set)
> -{
> -	struct btrfs_fs_devices *fs_devs;
> -	struct kobject *fsid_kobj;
> -	u64 features;
> -	int ret;
> -
> -	if (!fs_info)
> -		return;
> -
> -	features = get_features(fs_info, set);
> -	ASSERT(bit & supported_feature_masks[set]);
> -
> -	fs_devs = fs_info->fs_devices;
> -	fsid_kobj = &fs_devs->fsid_kobj;
> -
> -	if (!fsid_kobj->state_initialized)
> -		return;
> -
> -	/*
> -	 * FIXME: this is too heavy to update just one value, ideally we'd like
> -	 * to use sysfs_update_group but some refactoring is needed first.
> -	 */
> -	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
> -	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
> -}
> -
>  static int btrfs_init_debugfs(void)
>  {
>  #ifdef CONFIG_DEBUG_FS
> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
> index c6ee600aff89..93feedde8485 100644
> --- a/fs/btrfs/sysfs.h
> +++ b/fs/btrfs/sysfs.h
> @@ -88,7 +88,5 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
>  				struct kobject *parent);
>  int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
>  void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
> -void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
> -		u64 bit, enum btrfs_feature_set set);
>  
>  #endif
> -- 
> 2.16.4
> 
