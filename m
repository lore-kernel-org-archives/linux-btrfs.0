Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43130 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbbAGXtq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 18:49:46 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 1420F3EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 08:49:45 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 24161AC028A
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 08:49:44 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id C166DE08001
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 08:49:43 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
	by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 96FDA58432A
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 08:49:41 +0900 (JST)
Message-ID: <54ADC5FA.1040705@jp.fujitsu.com>
Date: Thu, 8 Jan 2015 08:49:14 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Fix a copy-n-paste bug in btrfs_read_fs_root().
References: <1420622623-25668-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1420622623-25668-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/01/07 18:23, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   disk-io.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 2bf8586..b853f66 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -693,7 +693,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
>   	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
>   		return fs_info->csum_root;
>   	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
> -		return fs_info->csum_root;
> +		return fs_info->quota_root;
>   
>   	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
>   	       location->offset != (u64)-1);
> 

