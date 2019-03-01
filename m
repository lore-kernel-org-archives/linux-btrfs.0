Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009A9C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 02:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E6920854
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 02:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbfCACp4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 21:45:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:46532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727948AbfCACp4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 21:45:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3438AADF2
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Mar 2019 02:45:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: trace: Add trace events for extent_io_tree
Date:   Fri,  1 Mar 2019 10:45:47 +0800
Message-Id: <20190301024550.17506-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/ftrace_extent_io_tree
Which is based on v5.0-rc7 tag.

Btrfs uses (almost abuse) extent_io_tree for a lot of operations, e.g:
- Tree block locking
  BTRFS_I(btree_inode)->io_tree
- Page status tracing
  BTRFS_I(file_inode)->io_tree and BTRFS_I(file_inode)->io_failure_tree
  transaction->dirty_pages
- Pinned down extents tracing
  fs_info->freed_extents[2]
...

However we don't have any trace events for us to understand how btrfs
works.

This patchset will introduce trace events for
set/clear/convert_extent_bit().

Despite that, there are some other small modifications required:
- Introduce extent_io_tree::fs_info
  For trace events to output fsid to distinguish different fs.
  This increase the size of extent_io_tree by 8 bytes.

- Allow NULL fs_info for TP_fast_assign_fsid()
  There is extent bits operation in selftest which is too deep to pass
  fs_info. And since it's in selftest, it shouldn't trigger trace
  events.
  But to be safe, we still need to check fs_indo in
  TP_fast_assign_fsid(), for NULL fs_info, just keep fsid filled with
  zero.

- New extent_io_tree::owner
  To distinguish different extent io trees. It uses the unpopulated bits
  of original trace_uptodate, so it doesn't increase the size of
  extent_io_tree.

The output examples and extra notes are: (copied from the 3rd patch)
  btrfs_set_extent_bit: <FDID>: io_tree=IO_TREE ino=1 root=1 start=22036480 len=4096 set_bits=LOCKED
  btrfs_set_extent_bit: <FSID>: io_tree=IO_TREE ino=1 root=1 start=22040576 len=4096 set_bits=LOCKED
  btrfs_set_extent_bit: <FSID>: io_tree=IO_TREE ino=1 root=1 start=22044672 len=4096 set_bits=LOCKED
  btrfs_set_extent_bit: <FSID>: io_tree=IO_TREE ino=1 root=1 start=22048768 len=4096 set_bits=LOCKED
  btrfs_clear_extent_bit: <FSID>: io_tree=IO_TREE ino=1 root=1 start=22036480 len=16384 clear_bits=LOCKED
  ^^^ Extent buffer 22036480 read from disc, the locking progress

  btrfs_set_extent_bit: <FSID>: io_tree=TRANS_DIRTY_PAGES ino=1 root=1 start=30425088 len=16384 set_bits=DIRTY
  btrfs_set_extent_bit: <FSID>: io_tree=TRANS_DIRTY_PAGES ino=1 root=1 start=30441472 len=16384 set_bits=DIRTY
  ^^^ 2 new tree blocks allocated in one transaction

  btrfs_set_extent_bit: <FSID>: io_tree=FREED_EXTENTS0 ino=0 root=0 start=30523392 len=16384 set_bits=DIRTY
  btrfs_set_extent_bit: <FSID>: io_tree=FREED_EXTENTS0 ino=0 root=0 start=30556160 len=16384 set_bits=DIRTY
  ^^^ 2 old tree blocks get pinned down

There is one point which need extra attention:
1) Those trace events are pretty heavy
   The following workload would generate over 400 trace events.
	mkfs.btrfs -f $dev
	start_trace
	mount $dev $mnt -o enospc_debug
	sync
	touch $mnt/file1
	touch $mnt/file2
	touch $mnt/file3
	xfs_io -f -c "pwrite 0 16k" $mnt/file4
	umount $mnt
	end_trace
   It's not recommended to use them in real world environment.


Qu Wenruo (3):
  btrfs: Introduce fs_info for extent_io_tree
  btrfs: Introduce extent_io_tree::owner to distinguish different
    io_trees
  btrfs: trace: Add trace events for extent_io_tree

 fs/btrfs/disk-io.c               |  12 ++-
 fs/btrfs/extent_io.c             |   9 +-
 fs/btrfs/extent_io.h             |  22 ++++-
 fs/btrfs/inode.c                 |   6 +-
 fs/btrfs/relocation.c            |   9 +-
 fs/btrfs/tests/btrfs-tests.c     |   6 +-
 fs/btrfs/tests/extent-io-tests.c |   2 +-
 fs/btrfs/transaction.c           |   4 +-
 include/trace/events/btrfs.h     | 159 ++++++++++++++++++++++++++++++-
 9 files changed, 210 insertions(+), 19 deletions(-)

-- 
2.21.0

