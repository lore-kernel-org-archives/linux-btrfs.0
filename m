Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22540 "EHLO
	m0001303.ppops.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514AbbIKSoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 14:44:08 -0400
Date: Fri, 11 Sep 2015 14:44:03 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150911184403.GL9511@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have a few more for the btrfs tree in my for-linus-4.3 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.3

These are small cleanups, and also some fixes for our async worker
thread initialization.

I was having some trouble testing these, but it ended up being a
combination of changing around my test servers and a shiny new schedule
while atomic from the new start/finish_plug in writeback_sb_inodes().

That one only hits on btrfs raid5/6 or MD raid10, and if I wasn't
changing a bunch of things in my test setup at once it would have
been really clear.  Fix for writeback_sb_inodes() on the way as well.

Zhao Lei (4) commits (+66/-88):
    btrfs: Remove noused chunk_tree and chunk_objectid from scrub_enumerate_chunks and scrub_chunk (+2/-8)
    btrfs: Cleanup for btrfs_calc_num_tolerated_disk_barrier_failures (+33/-40)
    btrfs: Update out-of-date "skip parity stripe" comment (+1/-1)
    btrfs: Add raid56 support for updating (+30/-39)

Qu Wenruo (1) commits (+35/-24):
    btrfs: async_thread: Fix workqueue 'max_active' value when initializing

Tsutomu Itoh (1) commits (+3/-6):
    Btrfs: cleanup: remove unnecessary check before btrfs_free_path is called

Total: (6) commits (+104/-118)

 fs/btrfs/async-thread.c | 57 ++++++++++++++++++++++---------------
 fs/btrfs/async-thread.h |  2 +-
 fs/btrfs/dev-replace.c  |  3 +-
 fs/btrfs/disk-io.c      | 76 +++++++++++++++++++++++--------------------------
 fs/btrfs/disk-io.h      |  1 +
 fs/btrfs/inode.c        |  3 +-
 fs/btrfs/scrub.c        | 12 ++------
 fs/btrfs/tree-defrag.c  |  3 +-
 fs/btrfs/volumes.c      | 21 +++-----------
 9 files changed, 82 insertions(+), 96 deletions(-)
