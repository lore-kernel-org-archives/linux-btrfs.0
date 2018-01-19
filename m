Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:49633 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbeASFhq (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:37:46 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 00/16] btrfs-progs: Split lowmem mode check to its own
Date: Fri, 19 Jan 2018 13:37:15 +0800
Message-Id: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The long planned cmds-check re-construction is finally here.

As the original cmds-check.c is getting larger and larger (already over
15K lines), it's always a good idea to split it into its own check/
directory.

This patchset do the following work:
1) Move cmds-check.c to check/main.c
2) Put codes shared by both original and lowmem mode into
   check/common.[ch]
3) Put lowmem code into check/lowmem.[ch]
   With minor renaming to get rid of unnecessary _v2 suffix.

The modification looks scary, but no functional change at all.

And considering how much the file structure changed, it's a good idea to
put PART1 as quick as possible, and there will be less pressure to
rebase new incoming fsck related codes.

The real move work happens in the 15th patch, which due to its size
(500KB+), it may not be able to reach mail list.
So please fetch the whole patchset from github:
https://github.com/adam900710/btrfs-progs/tree/split_check

There will be a part 2, mostly moving original mode to its own
check/original.[ch], along with extra comment explaining how the two
different modes work.

Qu Wenruo (16):
  btrfs-progs: Moves cmds-check.c to check/main.c
  btrfs-progs: check: Move original mode definitions to check/original.h
  btrfs-progs: check: Move definitions of lowmem mode to check/lowmem.h
  btrfs-progs: check: Move node_ptr structure to check/common.h
  btrfs-progs: check: Export check global variables to check/common.h
  btrfs-progs: check: Move imode_to_type function to check/common.h
  btrfs-progs: check: Move fs_root_objectid function to check/common.h
  btrfs-progs: check: Move count_csum_range function to check/common.c
  btrfs-progs: check: Move __create_inode_item function to
    check/common.c
  btrfs-progs: check: Move link_inode_to_lostfound function to common.c
  btrfs-progs: check: Move check_dev_size_alignment to check/common.c
  btrfs-progs: check: move reada_walk_down to check/common.c
  btrfs-progs: check: Move check_child_node to check/common.c
  btrfs-progs: check: Move reset_cached_block_groups to check/common.c
  btrfs-progs: check: Move lowmem check code to its own
    check/lowmem.[ch]
  btrfs-progs: check/lowmem: Cleanup unnecessary _v2 suffix

 Makefile                     |     6 +-
 check/common.c               |   351 +
 check/common.h               |   100 +
 check/lowmem.c               |  4571 ++++++++++++
 check/lowmem.h               |    67 +
 cmds-check.c => check/main.c | 16389 ++++++++++++++---------------------------
 check/original.h             |   293 +
 7 files changed, 11007 insertions(+), 10770 deletions(-)
 create mode 100644 check/common.c
 create mode 100644 check/common.h
 create mode 100644 check/lowmem.c
 create mode 100644 check/lowmem.h
 rename cmds-check.c => check/main.c (65%)
 create mode 100644 check/original.h

-- 
2.15.1

