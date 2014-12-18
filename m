Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63005 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307AbaLRDkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 22:40:03 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBI3dakT002153
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 11:39:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] Add repair function for file extent to enhance
Date: Thu, 18 Dec 2014 11:37:55 +0800
Message-ID: <1418873880-7916-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add two repair functions to handle 2 types of file extent error:

1. Orphan file extents
Orphan file extents are extent items whose type is DATA but its data
backref is invalid(points to non-exists).
This kind of corruption can occur when fs tree is corrupted but extent
tree stay fine.
The repair is to assume them as normal uncompressed file extent and
re-insert them back to fs tree.

2. Discontinuous file extents
This kind of corruption can be caused by kernel regression (although I
didn't remember which patch can cause it) or fs tree leaf corruption.
This one is relatively easy to handle, just punch hole to fill them.

With this patchset, btrfsck should be able to fix most of cases when fs
tree has leaf/node corruption.

Btrfs-progs test cases will be follow soon.

Qu Wenruo (5):
  btrfs-progs: Record orphan data extent ref to corresponding root.
  btrfs-progs: Add btrfs_get_extent() and btrfs_punch_hole().
  btrfs-progs: Record and report every file extent hole.
  btrfs-progs: Add repair and report function for orphan file exntent.
  btrfs-progs: Add repair function for discount file extent hole.

 Makefile     |   2 +-
 cmds-check.c | 509 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 ctree.h      |  19 +++
 disk-io.c    |   1 +
 file.c       | 162 +++++++++++++++++++
 5 files changed, 660 insertions(+), 33 deletions(-)
 create mode 100644 file.c

-- 
2.1.3

