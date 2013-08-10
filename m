Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52010 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab3HJM2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 08:28:35 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2D1C09A068D
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 06:28:35 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Message-ID: <20130810122832.17880.78970@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Sat, 10 Aug 2013 08:28:32 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

These are assorted fixes, mostly from Josef nailing down xfstests runs.
Zach also has a long standing fix for problems with readdir wrapping
f_pos (or ctx->pos)

These patches were spread out over different bases, so I rebased things on
top of rc4 and retested overnight.

Josef Bacik (6) commits (+82/-52):
    Btrfs: check to see if root_list is empty before adding it to dead roots (+5/-5)
    Btrfs: make sure the backref walker catches all refs to our extent (+14/-11)
    Btrfs: allow splitting of hole em's when dropping extent cache (+40/-22)
    Btrfs: release both paths before logging dir/changed extents (+2/-3)
    Btrfs: fix backref walking when we hit a compressed extent (+15/-8)
    Btrfs: do not offset physical if we're compressed (+6/-3)

Liu Bo (2) commits (+12/-5):
    Btrfs: fix a bug of snapshot-aware defrag to make it work on partial extents (+12/-4)
    Btrfs: fix extent buffer leak after backref walking (+0/-1)

Zach Brown (1) commits (+25/-8):
    btrfs: don't loop on large offsets in readdir

Jie Liu (1) commits (+0/-3):
    btrfs: fix file truncation if FALLOC_FL_KEEP_SIZE is specified

Total: (10) commits (+119/-68)

 fs/btrfs/backref.c     | 48 ++++++++++++++++++++++----------------
 fs/btrfs/ctree.c       |  1 -
 fs/btrfs/extent_io.c   |  9 +++++---
 fs/btrfs/file.c        | 62 ++++++++++++++++++++++++++++++++------------------
 fs/btrfs/inode.c       | 52 ++++++++++++++++++++++++++++++------------
 fs/btrfs/transaction.c |  8 +++----
 fs/btrfs/transaction.h |  2 +-
 fs/btrfs/tree-log.c    |  5 ++--
 8 files changed, 119 insertions(+), 68 deletions(-)
