Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57100 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753150AbbEUCYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 22:24:23 -0400
Message-ID: <555D41D5.10109@cn.fujitsu.com>
Date: Thu, 21 May 2015 10:24:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: Fix a bug which makes unfinished fsid change
 unrecoverable.
References: <1431671795-30516-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431671795-30516-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

I didn't see this patch merged into 4.0.1.

As without this patch, canceled fsid change process can't be recovered.

I totally understand that it's not good to merge a patch into the
already fully tested tree.
So would you please consider add this patch to next release(even 4.1 is OK)?

Thanks,
Qu

-------- Original Message  --------
Subject: [PATCH] btrfs-progs: Fix a bug which makes unfinished fsid 
change unrecoverable.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年05月15日 14:36

> This bug is found by making break point after change_fsid_prepare() and
> then kill the unfinished change, then try to restore the unfinished fsid
> change.
>
> If fsid change is canceled, open_ctree will still fail even with
> IGNORE_FSID_MIMATCH open ctree flag, since it can't find device with
> mismatched fsid, making it unable to restoring.
>
> Now add ignore_fsid_mismatch judgment in btrfs_find_device() to fix the
> bug and allow later restore to work as expected.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   volumes.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/volumes.c b/volumes.c
> index 14ce33e..f7462c5 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -1510,7 +1510,8 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
>   	cur_devices = root->fs_info->fs_devices;
>   	while (cur_devices) {
>   		if (!fsid ||
> -		    !memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
> +		    (!memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE) ||
> +		     root->fs_info->ignore_fsid_mismatch)) {
>   			device = __find_device(&cur_devices->devices,
>   					       devid, uuid);
>   			if (device)
>
