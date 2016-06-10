Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55967 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788AbcFJUB3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 16:01:29 -0400
Date: Fri, 10 Jun 2016 16:01:12 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160610200112.bovbofqxizi42w4y@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

My for-linus-4.7 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.7

Has some fixes and some new self tests for btrfs.  The self tests are
usually disabled in the .config file (unless you're doing btrfs dev
work), and this bunch is meant to find problems with the 64K page
size patches.

Jeff has a patch to help people see if they are using the hardware
assist crc32c module, which really helps us nail down problems when
people ask why crcs are using so much CPU.

Otherwise, it's small fixes.

Feifei Xu (8) commits (+475/-361):
    Btrfs: test_check_exists: Fix infinite loop when searching for free space entries (+2/-2)
    Btrfs: self-tests: Execute page straddling test only when nodesize < PAGE_SIZE (+30/-19)
    Btrfs: self-tests: Use macros instead of constants and add missing newline (+31/-18)
    Btrfs: self-tests: Support testing all possible sectorsizes and nodesizes (+32/-22)
    Btrfs: self-tests: Fix extent buffer bitmap test fail on BE system (+11/-1)
    Btrfs: Fix integer overflow when calculating bytes_per_bitmap (+7/-7)
    Btrfs: self-tests: Fix test_bitmaps fail on 64k sectorsize (+7/-1)
    Btrfs: self-tests: Support non-4k page size (+355/-291)

Liu Bo (3) commits (+104/-15):
    Btrfs: clear uptodate flags of pages in sys_array eb (+2/-0)
    Btrfs: add validadtion checks for chunk loading (+67/-15)
    Btrfs: add more validation checks for superblock (+35/-0)

Josef Bacik (1) commits (+1/-0):
    Btrfs: end transaction if we abort when creating uuid root

Jeff Mahoney (1) commits (+9/-2):
    btrfs: advertise which crc32c implementation is being used at module load

Vinson Lee (1) commits (+1/-1):
    btrfs: Use __u64 in exported linux/btrfs.h.

Total: (14) commits (+590/-379)

 fs/btrfs/ctree.c                       |   6 +-
 fs/btrfs/disk-io.c                     |  20 +-
 fs/btrfs/disk-io.h                     |   2 +-
 fs/btrfs/extent_io.c                   |  10 +-
 fs/btrfs/extent_io.h                   |   4 +-
 fs/btrfs/free-space-cache.c            |  18 +-
 fs/btrfs/hash.c                        |   5 +
 fs/btrfs/hash.h                        |   1 +
 fs/btrfs/super.c                       |  57 ++++--
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/btrfs-tests.h           |  27 +--
 fs/btrfs/tests/extent-buffer-tests.c   |  13 +-
 fs/btrfs/tests/extent-io-tests.c       |  86 ++++++---
 fs/btrfs/tests/free-space-tests.c      |  76 +++++---
 fs/btrfs/tests/free-space-tree-tests.c |  30 +--
 fs/btrfs/tests/inode-tests.c           | 344 ++++++++++++++++++---------------
 fs/btrfs/tests/qgroup-tests.c          | 111 ++++++-----
 fs/btrfs/volumes.c                     | 109 +++++++++--
 include/uapi/linux/btrfs.h             |   2 +-
 19 files changed, 569 insertions(+), 358 deletions(-)
