Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751823AbdGZROF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 13:14:05 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F4A5AE17
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 17:14:04 +0000 (UTC)
Date: Wed, 26 Jul 2017 19:12:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@susze.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Deprecate userspace transaction ioctls
Message-ID: <20170726171247.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170725154623.GB2866@suse.cz>
 <1501057588-7542-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501057588-7542-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 26, 2017 at 11:26:28AM +0300, Nikolay Borisov wrote:
> Userspace transactions were introduced in commit
> 6bf13c0cc833 ("Btrfs: transaction ioctls") to provide semantics that Ceph's
> object store required. However, things have changed significantly since then,
> to the point where btrfs is no longer suitable as a backend for ceph and in fact
> it's actively advised against such usages. Considering this, there doesn't
> seem to be a widespread, legit use case of userspace transaction. They also
> clutter the file->private pointer.
> 
> So to end the agony let's nuke the userspace transaction ioctls. As a first
> step let's give time for people to voice their objection by just WARN()ining
> when the userspace transaction is used.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index fa1b78cf25f6..10d78d71df96 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4000,6 +4000,12 @@ static long btrfs_ioctl_trans_start(struct file *file)
>  	struct btrfs_trans_handle *trans;
>  	int ret;
>  
> +	btrfs_warn(fs_info, "Userspace transaction mechanism is considered
> +		   deprecated and slated to be removed in the near future "
> +		   "(1 or 2 releases). If you have a valid use case please
> +		   speak up on the mailing list");
> +	WARN_ON_ONCE(1);
> +
>  	ret = -EPERM;
>  	if (!capable(CAP_SYS_ADMIN))
>  		goto out;

The warning must go after the permission checks and warn really just only once,
so we need to keep the local state anyway.

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3967,17 +3967,22 @@ static long btrfs_ioctl_trans_start(struct file *file)
        struct btrfs_root *root = BTRFS_I(inode)->root;
        struct btrfs_trans_handle *trans;
        int ret;
-
-       btrfs_warn(fs_info, "Userspace transaction mechanism is considered
-                  deprecated and slated to be removed in the near future "
-                  "(1 or 2 releases). If you have a valid use case please
-                  speak up on the mailing list");
-       WARN_ON_ONCE(1);
+       static bool warned = false;

        ret = -EPERM;
        if (!capable(CAP_SYS_ADMIN))
                goto out;

+       if (!warned) {
+               btrfs_warn(fs_info,
+                       "Userspace transaction mechanism is considered "
+                       "deprecated and slated to be removed in 4.17. "
+                       "If you have a valid use case please "
+                       "speak up on the mailing list");
+               WARN_ON(1);
+               warned = true;
+       }
+
        ret = -EINPROGRESS;
        if (file->private_data)
                goto out;
