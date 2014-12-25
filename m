Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56460 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaLYB3R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:29:17 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 3E9BA3EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:29:16 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 5349BAC0495
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:29:15 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 068E2E08001
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 10:29:15 +0900 (JST)
Message-ID: <549B6864.2030508@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 10:29:08 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 4/8] Add strdup in btrfs_add_to_fsid() to track the device
 path.
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it> <1418847252-14184-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-5-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/18 5:14, Goffredo Baroncelli wrote:
> When creating a new btrfs_device, copy the path to track it.
> This path is then used by mkfs.btrfs to list all devices.
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   utils.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/utils.c b/utils.c
> index dcb4f74..3f50e4d 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -647,6 +647,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   	device->bytes_used = 0;
>   	device->total_ios = 0;
>   	device->dev_root = root->fs_info->dev_root;
> +	device->name = strdup(path);
>   
>   	ret = btrfs_add_device(trans, root, device);
>   	BUG_ON(ret);
> 

