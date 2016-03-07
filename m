Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:63367 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbcCGDZj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 22:25:39 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id F39F1AC01A6
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Mar 2016 12:25:30 +0900 (JST)
Subject: Re: [PATCH v2] Btrfs: Show a warning message if one of objectid
 reaches its highest value
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56DCF015.9060703@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56DCF4A3.1080300@jp.fujitsu.com>
Date: Mon, 7 Mar 2016 12:25:23 +0900
MIME-Version: 1.0
In-Reply-To: <56DCF015.9060703@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/07 12:05, Satoru Takeuchi wrote:
> - It's better to show a warning message for the exceptional case
>    that one of objectid (in most case, inode number) reaches its
>    highest value. Show this message only once to avoid filling
>    dmesg with it.
> - EOVERFLOW is more proper return value for this case.
>    ENOSPC is for "No space left on device" case and objectid isn't
>    related to any device.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
> This patch can be applied to 4.5-rc7

Sorry, I forgot to add changelog.

===
V2:
 - Reflect Filipe's comment
   - Use btrfs_warn() instead of WARN_ONCE()
   - Print the id of the tree
===

Thanks,
Satoru

> ---
>   fs/btrfs/inode-map.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index e50316c..f5e3228 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -556,7 +556,15 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>   	mutex_lock(&root->objectid_mutex);
> 
>   	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
> -		ret = -ENOSPC;
> +		static bool __warned = false;
> +
> +		if (unlikely(!__warned)) {
> +			btrfs_warn(root->fs_info,
> +				   "The objectid of root %llu reaches its highest value.\n",
> +				   root->root_key.objectid);
> +			__warned = true;
> +		}
> +		ret = -EOVERFLOW;
>   		goto out;
>   	}
> 
