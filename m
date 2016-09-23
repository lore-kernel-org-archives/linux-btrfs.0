Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33683 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933536AbcIWAWp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 20:22:45 -0400
Received: by mail-pa0-f44.google.com with SMTP id hm5so34132809pac.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 17:22:45 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
Date: Thu, 22 Sep 2016 17:22:31 -0700
Message-Id: <cover.1474580472.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This is v2 of my earlier series "Btrfs: fix free space tree
bitmaps+tests on big-endian systems" [1]. Patches 1, 4, and 5 are the
same as patches 1, 2, and 3 from the original series. I've added patch 2
to fix another bug I noticed (an xfstest went out earlier). Patch 3 is
the result of the earlier discussion here [2]. Finally, patch 6 was
necessary to get the sanity tests to run on my MIPS emulator.

This series applies to v4.8-rc7. The sanity tests pass on both x86-64
and MIPS, and there are no xfstests regressions. Chandan and Anatoly,
could you test these out as well?

I'm working on the btrfs-progs follow up, but these patches are safe
without that -- the new FREE_SPACE_TREE_VALID bit will stop all versions
of btrfs-progs from mounting read-write.

Thanks!

1: http://marc.info/?l=linux-btrfs&m=146853909905570&w=2
2: http://marc.info/?l=linux-btrfs&m=147448992301110&w=2

Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Anatoly Pugachev <matorola@gmail.com>

Omar Sandoval (6):
  Btrfs: fix free space tree bitmaps on big-endian systems
  Btrfs: fix mount -o clear_cache,space_cache=v2
  Btrfs: catch invalid free space trees
  Btrfs: fix extent buffer bitmap tests on big-endian systems
  Btrfs: expand free space tree sanity tests to catch endianness bug
  Btrfs: use less memory for delalloc sanity tests

 fs/btrfs/ctree.h                       |   3 +-
 fs/btrfs/disk-io.c                     |  33 ++++---
 fs/btrfs/extent_io.c                   |  64 +++++++++----
 fs/btrfs/extent_io.h                   |  22 +++++
 fs/btrfs/free-space-tree.c             |  19 ++--
 fs/btrfs/tests/extent-io-tests.c       |  95 +++++++++++--------
 fs/btrfs/tests/free-space-tree-tests.c | 164 +++++++++++++++++++--------------
 include/uapi/linux/btrfs.h             |  10 +-
 8 files changed, 261 insertions(+), 149 deletions(-)

-- 
2.10.0

