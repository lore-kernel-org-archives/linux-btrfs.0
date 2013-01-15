Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64366 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab3AOQ7O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 11:59:14 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so179423eek.28
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 08:59:13 -0800 (PST)
Date: Tue, 15 Jan 2013 18:59:04 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash of starting balance
Message-ID: <20130115165903.GB2040@zambezi.lan>
References: <1358261277-3566-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358261277-3566-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 15, 2013 at 10:47:57PM +0800, Liu Bo wrote:
> We will crash on BUG_ON(ret == -EEXIST) when we do not resume the existing
> balance but attempt to start a new one.
> 
> The steps can be:
> 1. start balance
> 2. pause balance
> 3. start balance
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5cce6aa..3901654 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3100,7 +3100,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		goto out;
>  
>  	if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
> -		BUG_ON(ret == -EEXIST);
> +		/*
> +		 * This can happen when we do not resume the existing balance
> +		 * but try to start a new one instead.
> +		 */
> +		if (ret == -EEXIST)
> +			goto out;
>  		set_balance_control(bctl);
>  	} else {
>  		BUG_ON(ret != -EEXIST);

OK, it seems balance pause/resume logic got broken by dev-replace code
(5ac00addc7ac09110995fe967071d191b5981cc1), which went into v3.8-rc1.
This is most certainly not the right way to fix it, that BUG_ON is there
for a reason.  I'll send a fix in a couple of days.

Thanks,

		Ilya

> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
