Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2KFUvy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 15:51:54 -0500
Date: Wed, 07 Nov 2012 04:51:47 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [ablock84-btrfs:btrfs-far 20/20] fs/btrfs/send.c:1683:51: sparse: incorrect type in argument 5 (different base types)
Message-ID: <50997863.DxtbfvNUpe1vD8o/%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   git://github.com/ablock84/linux-btrfs.git btrfs-far
head:   f9a5bb450a8cc7aa5fd4f11d0306b3f48cf2771d
commit: f9a5bb450a8cc7aa5fd4f11d0306b3f48cf2771d [20/20] Btrfs: use libfarstream for btrfs send


sparse warnings:

+ fs/btrfs/send.c:1683:51: sparse: incorrect type in argument 5 (different base types)
fs/btrfs/send.c:1683:51:    expected unsigned long long [unsigned] [usertype] vol_gen
fs/btrfs/send.c:1683:51:    got restricted __le64 [usertype] ctransid
fs/btrfs/send.c:1693:61: sparse: incorrect type in argument 5 (different base types)
fs/btrfs/send.c:1693:61:    expected unsigned long long [unsigned] [usertype] vol_gen
fs/btrfs/send.c:1693:61:    got restricted __le64 [usertype] ctransid
+ fs/btrfs/send.c:3102:50: sparse: incorrect type in argument 2 (different address spaces)
fs/btrfs/send.c:3102:50:    expected char [noderef] <asn:1>*<noident>
fs/btrfs/send.c:3102:50:    got char *read_buf
fs/btrfs/send.c:4101:62: sparse: incorrect type in argument 5 (different base types)
fs/btrfs/send.c:4101:62:    expected unsigned long long [unsigned] [usertype] vol_gen
fs/btrfs/send.c:4101:62:    got restricted __le64 [usertype] ctransid
fs/btrfs/send.c:4132:51: sparse: incorrect type in argument 5 (different base types)
fs/btrfs/send.c:4132:51:    expected unsigned long long [unsigned] [usertype] vol_gen
fs/btrfs/send.c:4132:51:    got restricted __le64 [usertype] ctransid

vim +1683 fs/btrfs/send.c

31db9f7c Alexander Block 2012-07-25  1677  	read_extent_buffer(leaf, name, (unsigned long)(ref + 1), namelen);
31db9f7c Alexander Block 2012-07-25  1678  	btrfs_release_path(path);
31db9f7c Alexander Block 2012-07-25  1679  
f9a5bb45 Alexander Block 2012-11-06  1680  	vid = far_volume_identifier_create("btrfs", -1,
f9a5bb45 Alexander Block 2012-11-06  1681  			sctx->send_root->root_item.uuid,
f9a5bb45 Alexander Block 2012-11-06  1682  			BTRFS_UUID_SIZE,
f9a5bb45 Alexander Block 2012-11-06 @1683  			sctx->send_root->root_item.ctransid,
f9a5bb45 Alexander Block 2012-11-06  1684  			name, namelen);
f9a5bb45 Alexander Block 2012-11-06  1685  	if (!vid) {
f9a5bb45 Alexander Block 2012-11-06  1686  		ret = -ENOMEM;
f9a5bb45 Alexander Block 2012-11-06  1687  		goto out;
31db9f7c Alexander Block 2012-07-25  1688  	}
31db9f7c Alexander Block 2012-07-25  1689  	if (parent_root) {
f9a5bb45 Alexander Block 2012-11-06  1690  		parent_vid = far_volume_identifier_create("btrfs", -1,
f9a5bb45 Alexander Block 2012-11-06  1691  				sctx->parent_root->root_item.uuid,
f9a5bb45 Alexander Block 2012-11-06  1692  				BTRFS_UUID_SIZE,
f9a5bb45 Alexander Block 2012-11-06 @1693  				sctx->parent_root->root_item.ctransid,
f9a5bb45 Alexander Block 2012-11-06  1694  				"", -1);
f9a5bb45 Alexander Block 2012-11-06  1695  		if (!parent_vid) {
f9a5bb45 Alexander Block 2012-11-06  1696  			ret = -ENOMEM;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
