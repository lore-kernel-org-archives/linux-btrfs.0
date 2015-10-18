Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53049 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbbJRLlk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 07:41:40 -0400
Subject: Re: [PATCH] Btrfs-progs: fix btrfs-convert rollback to check
 ROOT_BACKREF
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1445147081-13511-1-git-send-email-bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56238567.7060201@gmx.com>
Date: Sun, 18 Oct 2015 19:41:27 +0800
MIME-Version: 1.0
In-Reply-To: <1445147081-13511-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年10月18日 13:44, Liu Bo 写道:
> Btrfs has changed to delete subvolume/snapshot asynchronously, which means that
> after umount itself, if we've already deleted 'ext2_saved', rollback can still
> be completed.
>
> So this adds a check for ROOT_BACKREF before checking ROOT_ITEM since
> ROOT_BACKREF is immediately not in the btree after ioctl(BTRFS_IOC_SNAP_DESTROY)
> returns.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Looks good to me.

Although the error message for ret > 0 case can be improved a little, like:
"unable to find convert image subvolume, maybe it's already deleted?\n".


BTW, would you please submit a test case for fstests? It won't be a hard 
one though.

Thanks,
Qu

> ---
>   btrfs-convert.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index 802930c..f8a6c16 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -2591,6 +2591,22 @@ static int do_rollback(const char *devname)
>   	btrfs_init_path(&path);
>
>   	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
> +	key.type = BTRFS_ROOT_BACKREF_KEY;
> +	key.offset = BTRFS_FS_TREE_OBJECTID;
> +	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path, 0,
> +				0);
> +	btrfs_release_path(&path);
> +	if (ret > 0) {
> +		fprintf(stderr, "unable to open subvol %llu\n",
> +			(unsigned long long)key.objectid);
> +		goto fail;
> +	} else if (ret < 0) {
> +		fprintf(stderr, "unable to open subvol %llu ret %d\n",
> +			(unsigned long long)key.objectid, ret);
> +		goto fail;
> +	}
> +
> +	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
>   	key.type = BTRFS_ROOT_ITEM_KEY;
>   	key.offset = (u64)-1;
>   	image_root = btrfs_read_fs_root(root->fs_info, &key);
>
