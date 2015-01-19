Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41939 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbbASGrS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:18 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kdZ0022552
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 00/10] Enhance btrfs-find-root and open_ctree() to provide better chance on damaged btrfs.
Date: Mon, 19 Jan 2015 14:45:02 +0800
Message-ID: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset first enhance btrfs-find-root command and then use it to
enhance open_ctree to provide a better chance to open heavily damaged
btrfs.

Patch 1~9 are all enhancement/cleanup for btrfs-find-root in the following
concepts.
1) Reuse existing infrastructure.
Use existing or slightly modified infrastructure other than
copy-n-modify codes.

2) Enhanced root search logic
The old root search logic have many problems, like ignore newer root
with smaller level and use wrong generation/level for searching.

The new logic will keep a per-generation record to deal the tree search,
and use different level/generation for different tree.

3) Make the find-root infrastructure exported to other commands.
Allow other btrfs-progs components to use find-root infrastructure, e.g.
open_ctree can use it if all primary/backup tree roots are corrupted.

Patch 10 is enhancement for open_ctree to use find-root infrastructure.

To: David Sterba <dsterba@suse.cz>
I also created a pull request at github if it's OK for you.
https://github.com/kdave/btrfs-progs/pull/4

Qu Wenruo (10):
  btrfs-progs: Cleanup, use bitshift instead of immediate number in
    btrfs_open_ctree_flags.
  btrfs-progs: Add support to suppress tree block csum error output.
  btrfs-progs: Add new btrfs_open_ctree_flags CHUNK_ONLY.
  btrfs-progs: Add new find-root.[ch] infrastructure.
  btrfs-progs: Swith btrfs-find-root to use the new open_ctree flags.
  btrfs-progs: Add better search generation judgment for
    btrfs-find-root.
  btrfs-progs: Swith btrfs-find-root to use the find-root
    infrastructure.
  btrfs-progs: Cleanup unneeded btrfs-find-root codes.
  btrfs-progs: Add new option for btrfs-find-root to search through all
    the metadata extents.
  btrfs-progs: Allow open_ctree use backup tree root or search it
    automatically if primary tree root is corrupted.

 Documentation/btrfs-find-root.txt |   2 +
 Makefile                          |   2 +-
 btrfs-find-root.c                 | 379 +++++++++++++-------------------------
 ctree.h                           |   2 +
 disk-io.c                         | 128 +++++++++++--
 disk-io.h                         |  24 ++-
 find-root.c                       | 139 ++++++++++++++
 find-root.h                       |  84 +++++++++
 8 files changed, 486 insertions(+), 274 deletions(-)
 create mode 100644 find-root.c
 create mode 100644 find-root.h

-- 
2.2.2

