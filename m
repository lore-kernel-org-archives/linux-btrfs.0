Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35975 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbbICToh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Sep 2015 15:44:37 -0400
Received: by pacwi10 with SMTP id wi10so55660669pac.3
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2015 12:44:36 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 0/9] free space B-tree
Date: Thu,  3 Sep 2015 12:44:18 -0700
Message-Id: <cover.1441309178.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's version 2 of the the free space B-tree patches, addressing
Josef's review from the last round, which you can find here:
http://www.spinics.net/lists/linux-btrfs/msg46713.html

Changes from v1->v2:

- Cleaned up a bunch of unnecessary instances of "if (ret) goto out; ret = 0"
- Added aborts in the free space tree code closer to the site the error
  is encountered: where we add or remove block groups, add or remove
  free space, and also when we convert formats
- Moved loading of the free space tree into caching_thread() and added a
  new patch 4 in preparation for it
- Commented a bunch of stuff in the extent buffer bitmap operations and
  refactored some of the complicated logic
- Added sanity tests for the extent buffer bitmap operations and free
  space tree (patches 2 and 6)
- Added Josef's Reviewed-by tags

Omar Sandoval (9):
  Btrfs: add extent buffer bitmap operations
  Btrfs: add extent buffer bitmap sanity tests
  Btrfs: add helpers for read-only compat bits
  Btrfs: refactor caching_thread()
  Btrfs: introduce the free space B-tree on-disk format
  Btrfs: implement the free space B-tree
  Btrfs: add free space tree sanity tests
  Btrfs: wire up the free space tree to the extent tree
  Btrfs: add free space tree mount option

 fs/btrfs/Makefile                      |    5 +-
 fs/btrfs/ctree.h                       |  107 ++-
 fs/btrfs/disk-io.c                     |   26 +
 fs/btrfs/extent-tree.c                 |  112 ++-
 fs/btrfs/extent_io.c                   |  183 +++-
 fs/btrfs/extent_io.h                   |   10 +-
 fs/btrfs/free-space-tree.c             | 1501 ++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-tree.h             |   71 ++
 fs/btrfs/super.c                       |   24 +-
 fs/btrfs/tests/btrfs-tests.c           |   52 ++
 fs/btrfs/tests/btrfs-tests.h           |   10 +
 fs/btrfs/tests/extent-io-tests.c       |  138 ++-
 fs/btrfs/tests/free-space-tests.c      |   35 +-
 fs/btrfs/tests/free-space-tree-tests.c |  570 ++++++++++++
 fs/btrfs/tests/qgroup-tests.c          |   20 +-
 include/trace/events/btrfs.h           |    3 +-
 16 files changed, 2763 insertions(+), 104 deletions(-)
 create mode 100644 fs/btrfs/free-space-tree.c
 create mode 100644 fs/btrfs/free-space-tree.h
 create mode 100644 fs/btrfs/tests/free-space-tree-tests.c

-- 
2.5.1

