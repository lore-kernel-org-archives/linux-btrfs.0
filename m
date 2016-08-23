Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756858AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D06F9ABDB
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/13] Btrfs-progs: partial mkfs/convert, error handling, cleanups
Date: Tue, 23 Aug 2016 12:25:04 +0200
Message-Id: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this series mainly improves error handling in mkfs and convert, plus the
collaterals. There were too many BUG_ONs, now there are 0 in mkfs.c. There's
still work to do, eg. in the generic functions.

The improvement idea is to be able to safely leave around an unfinished
filesystem image, so the error handling is just "report & return". The signature
is intentionally bogus until the entire filesystem is constructed.

This is now in devel.

David Sterba (13):
  btrfs-progs: pass OPEN_CTREE flags as unsigned
  btrfs-progs: make superblock reading/scanning api more generic
  btrfs-progs: introduce signature for a partially set up filesystem
  btrfs-progs: mkfs: do not scan partially initialized devices
  btrfs-progs: two staged filesystem creation
  btrfs-progs: mkfs: return errors from block group creation functions
  btrfs-progs: mkfs: improve error handling in main()
  btrfs-progs: mkfs: improve error handling in recow_roots
  btrfs-progs: document all btrfs_open_ctree_flags
  btrfs-progs: mkfs: switch BUG_ON to error handling in
    traverse_directory
  btrfs-progs: mkfs: handle and report transaction commit failures
  btrfs-progs: mkfs: help and usage now to to stdout
  btrfs-progs: mkfs: clean up make_image

 btrfs-convert.c   |   7 +-
 btrfstune.c       |   2 +-
 chunk-recover.c   |   8 +-
 cmds-check.c      |   2 +-
 cmds-filesystem.c |   2 +-
 ctree.h           |   7 ++
 disk-io.c         |  66 ++++++++++-----
 disk-io.h         |  69 ++++++++++-----
 mkfs.c            | 246 ++++++++++++++++++++++++++++++++++++------------------
 super-recover.c   |   3 +-
 utils.c           |  22 +++--
 volumes.c         |   4 +-
 volumes.h         |   2 +-
 13 files changed, 299 insertions(+), 141 deletions(-)

-- 
2.7.1

