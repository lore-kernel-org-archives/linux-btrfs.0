Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21905 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbaGDOmH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 10:42:07 -0400
Message-ID: <53B6BD39.4010901@fb.com>
Date: Fri, 4 Jul 2014 10:42:01 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

We've queued up a few fixes in my for-linus branch, please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Anand Jain (7) commits (+68/-10):
    btrfs: fix null pointer dereference in btrfs_show_devname when name is null (+2/-0)
    btrfs: fix null pointer dereference in clone_fs_devices when name is null (+7/-5)
    btrfs: create sprout should rename fsid on the sysfs as well (+10/-0)
    btrfs: rename add_device_membership to btrfs_kobj_add_device (+2/-2)
    btrfs: dev replace should replace the sysfs entry (+5/-0)
    btrfs: dev delete should remove sysfs entry (+26/-0)
    btrfs: dev add should add its sysfs entry (+16/-3)

Filipe Manana (4) commits (+24/-20):
    Btrfs: fix use-after-free when cloning a trailing file hole (+9/-11)
    Btrfs: atomically set inode->i_flags in btrfs_update_iflags (+10/-7)
    Btrfs: assert send doesn't attempt to start transactions (+4/-2)
    Btrfs: fix crash when starting transaction (+1/-0)

Liu Bo (2) commits (+4/-6):
    Btrfs: fix crash when mounting raid5 btrfs with missing disks (+3/-2)
    Btrfs: fix race of using total_bytes_pinned (+1/-4)

Josef Bacik (2) commits (+7/-5):
    btrfs: only unlock block in verify_parent_transid if we locked it (+2/-1)
    Btrfs: fix btrfs_print_leaf for skinny metadata (+5/-4)

David Sterba (2) commits (+1/-6):
    btrfs: remove stale comment from btrfs_flush_all_pending_stuffs (+0/-5)
    btrfs: use E2BIG instead of EIO if compression does not help (+1/-1)

Eric Sandeen (1) commits (+2/-1):
    btrfs: fix nossd and ssd_spread mount option regression

Sergey Senozhatsky (1) commits (+1/-1):
    btrfs compression: reuse recently used workspace

Wang Shilong (1) commits (+4/-0):
    Btrfs: fix race between balance recovery and root deletion

Total: (20) commits

 fs/btrfs/compression.c     |  2 +-
 fs/btrfs/dev-replace.c     |  5 +++++
 fs/btrfs/disk-io.c         |  5 ++++-
 fs/btrfs/extent-tree.c     |  5 +----
 fs/btrfs/ioctl.c           | 37 +++++++++++++++++++------------------
 fs/btrfs/print-tree.c      |  9 +++++----
 fs/btrfs/raid56.c          |  5 +++--
 fs/btrfs/super.c           |  7 ++++++-
 fs/btrfs/sysfs.c           | 32 +++++++++++++++++++++++++++++---
 fs/btrfs/sysfs.h           |  4 ++++
 fs/btrfs/transaction.c     | 12 +++++-------
 fs/btrfs/volumes.c         | 30 +++++++++++++++++++++++++-----
 fs/btrfs/zlib.c            |  2 +-
 include/uapi/linux/btrfs.h |  1 +
 14 files changed, 109 insertions(+), 47 deletions(-)
