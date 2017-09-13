Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51619 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751105AbdIMB2z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 21:28:55 -0400
Subject: Re: [PATCH] btrfs: prevent to set invalid default subvolid
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-btrfs@vger.kernel.org
References: <87mv60vxr7.wl-satoru.takeuchi@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ef1e2715-8da2-b7eb-f084-0d76a35b474d@gmx.com>
Date: Wed, 13 Sep 2017 09:28:48 +0800
MIME-Version: 1.0
In-Reply-To: <87mv60vxr7.wl-satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月12日 21:42, Satoru Takeuchi wrote:
> `btrfs sub set-default` succeeds to set an ID which isn't corresponding to any
> fs/file tree. If such the bad ID is set to a filesystem, we can't mount this
> filesystem without specifying `subvol` or `subvolid` mount options.
> 
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

I was a little worried about the handling of special treeid like RECLOC 
and DATA_RELOC, but is_fstree() called btrfs_qgroup_level() check so we 
don't need to worry about that.

Nice catch.

Thanks,
Qu
> -
>   fs/btrfs/ioctl.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ae8fbf9..8e1bc19 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4057,6 +4057,10 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
>   		ret = PTR_ERR(new_root);
>   		goto out;
>   	}
> +	if (!is_fstree(new_root->objectid)) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
>   
>   	path = btrfs_alloc_path();
>   	if (!path) {
> 
