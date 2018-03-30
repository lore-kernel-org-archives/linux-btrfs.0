Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46492 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbeC3FtM (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 01:49:12 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs-progs: extent buffer related refactor and cleanup
Date: Fri, 30 Mar 2018 13:48:52 +0800
Message-Id: <20180330054857.6106-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/eb_cleanup

Just like kernel cleanup and refactors, this patchset will embed
btrfs_fs_info structure into extent_buffer.

And fixes several possible NULL pointer dereference (although not
utilized in btrfs-progs yet).

Changelog:
v2:
  Embarrassingly, I forgot to install reiserfsprogs in my development
  machine, so the 3rd patch lacks one call site in
  convert/source-reiserfs.c.

Qu Wenruo (5):
  btrfs-progs: extent_io: Fix NULL pointer dereference in
    free_extent_buffer_final()
  btrfs-progs: extent_io: Init eb->lru to avoid NULL pointer dereference
  btrfs-progs: extent_io: Refactor alloc_extent_buffer() to follow
    kernel parameters
  btrfs-progs: Unify btrfs_leaf_free_psace() parameter with kernel
  btrfs-progs: print-tree: Remove btrfs_root parameter

 btrfs-corrupt-block.c     |  2 +-
 check/main.c              |  2 +-
 check/mode-lowmem.c       |  2 +-
 cmds-inspect-dump-tree.c  | 31 ++++++++++------------
 convert/source-reiserfs.c |  3 +--
 ctree.c                   | 65 +++++++++++++++++++++++++----------------------
 ctree.h                   |  3 ++-
 disk-io.c                 |  3 +--
 extent-tree.c             |  8 +++---
 extent_io.c               | 17 ++++++++-----
 extent_io.h               |  3 ++-
 print-tree.c              | 20 ++++++++-------
 print-tree.h              |  4 +--
 13 files changed, 85 insertions(+), 78 deletions(-)

-- 
2.16.3

