Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9219 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2KZJ1H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 04:27:07 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ9R6Sl010034
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 17:27:06 +0800
Message-ID: <50B33601.9050908@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 17:27:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs: fix freeze vs auto defrag
References: <50B32FE7.5080908@cn.fujitsu.com>
In-Reply-To: <50B32FE7.5080908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we freeze the fs, the auto defragment should not run. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6ca2b46..40b17d0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -318,8 +318,11 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	memset(&range, 0, sizeof(range));
 	range.len = (u64)-1;
 	range.start = defrag->last_offset;
+
+	sb_start_write(fs_info->sb);
 	num_defrag = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
 				       BTRFS_DEFRAG_BATCH);
+	sb_end_write(fs_info->sb);
 	/*
 	 * if we filled the whole defrag batch, there
 	 * must be more work to do.  Queue this defrag
-- 
1.7.11.7

