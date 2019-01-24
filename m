Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B446AC282C3
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 20:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF2B217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 20:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfAXUVu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 15:21:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:49390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727898AbfAXUVu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 15:21:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1A53EB05C;
        Thu, 24 Jan 2019 20:21:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7F663DA6F5; Thu, 24 Jan 2019 21:21:15 +0100 (CET)
Date:   Thu, 24 Jan 2019 21:21:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: add kernel scrub log messages
Message-ID: <20190124202112.GB2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546503460-3183-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546503460-3183-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 04:17:40PM +0800, Anand Jain wrote:
> scrub kernel messages helps debug and audit, add them to the log.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: fix btrfs_info, using string directly. Add spacing.

>  fs/btrfs/scrub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 6dcd36d7b849..aadafc3e52c7 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3903,6 +3903,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  	 */
>  	nofs_flag = memalloc_nofs_save();
>  	if (!is_dev_replace) {
> +		btrfs_info(fs_info, "scrub: devid %llu started", devid);
>  		/*
>  		 * by holding device list mutex, we can
>  		 * kick off writing super in log tree sync.
> @@ -3925,6 +3926,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  	if (progress)
>  		memcpy(progress, &sctx->stat, sizeof(*progress));
>  
> +	if (!is_dev_replace)
> +		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
> +			devid, ret ? "not finished" : "finished", ret);

I've checked how the balance status messages are formatted and unified
them so it's

+		btrfs_info(fs_info, "scrub: started on devid %llu", devid);

and

+               btrfs_info(fs_info, "scrub: %s on devid %llu with status: %d",
+                       ret ? "not finished" : "finished", devid, ret);

Patch added to misc-next, thanks.
