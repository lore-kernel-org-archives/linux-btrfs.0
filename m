Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3ILIHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 04:07:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8C87cWU015391
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 16:07:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v2 1/9] btrfs: Cleanup the unused struct async_sched.
Date: Thu, 12 Sep 2013 16:08:16 +0800
Message-Id: <1378973304-11693-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The struct async_sched is not used by any codes and can be removed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..12eaf89 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5031,13 +5031,6 @@ static void btrfs_end_bio(struct bio *bio, int err)
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
1.8.4

