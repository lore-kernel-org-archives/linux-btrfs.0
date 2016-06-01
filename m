Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:47823 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcFAPwh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 11:52:37 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 09:52:36 -0600
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 0/8] Btrfs: self-tests: Support non-4k page size 
Date: Wed,  1 Jun 2016 15:51:39 +0000
Message-Id: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Btrfs self-test module assumed that both sectorsize and PAGE_SIZE are 4K.
Thus many self-tests fail on non-4K page size systems, like ppc64. This
patchset enables self-tests to be executed on non-4k page size systems.

This patchset enables us to easily add support for possible sectorsizes and
nodesizes (e.g. for future subpage-blocksize support).

This patchset also fixes the following bugs in self-tests:
 1) Fix integer overflow when calculating bytes_per_bitmap
 2) Fix infinite loop when searching for free space
 3) Fix extent test_bitmaps fail on 64k sectorsize system
 4) Fix extent buffer bitmap test fail on big-endian system

Also use macros instead of constants add add missing newline
when print strings in self-tests codes.

-----
V1->V2:
  1) use rb_next(&tmp->offset_index)/rb_prev(&tmp->offset_index) instead
     of doing the info = tmp thing. As suggested by Josef Bacik.

  2) Separate V1 patch "[PATCH 3/5] Btrfs: self-tests: Support non-4k 
     page size" to following  patches in V2.
	- [PATCH V2 3/8] Btrfs: self-tests: Support non-4k page size
	- [PATCH V2 4/8] Btrfs: self-tests: Execute page straddling
		test only when nodesize < PAGE_SIZE
	- [PATCH V2 5/8] Btrfs: self-tests: Support testing all
		possible sectorsizes and nodesizes
	- [PATCH V2 6/8] Btrfs: self-tests: Use macros instead of
		constants and add missing newline
     As suggested by David Sterba that separate all change that are not
     related to hardcoded 4096/sectorsize/PAGE_SIZE.

  3) fix some coding style issue
-----
Feifei Xu (8):
  Btrfs: test_check_exists: Fix infinite loop when searching for free
    space entries
  Btrfs: Fix integer overflow when calculating bytes_per_bitmap
  Btrfs: self-tests: Support non-4k page size
  Btrfs: self-tests: Execute page straddling test only when nodesize <
    PAGE_SIZE
  Btrfs: self-tests: Support testing all possible sectorsizes and
    nodesizes
  Btrfs: self-tests: Use macros instead of constants and add missing
    newline
  Btrfs: self-tests: Fix test_bitmaps fail on 64k sectorsize
  Btrfs: self-tests: Fix extent buffer bitmap test fail on BE system

 fs/btrfs/ctree.c                       |   6 +-
 fs/btrfs/disk-io.c                     |   9 +-
 fs/btrfs/disk-io.h                     |   2 +-
 fs/btrfs/extent_io.c                   |  10 +-
 fs/btrfs/extent_io.h                   |   4 +-
 fs/btrfs/free-space-cache.c            |  18 +-
 fs/btrfs/super.c                       |  52 +++--
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/btrfs-tests.h           |  27 +--
 fs/btrfs/tests/extent-buffer-tests.c   |  13 +-
 fs/btrfs/tests/extent-io-tests.c       |  86 ++++++---
 fs/btrfs/tests/free-space-tests.c      |  76 +++++---
 fs/btrfs/tests/free-space-tree-tests.c |  30 +--
 fs/btrfs/tests/inode-tests.c           | 344 ++++++++++++++++++---------------
 fs/btrfs/tests/qgroup-tests.c          | 111 ++++++-----
 15 files changed, 454 insertions(+), 340 deletions(-)

-- 
2.7.4

