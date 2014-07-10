Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50508 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaGJAFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 20:05:44 -0400
Message-ID: <53BDD8B5.2040609@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 09:05:09 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <julia.lawall@lip6.fr>
Subject: Re: [PATCH] Btrfs: use BUG_ON
References: <20140708222141.GA11854@himangi-Dell>
In-Reply-To: <20140708222141.GA11854@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Himangi,

(2014/07/09 7:21), Himangi Saraogi wrote:
> Use BUG_ON(x) rather than if(x) BUG();
>
> The semantic patch that fixes this problem is as follows:
>
> // <smpl>
> @@ identifier x; @@
> -if (x) BUG();
> +BUG_ON(x);
> // </smpl>

Strictly speaking, BUG_ON() is "if (unlikely(x)) BUG".
Anyway, I consider that put this condition in unlikely()
in this case is good.

BTW, there are many "if BUG()" case under fs/btrfs.
How about fix all of them?

===============================================================================
$ grep -rnH -B 1 "BUG()" fs/btrfs | grep -A 1 'if.*('
fs/btrfs/inode.c-6318-		} else if (create && PageUptodate(page)) {
fs/btrfs/inode.c:6319:			BUG();
--
fs/btrfs/volumes.c-2626-			else if (ret)
fs/btrfs/volumes.c:2627:				BUG(); # <- your patch fixes it.
--
fs/btrfs/volumes.c-3092-		if (ret == 0)
fs/btrfs/volumes.c:3093:			BUG(); /* FIXME break ? */
--
fs/btrfs/raid56.c-2048-	if (rbio->faila == -1) {
fs/btrfs/raid56.c:2049:		BUG();
===============================================================================

Thanks,
Satoru

>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>   fs/btrfs/volumes.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6104676..63e746e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2623,8 +2623,8 @@ again:
>   						   found_key.offset);
>   			if (ret == -ENOSPC)
>   				failed++;
> -			else if (ret)
> -				BUG();
> +			else
> +				BUG_ON(ret);
>   		}
>
>   		if (found_key.offset == 0)
>

