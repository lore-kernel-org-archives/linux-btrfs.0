Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52448 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaLVDJg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 22:09:36 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 7DDBD3EE194
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:09:35 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 8D292AC0498
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:09:34 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 387D61DB804E
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:09:34 +0900 (JST)
Message-ID: <54978B65.8050807@jp.fujitsu.com>
Date: Mon, 22 Dec 2014 12:09:25 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: <fdmanana@gmail.com>
Subject: Re: [PATCH] btrfs-progs: Don't increase error count if the inode
 can be repaired.
References: <1419216816-13171-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1419216816-13171-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/22 11:53, Qu Wenruo wrote:
> The original check_inode_recs() will return -1 if found any error in a
> inode_record. This is OK for original design since there is almost
> nothing can repair at that time.
> 
> However more and more error from nlink mismatch to missing inode item
> can be repaired in try_repair_inode(), check_inode_recs() should not
> increase the error count if the inode can be repair.
> 
> With this patch, repair function for leaf-corruption will not return
> error if all corruption inode can be recovered.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> ---
>   cmds-check.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 3e7a4eb..aa47984 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -2302,7 +2302,7 @@ static int check_inode_recs(struct btrfs_root *root,
>   	struct inode_record *rec;
>   	struct inode_backref *backref;
>   	int stage = 0;
> -	int ret;
> +	int ret = 0;
>   	int err = 0;
>   	u64 error = 0;
>   	u64 root_dirid = btrfs_root_dirid(&root->root_item);
> @@ -2452,7 +2452,8 @@ static int check_inode_recs(struct btrfs_root *root,
>   			ret = 0;
>   		}
>   
> -		error++;
> +		if (!(repair && ret == 0))
> +			error++;
>   		print_inode_error(root, rec);
>   		list_for_each_entry(backref, &rec->backrefs, list) {
>   			if (!backref->found_dir_item)
> 

