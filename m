Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55245 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbbCTQ4C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 12:56:02 -0400
Date: Fri, 20 Mar 2015 12:55:38 -0400
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20150320165529.GA26341@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please grab my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Most of these are fixing extent reservation accounting, or corners with
tree writeback during commit.  Josef's set does add a test, which isn't
strictly a fix, but it'll keep us from making this same mistake again.

Josef Bacik (8) commits (+349/-46):
    Btrfs: account for the correct number of extents for delalloc reservations (+5/-1)
    Btrfs: add sanity test for outstanding_extents accounting (+217/-1)
    Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list) (+18/-13)
    Btrfs: fix outstanding_extents accounting in DIO (+35/-2)
    Btrfs: prepare block group cache before writing (+32/-1)
    Btrfs: account merges/splits properly (+30/-27)
    Btrfs: just free dummy extent buffers (+6/-0)
    Btrfs: fix merge delalloc logic (+6/-1)

Liu Bo (2) commits (+4/-1):
    Btrfs: catch transaction abortion after waiting for it (+3/-0)
    Btrfs: fix comp_oper to get right order (+1/-1)

Fabian Frederick (1) commits (+1/-1):
    btrfs: fix sizeof format specifier in btrfs_check_super_valid()

Total: (11) commits (+354/-48)

 fs/btrfs/ctree.h             |   5 ++
 fs/btrfs/disk-io.c           |   2 +-
 fs/btrfs/extent-tree.c       |  35 +++++++-
 fs/btrfs/extent_io.c         |   6 ++
 fs/btrfs/inode.c             | 112 ++++++++++++++++++------
 fs/btrfs/qgroup.c            |   2 +-
 fs/btrfs/tests/inode-tests.c | 197 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/transaction.c       |  39 ++++++---
 8 files changed, 352 insertions(+), 46 deletions(-)
