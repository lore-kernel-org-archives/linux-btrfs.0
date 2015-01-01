Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:32856 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbAAW7Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jan 2015 17:59:16 -0500
Date: Thu, 1 Jan 2015 14:58:47 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't delay inode ref updates during log replay
Message-ID: <20150101225847.GJ17254@merlins.org>
References: <20141228192614.GO17254@merlins.org>
 <20141229010047.7f9b6d43@natsu>
 <54A1FAB2.2050805@cn.fujitsu.com>
 <20141231183013.GA3637@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141231183013.GA3637@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris, you rule, I applied this to 3.16.7 and my problem went away.

Tested-By: Marc MERLIN <marc@merlins.org>

Happy new year! :)

Marc

On Wed, Dec 31, 2014 at 01:30:13PM -0500, Chris Mason wrote:
> Commit 1d52c78afbb (Btrfs: try not to ENOSPC on log replay) added a
> check to skip delayed inode updates during log replay because it
> confuses the enospc code.  But the delayed processing will end up
> skipping delayed refs from log replay because the inode itself wasn't
> put through the delayed code.
> 
> This can end up triggering a warning at commit time:
> 
> WARNING: CPU: 2 PID: 778 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empty+0x32/0x34()
> 
> Which is repeated for each commit because we never process the delayed ref.
> 
> The fix used here is to change btrfs_delayed_delete_inode_ref to return
> an error if we're current in log replay.  The caller will do the ref
> deletion immediately and everything will work properly.
> 
> This bug can cause lost files, whick fsck will find.  --repair on
> btrfs-progs 3.18 will fix them
> 
> Signed-off-by: Chris Mason <clm@fb.com>
> cc: stable@vger.kernel.org # v3.18 and any stable series that picked 1d52c78afbbf80b58299e076a159617d6b42fe3c
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 054577b..de4e70f 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1857,6 +1857,14 @@ int btrfs_delayed_delete_inode_ref(struct inode *inode)
>  {
>  	struct btrfs_delayed_node *delayed_node;
>  
> +	/*
> +	 * we don't do delayed inode updates during log recovery because it
> +	 * leads to enospc problems.  This means we also can't do
> +	 * delayed inode refs
> +	 */
> +	if (BTRFS_I(inode)->root->fs_info->log_root_recovering)
> +		return -EAGAIN;
> +
>  	delayed_node = btrfs_get_or_create_delayed_node(inode);
>  	if (IS_ERR(delayed_node))
>  		return PTR_ERR(delayed_node);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
