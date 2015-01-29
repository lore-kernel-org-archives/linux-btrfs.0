Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26427 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752740AbbA2JI0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:26 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0T97hhS026087
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 17:07:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() to provide better chance on damaged btrfs.
Date: Thu, 29 Jan 2015 17:07:15 +0800
Message-ID: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
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

Also, since only 2 patches is modified(although other part is slightly
modified to match the change), to avoid mail bombing, I created the pull
request on github and only send the first 2 patches with cover-letter.
https://github.com/kdave/btrfs-progs/pull/5

---
changelog:
v2:
   Split patch into logically independent parts.
v3:
   Change fs_info->suppress_error to fs_info->suppress_tree_err to avoid
   naming confusion.
   Cleanup the check_tree_block() output and provide better output in
   print_tree_block_err().
---

Qu Wenruo (10):
  btrfs-progs: Cleanup check_tree_block() function and split the output
    to     print_tree_block_err() function.
  btrfs-progs: Add support to suppress tree block csum error output.
  btrfs-progs: Add new btrfs_open_ctree_flags CHUNK_ONLY.
  btrfs-progs: Add new find-root.[ch] infrastructure.
  btrfs-progs: Switch btrfs-find-root to use the new open_ctree flags.
  btrfs-progs: Add better search generation judgment for
    btrfs-find-root.
  btrfs-progs: Switch btrfs-find-root to use the find-root
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
 disk-io.c                         | 172 ++++++++++++++---
 disk-io.h                         |  10 +
 find-root.c                       | 138 ++++++++++++++
 find-root.h                       |  84 +++++++++
 8 files changed, 514 insertions(+), 275 deletions(-)
 create mode 100644 find-root.c
 create mode 100644 find-root.h

-- 
2.2.2

