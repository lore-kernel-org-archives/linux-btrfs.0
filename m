Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17713 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbbFKG3g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 02:29:36 -0400
Date: Thu, 11 Jun 2015 14:29:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>, Chris Mason <clm@fb.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [btrfs:integration-4.2 29/57] fs/btrfs/disk-io.c:2325:17-30:
 ERROR: reference preceded by free on line 2324
Message-ID: <20150611062918.GB9634@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <201506110750.oOHGNTQE%fengguang.wu@intel.com>
 <alpine.DEB.2.02.1506110800020.2014@localhost6.localdomain6>
 <20150611062319.GA9634@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150611062319.GA9634@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 02:23:20PM +0800, Liu Bo wrote:
> On Thu, Jun 11, 2015 at 08:07:09AM +0200, Julia Lawall wrote:
> > This does not look correct.  Please check.
> 
> Oops, thanks for pointing it out.
> 
> Sorry for my miss, here is the fix.
> 
> (Chris, if you prefer me to fold this into the original patch, I'll do
> it.)
> 
> Thanks,
> 
> -liubo
> 
> From de72ac1c6612441bd5e1a314a05c38d727e12121 Mon Sep 17 00:00:00 2001
> From: Liu Bo <bo.li.liu@oracle.com>
> Date: Thu, 11 Jun 2015 14:16:44 +0800
> Subject: [PATCH] Btrfs: fix use-after-free in btrfs_replay_log
> 
> @log_root_tree should be referenced after kfree.

Err... s/should/should not/g

Thanks,

-liubo

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7f83778..3e49d80 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2321,8 +2321,9 @@ static int btrfs_replay_log(struct btrfs_fs_info
> *fs_info,
>  			fs_info->generation + 1);
>  	if (IS_ERR(log_tree_root->node)) {
>  		printk(KERN_ERR "BTRFS: failed to read log tree\n");
> +		ret = PTR_ERR(log_tree_root->node);
>  		kfree(log_tree_root);
> -		return PTR_ERR(log_tree_root->node);
> +		return ret;
>  	} else if (!extent_buffer_uptodate(log_tree_root->node)) {
>  		printk(KERN_ERR "BTRFS: failed to read log tree\n");
>  		free_extent_buffer(log_tree_root->node);
> -- 
> 2.1.0
> 
> 
> 
> 
> 
> > 
> > julia
> > 
> > On Thu, 11 Jun 2015, kbuild test robot wrote:
> > 
> > > TO: Liu Bo <bo.li.liu@oracle.com>
> > > CC: "Chris Mason <chris.mason@fusionio.com> Chris Mason" <clm@fb.com>
> > > CC: David Sterba <dsterba@suse.cz>
> > > CC: linux-btrfs@vger.kernel.org
> > > 
> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git integration-4.2
> > > head:   9a4e7276d39071576d369e607d7accb84b41d0b4
> > > commit: 64c043de466d5746e7ca306dab9d418cd871cefc [29/57] Btrfs: fix up read_tree_block to return proper error
> > > :::::: branch date: 7 hours ago
> > > :::::: commit date: 8 days ago
> > > 
> > > >> fs/btrfs/disk-io.c:2325:17-30: ERROR: reference preceded by free on line 2324
> > > 
> > > git remote add btrfs git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> > > git remote update btrfs
> > > git checkout 64c043de466d5746e7ca306dab9d418cd871cefc
> > > vim +2325 fs/btrfs/disk-io.c
> > > 
> > > 63443bf5 Eric Sandeen 2014-08-01  2318  			BTRFS_TREE_LOG_OBJECTID);
> > > 63443bf5 Eric Sandeen 2014-08-01  2319  
> > > 63443bf5 Eric Sandeen 2014-08-01  2320  	log_tree_root->node = read_tree_block(tree_root, bytenr,
> > > 63443bf5 Eric Sandeen 2014-08-01  2321  			fs_info->generation + 1);
> > > 64c043de Liu Bo       2015-05-25  2322  	if (IS_ERR(log_tree_root->node)) {
> > > 64c043de Liu Bo       2015-05-25  2323  		printk(KERN_ERR "BTRFS: failed to read log tree\n");
> > > 64c043de Liu Bo       2015-05-25 @2324  		kfree(log_tree_root);
> > > 64c043de Liu Bo       2015-05-25 @2325  		return PTR_ERR(log_tree_root->node);
> > > 64c043de Liu Bo       2015-05-25  2326  	} else if (!extent_buffer_uptodate(log_tree_root->node)) {
> > > 63443bf5 Eric Sandeen 2014-08-01  2327  		printk(KERN_ERR "BTRFS: failed to read log tree\n");
> > > 63443bf5 Eric Sandeen 2014-08-01  2328  		free_extent_buffer(log_tree_root->node);
> > > 
> > > ---
> > > 0-DAY kernel test infrastructure                Open Source Technology Center
> > > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
