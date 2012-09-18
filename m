Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30781 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab2IRKxC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:02 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8IAr0uX016412
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 18:53:00 +0800
Message-ID: <5058528B.40106@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 18:52:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 2/7] Btrfs-progs: fix compile warning of implicit declaration
 of "list_snapshots"
References: <50584E6D.8000602@cn.fujitsu.com>
In-Reply-To: <50584E6D.8000602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

This patch fixes the following warning:
cmds-subvolume.c:283:3: warning: implicit declaration of function "list_snapshots"

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v3 -> v4:
- no change.

Changelog v1 -> v3:
- new patch.
---
 btrfs-list.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.h b/btrfs-list.h
index 96f3641..b4a7f30 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -17,5 +17,6 @@
  */
 
 int list_subvols(int fd, int print_parent, int get_default, int print_uuid);
+int list_snapshots(int fd, int print_parent, int order, int print_uuid);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 char *path_for_root(int fd, u64 root);
-- 
1.7.6.5

