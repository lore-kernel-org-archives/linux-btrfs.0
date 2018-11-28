Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E628C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E1B0204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="gs6fSXTr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E1B0204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbeK1L23 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:28:29 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46756 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbeK1L23 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:28:29 -0500
Received: by mail-pl1-f195.google.com with SMTP id t13so16439668ply.13
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wmk8G5mi5lIqSGfp4MF3wRMXt1V24erTsfY43EEG76o=;
        b=gs6fSXTrL+abVqmjfKiXD4O9h12QiUrV6MuWLKXKjpGq1g6HrkpTmUhd9VP1fd4yR+
         yhBsaCtbEEO20m5EQjnbZ1biVutorGSmvvK9tcEYT9t5/MAUXL7oAPfoJLnZwiVWDgkb
         4DDopdSXz18KomNWORfE2jrXc9Ivx7dsiCI/x4//5lEPbOZjTsnpMQuRmkl0zQUeTvrf
         oPYBzPoyN6pdY6G5c1MF4g2vhF5j5wXh0aa36suikrEqka5K6jFjTBKapvfWvtZMho3D
         JI4pmO+Ovu8FNAr5WBh8PR8G9XeC3Yxb7tYvJGTjdZGE4cr9uR0jD9jvzg+yVYfZnvBb
         95ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wmk8G5mi5lIqSGfp4MF3wRMXt1V24erTsfY43EEG76o=;
        b=LGmDUh/shPaw2tdaDPYNGoQw1h4HFk0st+7DTe3Brw27ZTQo365YRihZ1OnGrfODiH
         2P1MZBUp2lDELFbb+9djDMLuRrZsWMFvCy4ABtGV7gGnLfs2gGqf6bUyLyNSO7IFm+Sd
         HmbxgP9w9NK+2gX5VjLS2yYcMyTCK7nNkE6qC5M+HUgGQeYFbsan37EdzvUQufcHLZln
         D2NprswZ7TMvUZz6S5QIb9iKHQgA6rQBc/wfn+rgPfNLcWBHFXv44gahUHxw0ZRIHvMk
         tQ2xLErR6ZLGXBFFNXHnv4x+bPc/eVZCh9i8InGFV2BojiFTlIXPSJ6yN/JRtHuqeVNJ
         9MzQ==
X-Gm-Message-State: AA+aEWbfTMnes2OKQoUDuj8EO0s78iWdOrtV6UjS/RuTbw8P3Tx/rjCo
        MDNCZm2VBMcYvUl6YmpBvfFmb/z87p8=
X-Google-Smtp-Source: AFSGD/WJ2prs/yfQpMCMkfHG30yvrnkAZ3zyMM0Q9mHxPZmudN2072WEHG4zhzk16pgpGgIQqIpZww==
X-Received: by 2002:a17:902:7603:: with SMTP id k3mr35101475pll.285.1543364929847;
        Tue, 27 Nov 2018 16:28:49 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id g2sm6284739pfi.95.2018.11.27.16.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:28:49 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:28:48 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/9] btrfs: switch BTRFS_FS_* to enums
Message-ID: <20181128002848.GK846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <9ff441008db0d0bb2780cb94830c66fa65c78f60.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ff441008db0d0bb2780cb94830c66fa65c78f60.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:45PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> internal filesystem states.

Hah, looks like we never had a bit 0 ;)

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 63 ++++++++++++++++++++++++------------------------
>  1 file changed, 31 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 40c405d74a01..7176b95b40e7 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -757,38 +757,37 @@ struct btrfs_swapfile_pin {
>  
>  bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr);
>  
> -#define BTRFS_FS_BARRIER			1
> -#define BTRFS_FS_CLOSING_START			2
> -#define BTRFS_FS_CLOSING_DONE			3
> -#define BTRFS_FS_LOG_RECOVERING			4
> -#define BTRFS_FS_OPEN				5
> -#define BTRFS_FS_QUOTA_ENABLED			6
> -#define BTRFS_FS_UPDATE_UUID_TREE_GEN		9
> -#define BTRFS_FS_CREATING_FREE_SPACE_TREE	10
> -#define BTRFS_FS_BTREE_ERR			11
> -#define BTRFS_FS_LOG1_ERR			12
> -#define BTRFS_FS_LOG2_ERR			13
> -#define BTRFS_FS_QUOTA_OVERRIDE			14
> -/* Used to record internally whether fs has been frozen */
> -#define BTRFS_FS_FROZEN				15
> -
> -/*
> - * Indicate that a whole-filesystem exclusive operation is running
> - * (device replace, resize, device add/delete, balance)
> - */
> -#define BTRFS_FS_EXCL_OP			16
> -
> -/*
> - * To info transaction_kthread we need an immediate commit so it doesn't
> - * need to wait for commit_interval
> - */
> -#define BTRFS_FS_NEED_ASYNC_COMMIT		17
> -
> -/*
> - * Indicate that balance has been set up from the ioctl and is in the main
> - * phase. The fs_info::balance_ctl is initialized.
> - */
> -#define BTRFS_FS_BALANCE_RUNNING		18
> +enum {
> +	BTRFS_FS_BARRIER,
> +	BTRFS_FS_CLOSING_START,
> +	BTRFS_FS_CLOSING_DONE,
> +	BTRFS_FS_LOG_RECOVERING,
> +	BTRFS_FS_OPEN,
> +	BTRFS_FS_QUOTA_ENABLED,
> +	BTRFS_FS_UPDATE_UUID_TREE_GEN,
> +	BTRFS_FS_CREATING_FREE_SPACE_TREE,
> +	BTRFS_FS_BTREE_ERR,
> +	BTRFS_FS_LOG1_ERR,
> +	BTRFS_FS_LOG2_ERR,
> +	BTRFS_FS_QUOTA_OVERRIDE,
> +	/* Used to record internally whether fs has been frozen */
> +	BTRFS_FS_FROZEN,
> +	/*
> +	 * Indicate that a whole-filesystem exclusive operation is running
> +	 * (device replace, resize, device add/delete, balance)
> +	 */
> +	BTRFS_FS_EXCL_OP,
> +	/*
> +	 * To info transaction_kthread we need an immediate commit so it
> +	 * doesn't need to wait for commit_interval
> +	 */
> +	BTRFS_FS_NEED_ASYNC_COMMIT,
> +	/*
> +	 * Indicate that balance has been set up from the ioctl and is in the
> +	 * main phase. The fs_info::balance_ctl is initialized.
> +	 */
> +	BTRFS_FS_BALANCE_RUNNING,
> +};
>  
>  struct btrfs_fs_info {
>  	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
> -- 
> 2.19.1
> 
