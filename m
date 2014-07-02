Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32884 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756610AbaGBFew (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 01:34:52 -0400
Message-ID: <53B398E9.7040003@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 13:30:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
CC: <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Btrfs: fill_holes: Fix slot number passed to hole_mergeable()
 call.
References: <1404196468-2007-1-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1404196468-2007-1-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2014 02:34 PM, Chandan Rajendra wrote:
> For a non-existent key, btrfs_search_slot() sets path->slots[0] to the slot
> where the key could have been present, which in this case would be the slot
> containing the extent item which would be the next neighbor of the file range
> being punched. The current code passes an incremented path->slots[0] and we
> skip to the wrong file extent item. This would mean that we would fail to
> merge the "yet to be created" hole with the next neighboring hole (if one
> exists). Fix this.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
Nice catch, this looks good to me.

Reviewed-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

>   fs/btrfs/file.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index ad7c059..3cd7997 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2126,10 +2126,9 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
>   		goto out;
>   	}
>   
> -	if (hole_mergeable(inode, leaf, path->slots[0]+1, offset, end)) {
> +	if (hole_mergeable(inode, leaf, path->slots[0], offset, end)) {
>   		u64 num_bytes;
>   
> -		path->slots[0]++;
>   		key.offset = offset;
>   		btrfs_set_item_key_safe(root, path, &key);
>   		fi = btrfs_item_ptr(leaf, path->slots[0],

