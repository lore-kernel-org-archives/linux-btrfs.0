Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:41867 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932527AbaLJVFS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:18 -0500
Received: from mail-in-14-z2.arcor-online.net (mail-in-14-z2.arcor-online.net [151.189.8.31])
	by mx.arcor.de (Postfix) with ESMTP id 312142120B2
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:17 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 00/18] Patch series related to my btrfs recovery
Date: Wed, 10 Dec 2014 21:51:30 +0100
Message-Id: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

This patch series contains all changes I made to the btrfs tools
in the course of analyzing and repairing the corruption I described
in my other mail to linux-btrfs titled "A story of btrfs corruption
and recovery".

The bottom line of this patch set is: 1) have the tools continue with
error messages instead of aborting in certain error cases; and 
2) look for meta data outside the current trees. Both is useful if
the tree is internally corrupted in the way I described. I have also
added support for extracting inode meta data (times, permissions) 
in "btrfs restore"; this was also useful for my recovery case.

Please review and apply what you find useful.

Martin Wilck (18):
  btrfs-progs: btrfs-debug-tree: add option -f for "block only"
  btrfs-progs: btrfs-debug-tree: add option -B (backup root)
  btrfs-progs: btrfs-debug-tree: fix usage message
  btrfs-progs: btrfs-debug-tree: handle corruption more gracefully
  btrfs-progs: ctree.h: fix btrfs_inode_[amc]time
  btrfs restore: set uid/gid/mode/times
  btrfs restore: better output readability
  btrfs restore: track number of bytes restored
  btrfs restore: more graceful error handling in copy_file
  btrfs restore: hide "offset is X" messages
  btrfs restore: print progress marks for big files
  btrfs restore: check progress of file restoration
  btrfs restore: improve user-asking logic for files with many extents
  btrfs restore: report mismatch in file size
  btrfs-progs: NEW: btrfs-raw
  btrfs-progs: NEW: brtfs-search-metadata
  btrfs-progs: ctree.c: make bin_search non-static
  btrfs-progs: documentation for btrfs-raw and btrfs-search-metadata

 Documentation/Makefile                  |    2 +
 Documentation/btrfs-debug-tree.txt      |   10 ++
 Documentation/btrfs-raw.txt             |   54 ++++++++
 Documentation/btrfs-search-metadata.txt |   57 ++++++++
 Makefile                                |    4 +-
 btrfs-debug-tree.c                      |   78 +++++++++--
 btrfs-raw.c                             |  143 ++++++++++++++++++++
 btrfs-search-metadata.c                 |  224 +++++++++++++++++++++++++++++++
 cmds-restore.c                          |  205 +++++++++++++++++++++++-----
 ctree.c                                 |    4 +-
 ctree.h                                 |   15 ++-
 print-tree.c                            |   22 +++-
 12 files changed, 752 insertions(+), 66 deletions(-)
 create mode 100644 Documentation/btrfs-raw.txt
 create mode 100644 Documentation/btrfs-search-metadata.txt
 create mode 100644 btrfs-raw.c
 create mode 100644 btrfs-search-metadata.c

-- 
1.7.3.4

