Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:48694 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3EMNxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 09:53:38 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 31.27 OK)
	with ESMTP id g01efep4D8Qh95 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 May 2013 15:53:35 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Btrfs: some cleanups around btrfs_read_fs_root_no_name()
Date: Mon, 13 May 2013 15:53:32 +0200
Message-Id: <cover.1368450252.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just some line deletions for callers of btrfs_read_fs_root_no_name().
They repeat the check for btrfs_root_refs() after calling
btrfs_read_fs_root_no_name() and map the error to ENOENT in this case,
and btrfs_read_fs_root_no_name() already does the same for you.
send.c even checked the result for NULL which cannot happen.
And one static inline function in delayed-inode.c that called
btrfs_read_fs_root_no_name() was not at all used anymore.

Stefan Behrens (3):
  Btrfs: delete unused function
  Btrfs: cleanup, btrfs_read_fs_root_no_name() doesn't return NULL
  Btrfs: cleanup: don't check the same thing twice

 fs/btrfs/delayed-inode.c | 14 --------------
 fs/btrfs/export.c        |  5 -----
 fs/btrfs/file.c          |  4 ----
 fs/btrfs/inode.c         | 10 ----------
 fs/btrfs/ioctl.c         |  5 -----
 fs/btrfs/send.c          |  8 ++------
 fs/btrfs/super.c         |  3 ---
 7 files changed, 2 insertions(+), 47 deletions(-)

-- 
1.8.2.2

