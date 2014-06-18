Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:42665 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaFRGBr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 02:01:47 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id C73AE3EE0B6
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 15:01:45 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 46575AC059A
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 15:01:44 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id E399D1DB8037
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 15:01:43 +0900 (JST)
Message-ID: <53A12B3C.7020606@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 15:01:32 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Adam Buchbinder <abuchbinder@google.com>, <linux-btrfs@vger.kernel.org>
CC: <dave@jikos.cz>
Subject: Re: [PATCH] Properly size the leafsize field in the mdrestore_struct
 struct.
References: <1402613853-14956-1-git-send-email-abuchbinder@google.com>
In-Reply-To: <1402613853-14956-1-git-send-email-abuchbinder@google.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Adam,

(2014/06/13 7:57), Adam Buchbinder wrote:
> It's 32 bits as defined in ctree.h, but the struct had it as 64 bits.
> 
> Found using MemorySanitizer.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

It looks good to me.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> ---
>   btrfs-image.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/btrfs-image.c b/btrfs-image.c
> index cf1fe2d..98d765a 100644
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -128,7 +128,7 @@ struct mdrestore_struct {
>   	struct rb_root chunk_tree;
>   	struct list_head list;
>   	size_t num_items;
> -	u64 leafsize;
> +	u32 leafsize;
>   	u64 devid;
>   	u8 uuid[BTRFS_UUID_SIZE];
>   	u8 fsid[BTRFS_FSID_SIZE];
> 

