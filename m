Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758078Ab2IFKtn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:49:43 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86AngEW019769
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:49:42 +0800
Message-ID: <50487FB9.6070008@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:49:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3 2/7] Btrfs-progs: fix compile warning of implicit declaration,
 of "list_snapshots"
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487F6E.6060001@cn.fujitsu.com>

This patch fixes the following warning:
cmds-subvolume.c:283:3: warning: implicit declaration of function "list_snapshots"

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
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
