Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:14164 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750775AbeD1SE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 14:04:57 -0400
Date: Sun, 29 Apr 2018 02:04:12 +0800
From: kbuild test robot <lkp@intel.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] btrfs: Unexport and rename btrfs_invalidate_inodes
Message-ID: <201804290153.kwHLp9AY%fengguang.wu@intel.com>
References: <1524828984-2797-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524828984-2797-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Nikolay,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20180424]
[cannot apply to v4.17-rc2 v4.17-rc1 v4.16 v4.17-rc2]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Nikolay-Borisov/btrfs-Unexport-and-rename-btrfs_invalidate_inodes/20180428-234332
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/btrfs/disk-io.c:4317:17: sparse: undefined identifier 'btrfs_invalidate_inodes'
   fs/btrfs/disk-io.c:295:27: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:295:27: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:2257:39: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:2257:39: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:2298:39: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:2298:39: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:2560:37: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:2788:31: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:3191:17: sparse: incompatible types in comparison expression (different address spaces)
   fs/btrfs/disk-io.c:3523:33: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:3523:33: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:3532:33: sparse: expression using sizeof(void)
   fs/btrfs/disk-io.c:3532:33: sparse: expression using sizeof(void)
>> fs/btrfs/disk-io.c:4317:40: sparse: call with no type!
   fs/btrfs/disk-io.c: In function 'btrfs_destroy_delalloc_inodes':
   fs/btrfs/disk-io.c:4317:3: error: implicit declaration of function 'btrfs_invalidate_inodes'; did you mean 'btrfs_update_inode'? [-Werror=implicit-function-declaration]
      btrfs_invalidate_inodes(btrfs_inode->root);
      ^~~~~~~~~~~~~~~~~~~~~~~
      btrfs_update_inode
   cc1: some warnings being treated as errors

vim +4317 fs/btrfs/disk-io.c

acce952b0 liubo        2011-01-06  4297  
143bede52 Jeff Mahoney 2012-03-01  4298  static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
acce952b0 liubo        2011-01-06  4299  {
acce952b0 liubo        2011-01-06  4300  	struct btrfs_inode *btrfs_inode;
acce952b0 liubo        2011-01-06  4301  	struct list_head splice;
acce952b0 liubo        2011-01-06  4302  
acce952b0 liubo        2011-01-06  4303  	INIT_LIST_HEAD(&splice);
acce952b0 liubo        2011-01-06  4304  
eb73c1b7c Miao Xie     2013-05-15  4305  	spin_lock(&root->delalloc_lock);
eb73c1b7c Miao Xie     2013-05-15  4306  	list_splice_init(&root->delalloc_inodes, &splice);
acce952b0 liubo        2011-01-06  4307  
acce952b0 liubo        2011-01-06  4308  	while (!list_empty(&splice)) {
eb73c1b7c Miao Xie     2013-05-15  4309  		btrfs_inode = list_first_entry(&splice, struct btrfs_inode,
acce952b0 liubo        2011-01-06  4310  					       delalloc_inodes);
acce952b0 liubo        2011-01-06  4311  
acce952b0 liubo        2011-01-06  4312  		list_del_init(&btrfs_inode->delalloc_inodes);
df0af1a57 Miao Xie     2013-01-29  4313  		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
df0af1a57 Miao Xie     2013-01-29  4314  			  &btrfs_inode->runtime_flags);
eb73c1b7c Miao Xie     2013-05-15  4315  		spin_unlock(&root->delalloc_lock);
acce952b0 liubo        2011-01-06  4316  
acce952b0 liubo        2011-01-06 @4317  		btrfs_invalidate_inodes(btrfs_inode->root);
b216cbfb5 Miao Xie     2013-05-15  4318  
eb73c1b7c Miao Xie     2013-05-15  4319  		spin_lock(&root->delalloc_lock);
acce952b0 liubo        2011-01-06  4320  	}
acce952b0 liubo        2011-01-06  4321  
eb73c1b7c Miao Xie     2013-05-15  4322  	spin_unlock(&root->delalloc_lock);
acce952b0 liubo        2011-01-06  4323  }
acce952b0 liubo        2011-01-06  4324  

:::::: The code at line 4317 was first introduced by commit
:::::: acce952b0263825da32cf10489413dec78053347 Btrfs: forced readonly mounts on errors

:::::: TO: liubo <liubo2009@cn.fujitsu.com>
:::::: CC: Chris Mason <chris.mason@oracle.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
