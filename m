Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63328 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3H3CNh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 22:13:37 -0400
Message-ID: <521FFF59.1000300@cn.fujitsu.com>
Date: Fri, 30 Aug 2013 10:11:37 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix printing of non NULL terminated string
References: <1377017508-9355-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1377017508-9355-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/21/2013 12:51 AM, Filipe David Borba Manana wrote:

please use checkpatch.pl to check coding styles before sending patch

ERROR: code indent should use tabs where possible
#37: FILE: fs/btrfs/delayed-inode.c:1477:
+^I^I                name_len, name,$

total: 1 errors, 0 warnings, 13 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
       scripts/cleanfile

Thanks,
Wang
> The name buffer is not terminated by a '\0' character,
> therefore it needs to be printed with %.*s and use the
> length of the buffer.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>   fs/btrfs/delayed-inode.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index fa88297..c0c3a6b 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1471,10 +1471,10 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>   	mutex_lock(&delayed_node->mutex);
>   	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
>   	if (unlikely(ret)) {
> -		printk(KERN_ERR "err add delayed dir index item(name: %s) into "
> -				"the insertion tree of the delayed node"
> +		printk(KERN_ERR "err add delayed dir index item (name: %.*s) "
> +				"into the insertion tree of the delayed node "
>   				"(root id: %llu, inode id: %llu, errno: %d)\n",
> -				name,
> +		                name_len, name,
>   				(unsigned long long)delayed_node->root->objectid,
>   				(unsigned long long)delayed_node->inode_id,
>   				ret);

