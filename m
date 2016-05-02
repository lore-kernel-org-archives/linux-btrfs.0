Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbcEBPO4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 11:14:56 -0400
Date: Mon, 2 May 2016 17:14:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2 RESEND] btrfs: pass the error code to the
 btrfs_std_error and log ret
Message-ID: <20160502151440.GJ29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457583735-3925-1-git-send-email-anand.jain@oracle.com>
 <20160316131019.GM21722@twin.jikos.cz>
 <57268BF5.7010408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57268BF5.7010408@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 07:06:29AM +0800, Anand Jain wrote:
> > It's just logging an error, but it should really fail, without a
> > message. The error code will tell what went wrong. Assigning existing
> > qgroups is eg. EEXIST, if either doesn't exist then ENOENT. There's a
> > FIXME a few lines above that should be addressed.
> >
> > I'd like to avoid the message in this case because it should be handled
> > by the ioctl caller, otherwise it could be just flooding the system log.
> >
> >> +
> >>   	/* update qgroup status and info */
> >>   	err = btrfs_run_qgroups(trans, root->fs_info);
> >>   	if (err < 0)
> >> -		btrfs_std_error(root->fs_info, ret,
> >> +		btrfs_std_error(root->fs_info, err,
> 
>   This patch is missing in the 'dev-del-by-id' branch. I agree with your
>   the above comments, however the key intention of this patch was to get
>   the correct parameter passed to the btrfs_std_error(). And the above
>   btrfs_err() log should still help/motivate to get the part you
>   mentioned corrected.

Committed as

    btrfs: pass the right error code to the btrfs_std_error

    Also drop the newline from the message.

    Signed-off-by: Anand Jain <anand.jain@oracle.com>
    Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 798f58e7338e..40c62e1a4a23 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4859,8 +4859,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
        /* update qgroup status and info */
        err = btrfs_run_qgroups(trans, root->fs_info);
        if (err < 0)
-               btrfs_std_error(root->fs_info, ret,
-                           "failed to update qgroup status and info\n");
+               btrfs_std_error(root->fs_info, err,
+                           "failed to update qgroup status and info");
        err = btrfs_end_transaction(trans, root);
        if (err && !ret)
                ret = err;
