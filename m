Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2GEHaO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 03:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <1341473198-3883-1-git-send-email-zwu.kernel@gmail.com>
References: <1341473198-3883-1-git-send-email-zwu.kernel@gmail.com>
Date: Thu, 5 Jul 2012 15:30:13 +0800
Message-ID: <CAEH94Lg7owGgK=EcY_FVjQPYt4jF3DpEMaVayEy0YH_uMofc_g@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: rework the code logic
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, please ignore this patch.

On Thu, Jul 5, 2012 at 3:26 PM,  <zwu.kernel@gmail.com> wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  extent-cache.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/extent-cache.c b/extent-cache.c
> index 3dd6434..a5084ee 100644
> --- a/extent-cache.c
> +++ b/extent-cache.c
> @@ -136,10 +136,10 @@ struct cache_extent *find_first_cache_extent(struct cache_tree *tree,
>         struct cache_extent *entry;
>
>         ret = __tree_search(&tree->root, start, 1, &prev);
> -       if (!ret)
> +       if (!ret) {
>                 ret = prev;
> -       if (!ret)
>                 return NULL;
> +        }
>         entry = rb_entry(ret, struct cache_extent, rb_node);
>         return entry;
>  }
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
