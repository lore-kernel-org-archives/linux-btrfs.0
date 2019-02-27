Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D060DC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9427217F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfB0QnX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:43:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:59458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfB0QnX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 11:43:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8E5EAF5F;
        Wed, 27 Feb 2019 16:43:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA7ADDA83C; Wed, 27 Feb 2019 17:44:41 +0100 (CET)
Date:   Wed, 27 Feb 2019 17:44:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: zstd ensure reclaim timer is properly cleaned
 up
Message-ID: <20190227164441.GY24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190222195348.2728-1-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222195348.2728-1-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 22, 2019 at 02:53:48PM -0500, Dennis Zhou wrote:
> The timer function, zstd_reclaim_timer_fn(), reschedules itself under
> certain conditions. When cleaning up, take the lock and remove all
> workspaces. This prevents the timer from rearming itself. Lastly, switch
> to del_timer_sync() to ensure that the timer function can't trigger as
> we're unloading.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> v2:
> - cleanup workspaces and then disable the timer
> 
>  fs/btrfs/zstd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 3e418a3aeb11..6b9e29d050f3 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -195,8 +195,7 @@ static void zstd_cleanup_workspace_manager(void)
>  	struct workspace *workspace;
>  	int i;
>  
> -	del_timer(&wsm.timer);
> -
> +	spin_lock(&wsm.lock);
>  	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++) {
>  		while (!list_empty(&wsm.idle_ws[i])) {
>  			workspace = container_of(wsm.idle_ws[i].next,
> @@ -206,6 +205,9 @@ static void zstd_cleanup_workspace_manager(void)
>  			wsm.ops->free_workspace(&workspace->list);

I've noticed while reading the code, why do you use the indirect call
here? The wsm.ops points to btrfs_zstd_compress so free_workspace is
always zstd_free_workspace.

The compiler is usually smart to replace such things by direct call if
the type has not escaped, but this is not true for btrfs_compress_op so
the indirect function call must be preserved.
