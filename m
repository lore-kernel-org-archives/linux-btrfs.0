Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49440 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbaA1Pp5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 10:45:57 -0500
Message-ID: <52E7D0AF.4090603@fb.com>
Date: Tue, 28 Jan 2014 10:45:51 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Kusanagi Kouichi <slash@ac.auone-net.jp>, <linux-btrfs@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Return EXDEV for cross file system snapshot
References: <52cd2c7c00011d8a00004f4e0000743e400004e23b8c@amlmta033.auone-net.jp>
In-Reply-To: <52cd2c7c00011d8a00004f4e0000743e400004e23b8c@amlmta033.auone-net.jp>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/08/2014 05:46 AM, Kusanagi Kouichi wrote:
> EXDEV seems an appropriate error if an operation fails bacause it
> crosses file system boundaries.
>
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
> ---
>   fs/btrfs/ioctl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 21da576..15d35cb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1544,7 +1544,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
>   		if (src_inode->i_sb != file_inode(file)->i_sb) {
>   			printk(KERN_INFO "btrfs: Snapshot src from "
>   			       "another FS\n");
> -			ret = -EINVAL;
> +			ret = -EXDEV;
>   		} else {
>   			ret = btrfs_mksubvol(&file->f_path, name, namelen,
>   					     BTRFS_I(src_inode)->root,
Doesn't apply cleanly to btrfs-next, please rebase and try again. Thanks,

Josef
