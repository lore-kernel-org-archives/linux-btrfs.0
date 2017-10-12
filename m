Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:52817 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdJLRzp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 13:55:45 -0400
Received: by mail-wm0-f66.google.com with SMTP id k4so15506379wmc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 10:55:44 -0700 (PDT)
Date: Thu, 12 Oct 2017 19:55:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, target-devel@vger.kernel.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [Nouveau] [PATCH 03/10] driver:gpu: return -ENOMEM on allocation
 failure.
Message-ID: <20171012175541.5jh3ovdzpyj5fflv@phenom.ffwll.local>
References: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
 <1505287939-14106-3-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505287939-14106-3-git-send-email-allen.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 13, 2017 at 01:02:12PM +0530, Allen Pais wrote:
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Applied to drm-misc-next, thanks.
-Daniel

> ---
>  drivers/gpu/drm/gma500/mid_bios.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/gma500/mid_bios.c b/drivers/gpu/drm/gma500/mid_bios.c
> index d75ecb3..1fa1633 100644
> --- a/drivers/gpu/drm/gma500/mid_bios.c
> +++ b/drivers/gpu/drm/gma500/mid_bios.c
> @@ -237,7 +237,7 @@ static int mid_get_vbt_data_r10(struct drm_psb_private *dev_priv, u32 addr)
>  
>  	gct = kmalloc(sizeof(*gct) * vbt.panel_count, GFP_KERNEL);
>  	if (!gct)
> -		return -1;
> +		return -ENOMEM;
>  
>  	gct_virtual = ioremap(addr + sizeof(vbt),
>  			sizeof(*gct) * vbt.panel_count);
> -- 
> 2.7.4
> 
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
