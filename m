Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50341 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAVGQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 01:16:27 -0500
Received: by mail-pd0-f169.google.com with SMTP id g10so21442405pdj.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2015 22:16:26 -0800 (PST)
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3/3] btrfs: qgroup: destroy related qgroup when removing subvolume if needed.
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1421905582-4539-3-git-send-email-yangds.fnst@cn.fujitsu.com>
Date: Thu, 22 Jan 2015 14:16:20 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <88493A06-4B75-4802-9CF9-B98EF13BE160@gmail.com>
References: <1421905582-4539-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1421905582-4539-3-git-send-email-yangds.fnst@cn.fujitsu.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> 
> When removing a subvol, if the related qgroup has no child qgroup, we should destroy
> it at the same time. Also remove the TODO entry in qgroup.c.

My two cents here:

Take a quick look at this, i am not sure whether this is right way to do it.

Actually, i think we can only remove a subvolume qgroup safely when both refer and excl are 0,
because for subvolume removal case, to make qgroup accounting right, we need walk tree.

At this time, qgroup walking might have not finished, if we remove this qgroup directly,
accounting for this qgroup will be skipped.

Maybe we could remove such qgroup when at qgroup accounting, we find an qgroup¡¯s refer and excl
are 0, we could remove it, or we do it at the background..

Also, there is another risk, that is to say, if qgroup accounting not work right, So
we might need gurantee that subvolume it going to be deleted or have been deleted at the same time,
then we could remove qgroup safely etc.


> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
> fs/btrfs/inode.c  | 4 ++++
> fs/btrfs/qgroup.c | 1 -
> 2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e687bb0..31de211 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -59,6 +59,7 @@
> #include "backref.h"
> #include "hash.h"
> #include "props.h"
> +#include "qgroup.h"
> 
> struct btrfs_iget_args {
> 	struct btrfs_key *location;
> @@ -4029,6 +4030,9 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
> 	ret = btrfs_update_inode_fallback(trans, root, dir);
> 	if (ret)
> 		btrfs_abort_transaction(trans, root, ret);
> +	ret = btrfs_remove_qgroup(trans, root->fs_info, objectid);
> +	if (ret == -EBUSY)
> +		ret = 0;
> out:
> 	btrfs_free_path(path);
> 	return ret;
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c3b1e4f..303c078 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -35,7 +35,6 @@
> #include "qgroup.h"
> 
> /* TODO XXX FIXME
> - *  - subvol delete -> delete when ref goes to 0? delete limits also?
>  *  - reorganize keys
>  *  - compressed
>  *  - sync
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

