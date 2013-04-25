Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:33496 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440Ab3DYQFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 12:05:07 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, dsterba@suse.cz
Subject: [PATCH v4 0/3] Btrfs: quota rescan for 3.10
Date: Thu, 25 Apr 2013 18:04:49 +0200
Message-Id: <1366905892-7880-1-git-send-email-list.btrfs@jan-o-sch.net>
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
Changes v3->v4:
(the first two should have been in v2 but got lost along the way)
- take into account that mutex_unlock might schedule
- fix calculation of the "exclusive" field for qgroups in level != 0
- don't leak root ulist on ENOMEM from ulist add
- removed unnecessary spinlock from update_qgroup_status_item
- return -EINTR instread of EINTR from btrfs_qgroup_rescan_worker
- in btrfs_run_qgroups don't propagate error from btrfs_qgroup_rescan
- rebased to current version of btrfs-next

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
 fs/btrfs/qgroup.c          |  582 +++++++++++++++++++++++++++++++++++---------
 include/uapi/linux/btrfs.h |   12 +-
 5 files changed, 559 insertions(+), 140 deletions(-)

