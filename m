Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaB1CpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 21:45:22 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1S2jIcR017665
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Feb 2014 10:45:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 01/18] btrfs: Cleanup the unused struct async_sched.
Date: Fri, 28 Feb 2014 10:46:02 +0800
Message-Id: <1393555579-11271-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The struct async_sched is not used by any codes and can be removed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fusionio.com>
Tested-by: David Sterba <dsterba@suse.cz>
---
Changelog:
v1->v2:
  None.
v2->v3:
  None.
v3->v4:
  None:
v4->v5:
  None
---
 fs/btrfs/volumes.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 07629e9..82a63b1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5323,13 +5323,6 @@ static void btrfs_end_bio(struct bio *bio, int err)
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
1.9.0

