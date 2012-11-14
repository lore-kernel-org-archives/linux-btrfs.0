Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45690 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161058Ab2KNQIB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 11:08:01 -0500
Date: Thu, 15 Nov 2012 00:07:44 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: fs/btrfs/volumes.c:1505:1: warning: label 'error_close' defined
 but not used
Message-ID: <50a3c1d0.Y+kHjlVEjfDqnUNo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
head:   0cb8658e96f1ba2ff2d730224cb31e231edd318d
commit: 7017ac470ed5b029bc683883714a7f4a4ed34c33 Btrfs: move some common code into a subfunction
date:   2 days ago
config: make ARCH=x86_64 allyesconfig

All warnings:

fs/btrfs/volumes.c: In function 'btrfs_rm_device':
fs/btrfs/volumes.c:1505:1: warning: label 'error_close' defined but not used [-Wunused-label]

vim +1505 +/error_close fs/btrfs/volumes.c

2b82032c Yan Zheng      2008-11-17  1489  	 * at this point, the device is zero sized.  We want to
2b82032c Yan Zheng      2008-11-17  1490  	 * remove it from the devices list and zero out the old super
2b82032c Yan Zheng      2008-11-17  1491  	 */
1f78160c Xiao Guangrong 2011-04-20  1492  	if (clear_super) {
dfe25020 Chris Mason    2008-05-13  1493  		/* make sure this device isn't detected as part of
dfe25020 Chris Mason    2008-05-13  1494  		 * the FS anymore
dfe25020 Chris Mason    2008-05-13  1495  		 */
dfe25020 Chris Mason    2008-05-13  1496  		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
dfe25020 Chris Mason    2008-05-13  1497  		set_buffer_dirty(bh);
dfe25020 Chris Mason    2008-05-13  1498  		sync_dirty_buffer(bh);
dfe25020 Chris Mason    2008-05-13  1499  	}
a061fc8d Chris Mason    2008-05-07  1500  
a061fc8d Chris Mason    2008-05-07  1501  	ret = 0;
a061fc8d Chris Mason    2008-05-07  1502  
a061fc8d Chris Mason    2008-05-07  1503  error_brelse:
a061fc8d Chris Mason    2008-05-07  1504  	brelse(bh);
a061fc8d Chris Mason    2008-05-07 @1505  error_close:
dfe25020 Chris Mason    2008-05-13  1506  	if (bdev)
e525fd89 Tejun Heo      2010-11-13  1507  		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
a061fc8d Chris Mason    2008-05-07  1508  out:
a061fc8d Chris Mason    2008-05-07  1509  	mutex_unlock(&uuid_mutex);
a061fc8d Chris Mason    2008-05-07  1510  	return ret;
9b3517e9 Ilya Dryomov   2011-02-15  1511  error_undo:
9b3517e9 Ilya Dryomov   2011-02-15  1512  	if (device->writeable) {
0c1daee0 Xiao Guangrong 2011-04-20  1513  		lock_chunks(root);

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
