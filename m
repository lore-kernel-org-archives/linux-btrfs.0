Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbcDDPGk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 11:06:40 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Misc fixes for 4.6, part 2
Date: Mon,  4 Apr 2016 17:03:00 +0200
Message-Id: <cover.1459780674.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following patches to 4.6. They fix some user visible problems,
improve error handling and there are two debugging enhancements. Thanks.

----------------------------------------------------------------
The following changes since commit 232cad8413a0bfbd25f11cc19fd13dfd85e1d8ad:

  Merge branch 'misc-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.6 (2016-03-24 17:36:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git misc-4.6

for you to fetch changes up to 7ccefb98ce3e5c4493cd213cd03714b7149cf0cb:

  btrfs: Reset IO error counters before start of device replacing (2016-04-04 16:29:22 +0200)

----------------------------------------------------------------
David Sterba (1):
      btrfs: fallback to vmalloc in btrfs_compare_tree

Davide Italiano (1):
      Btrfs: Improve FL_KEEP_SIZE handling in fallocate

Josef Bacik (1):
      Btrfs: don't use src fd for printk

Liu Bo (1):
      Btrfs: fix invalid reference in replace_path

Mark Fasheh (2):
      btrfs: handle non-fatal errors in btrfs_qgroup_inherit()
      btrfs: Add qgroup tracing

Qu Wenruo (1):
      btrfs: Output more info for enospc_debug mount option

Yauhen Kharuzhy (1):
      btrfs: Reset IO error counters before start of device replacing

 fs/btrfs/ctree.c             | 12 ++++--
 fs/btrfs/dev-replace.c       |  2 +
 fs/btrfs/extent-tree.c       | 21 ++++++++++-
 fs/btrfs/file.c              |  9 +++--
 fs/btrfs/ioctl.c             |  2 +-
 fs/btrfs/qgroup.c            | 63 ++++++++++++++++++++-----------
 fs/btrfs/relocation.c        |  1 +
 include/trace/events/btrfs.h | 89 +++++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 166 insertions(+), 33 deletions(-)
