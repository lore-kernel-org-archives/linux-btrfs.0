Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42775 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966721Ab2EQO7C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 10:59:02 -0400
Received: by wgbdr13 with SMTP id dr13so1846078wgb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 07:59:00 -0700 (PDT)
Date: Thu, 17 May 2012 17:58:56 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] Btrfs: count the chunks which will be relocated at
 first
Message-ID: <20120517145856.GA1934@zambezi.lan>
References: <4FB4E785.4050902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB4E785.4050902@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 07:56:53PM +0800, Miao Xie wrote:
> the balance function should count the chunks which will be relocated at first,
> and then relocate those chunks one by one.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 759d024..91da8a2 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2580,7 +2580,7 @@ again:
>  
>  		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
>  
> -		if (!counting) {
> +		if (counting) {
>  			spin_lock(&fs_info->balance_lock);
>  			bctl->stat.considered++;
>  			spin_unlock(&fs_info->balance_lock);

__btrfs_balance() already calculates the approximate number of chunks
that will be relocated and stores that value in bctl->stat.expected.
The stat.considered counter OTOH is supposed to reflect the number of
chunks processed through balance filters and it is meant to be updated
at relocation pass, so AFAICS if (!counting) is the right test.

What exactly are you trying to fix here ?

Thanks,

		Ilya
