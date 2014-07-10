Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47193 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaGJCbn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 22:31:43 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 622AC3EE1DE
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 11:31:42 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 77FF6AC0A48
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 11:31:41 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 135251DB8032
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 11:31:41 +0900 (JST)
Message-ID: <53BDFAD2.3040204@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 11:30:42 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: set error return value in btrfs_get_blocks_direct
References: <1404732921-15003-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1404732921-15003-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/07 20:35), Filipe Manana wrote:
> We were returning with 0 (success) because we weren't extracting the
> error code from em (PTR_ERR(em)). Fix it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   fs/btrfs/inode.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 6b65fab..8a946c0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6998,8 +6998,10 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>   						       block_start, len,
>   						       orig_block_len,
>   						       ram_bytes, type);
> -				if (IS_ERR(em))
> +				if (IS_ERR(em)) {
> +					ret = PTR_ERR(em);
>   					goto unlock_err;
> +				}
>   			}
>   
>   			ret = btrfs_add_ordered_extent_dio(inode, start,
> 

