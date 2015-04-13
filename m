Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26887 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbbDMOf6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:35:58 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/1] Btrfs-progs: fix compile warnings
Date: Mon, 13 Apr 2015 22:48:54 +0800
Message-Id: <1428936534-2502-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

simple compile time warning fixes.

cmds-check.c: In function ‘del_file_extent_hole’:
cmds-check.c:289: warning: ‘prev.len’ may be used uninitialized in this function
cmds-check.c:289: warning: ‘prev.start’ may be used uninitialized in this function
cmds-check.c:290: warning: ‘next.len’ may be used uninitialized in this function
cmds-check.c:290: warning: ‘next.start’ may be used uninitialized in this function

btrfs-calc-size.c: In function ‘print_seek_histogram’:
btrfs-calc-size.c:221: warning: ‘group_start’ may be used uninitialized in this function
btrfs-calc-size.c:223: warning: ‘group_end’ may be used uninitialized in this function

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-calc-size.c | 4 ++--
 cmds-check.c      | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 1372084..88f92e1 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -218,9 +218,9 @@ static void print_seek_histogram(struct root_stats *stat)
 	struct rb_node *n = rb_first(&stat->seek_root);
 	struct seek *seek;
 	u64 tick_interval;
-	u64 group_start;
+	u64 group_start = 0;
 	u64 group_count = 0;
-	u64 group_end;
+	u64 group_end = 0;
 	u64 i;
 	u64 max_seek = stat->max_seek_len;
 	int digits = 1;
diff --git a/cmds-check.c b/cmds-check.c
index ed8c698..de22185 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -293,6 +293,9 @@ static int del_file_extent_hole(struct rb_root *holes,
 	int have_next = 0;
 	int ret = 0;
 
+	memset(&prev, 0, sizeof(struct file_extent_hole));
+	memset(&next, 0, sizeof(struct file_extent_hole));
+
 	tmp.start = start;
 	tmp.len = len;
 	node = rb_search(holes, &tmp, compare_hole_range, NULL);
-- 
2.0.0.153.g79dcccc

