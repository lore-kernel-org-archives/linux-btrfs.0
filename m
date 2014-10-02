Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaJBQtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:49:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 34350AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:49:45 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 00/14] Misc cleanups for 3.18
Date: Thu,  2 Oct 2014 18:49:44 +0200
Message-Id: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Assorted cleanups. There's fix from Filipe mixed among my patches because I
found it in the mailinglist but only after I had written my own patch of
course.

You can pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanup/misc-for-3.18

David Sterba (13):
  btrfs: defrag, use unsigned type for extent thresh
  btrfs: remove unused variable from btrfs_parse_options
  btrfs: remove unused extent state bits
  btrfs: use enum for wq endio metadata type
  btrfs: fix error labels in init_btrfs_fs
  btrfs: use slab for end_io_wq structures
  btrfs: remove unused members from struct scrub_warning
  btrfs: let merge_reloc_roots return void
  btrfs: hide typecast to definition of BTRFS_SEND_TRANS_STUB
  btrfs: drop constant param from btrfs_release_extent_buffer_page
  btrfs: kill extent_buffer_page helper
  btrfs: new define for the inline extent data start
  btrfs: move checks for DUMMY_ROOT into a helper

Filipe David Borba Manana (1):
  Btrfs: set default max_inline to 8KiB instead of 8MiB

 fs/btrfs/compression.c | 11 +++++---
 fs/btrfs/ctree.c       |  8 +++---
 fs/btrfs/ctree.h       | 26 +++++++++++++------
 fs/btrfs/disk-io.c     | 61 ++++++++++++++++++++++++-------------------
 fs/btrfs/disk-io.h     |  6 +++--
 fs/btrfs/extent-tree.c | 16 +++++-------
 fs/btrfs/extent_io.c   | 70 +++++++++++++++++++++++---------------------------
 fs/btrfs/extent_io.h   | 10 --------
 fs/btrfs/inode.c       |  3 ++-
 fs/btrfs/ioctl.c       |  8 +++---
 fs/btrfs/qgroup.c      | 10 +++-----
 fs/btrfs/relocation.c  |  3 +--
 fs/btrfs/scrub.c       | 17 ++----------
 fs/btrfs/send.c        |  2 +-
 fs/btrfs/super.c       | 14 ++++++----
 fs/btrfs/transaction.c |  2 +-
 fs/btrfs/transaction.h |  2 +-
 17 files changed, 131 insertions(+), 138 deletions(-)

-- 
1.8.4.5

