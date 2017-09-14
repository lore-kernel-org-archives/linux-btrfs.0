Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55777 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbdINBz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 21:55:59 -0400
Subject: Re: [PATCH] Btrfs: do not backup tree roots when fsync
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170913182521.31304-1-bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a89cb387-732a-199e-5589-828c7e68b2a3@gmx.com>
Date: Thu, 14 Sep 2017 09:55:48 +0800
MIME-Version: 1.0
In-Reply-To: <20170913182521.31304-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月14日 02:25, Liu Bo wrote:
> It doens't make sense to backup tree roots when doing fsync, since
> during fsync those tree roots have not been consistent on disk.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

With a pit can be improved.
> ---
>   fs/btrfs/disk-io.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 79ac228..a145a88 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3668,7 +3668,14 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>   	u64 flags;
>   
>   	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
> -	backup_super_roots(fs_info);
> +
> +	/*
> +	 * max_mirrors == 0 indicates we're from commit_transaction,
> +	 * not from fsync where the tree roots in fs_info have not
> +	 * been consistent on disk.
> +	 */
> +	if (max_mirrors == 0)
> +		backup_super_roots(fs_info);

BTW, the @max_mirrors naming here is really confusing.
Normally I would expect max_mirrors == 0 means we don't need to backup 
super roots...

And since there are only two callers it won't be a big thing to change.

Thanks,
Qu
>   
>   	sb = fs_info->super_for_commit;
>   	dev_item = &sb->dev_item;
> 
