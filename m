Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab2IPCqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Sep 2012 22:46:18 -0400
Date: Sun, 16 Sep 2012 10:41:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:master 62/66] fs/btrfs/backref.c:1637:2: error:
 implicit declaration of function 'vfree'
Message-ID: <20120916024113.GA8335@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

FYI, kernel build failed on

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
head:   df147c57b7b79624c977ffc4c763018a5426e6d8
commit: b17d706f8458bd6a0f42d5de2f3b7dca26ea8029 [62/66] Btrfs: use vfree instead of kfree
config: s390-allmodconfig

All related error/warning messages:

fs/btrfs/backref.c: In function 'init_data_container':
fs/btrfs/backref.c:1586:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
fs/btrfs/backref.c:1586:7: warning: assignment makes pointer from integer without a cast [enabled by default]
fs/btrfs/backref.c: In function 'free_ipath':
fs/btrfs/backref.c:1637:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

vim +1637 fs/btrfs/backref.c
  1632	
  1633	void free_ipath(struct inode_fs_paths *ipath)
  1634	{
  1635		if (!ipath)
  1636			return;
> 1637		vfree(ipath->fspath);
  1638		kfree(ipath);
  1639	}

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu, Yuanhan Liu                              Intel Corporation
