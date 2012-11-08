Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:50421 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2KHLeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 06:34:21 -0500
Message-ID: <509B98B9.1020509@giantdisaster.de>
Date: Thu, 08 Nov 2012 12:34:17 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: fs/btrfs/dev-replace.c:486:17: sparse: incompatible types in
 comparison expression (different address spaces)
References: <20121108073541.GA30285@localhost>
In-Reply-To: <20121108073541.GA30285@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 8 Nov 2012 15:35:41 +0800, Fengguang Wu wrote:
> Hi Stefan,
> 
> FYI, there are new sparse warnings show up in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
> head:   c1014be59ba93855c31fda9d9cf4319cc6f9eeb1
> commit: d8e784f51e2e1d1c57f091fdb49456c4e7fb62d2 Btrfs: add a new source file with device replace code
> date:   21 hours ago
> 
> + fs/btrfs/dev-replace.c:486:17: sparse: incompatible types in comparison expression (different address spaces)
> + fs/btrfs/dev-replace.c:486:17: sparse: incompatible types in comparison expression (different address spaces)
> fs/btrfs/dev-replace.c:745:17: sparse: incompatible types in comparison expression (different address spaces)
> fs/btrfs/dev-replace.c:745:17: sparse: incompatible types in comparison expression (different address spaces)
> fs/btrfs/dev-replace.c:766:30: sparse: too many arguments for function btrfs_scrub_dev
> fs/btrfs/dev-replace.c:407:30: sparse: too many arguments for function btrfs_scrub_dev
> fs/btrfs/dev-replace.c: In function 'btrfs_init_dev_replace':
> fs/btrfs/dev-replace.c:141:8: error: 'BTRFS_DEV_REPLACE_DEVID' undeclared (first use in this function)
> fs/btrfs/dev-replace.c:141:8: note: each undeclared identifier is reported only once for each function it appears in
> fs/btrfs/dev-replace.c:168:23: error: 'struct btrfs_device' has no member named 'is_tgtdev_for_dev_replace'
> fs/btrfs/dev-replace.c:169:4: error: implicit declaration of function 'btrfs_init_dev_replace_tgtdev_for_resume' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_start':
> fs/btrfs/dev-replace.c:331:2: error: implicit declaration of function 'btrfs_init_dev_replace_tgtdev' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c:409:10: error: too many arguments to function 'btrfs_scrub_dev'
> In file included from fs/btrfs/dev-replace.c:30:0:
> fs/btrfs/ctree.h:3648:5: note: declared here
> fs/btrfs/dev-replace.c:422:3: error: implicit declaration of function 'btrfs_destroy_dev_replace_tgtdev' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_finishing':
> fs/btrfs/dev-replace.c:500:12: error: 'struct btrfs_device' has no member named 'is_tgtdev_for_dev_replace'
> fs/btrfs/dev-replace.c:502:22: error: 'BTRFS_DEV_REPLACE_DEVID' undeclared (first use in this function)
> fs/btrfs/dev-replace.c:516:2: error: implicit declaration of function 'btrfs_rm_dev_replace_srcdev' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c: In function 'btrfs_resume_dev_replace_async':
> fs/btrfs/dev-replace.c:726:2: error: 'struct btrfs_fs_info' has no member named 'mutually_exclusive_operation_running'
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_kthread':
> fs/btrfs/dev-replace.c:756:21: error: 'struct btrfs_fs_info' has no member named 'mutually_exclusive_operation_running'
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_continue_on_mount':
> fs/btrfs/dev-replace.c:769:10: error: too many arguments to function 'btrfs_scrub_dev'
> In file included from fs/btrfs/dev-replace.c:30:0:
> fs/btrfs/ctree.h:3648:5: note: declared here
> cc1: some warnings being treated as errors
> 
> vim +486 fs/btrfs/dev-replace.c
> 
> d8e784f5 Stefan Behrens 2012-11-05  470  	}
> d8e784f5 Stefan Behrens 2012-11-05  471  	ret = btrfs_commit_transaction(trans, root);
> d8e784f5 Stefan Behrens 2012-11-05  472  	WARN_ON(ret);
> d8e784f5 Stefan Behrens 2012-11-05  473  
> d8e784f5 Stefan Behrens 2012-11-05  474  	/* keep away write_all_supers() during the finishing procedure */
> d8e784f5 Stefan Behrens 2012-11-05  475  	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
> d8e784f5 Stefan Behrens 2012-11-05  476  	btrfs_dev_replace_lock(dev_replace);
> d8e784f5 Stefan Behrens 2012-11-05  477  	dev_replace->replace_state =
> d8e784f5 Stefan Behrens 2012-11-05  478  		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
> d8e784f5 Stefan Behrens 2012-11-05  479  			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
> d8e784f5 Stefan Behrens 2012-11-05  480  	dev_replace->tgtdev = NULL;
> d8e784f5 Stefan Behrens 2012-11-05  481  	dev_replace->srcdev = NULL;
> d8e784f5 Stefan Behrens 2012-11-05  482  	dev_replace->time_stopped = btrfs_get_seconds_since_1970();
> d8e784f5 Stefan Behrens 2012-11-05  483  	dev_replace->item_needs_writeback = 1;
> d8e784f5 Stefan Behrens 2012-11-05  484  
> d8e784f5 Stefan Behrens 2012-11-05  485  	if (scrub_ret) {
> d8e784f5 Stefan Behrens 2012-11-05 @486  		printk_in_rcu(KERN_ERR
> d8e784f5 Stefan Behrens 2012-11-05  487  			      "btrfs: btrfs_scrub_dev(%s, %llu, %s) failed %d\n",
> d8e784f5 Stefan Behrens 2012-11-05  488  			      rcu_str_deref(src_device->name),
> d8e784f5 Stefan Behrens 2012-11-05  489  			      src_device->devid,
> d8e784f5 Stefan Behrens 2012-11-05  490  			      rcu_str_deref(tgt_device->name), scrub_ret);
> d8e784f5 Stefan Behrens 2012-11-05  491  		btrfs_dev_replace_unlock(dev_replace);
> d8e784f5 Stefan Behrens 2012-11-05  492  		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
> d8e784f5 Stefan Behrens 2012-11-05  493  		if (tgt_device)
> d8e784f5 Stefan Behrens 2012-11-05  494  			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
> 

Hi Fengguang,

Assuming that your script performs a periodic git fetch and git reset,
and then starts compile runs on different architectures, the only
explanation that I have is that something went wrong with the git
operation in your script. It looks like some C source files have been
updated, but the header files are old. Some kind of inconsistency that
either a git reset --hard should fix, or rm -rf . and git clone to start
from the beginning.

Could you check it please?

And could you please point me to some documentation, how this (very
useful !) service from Intel is working?

