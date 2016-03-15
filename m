Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934119AbcCONuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 09:50:40 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs cleanups for 4.6, part 2
Date: Tue, 15 Mar 2016 14:50:14 +0100
Message-Id: <cover.1458049397.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few more cleanups sent recently and some that I found in my inbox marked but
not processed. Based on top of current integration. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 5e33a2bd7ca7fa687fb0965869196eea6815d1f3:

  Btrfs: do not collect ordered extents when logging that inode exists (2016-03-01 08:23:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanups-4.6

for you to fetch changes up to bb7ab3b92e46da06b580c6f83abe7894dc449cca:

  btrfs: Fix misspellings in comments. (2016-03-14 15:05:02 +0100)

----------------------------------------------------------------
Adam Buchbinder (1):
      btrfs: Fix misspellings in comments.

Anand Jain (2):
      btrfs: rename btrfs_print_info to btrfs_print_mod_info
      btrfs: move btrfs_compression_type to compression.h

Ashish Samant (1):
      btrfs: Print Warning only if ENOSPC_DEBUG is enabled

Dan Carpenter (1):
      btrfs: scrub: silence an uninitialized variable warning

David Sterba (1):
      Documentation: btrfs: remove usage specific information

Rasmus Villemoes (1):
      btrfs: use kbasename in btrfsic_mount

Satoru Takeuchi (1):
      Btrfs: Show a warning message if one of objectid reaches its highest value

 Documentation/filesystems/btrfs.txt | 274 ++----------------------------------
 fs/btrfs/check-integrity.c          |  12 +-
 fs/btrfs/compression.h              |   9 ++
 fs/btrfs/ctree.h                    |  18 +--
 fs/btrfs/delayed-inode.c            |   7 +-
 fs/btrfs/dev-replace.c              |   2 +-
 fs/btrfs/disk-io.c                  |   3 +-
 fs/btrfs/extent-tree.c              |   2 +-
 fs/btrfs/extent_map.c               |   5 +-
 fs/btrfs/file-item.c                |   1 +
 fs/btrfs/file.c                     |   3 +-
 fs/btrfs/inode-map.c                |   3 +
 fs/btrfs/ioctl.c                    |   1 +
 fs/btrfs/ordered-data.c             |   3 +-
 fs/btrfs/props.c                    |   1 +
 fs/btrfs/scrub.c                    |   2 +-
 fs/btrfs/send.c                     |   1 +
 fs/btrfs/super.c                    |   4 +-
 fs/btrfs/tests/inode-tests.c        |   1 +
 fs/btrfs/tree-log.c                 |   3 +-
 fs/btrfs/volumes.c                  |   4 +-
 21 files changed, 62 insertions(+), 297 deletions(-)
