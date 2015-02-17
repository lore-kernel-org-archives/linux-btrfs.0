Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57178 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752058AbbBQJnG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 04:43:06 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1H9gGGO029810
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 17:42:16 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <1424165965-4066-1-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1424165965-4066-1-git-send-email-zhaolei@cn.fujitsu.com>
Subject: RE: [PATCH 01/10] btrfs: Adjust commit-transaction condition to avoid NO_SPACE more
Date: Tue, 17 Feb 2015 17:42:52 +0800
Message-ID: <000701d04a96$19c9f4c0$4d5dde40$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> From: Zhaolei [mailto:zhaolei@cn.fujitsu.com]
> Subject: [PATCH 01/10] btrfs: Adjust commit-transaction condition to avoid
> NO_SPACE more

Sorry for title, it is only one patch.
Will resend.

Thanks
Zhaolei

> 
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> If we have any chance to make a successful write, we should not give up.
> 
> This patch adjust commit-transaction condition from:
>   pinned >= wanted
> to
>   left + pinned >= wanted
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
> 414d533..4ffce64 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3751,7 +3751,8 @@ alloc:
>  		 * don't bother committing the transaction.
>  		 */
>  		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
> -					   bytes) < 0)
> +					   used + bytes -
> +					   data_sinfo->total_bytes) < 0)
>  			have_pinned_space = 0;
>  		spin_unlock(&data_sinfo->lock);
> 
> --
> 1.8.5.1



