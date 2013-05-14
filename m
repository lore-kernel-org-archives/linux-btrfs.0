Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40351 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3ENGjo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 02:39:44 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D77323EE0B6
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 15:39:42 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id CA8B145DE56
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 15:39:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id B3F0C45DE54
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 15:39:42 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id A4D4D1DB8040
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 15:39:42 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5EE2A1DB803A
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 15:39:42 +0900 (JST)
Message-ID: <5191DC20.704@jp.fujitsu.com>
Date: Tue, 14 May 2013 15:39:28 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs: don't abort the current transaction if there
 is no enough space for inode cache
References: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Miao,

On 2013/05/13 22:55, Miao Xie wrote:
> The filesystem with inode cache was forced to be read-only when we umounted it.
> 
> Steps to reproduce:
>   # mkfs.btrfs -f ${DEV}
>   # mount -o inode_cache ${DEV} ${MNT}
>   # dd if=/dev/zero of=${MNT}/file1 bs=1M count=8192
>   # btrfs fi syn ${MNT}
>   # dd if=${MNT}/file1 of=/dev/null bs=1M
>   # rm -f ${MNT}/file1
>   # btrfs fi syn ${MNT}
>   # umount ${MNT}
> 
> It is because there was no enough space to do inode cache truncation, and then
> we aborted the current transaction.

The problem has not occurred in my testset after applying your patchset.
Your patchset looks good to me. Thanks.

Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

> 
> But no space error is not a serious problem when we write out the inode cache,
> and it is safe that we just skip this step if we meet this problem. So we need
> not abort the current transaction.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>   fs/btrfs/inode-map.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index d26f67a..9818d4a 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -468,7 +468,8 @@ again:
>   	if (i_size_read(inode) > 0) {
>   		ret = btrfs_truncate_free_space_cache(root, trans, path, inode);
>   		if (ret) {
> -			btrfs_abort_transaction(trans, root, ret);
> +			if (ret != -ENOSPC)
> +				btrfs_abort_transaction(trans, root, ret);
>   			goto out_put;
>   		}
>   	}
> 


