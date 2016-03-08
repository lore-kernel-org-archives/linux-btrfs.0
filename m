Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:51447 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbcCHTYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Mar 2016 14:24:39 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v2] Btrfs: Show a warning message if one of objectid
 reaches its highest value
References: <56DCF015.9060703@jp.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56DF26F4.2010508@inwind.it>
Date: Tue, 8 Mar 2016 20:24:36 +0100
MIME-Version: 1.0
In-Reply-To: <56DCF015.9060703@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-07 04:05, Satoru Takeuchi wrote:
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


Please, don't use a static GLOBAL variable. I suggest to move to a "per filesystem" variables for two main reasons:

1) if in the (very unlikely) case where two different filesystems reach BTRFS_LAST_FREE_OBJECTID, the first error will hide the second one.

2) if you umount and remount the filesystem the error is not shown anymore. A module unload/load or a reboot is required. 
If something strange happens, one of the first thing that the user does, is to umount/remount the filesystem. But the error is not show anymore. This could complicate the diagnosis of the problem. 




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


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
