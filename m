Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61904 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbaBPNK2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 08:10:28 -0500
Message-ID: <5300B95F.3040306@fb.com>
Date: Sun, 16 Feb 2014 08:13:03 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have a small collection of fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The big thing that stands out is a revert of a new ioctl.  Users haven't
shipped yet in btrfs-progs, and Dave Sterba found a better way to export
the information.

Anand Jain (1) commits (+8/-2):
    btrfs: fix null pointer deference at btrfs_sysfs_add_one+0x105

Liu Bo (1) commits (+0/-1):
    Btrfs: fix a lockdep warning when cleaning up aborted transaction

Filipe David Borba Manana (1) commits (+10/-0):
    Btrfs: use right clone root offset for compressed extents

Mitch Harder (1) commits (+1/-1):
    Btrfs: fix max_inline mount option

Chris Mason (1) commits (+0/-17):
    Revert "btrfs: add ioctl to export size of global metadata reservation"

Josef Bacik (1) commits (+9/-2):
    Btrfs: unset DCACHE_DISCONNECTED when mounting default subvol

Total: (6) commits (+28/-23)

 fs/btrfs/disk-io.c         |  1 -
 fs/btrfs/inode.c           |  2 +-
 fs/btrfs/ioctl.c           | 16 ----------------
 fs/btrfs/send.c            | 10 ++++++++++
 fs/btrfs/super.c           | 11 +++++++++--
 fs/btrfs/sysfs.c           | 10 ++++++++--
 include/uapi/linux/btrfs.h |  1 -
 7 files changed, 28 insertions(+), 23 deletions(-)
