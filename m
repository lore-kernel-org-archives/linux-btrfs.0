Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:35996 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbeACHNW (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 3 Jan 2018 02:13:22 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/5] Cleanups for later btrfs_alloc_chunk() rework
Date: Wed,  3 Jan 2018 15:13:01 +0800
Message-Id: <20180103071306.11500-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just small cleanups for incoming btrfs_alloc_chunk() rework, which is
designed to allow btrfs_alloc_chunk() to be able to alloc meta chunk,
even current meta chunks are already full.

The cleanups are quite small, most of them are just removing unnecessary
parameters, and make some function static.

Qu Wenruo (5):
  btrfs-progs: Use bool parameter to determine if we're allocating data
    extent
  btrfs-progs: volumes: Make find_free_dev_extent_start static
  btrfs-progs: volumes: Remove unnecessary trans parameter
  btrfs-progs: volumes: Remove unnecessary parameters when allocating
    device extent
  btrfs-progs: Remove unnecessary parameter for btrfs_add_block_group

 cmds-check.c   |  4 ++--
 convert/main.c |  4 +---
 ctree.h        |  7 +++----
 extent-tree.c  | 31 ++++++++++++++++---------------
 mkfs/main.c    | 14 ++++----------
 volumes.c      | 35 ++++++++++++++---------------------
 6 files changed, 40 insertions(+), 55 deletions(-)

-- 
2.15.1

