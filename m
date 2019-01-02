Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0F7C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CDC5218EA
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbfABRUs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 12:20:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:50618 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729749AbfABRUs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 12:20:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 850CCAE3F;
        Wed,  2 Jan 2019 17:20:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CBDD9DA781; Wed,  2 Jan 2019 18:20:17 +0100 (CET)
Date:   Wed, 2 Jan 2019 18:20:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: add kernel scrub log messages
Message-ID: <20190102172017.GC23615@twin.jikos.cz>
Reply-To: dsterba@suse.ce
Mail-Followup-To: dsterba@suse.ce, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1545016512-4336-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545016512-4336-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 17, 2018 at 11:15:12AM +0800, Anand Jain wrote:
> scrub kernel messages helps debug and audit, add them to the log.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/scrub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 902819d3cf41..d7a92521019e 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3876,6 +3876,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  	mutex_unlock(&fs_info->scrub_lock);
>  
>  	if (!is_dev_replace) {
> +		btrfs_info(fs_info, "scrub: devid %llu %s", devid, "started");

Why do you print a fixed and known string using %s?

>  		/*
>  		 * by holding device list mutex, we can
>  		 * kick off writing super in log tree sync.
> @@ -3897,6 +3898,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  	if (progress)
>  		memcpy(progress, &sctx->stat, sizeof(*progress));
>  
> +	if (!is_dev_replace)
> +		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
> +			   devid, ret ? "not finished":"finished", ret);

Spaces around binary operators please: ret ? "not finished" : "finished"

What's the reason to print the error code here? It is returned from the
ioctl.
