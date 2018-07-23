Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387831AbeGWQ2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 12:28:21 -0400
Date: Mon, 23 Jul 2018 17:26:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH resend 1/2] btrfs: allow defrag on a file opened ro that
 has rw permissions
Message-ID: <20180723152624.GO26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180717220357.hn7mvajicpy7hu3l@angband.pl>
 <20180717220900.3588-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180717220900.3588-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 12:08:59AM +0200, Adam Borowski wrote:
> Requiring a rw descriptor conflicts both ways with exec, returning ETXTBSY
> whenever you try to defrag a program that's currently being run, or
> causing intermittent exec failures on a live system being defragged.
> 
> As defrag doesn't change the file's contents in any way, there's no reason
> to consider it a rw operation.  Thus, let's check only whether the file
> could have been opened rw.  Such access control is still needed as
> currently defrag can use extra disk space, and might trigger bugs.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  fs/btrfs/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 43ecbe620dea..01c150b6ab62 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2941,7 +2941,8 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
>  		ret = btrfs_defrag_root(root);
>  		break;
>  	case S_IFREG:
> -		if (!(file->f_mode & FMODE_WRITE)) {
> +		if (!capable(CAP_SYS_ADMIN) &&
> +		    inode_permission(inode, MAY_WRITE)) {

The dedupe ioctl does the admin check or the FMODE_WRITE, which means
admin can dedupe anything but user has to have the file write open.
Doing the same for defrag should be ok for same reasons it is for
dedupe.

I'm not sure about using plain inode_permissions here, though it looks
correct and I'm not able to see inode vs file descriptor issues that
could cause trouble here. There are uid/gid, rws, acl, immutable,
capabilities, namespace aware checks, security hooks.

So, I'll add the patch to 4.19 queue. It's small and isolated change so
a revert would be easy in case we find something bad. The 2nd patch
should be IMHO part of this change as it's logical to return the error
code in the patch that modifies the user visible behaviour.
