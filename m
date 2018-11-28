Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CB6C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BF88204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="hSMVlj/r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BF88204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbeK1LaF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:30:05 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45427 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeK1LaF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:30:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id g62so9226377pfd.12
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z16+FdApu8v+Bu7zIQZz10387kMHuUREoT28ZDIa28Q=;
        b=hSMVlj/r3o8eZpKJo6fT5aRsUt7+WvvGbp0i+FacDK1S/mraVtB5oUlOx51yoXYHb7
         ihuW0J2pQDUgfk9B1Y/MKFHQJ9+GzYLIOlVOx43ksC3V3sOZG/nvIgD89nia9HJsk49g
         ipv6mwZMe8X9JQj1MR+puhcMZxN8kGlfxgEhcoXQhsNhmLBwGo61gAEje23cmffzCoo+
         uFY6xq5G7Z3jBFW5HyQYTFmfFchA0BDbzkdffwLYtdU5B36NmFg2FU3/bVRvl3D+eyG5
         FaIqSI3VyBn14d368i9mjG6Isbu09HG2C4dkSeXdgmUORqRcsv00uTprtHFpmjGO01IE
         rFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z16+FdApu8v+Bu7zIQZz10387kMHuUREoT28ZDIa28Q=;
        b=i0ZgAglnhab+2qxs/2mmatu36WznTXPOfkcrkDuJ+qBWqmh4IYBuEeY6rsCBK9OOfs
         TTbLuaOlvSd6IRBGrBhUq85EYS6bPXD8M9+NP2XfSRAaTcB9M/dUTk8ihjGfqOk/a1a6
         c+7KrGJurELB7evVUCH30+UCDuvkvTzE/iyKF34xe7nVxhKUQi3EZmSCT7YNQ9J2VdAZ
         4/XeyGxskyN2K/rM06KB7+tZHQmPe5oA8qDRM4zvjqsrriUENm8E27fMzXzU/uGh4e68
         wOZWjx3pgt84fUbK6pGECmKLxD0D/Rwp3HzAa9D2xxPXBRKNddI4CiaGXrAqXQa+6oQ4
         MQIg==
X-Gm-Message-State: AA+aEWYqeyRyZO/OHCqfI7JVUG60dGSBfRUSFhuBfUwjSIVCbI5dOqfy
        oQIHQinDCGcijs/3d0lJQnht2+zT+J8=
X-Google-Smtp-Source: AFSGD/XtLyvtXceOUc3+8TuEdz/7HLkJP0sHExEyBv+0It+c/wS4WahqUX59rmj8s4JiUVyziMFr9Q==
X-Received: by 2002:a63:5c22:: with SMTP id q34mr31022925pgb.417.1543365025620;
        Tue, 27 Nov 2018 16:30:25 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id u186sm6543180pfu.51.2018.11.27.16.30.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:30:25 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:30:24 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: switch BTRFS_ROOT_* to enums
Message-ID: <20181128003024.GL846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <f78a535281ed0bd208db0c2f70aa0e43f18cb40c.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f78a535281ed0bd208db0c2f70aa0e43f18cb40c.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:48PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> root tree flags.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7176b95b40e7..4bb0ac3050ff 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1180,22 +1180,23 @@ struct btrfs_subvolume_writers {
>  /*
>   * The state of btrfs root
>   */
> -/*
> - * btrfs_record_root_in_trans is a multi-step process,
> - * and it can race with the balancing code.   But the
> - * race is very small, and only the first time the root
> - * is added to each transaction.  So IN_TRANS_SETUP
> - * is used to tell us when more checks are required
> - */
> -#define BTRFS_ROOT_IN_TRANS_SETUP	0
> -#define BTRFS_ROOT_REF_COWS		1
> -#define BTRFS_ROOT_TRACK_DIRTY		2
> -#define BTRFS_ROOT_IN_RADIX		3
> -#define BTRFS_ROOT_ORPHAN_ITEM_INSERTED	4
> -#define BTRFS_ROOT_DEFRAG_RUNNING	5
> -#define BTRFS_ROOT_FORCE_COW		6
> -#define BTRFS_ROOT_MULTI_LOG_TASKS	7
> -#define BTRFS_ROOT_DIRTY		8
> +enum {
> +	/*
> +	 * btrfs_record_root_in_trans is a multi-step process, and it can race
> +	 * with the balancing code.   But the race is very small, and only the
> +	 * first time the root is added to each transaction.  So IN_TRANS_SETUP
> +	 * is used to tell us when more checks are required
> +	 */
> +	BTRFS_ROOT_IN_TRANS_SETUP,
> +	BTRFS_ROOT_REF_COWS,
> +	BTRFS_ROOT_TRACK_DIRTY,
> +	BTRFS_ROOT_IN_RADIX,
> +	BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
> +	BTRFS_ROOT_DEFRAG_RUNNING,
> +	BTRFS_ROOT_FORCE_COW,
> +	BTRFS_ROOT_MULTI_LOG_TASKS,
> +	BTRFS_ROOT_DIRTY,
> +};
>  
>  /*
>   * in ram representation of the tree.  extent_root is used for all allocations
> -- 
> 2.19.1
> 
