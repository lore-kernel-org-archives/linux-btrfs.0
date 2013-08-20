Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:32816 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3HTLU2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] Btrfs: cast cleanups
Date: Tue, 20 Aug 2013 13:20:06 +0200
Message-Id: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

	Hi Chris,

This is a collection of cast cleanups I created after burning my eyes
by the btrfs code.

  - [01/12] Btrfs: Remove superfluous casts from u64 to unsigned long long
  - [02/12] Btrfs: Make BTRFS_DEV_REPLACE_DEVID an unsigned long long constant
  - [03/12] Btrfs: Format PAGE_SIZE as unsigned long
  - [04/12] Btrfs: Format mirror_num as int
  - [05/12] Btrfs: Make btrfs_device_uuid() return unsigned long
  - [06/12] Btrfs: Make btrfs_device_fsid() return unsigned long
  - [07/12] Btrfs: Make btrfs_dev_extent_chunk_tree_uuid() return unsigned long
  - [08/12] Btrfs: Make btrfs_header_fsid() return unsigned long
  - [09/12] Btrfs: Make btrfs_header_chunk_tree_uuid() return unsigned long
  - [10/12] Btrfs: PAGE_CACHE_SIZE is already unsigned long
  - [11/12] Btrfs: Do not truncate sector_t on 32-bit with CONFIG_LBDAF=y
  - [12/12] Btrfs: Use %z to format size_t

None of them are real bugs, except for "[11/12] Btrfs: Do not truncate
sector_t on 32-bit with CONFIG_LBDAF=y", which may print truncated values.

This was only compile-tested.

 fs/btrfs/backref.c          |   24 ++--
 fs/btrfs/check-integrity.c  |  313 +++++++++++++++----------------------------
 fs/btrfs/compression.c      |    5 +-
 fs/btrfs/ctree.c            |   28 ++--
 fs/btrfs/ctree.h            |   24 ++--
 fs/btrfs/delayed-inode.c    |   10 +-
 fs/btrfs/dev-replace.c      |    4 +-
 fs/btrfs/disk-io.c          |   39 ++----
 fs/btrfs/extent-tree.c      |   47 +++----
 fs/btrfs/extent_io.c        |   48 +++----
 fs/btrfs/file-item.c        |    4 +-
 fs/btrfs/free-space-cache.c |    6 +-
 fs/btrfs/inode.c            |   24 ++--
 fs/btrfs/ioctl.c            |   15 +--
 fs/btrfs/ordered-data.c     |   11 +-
 fs/btrfs/print-tree.c       |   80 ++++-------
 fs/btrfs/qgroup.c           |   10 +-
 fs/btrfs/relocation.c       |    7 +-
 fs/btrfs/root-tree.c        |    3 +-
 fs/btrfs/scrub.c            |   25 ++--
 fs/btrfs/super.c            |   10 +-
 fs/btrfs/transaction.c      |    3 +-
 fs/btrfs/volumes.c          |   40 +++---
 23 files changed, 279 insertions(+), 501 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
