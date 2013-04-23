Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:38689 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab3DWL1F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 07:27:05 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, dsterba@suse.cz
Subject: [PATCH v3 0/3] Btrfs: quota rescan for 3.10
Date: Tue, 23 Apr 2013 13:26:48 +0200
Message-Id: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net>
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
Changes v2->v3:
- rebased to btrfs-next
- stop rescan worker when quota is disabled
- check return value of ulist_add()
- initialize worker struct to zero

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
 fs/btrfs/disk-io.c         |    5 +
 fs/btrfs/ioctl.c           |   83 ++++++-
 fs/btrfs/qgroup.c          |  575 +++++++++++++++++++++++++++++++++++---------
 include/uapi/linux/btrfs.h |   12 +-
 5 files changed, 552 insertions(+), 140 deletions(-)

