Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26869 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbaAEAk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 19:40:28 -0500
Message-ID: <52C8A9F7.6080701@fb.com>
Date: Sat, 4 Jan 2014 19:40:23 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: use WARN_ON_ONCE instead for btrfs_invalidate_inodes
References: <1388389874-29141-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388389874-29141-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/30/2013 02:51 AM, Liu Bo wrote:
> So after transaction is aborted, we need to cleanup inode resources by
> calling btrfs_invalidate_inodes(), and btrfs_invalidate_inodes() hopes
> roots' refs to be zero in old times and sets a WARN_ON(), however, this
> is not always true within cleaning up transaction, so WARN_ON_ONCE() is
> better, and we won't get another syslog message bomb.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index f1a7744..ef7f6af 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4761,7 +4761,7 @@ void btrfs_invalidate_inodes(struct btrfs_root *root)
>   	struct inode *inode;
>   	u64 objectid = 0;
>   
> -	WARN_ON(btrfs_root_refs(&root->root_item) != 0);
> +	WARN_ON_ONCE(btrfs_root_refs(&root->root_item) != 0);
>   
>   	spin_lock(&root->inode_lock);
>   again:

I'd rather just detect that we're cleaning up for an abort and not warn 
at all.  Thanks,

Josef
