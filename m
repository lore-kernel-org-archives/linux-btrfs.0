Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab2KGUEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Nov 2012 15:04:12 -0500
Date: Thu, 08 Nov 2012 04:03:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: fs/btrfs/ioctl.c:3872:7: error: case label does not reduce to an
 integer constant
Message-ID: <509abe9b.i5HypmCoaxVnophU%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
head:   c1014be59ba93855c31fda9d9cf4319cc6f9eeb1
commit: dffe58193fa354392bc1f03d38b882f122cef85b Btrfs: add support for device replace ioctls
date:   10 hours ago
config: make ARCH=mips allyesconfig

All error/warnings:

fs/btrfs/ioctl.c: In function 'btrfs_ioctl':
fs/btrfs/ioctl.c:3872:7: error: case label does not reduce to an integer constant

vim +3872 fs/btrfs/ioctl.c

5d13a37b Arne Jansen       2011-09-14  3866  	case BTRFS_IOC_QGROUP_ASSIGN:
5d13a37b Arne Jansen       2011-09-14  3867  		return btrfs_ioctl_qgroup_assign(root, argp);
5d13a37b Arne Jansen       2011-09-14  3868  	case BTRFS_IOC_QGROUP_CREATE:
5d13a37b Arne Jansen       2011-09-14  3869  		return btrfs_ioctl_qgroup_create(root, argp);
5d13a37b Arne Jansen       2011-09-14  3870  	case BTRFS_IOC_QGROUP_LIMIT:
5d13a37b Arne Jansen       2011-09-14  3871  		return btrfs_ioctl_qgroup_limit(root, argp);
dffe5819 Stefan Behrens    2012-11-06 @3872  	case BTRFS_IOC_DEV_REPLACE:
dffe5819 Stefan Behrens    2012-11-06  3873  		return btrfs_ioctl_dev_replace(root, argp);
f46b5a66 Christoph Hellwig 2008-06-11  3874  	}
f46b5a66 Christoph Hellwig 2008-06-11  3875  

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
