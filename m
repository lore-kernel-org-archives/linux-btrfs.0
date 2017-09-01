Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:2028 "EHLO
        mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750910AbdIAFwE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 01:52:04 -0400
Date: Fri, 1 Sep 2017 07:52:02 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Josef Bacik <jbacik@fb.com>
cc: linux-btrfs@vger.kernel.org, kbuild-all@01.org
Subject: [josef-btrfs:btrfs-readdir 4/5] fs/btrfs/ref-verify.c:322:12-14:
 ERROR: reference preceded by free on line 321 (fwd)
Message-ID: <alpine.DEB.2.20.1709010749590.2199@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It does not look correct to access &be->node on line 322 after freeing be
on line 321.

julia

---------- Forwarded message ----------
Date: Fri, 1 Sep 2017 07:41:26 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [josef-btrfs:btrfs-readdir 4/5] fs/btrfs/ref-verify.c:322:12-14: ERROR:
     reference preceded by free on line 321

CC: kbuild-all@01.org
CC: linux-btrfs@vger.kernel.org
TO: Josef Bacik <jbacik@fb.com>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git btrfs-readdir
head:   707c82dec33ba199538c4b20885873c32c0c4259
commit: b5bfaee4fb7028e8ac44e1feab4d99b917b876d7 [4/5] Btrfs: add a extent ref verify tool
:::::: branch date: 5 hours ago
:::::: commit date: 8 hours ago

>> fs/btrfs/ref-verify.c:322:12-14: ERROR: reference preceded by free on line 321

# https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git/commit/?id=b5bfaee4fb7028e8ac44e1feab4d99b917b876d7
git remote add josef-btrfs https://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
git remote update josef-btrfs
git checkout b5bfaee4fb7028e8ac44e1feab4d99b917b876d7
vim +322 fs/btrfs/ref-verify.c

b5bfaee4 Josef Bacik 2014-05-09  284
b5bfaee4 Josef Bacik 2014-05-09  285  static struct block_entry *add_block_entry(struct btrfs_root *root, u64 bytenr,
b5bfaee4 Josef Bacik 2014-05-09  286  					   u64 len, u64 root_objectid)
b5bfaee4 Josef Bacik 2014-05-09  287  {
b5bfaee4 Josef Bacik 2014-05-09  288  	struct btrfs_fs_info *fs_info = root->fs_info;
b5bfaee4 Josef Bacik 2014-05-09  289  	struct block_entry *be = NULL, *exist;
b5bfaee4 Josef Bacik 2014-05-09  290  	struct root_entry *re = NULL;
b5bfaee4 Josef Bacik 2014-05-09  291
b5bfaee4 Josef Bacik 2014-05-09  292  	re = kmalloc(sizeof(struct root_entry), GFP_NOFS);
b5bfaee4 Josef Bacik 2014-05-09  293  	be = kmalloc(sizeof(struct block_entry), GFP_NOFS);
b5bfaee4 Josef Bacik 2014-05-09  294  	if (!be || !re) {
b5bfaee4 Josef Bacik 2014-05-09  295  		kfree(re);
b5bfaee4 Josef Bacik 2014-05-09  296  		kfree(be);
b5bfaee4 Josef Bacik 2014-05-09  297  		return ERR_PTR(-ENOMEM);
b5bfaee4 Josef Bacik 2014-05-09  298  	}
b5bfaee4 Josef Bacik 2014-05-09  299  	be->bytenr = bytenr;
b5bfaee4 Josef Bacik 2014-05-09  300  	be->len = len;
b5bfaee4 Josef Bacik 2014-05-09  301
b5bfaee4 Josef Bacik 2014-05-09  302  	re->root_objectid = root_objectid;
b5bfaee4 Josef Bacik 2014-05-09  303  	re->num_refs = 0;
b5bfaee4 Josef Bacik 2014-05-09  304
b5bfaee4 Josef Bacik 2014-05-09  305  	spin_lock(&fs_info->ref_verify_lock);
b5bfaee4 Josef Bacik 2014-05-09  306  	exist = insert_block_entry(&fs_info->block_tree, be);
b5bfaee4 Josef Bacik 2014-05-09  307  	if (exist) {
b5bfaee4 Josef Bacik 2014-05-09  308  		update_block_entry(root, exist, re);
b5bfaee4 Josef Bacik 2014-05-09  309  		kfree(be);
b5bfaee4 Josef Bacik 2014-05-09  310  		be = exist;
b5bfaee4 Josef Bacik 2014-05-09  311  		goto out;
b5bfaee4 Josef Bacik 2014-05-09  312  	}
b5bfaee4 Josef Bacik 2014-05-09  313
b5bfaee4 Josef Bacik 2014-05-09  314  	be->num_refs = 1;
b5bfaee4 Josef Bacik 2014-05-09  315  	be->metadata = 0;
b5bfaee4 Josef Bacik 2014-05-09  316  	be->roots = RB_ROOT;
b5bfaee4 Josef Bacik 2014-05-09  317  	be->refs = RB_ROOT;
b5bfaee4 Josef Bacik 2014-05-09  318  	INIT_LIST_HEAD(&be->actions);
b5bfaee4 Josef Bacik 2014-05-09  319  	if (insert_root_entry(&be->roots, re)) {
b5bfaee4 Josef Bacik 2014-05-09  320  		kfree(re);
b5bfaee4 Josef Bacik 2014-05-09 @321  		kfree(be);
b5bfaee4 Josef Bacik 2014-05-09 @322  		rb_erase(&be->node, &fs_info->block_tree);
b5bfaee4 Josef Bacik 2014-05-09  323  		be = ERR_PTR(-EINVAL);
b5bfaee4 Josef Bacik 2014-05-09  324  		ASSERT(0);
b5bfaee4 Josef Bacik 2014-05-09  325  	}
b5bfaee4 Josef Bacik 2014-05-09  326  out:
b5bfaee4 Josef Bacik 2014-05-09  327  	spin_unlock(&fs_info->ref_verify_lock);
b5bfaee4 Josef Bacik 2014-05-09  328  	return be;
b5bfaee4 Josef Bacik 2014-05-09  329  }
b5bfaee4 Josef Bacik 2014-05-09  330

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
