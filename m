Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47897 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbbAGBxM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jan 2015 20:53:12 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 693303EE0BD
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Jan 2015 10:53:10 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 6DEB9AC017F
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Jan 2015 10:53:09 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 087E2E08007
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Jan 2015 10:53:09 +0900 (JST)
Message-ID: <54AC916D.4080307@jp.fujitsu.com>
Date: Wed, 7 Jan 2015 10:52:45 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: qgroup: move WARN_ON() to the correct location.
References: <1420548882-12106-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1420548882-12106-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/01/06 21:54, Dongsheng Yang wrote:
> In function qgroup_excl_accounting(), we need to WARN when
> qg->excl is less than what we want to free, same to child
> and parents. But currently, for parent qgroup, the WARN_ON()
> is located after freeing qg->excl. It will WARN out even we
> free it normally.
> 
> This patch move this WARN_ON() before freeing qg->excl.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   fs/btrfs/qgroup.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 48b60db..97159a8 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1431,9 +1431,8 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>   		qgroup = u64_to_ptr(unode->aux);
>   		qgroup->rfer += sign * oper->num_bytes;
>   		qgroup->rfer_cmpr += sign * oper->num_bytes;
> +		WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
>   		qgroup->excl += sign * oper->num_bytes;
> -		if (sign < 0)
> -			WARN_ON(qgroup->excl < oper->num_bytes);
>   		qgroup->excl_cmpr += sign * oper->num_bytes;
>   		qgroup_dirty(fs_info, qgroup);
>   
> 

