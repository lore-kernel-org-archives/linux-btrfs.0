Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D996C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C828120665
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="WFWrnK6Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C828120665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbeK1LXn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:23:43 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:52741 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbeK1LXn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:23:43 -0500
Received: by mail-it1-f194.google.com with SMTP id i7so1625338iti.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZaHMb0eeFuhiEYrveWri4frIQJw0sIMY85T3N2pXoeE=;
        b=WFWrnK6YWhKVcd7MKxZFB7woqmfAHafyy4dJ2fluWg6EpkFhnR9A9QtvncvIpm8JWc
         mkk0x4PFXvhUrzSRlclJs39ckdtJqAj+/K7UGbgj0oNg0ijc6pDlXZgQvZFALfMIpG1y
         TwVnDM+wz18JgW21jKpMMsijF8DWVNXZFGtDyiv8t7Dj1OaANeBtgLQBKuwicIS6LpO1
         2ytBjXi6r+3yJYhIN6yHRDjQD2dfUYrVSxjGihJdmaC1ZRHoUzfolnCqilizuyI50Bnk
         IV85061MINnsVoQKR7pMxC+8WaSRYPlh6Uwyo3b5t1EgiSy3+C0n5BPui0UJvA1hiVpM
         +wGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZaHMb0eeFuhiEYrveWri4frIQJw0sIMY85T3N2pXoeE=;
        b=kfjJ/+eK+/4Sxp5S8ImJwZhbsoO/dz7C445kvnO9PLlJ6lIhLkG4Sp32ivvPYJt/tT
         0wVtww33r3j8Fu/KnNIGyqJ+f9QG5CzBFdzZCCecXXwuTWbpxR82oxkjPoT0mwg1IVOM
         EIjEPgNJfz115+VDtwWgpnsBM7RDz1EGP13FM9WoRDGrmn6WyjqMI7XfvJkhL0r0X38k
         6niTaF6EAyZ8NNjIyzvKaH0WvRJtBwXXAHpbojFbeMyw2GgeMrycKhol4dTyWJ+DtkTc
         fHYRA+ubAuyWwGz7wQ4Z9ytBZbQTmOUsPlL3cYJ7mW4GmGh94ehojFmcoOFb91PA30pF
         cmrQ==
X-Gm-Message-State: AA+aEWZnqBeibbkI4jzyBUw9ktZU+cewKGm2JDB1XHyGnPt2YK3MzLUB
        GO+khJRzsqqAMuh1lQfOlPZUs2usibs=
X-Google-Smtp-Source: AFSGD/VAiqzfs9+FsThqFG98ssHCzd5kaOALvmajrBaRPUislJGovRlFdzDeZihMM7XW9NUnR3kO0w==
X-Received: by 2002:a24:170a:: with SMTP id 10-v6mr1060515ith.117.1543364645313;
        Tue, 27 Nov 2018 16:24:05 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id j13-v6sm323038ita.27.2018.11.27.16.24.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:24:04 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:24:03 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs: switch BTRFS_FS_STATE_* to enums
Message-ID: <20181128002403.GI846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:41PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> global filesystem states.

Reviewed-by: Omar Sandoval <osandov@fb.com>

Some typos/wording suggestions below.

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a98507fa9192..f82ec5e41b0c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -109,13 +109,26 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>  }
>  
>  /*
> - * File system states
> + * Runtime (in-memory) states of filesystem
>   */
> -#define BTRFS_FS_STATE_ERROR		0
> -#define BTRFS_FS_STATE_REMOUNTING	1
> -#define BTRFS_FS_STATE_TRANS_ABORTED	2
> -#define BTRFS_FS_STATE_DEV_REPLACING	3
> -#define BTRFS_FS_STATE_DUMMY_FS_INFO	4
> +enum {
> +	/* Global indicator of serious filesysystem errors */

filesysystem -> filesystem

> +	BTRFS_FS_STATE_ERROR,
> +	/*
> +	 * Filesystem is being remounted, allow to skip some operations, like
> +	 * defrag
> +	 */
> +	BTRFS_FS_STATE_REMOUNTING,
> +	/* Track if the transaction abort has been reported */

Which one is "the" transaction abort? This gives me the impression that
this is a flag on the transaction, but it's actually filesystem state.
Maybe "Track if a transaction abort has been reported on this
filesystem"?

> +	BTRFS_FS_STATE_TRANS_ABORTED,
> +	/*
> +	 * Indicate that replace source or target device state is changed and
> +	 * allow to block bio operations
> +	 */

Again, this makes it sound like it's device state, but it's actually
filesystem state. How about "Bio operations should be blocked on this
filesystem because a source or target device is being destroyed as part
of a device replace"?

> +	BTRFS_FS_STATE_DEV_REPLACING,
> +	/* The btrfs_fs_info created for self-tests */
> +	BTRFS_FS_STATE_DUMMY_FS_INFO,
> +};
>  
>  #define BTRFS_BACKREF_REV_MAX		256
>  #define BTRFS_BACKREF_REV_SHIFT		56
> -- 
> 2.19.1
> 
