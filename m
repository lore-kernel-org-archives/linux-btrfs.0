Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377E3C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A7C1218A4
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbfA3OIh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:08:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:57142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729203AbfA3OIg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:08:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 256C0ADE6;
        Wed, 30 Jan 2019 14:08:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D15C1DA78C; Wed, 30 Jan 2019 15:07:59 +0100 (CET)
Date:   Wed, 30 Jan 2019 15:07:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] btrfs: scrub: fix circular locking dependency
 warning
Message-ID: <20190130140758.GR2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
 <1548830702-14676-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548830702-14676-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 02:45:00PM +0800, Anand Jain wrote:
> v3->v4: Fix list corruption as reported by btrfs/073 by David.
>            [1]
>            https://patchwork.kernel.org/patch/10705741/
> 	Which I was able to reproduce with an instrumented kernel but not with
> 	btrfs/073.
>         In v3 patch, it releases the fs_info::scrub_lock to destroy the work queue
> 	which raced with new scrub requests, overwriting the scrub workers
> 	pointers. So in v4, it kills the function scrub_workers_put(), and
> 	performs the destroy_workqueue in two stages, with worker pointers
> 	copied locally.

> @@ -3932,9 +3925,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  
>  	mutex_lock(&fs_info->scrub_lock);
>  	dev->scrub_ctx = NULL;
> -	scrub_workers_put(fs_info);
> +	if (--fs_info->scrub_workers_refcnt == 0) {
> +		scrub_workers = fs_info->scrub_workers;
> +		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
> +		scrub_parity = fs_info->scrub_parity_workers;
> +	}
>  	mutex_unlock(&fs_info->scrub_lock);
>  
> +	btrfs_destroy_workqueue(scrub_workers);
> +	btrfs_destroy_workqueue(scrub_wr_comp);
> +	btrfs_destroy_workqueue(scrub_parity);

https://lore.kernel.org/linux-btrfs/1543554924-17397-2-git-send-email-anand.jain@oracle.com/

Comparing to the previous version, it's almost the same I think. If
scrub_workers_get races between the unlock and destroy_workers, anything
that uses fs_info->scrub_wokers will soon use freed memory.

The difference is that the worker pointers are read from fs_info under a
lock but are still used outside. I haven't tested this version but from
the analysis of previous crash, I don't see how v4 is supposed to be
better.
