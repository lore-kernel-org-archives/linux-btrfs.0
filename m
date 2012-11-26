Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24839 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2KZIjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:39:06 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ8d2KG006406
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 16:39:03 +0800
Message-ID: <50B32ABF.7040803@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:39:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/9] random fix for btrfs_ioctl()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes some bugs of btrfs_ioctl(). Most of them (0004-0009) is
relative to write access permission.

In these patches, the last patch(0009) modified the original process of the device
insertion，and made it follow the rule of the read-only filesystem. It might be
issuable, so mark it RFC.

We can pull this patchset from the URL

	git://github.com/miaoxie/linux-btrfs.git readonly

Thanks
Miao
---
Miao Xie (9):
  Btrfs: pass root object into btrfs_ioctl_{start, wait}_sync()
  Btrfs: don't start a new transaction when starting sync
  Btrfs: fix wrong return value of btrfs_wait_for_commit()
  Btrfs: get write access when setting the default subvolume
  Btrfs: get write access when doing resize fs
  Btrfs: get write access when removing a device
  Btrfs: get write access for scrub
  Btrfs: get write access for qgroup operations
  Btrfs: get write access for adding device (RFC PATCH)

 fs/btrfs/ioctl.c       | 260 ++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/super.c       |   5 +-
 fs/btrfs/transaction.c |  28 +++---
 fs/btrfs/volumes.c     |  26 ++---
 fs/btrfs/volumes.h     |   3 +-
 5 files changed, 219 insertions(+), 103 deletions(-)

-- 
1.7.11.7
