Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750893AbdGZRE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 13:04:57 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0E1CAE17
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 17:04:52 +0000 (UTC)
Date: Wed, 26 Jul 2017 19:03:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@susze.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Deprecate userspace transaction ioctls
Message-ID: <20170726170335.GI2866@twin.jikos.cz>
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

Compiler complains about the string

fs/btrfs/ioctl.c:5635:0: error: unterminated argument list invoking macro "btrfs_warn"

as it is trivial I'll fix it.


> +		   "(1 or 2 releases). If you have a valid use case please

So this patch will get released in 4.14, the last release that'll have
the ioctl is 4.16. I'll make that explicit in the message.

> +		   speak up on the mailing list");
> +	WARN_ON_ONCE(1);
> +
>  	ret = -EPERM;
>  	if (!capable(CAP_SYS_ADMIN))
>  		goto out;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
