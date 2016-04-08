Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44787 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932818AbcDHUnk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Apr 2016 16:43:40 -0400
Date: Fri, 8 Apr 2016 16:43:33 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160408204333.dr42xpen7abw4z6g@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

We have some fixes queued up in my for-linus-4.6 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.6

These are bug fixes, including a really old fsync bug, and a few
trace points to help us track down problems in the quota code.

Mark Fasheh (2) commits (+129/-23):
    btrfs: handle non-fatal errors in btrfs_qgroup_inherit() (+32/-22)
    btrfs: Add qgroup tracing (+97/-1)

Filipe Manana (1) commits (+137/-0):
    Btrfs: fix file/data loss caused by fsync after rename and new inode

Liu Bo (1) commits (+1/-0):
    Btrfs: fix invalid reference in replace_path

Yauhen Kharuzhy (1) commits (+2/-0):
    btrfs: Reset IO error counters before start of device replacing

Qu Wenruo (1) commits (+19/-2):
    btrfs: Output more info for enospc_debug mount option

Davide Italiano (1) commits (+6/-3):
    Btrfs: Improve FL_KEEP_SIZE handling in fallocate

Josef Bacik (1) commits (+1/-1):
    Btrfs: don't use src fd for printk

David Sterba (1) commits (+8/-4):
    btrfs: fallback to vmalloc in btrfs_compare_tree

Total: (9) commits (+303/-33)

 fs/btrfs/ctree.c             |  12 ++--
 fs/btrfs/dev-replace.c       |   2 +
 fs/btrfs/extent-tree.c       |  21 ++++++-
 fs/btrfs/file.c              |   9 ++-
 fs/btrfs/ioctl.c             |   2 +-
 fs/btrfs/qgroup.c            |  63 +++++++++++++-------
 fs/btrfs/relocation.c        |   1 +
 fs/btrfs/tree-log.c          | 137 +++++++++++++++++++++++++++++++++++++++++++
 include/trace/events/btrfs.h |  89 +++++++++++++++++++++++++++-
 9 files changed, 303 insertions(+), 33 deletions(-)
