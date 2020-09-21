Return-Path: <SRS0=y50c=C6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C735DC4363C
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 18:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B96720756
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 18:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgIUSui (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:50:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:32998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUSui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Sep 2020 14:50:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE685B1FE;
        Mon, 21 Sep 2020 18:51:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B96B8DA6E0; Mon, 21 Sep 2020 20:49:21 +0200 (CEST)
Date:   Mon, 21 Sep 2020 20:49:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Denis Efremov <efremov@linux.com>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/2] btrfs: check allocation size in btrfs_ioctl_send()
Message-ID: <20200921184921.GR6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Denis Efremov <efremov@linux.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20200921170336.82643-1-efremov@linux.com>
 <20200921170336.82643-2-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921170336.82643-2-efremov@linux.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 21, 2020 at 08:03:36PM +0300, Denis Efremov wrote:
> Replace kvzalloc() call with kvcalloc() that checks
> the size internally. Use array_size() helper to compute
> the memory size for clone_sources_tmp.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  fs/btrfs/send.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index c874ddda6252..9e02aba30651 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -7087,7 +7087,7 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
>  	u32 i;
>  	u64 *clone_sources_tmp = NULL;
>  	int clone_sources_to_rollback = 0;
> -	unsigned alloc_size;
> +	size_t alloc_size;
>  	int sort_clone_roots = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -7179,15 +7179,16 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
>  	sctx->waiting_dir_moves = RB_ROOT;
>  	sctx->orphan_dirs = RB_ROOT;
>  
> -	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
> -
> -	sctx->clone_roots = kvzalloc(alloc_size, GFP_KERNEL);
> +	sctx->clone_roots = kvcalloc(sizeof(*sctx->clone_roots),
> +				     arg->clone_sources_count + 1,
> +				     GFP_KERNEL);

There is an overflow check in btrfs_ioctl_send a few lines above, it
won't overflow at the allocation so this more like a cleanup than adding
a missing check, as the subject suggests.

Patches added to misc-next, thanks.
