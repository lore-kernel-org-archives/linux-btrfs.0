Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752789AbeDXMBf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 08:01:35 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.16.1
Date: Tue, 24 Apr 2018 13:58:57 +0200
Message-Id: <20180424115857.25174-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.16.1 have been released.  This is a bugfix release.

Changes:

  * remove obsolete tools: btrfs-debug-tree, btrfs-zero-log, btrfs-show-super,
    btrfs-calc-size
  * sb-mod: new debugging tool to edit superblock items
  * mkfs: detect if thin-provisioned device does not have enough space
  * check: don't try to verify checksums on metadata dump images
  * build: fail documentation build if xmlto is not found
  * build: fix build of btrfs.static

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Baruch Siach (1):
      btrfs-progs: build btrfs.static needs libbtrfsutil to build

David Sterba (5):
      btrfs-progs: sb-mod: add preliminary support for non-u64 types
      btrfs-progs: sb-mod: add csum_type
      btrfs-progs: sb-mod: add compat bit to the recognized fields
      btrfs-progs: reorder extent buffer members for better packing
      btrfs-progs: update CHANGES for v4.16.1

Gu Jinxiang (4):
      btrfs-progs: send-utils: remove unused functions path_cat and path_cat3
      btrfs-progs: Let function find_device to be consistent with kernel
      btrfs-progs: Remove duplicate value-get for data_extents_scrubbed
      btrfs-progs: Do not add extra slash if given path end with it

Misono Tomohiro (1):
      btrfs-progs: configure: check if xmlto exists at configure time

Nikolay Borisov (4):
      btrfs-progs: Remove btrfs-debug-tree command
      btrfs-progs: Remove deprecated btrfs-zero-log standalone tool
      btrfs-progs: Remove deprecated btrfs-show-super
      btrfs-progs: Remove deprecated btrfs-calc-size tool

Qu Wenruo (9):
      btrfs-progs: check: Skip data csum verification for metadata dump
      btrfs-progs: tests/fsck: Add test case to check if btrfs check can skip data csum verfication for metadata dump
      btrfs-progs: extent_io: Fix NULL pointer dereference in free_extent_buffer_final()
      btrfs-progs: extent_io: Init eb->lru to avoid NULL pointer dereference
      btrfs-progs: extent_io: Refactor alloc_extent_buffer() to follow kernel parameters
      btrfs-progs: Unify btrfs_leaf_free_space() parameter with kernel
      btrfs-progs: print-tree: Remove btrfs_root parameter
      btrfs-progs: Rename OPEN_CTREE_FS_PARTIAL to OPEN_CTREE_TEMPORARY_SUPER
      btrfs-progs: Use more loose open ctree flags for dump-tree and restore

Su Yue (1):
      btrfs-progs: mkfs: return nozero value on thin provisioned device
