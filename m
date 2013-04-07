Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65050 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab3DGKuu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 06:50:50 -0400
Received: by mail-pa0-f51.google.com with SMTP id jh10so2751726pab.38
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 03:50:50 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH V3 0/5] introduce a mutex lock and fix missing checks
Date: Sun,  7 Apr 2013 18:50:15 +0800
Message-Id: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset introduces a mutex lock 'qgroup_ioctl_lock'
to protect all the user change for quota operations.

Without an extra lock, race condition can not be avoided
between operations in disk and in memory.

Holding mutex lock, we can fix missing check before creating
a qgroup(whether 'src' and 'dst' exist).And we can guarantee
that all the qgroups in 'inherit' dose exist before tracking
qgroup.

V2->V3:
	rename 'quota_lock' to 'qgroup_ioctl_lock' and holding
	'qgroup_ioctl_lock' inside qgroup.c to avoid serializing
	operations.
V1->V2:
	use quota configurations in memory to speed up checks.

Wang Shilong (5):
  Btrfs: introduce a mutex lock for btrfs quota operations
  Btrfs: remove some unnecessary spin_lock usages
  Btrfs: fix missing check before creating a qgroup relation
  Btrfs: fix missing check in the btrfs_qgroup_inherit()
  Btrfs: fix a warning when updating qgroup limit

 fs/btrfs/ctree.h   |   3 ++
 fs/btrfs/disk-io.c |   1 +
 fs/btrfs/qgroup.c  | 136 ++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 92 insertions(+), 48 deletions(-)

-- 
1.7.11.7

