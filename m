Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32510 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbcFYNNW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 09:13:22 -0400
Date: Sat, 25 Jun 2016 09:13:17 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL 1/2] Btrfs
Message-ID: <20160625131317.orm7k3dvt4mbfqof@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have a two part pull this time because one of the patches Dave Sterba
collected needed to be against v4.7-rc2 or higher (we used rc4).  I try
to make my for-linus-xx branch testable on top of the last major
so we can hand fixes to people on the list more easily, so I've split
this pull in two.

My for-linus-4.7 branch has some fixes and two performance improvements
that we've been testing for some time.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.7

Josef's two performance fixes are most notable.  The transid tracking
patch makes a big improvement on pretty much every workload.

Josef Bacik (2) commits (+38/-27):
    Btrfs: don't do nocow check unless we have to (+22/-22)
    Btrfs: track transid for delayed ref flushing (+16/-5)

Liu Bo (1) commits (+11/-2):
    Btrfs: fix error handling in map_private_extent_buffer

Chris Mason (1) commits (+11/-9):
    btrfs: fix deadlock in delayed_ref_async_start

Wei Yongjun (1) commits (+1/-1):
    Btrfs: fix error return code in btrfs_init_test_fs()

Chandan Rajendra (1) commits (+4/-6):
    Btrfs: Force stripesize to the value of sectorsize

Wang Xiaoguang (1) commits (+2/-1):
    btrfs: fix disk_i_size update bug when fallocate() fails

Total: (7) commits (+67/-46)

 fs/btrfs/ctree.c             |  6 +++++-
 fs/btrfs/ctree.h             |  2 +-
 fs/btrfs/disk-io.c           |  6 ++----
 fs/btrfs/extent-tree.c       | 15 +++++++++++++--
 fs/btrfs/extent_io.c         |  7 ++++++-
 fs/btrfs/file.c              | 44 ++++++++++++++++++++++----------------------
 fs/btrfs/inode.c             |  1 +
 fs/btrfs/ordered-data.c      |  3 ++-
 fs/btrfs/tests/btrfs-tests.c |  2 +-
 fs/btrfs/transaction.c       |  3 ++-
 fs/btrfs/volumes.c           |  4 ++--
 11 files changed, 57 insertions(+), 36 deletions(-)
