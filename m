Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:60779
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbbFKGHS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 02:07:18 -0400
Date: Thu, 11 Jun 2015 08:07:09 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: kbuild test robot <fengguang.wu@intel.com>, Liu Bo <bo.li.liu@oracle.com>
cc: kbuild@01.org, clm@fb.com, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [btrfs:integration-4.2 29/57] fs/btrfs/disk-io.c:2325:17-30:
 ERROR: reference preceded by free on line 2324
In-Reply-To: <201506110750.oOHGNTQE%fengguang.wu@intel.com>
Message-ID: <alpine.DEB.2.02.1506110800020.2014@localhost6.localdomain6>
References: <201506110750.oOHGNTQE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This does not look correct.  Please check.

julia

On Thu, 11 Jun 2015, kbuild test robot wrote:

> TO: Liu Bo <bo.li.liu@oracle.com>
> CC: "Chris Mason <chris.mason@fusionio.com> Chris Mason" <clm@fb.com>
> CC: David Sterba <dsterba@suse.cz>
> CC: linux-btrfs@vger.kernel.org
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git integration-4.2
> head:   9a4e7276d39071576d369e607d7accb84b41d0b4
> commit: 64c043de466d5746e7ca306dab9d418cd871cefc [29/57] Btrfs: fix up read_tree_block to return proper error
> :::::: branch date: 7 hours ago
> :::::: commit date: 8 days ago
> 
> >> fs/btrfs/disk-io.c:2325:17-30: ERROR: reference preceded by free on line 2324
> 
> git remote add btrfs git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> git remote update btrfs
> git checkout 64c043de466d5746e7ca306dab9d418cd871cefc
> vim +2325 fs/btrfs/disk-io.c
> 
> 63443bf5 Eric Sandeen 2014-08-01  2318  			BTRFS_TREE_LOG_OBJECTID);
> 63443bf5 Eric Sandeen 2014-08-01  2319  
> 63443bf5 Eric Sandeen 2014-08-01  2320  	log_tree_root->node = read_tree_block(tree_root, bytenr,
> 63443bf5 Eric Sandeen 2014-08-01  2321  			fs_info->generation + 1);
> 64c043de Liu Bo       2015-05-25  2322  	if (IS_ERR(log_tree_root->node)) {
> 64c043de Liu Bo       2015-05-25  2323  		printk(KERN_ERR "BTRFS: failed to read log tree\n");
> 64c043de Liu Bo       2015-05-25 @2324  		kfree(log_tree_root);
> 64c043de Liu Bo       2015-05-25 @2325  		return PTR_ERR(log_tree_root->node);
> 64c043de Liu Bo       2015-05-25  2326  	} else if (!extent_buffer_uptodate(log_tree_root->node)) {
> 63443bf5 Eric Sandeen 2014-08-01  2327  		printk(KERN_ERR "BTRFS: failed to read log tree\n");
> 63443bf5 Eric Sandeen 2014-08-01  2328  		free_extent_buffer(log_tree_root->node);
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
