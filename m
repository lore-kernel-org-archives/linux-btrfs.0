Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8971 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751030AbbGaSVL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 14:21:11 -0400
Date: Fri, 31 Jul 2015 14:21:05 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150731182105.GA19756@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull the fixes from my for-linus-4.2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.2

Filipe fixed up a hard to trigger ENOSPC regression from our merge
window pull, and we have a few other smaller fixes.

Zhao Lei (2) commits (+4/-2):
    btrfs: Avoid NULL pointer dereference of free_extent_buffer when read_tree_block() fail (+2/-1)
    btrfs: Fix lockdep warning of btrfs_run_delayed_iputs() (+2/-1)

Anand Jain (1) commits (+1/-1):
    btrfs: its btrfs_err() instead of btrfs_error()

Filipe Manana (1) commits (+18/-0):
    Btrfs: fix quick exhaustion of the system array in the superblock

Total: (4) commits (+23/-3)

 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/disk-io.c     |  3 ++-
 fs/btrfs/extent-tree.c | 18 ++++++++++++++++++
 fs/btrfs/transaction.c |  3 ++-
 4 files changed, 23 insertions(+), 3 deletions(-)

