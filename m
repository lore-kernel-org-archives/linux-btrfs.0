Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbbIYKc0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 06:32:26 -0400
Date: Fri, 25 Sep 2015 12:31:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] Btrfs: consolidate btrfs_error() to btrfs_std_error()
Message-ID: <20150925103128.GC11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1443163381-12332-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443163381-12332-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2015 at 02:43:01PM +0800, Anand Jain wrote:
> btrfs_error() and btrfs_std_error() does the same thing
> and calls _btrfs_std_error(), so consolidate them together.
> And the main motivation is that btrfs_error() is closely
> named with btrfs_err(), one handles error action the other
> is to log the error, so don't closely name them.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Suggested-by: David Sterba <dsterba@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I guess we can live with the extra NULL argument, in some cases it does
not make sense to put a string there.

> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4852,7 +4852,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>  	/* update qgroup status and info */
>  	err = btrfs_run_qgroups(trans, root->fs_info);
>  	if (err < 0)
> -		btrfs_error(root->fs_info, ret,
> +		btrfs_std_error(root->fs_info, ret,

This looks like a bug, ret instead of err. The value of 'ret' is set by
add/del qgroup relation which might fail if the relations are there, but
we do not care. We're likely interested in the return code of
btrfs_run_qgroups, ie. err. Can you please send a new patch on top of this?

>  			    "failed to update qgroup status and info\n");
>  	err = btrfs_end_transaction(trans, root);
>  	if (err && !ret)
