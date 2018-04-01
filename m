Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbeDAKD7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Apr 2018 06:03:59 -0400
Subject: Re: [PATCH] Btrfs: fix NULL pointer dereference in log_dir_items
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1522447918-19147-3-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cc4fb2de-3bbf-1726-e8cf-5725d7cd674b@suse.com>
Date: Sun, 1 Apr 2018 13:03:56 +0300
MIME-Version: 1.0
In-Reply-To: <1522447918-19147-3-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.03.2018 01:11, Liu Bo wrote:
> 0, 1 and <0 can be returned by btrfs_next_leaf(), and when <0 is
> returned, path->nodes[0] could be NULL, log_dir_items lacks such a
> check for <0 and we may run into a null pointer dereference panic.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>

This bug has been present ever since 2.6.29 (e02119d5a7b4 ("Btrfs: Add a
write ahead tree log to optimize synchronous operations"))
 so this needs a stable tag.

> ---
>  fs/btrfs/tree-log.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 4344577..4ee9431 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3518,8 +3518,11 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
>  		 * from this directory and from this transaction
>  		 */
>  		ret = btrfs_next_leaf(root, path);
> -		if (ret == 1) {
> -			last_offset = (u64)-1;
> +		if (ret) {
> +			if (ret == 1)
> +				last_offset = (u64)-1;
> +			else
> +				err = ret;
>  			goto done;
>  		}
>  		btrfs_item_key_to_cpu(path->nodes[0], &tmp, path->slots[0]);
> 
