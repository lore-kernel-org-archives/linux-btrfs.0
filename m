Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:24270 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/7] Btrfs: fixes for 3.5-rc5
Date: Wed, 27 Jun 2012 19:24:52 +0200
Message-Id: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I expect this to be my last fixup set for the 3.5 series. All seven
fixes are pretty small, five of them for the tree mod log (3-7), one
generic for backref walking (2) and one fixing a starvation issue when
waiting for more delayed refs (1).

You can pull my patches based on your current for-linus from

	git://git.jan-o-sch.net/btrfs-unstable for-chris

I've run through xfstests as usual. All my backref walking tests are
succeeding now.

Even the qgroups patch set looks pretty good on top of these. If things
go well, I'll publish that patch series as soon as the current rc is
out, so there'll be plenty of time before 3.6.

Thanks,
-Jan

Jan Schmidt (7):
  Btrfs: avoid waiting for delayed refs when we must not
  Btrfs: support root level changes in __resolve_indirect_ref
  Btrfs: fix tree mod log for root replacements at leaf level
  Btrfs: always put insert_ptr modifications into the tree mod log
  Btrfs: leave critical region in btrfs_find_all_roots as soon as
    possible
  Btrfs: fix tree mod log rewind of ADD operations
  Btrfs: resolve tree mod log locking issue in btrfs_next_leaf

 fs/btrfs/backref.c     |   15 +++++++----
 fs/btrfs/ctree.c       |   60 ++++++++++++++++++++++++++++--------------------
 fs/btrfs/extent-tree.c |   11 ++++----
 3 files changed, 50 insertions(+), 36 deletions(-)

-- 
1.7.3.4

