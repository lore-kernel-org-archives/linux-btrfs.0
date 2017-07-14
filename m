Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33604 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbdGNURo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 16:17:44 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs for 4.13, part 2
Date: Fri, 14 Jul 2017 22:16:12 +0200
Message-Id: <cover.1500058584.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we've identified and fixed a silent corruption (introduced by code in the
first pull), a fixup after the blk_status_t merge and two fixes to incremental
send that Filipe has been hunting for some time. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 848c23b78fafdcd3270b06a30737f8dbd70c347f:

  btrfs: Remove false alert when fiemap range is smaller than on-disk extent (2017-06-29 20:25:20 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.13-part2

for you to fetch changes up to c3cfb656307583ddfea45375c10183737593c195:

  Btrfs: fix unexpected return value of bio_readpage_error (2017-07-14 20:42:37 +0200)

----------------------------------------------------------------
David Sterba (3):
      Merge branch 'next/filipe' into for-4.13-part2
      btrfs: cloned bios must not be iterated by bio_for_each_segment_all
      btrfs: btrfs_create_repair_bio never fails, skip error handling

Filipe Manana (3):
      Btrfs: incremental send, fix invalid path for link commands
      Btrfs: incremental send, fix invalid memory access
      Btrfs: fix write corruption due to bio cloning on raid5/6

Liu Bo (1):
      Btrfs: fix unexpected return value of bio_readpage_error

 fs/btrfs/compression.c |  1 +
 fs/btrfs/disk-io.c     |  1 +
 fs/btrfs/extent_io.c   | 19 ++++++-----
 fs/btrfs/extent_io.h   |  4 +--
 fs/btrfs/inode.c       |  6 ++--
 fs/btrfs/raid56.c      | 26 ++++++++++-----
 fs/btrfs/send.c        | 88 +++++++++++++++++++++++++++++++-------------------
 7 files changed, 88 insertions(+), 57 deletions(-)
