Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:56109 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab3KMAX1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 19:23:27 -0500
Received: by mail-qa0-f52.google.com with SMTP id ii20so36428qab.4
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 16:23:26 -0800 (PST)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [PATCH v2 0/2] Change printk to btrfs_* where applicable
Date: Tue, 12 Nov 2013 19:22:51 -0500
Message-Id: <1384302173-32075-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've replaced pr_ and printk statments by btrfs_ output macros where I could
find a fs_info structure. There may be a few remaining cases where a fs_info
structure could be obtained from one of the inputs but I wasn't sure how.
For all the of the remaining pr_ and printk statements I've made sure that
the btrfs: prefix is present and correct.

The second patch is needed because of the way pr_debug is handled by the kernel.
When DEBUG is not defined pr_debug is removed and does not cause any output.
This patch defines btrfs_debug as noprintk when DEBUG is not defined which
matches the way pr_debug is handled.

Thanks

Frank Holton (2):
  Btrfs: convert printk and pr_ to btrfs_* and fix btrfs: prefix
  Btrfs: make btrfs_debug match pr_debug handling related to DEBUG

 fs/btrfs/backref.c               |   21 ++++----
 fs/btrfs/compression.c           |   11 ++--
 fs/btrfs/ctree.c                 |   14 ++---
 fs/btrfs/ctree.h                 |   10 +++-
 fs/btrfs/delayed-inode.c         |   10 ++--
 fs/btrfs/delayed-ref.c           |    3 +-
 fs/btrfs/dev-replace.c           |   28 +++++-----
 fs/btrfs/dir-item.c              |    6 +--
 fs/btrfs/disk-io.c               |   45 ++++++++--------
 fs/btrfs/extent-tree.c           |   12 ++---
 fs/btrfs/extent_io.c             |   83 ++++++++++++++++++------------
 fs/btrfs/file-item.c             |    4 +-
 fs/btrfs/free-space-cache.c      |   14 ++---
 fs/btrfs/inode.c                 |   12 ++---
 fs/btrfs/ioctl.c                 |   28 +++++-----
 fs/btrfs/lzo.c                   |    6 +--
 fs/btrfs/ordered-data.c          |    9 ++--
 fs/btrfs/qgroup.c                |   29 ++++++-----
 fs/btrfs/reada.c                 |   14 ++---
 fs/btrfs/relocation.c            |    4 +-
 fs/btrfs/root-tree.c             |    3 +-
 fs/btrfs/scrub.c                 |   27 +++++-----
 fs/btrfs/super.c                 |  105 ++++++++++++++++++--------------------
 fs/btrfs/tests/extent-io-tests.c |    3 +-
 fs/btrfs/transaction.c           |    4 +-
 fs/btrfs/uuid-tree.c             |   12 ++---
 fs/btrfs/volumes.c               |   70 ++++++++++++-------------
 27 files changed, 307 insertions(+), 280 deletions(-)

-- 
1.7.9.5

