Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48094 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2IRB3B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 21:29:01 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 717353EE0BC
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:29:00 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5A5EB45DE58
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:29:00 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 437D545DE55
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:29:00 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 36D1F1DB804F
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:29:00 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id E5A2B1DB804A
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:28:59 +0900 (JST)
Message-ID: <5057CE50.1050706@jp.fujitsu.com>
Date: Tue, 18 Sep 2012 10:28:48 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: make space to keep default mount options
References: <5057CDA7.3090201@jp.fujitsu.com>
In-Reply-To: <5057CDA7.3090201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch create space to hold default mount option,
and to use saved default mount option change super.c
to read default mount option first when mount devices.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/btrfs/ctree.h |    5 ++++-
 fs/btrfs/super.c |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa5c45b..3eb0551 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -458,8 +458,11 @@ struct btrfs_super_block {
 
 	__le64 cache_generation;
 
+	/* default mount options */
+	unsigned long default_mount_opt;
+
 	/* future expansion */
-	__le64 reserved[31];
+	__le64 reserved[30];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e239915..7ef4a2e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -340,6 +340,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	char *compress_type;
 	bool compress_force = false;
 
+	info->mount_opt = info->super_copy->default_mount_opt;
+
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
 		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
-- 
1.7.7.6


