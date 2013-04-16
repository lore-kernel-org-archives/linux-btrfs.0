Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:13723 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab3DPIpc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 04:45:32 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] Btrfs: quota rescan for 3.10
Date: Tue, 16 Apr 2013 10:45:17 +0200
Message-Id: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel side for rescan, which is needed if you want to enable qgroup
tracking on a non-empty volume. The first patch splits
btrfs_qgroup_account_ref into readable ans reusable units. The second
patch adds the rescan implementation (refer to its commit message for a
description of the algorithm). The third  patch starts an automatic
rescan when qgroups are enabled. It is only separated to potentially
help bisecting things in case of a problem.

The required user space patch was sent at 2013-04-05, subject "[PATCH]
Btrfs-progs: quota rescan".

--
Changes v1->v2:
- fix calculation of the "exclusive" field for qgroups in level != 0
- split btrfs_qgroup_account_ref
- take into account that mutex_unlock might schedule
- fix kzalloc error checking
- add some reserved ints to struct btrfs_ioctl_quota_rescan_args
- changed modification to unused #define BTRFS_QUOTA_CTL_RESCAN
- added missing (unsigned long long) casts for pr_debug
- more detailed commit messages

Jan Schmidt (3):
  Btrfs: split btrfs_qgroup_account_ref into four functions
  Btrfs: rescan for qgroups
  Btrfs: automatic rescan after "quota enable" command

 fs/btrfs/ctree.h           |   17 +-
 fs/btrfs/disk-io.c         |    6 +
 fs/btrfs/ioctl.c           |   83 ++++++--
 fs/btrfs/qgroup.c          |  517 +++++++++++++++++++++++++++++++++++---------
 include/uapi/linux/btrfs.h |   12 +-
 5 files changed, 509 insertions(+), 126 deletions(-)

