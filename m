Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:49161 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754370AbdJIV3T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Oct 2017 17:29:19 -0400
From: Tejun Heo <tj@kernel.org>
To: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCHSET] cgroup, writeback, btrfs: make sure btrfs issues metadata IOs from the root cgroup
Date: Mon,  9 Oct 2017 14:29:08 -0700
Message-Id: <20171009212911.473208-1-tj@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

btrfs has different ways to issue metadata IOs and may end up issuing
metadata or otherwise shared IOs from a non-root cgroup, which can
lead to priority inversion and ineffective IO isolation.

This patchset makes sure that btrfs issues all metadata and shared IOs
from the root cgroup by exempting btree_inodes from cgroup writeback
and explicitly associating shared IOs with the root cgroup.

This patchset containst he following three patches

 [PATCH 1/3] cgroup, writeback: replace SB_I_CGROUPWB with per-inode
 [PATCH 2/3] cgroup, writeback: implement submit_bh_blkcg_css()
 [PATCH 3/3] btrfs: ensure that metadata and flush are issued from the

and is also available in the following git branch

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-btrfs-metadata

diffstat follows.  Thanks.

 fs/block_dev.c              |    3 +--
 fs/btrfs/check-integrity.c  |    2 +-
 fs/btrfs/disk-io.c          |    4 ++++
 fs/btrfs/ioctl.c            |    6 +++++-
 fs/btrfs/super.c            |    1 -
 fs/buffer.c                 |   12 ++++++++++++
 fs/ext2/inode.c             |    3 ++-
 fs/ext2/super.c             |    1 -
 fs/ext4/inode.c             |    5 ++++-
 fs/ext4/super.c             |    2 --
 fs/fs-writeback.c           |    1 +
 include/linux/backing-dev.h |    2 +-
 include/linux/buffer_head.h |   11 +++++++++++
 include/linux/fs.h          |    3 ++-
 include/linux/writeback.h   |    6 ++++--
 15 files changed, 48 insertions(+), 14 deletions(-)

--
tejun
