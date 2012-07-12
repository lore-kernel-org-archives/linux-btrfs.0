Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:20046 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 00/15] Btrfs: subvolume quota groups (qgroups)
Date: Thu, 12 Jul 2012 11:43:32 +0200
Message-Id: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a new version of Arne's qgroup patches from last October. The
old patches didn't get the backref walking right, which is now based on
the tree modification log.

You can limit the space available to subvolumes or any group of
subvolumes. You can determine the amount of space that will get freed
when deleting a snapshot.

The initial scan is still missing, so expect negative counters when you
enable quotas on a non-empty volume and then delete stuff.

Arne's introduction and concept description can still be found at

	http://sensille.com/qgroups.pdf

You can pull these patches from my git repository

	git://git.jan-o-sch.net/btrfs-unstable qgroup

The user mode patches required were sent at October 11, 2011 by Arne,
subject "[PATCH v0] btrfs-progs: add qgroup commands".

I tried to include some fair benchmark results with this cover letter.
However, I tried several disk benchmarks from the phoronix test suite,
none of them resulted in any write throughput decrease. I will have to
create a more realistic setup on my own to benchmark the impact of
qgroups (suggestions welcome). For now, I just wanted to get that patch
set out :-)

Thanks,
-Jan

Arne Jansen (11):
  Btrfs: qgroup on-disk format
  Btrfs: add helper for tree enumeration
  Btrfs: check the root passed to btrfs_end_transaction
  Btrfs: added helper to create new trees
  Btrfs: qgroup state and initialization
  Btrfs: Test code to change the order of delayed-ref processing
  Btrfs: qgroup implementation and prototypes
  Btrfs: quota tree support and startup
  Btrfs: hooks to reserve qgroup space
  Btrfs: add qgroup ioctls
  Btrfs: add qgroup inheritance

Jan Schmidt (4):
  Btrfs: fix buffer leak in btrfs_next_old_leaf
  Btrfs: join tree mod log code with the code holding back delayed refs
  Btrfs: call the qgroup accounting functions
  Btrfs: hooks for qgroup to record delayed refs

 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/backref.c     |   30 +-
 fs/btrfs/backref.h     |    3 +-
 fs/btrfs/ctree.c       |  348 ++++++++----
 fs/btrfs/ctree.h       |  233 +++++++-
 fs/btrfs/delayed-ref.c |   56 +-
 fs/btrfs/delayed-ref.h |   62 +--
 fs/btrfs/disk-io.c     |  134 ++++-
 fs/btrfs/disk-io.h     |    6 +
 fs/btrfs/extent-tree.c |  119 ++++-
 fs/btrfs/ioctl.c       |  244 +++++++-
 fs/btrfs/ioctl.h       |   62 ++-
 fs/btrfs/qgroup.c      | 1571 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c |   57 ++-
 fs/btrfs/transaction.h |   11 +
 15 files changed, 2696 insertions(+), 242 deletions(-)
 create mode 100644 fs/btrfs/qgroup.c

-- 
1.7.3.4

