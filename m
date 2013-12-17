Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:44210 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3LQJbs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:31:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBH9V6EH027097
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 17:31:10 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4 01/18] btrfs: Cleanup the unused struct async_sched.
Date: Tue, 17 Dec 2013 17:31:42 +0800
Message-Id: <1387272719-11889-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The struct async_sched is not used by any codes and can be removed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fusionio.com>
---
Changelog:
v1->v2:
  None.
v2->v3:
  None.
v3->v4:
  None:
---
 fs/btrfs/volumes.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 92303f4..c63ed39 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5322,13 +5322,6 @@ static void btrfs_end_bio(struct bio *bio, int err)
 	}
 }
 
-struct async_sched {
-	struct bio *bio;
-	int rw;
-	struct btrfs_fs_info *info;
-	struct btrfs_work work;
-};
-
 /*
  * see run_scheduled_bios for a description of why bios are collected for
  * async submit.
-- 
1.8.5.1

