Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21043 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457AbaCFETz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Mar 2014 23:19:55 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s264Jphd013119
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 12:19:52 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs: Cleanup the btrfs_workqueue related function type
Date: Thu, 6 Mar 2014 04:19:50 +0000
Message-ID: <1394079657-24937-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new btrfs_workqueue still use open-coded function defition,
this patch will change them into btrfs_func_t type which is much the
same as kernel workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c |  6 +++---
 fs/btrfs/async-thread.h | 20 +++++++++++---------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index a709585..d8c07e5 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -255,9 +255,9 @@ static void normal_work_helper(struct work_struct *arg)
 }
 
 void btrfs_init_work(struct btrfs_work *work,
-		     void (*func)(struct btrfs_work *),
-		     void (*ordered_func)(struct btrfs_work *),
-		     void (*ordered_free)(struct btrfs_work *))
+		     btrfs_func_t func,
+		     btrfs_func_t ordered_func,
+		     btrfs_func_t ordered_free)
 {
 	work->func = func;
 	work->ordered_func = ordered_func;
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 08d7174..0a891cd 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -23,11 +23,13 @@
 struct btrfs_workqueue;
 /* Internal use only */
 struct __btrfs_workqueue;
+struct btrfs_work;
+typedef void (*btrfs_func_t)(struct btrfs_work *arg);
 
 struct btrfs_work {
-	void (*func)(struct btrfs_work *arg);
-	void (*ordered_func)(struct btrfs_work *arg);
-	void (*ordered_free)(struct btrfs_work *arg);
+	btrfs_func_t func;
+	btrfs_func_t ordered_func;
+	btrfs_func_t ordered_free;
 
 	/* Don't touch things below */
 	struct work_struct normal_work;
@@ -37,13 +39,13 @@ struct btrfs_work {
 };
 
 struct btrfs_workqueue *btrfs_alloc_workqueue(char *name,
-						     int flags,
-						     int max_active,
-						     int thresh);
+					      int flags,
+					      int max_active,
+					      int thresh);
 void btrfs_init_work(struct btrfs_work *work,
-		     void (*func)(struct btrfs_work *),
-		     void (*ordered_func)(struct btrfs_work *),
-		     void (*ordered_free)(struct btrfs_work *));
+		     btrfs_func_t func,
+		     btrfs_func_t ordered_func,
+		     btrfs_func_t ordered_free);
 void btrfs_queue_work(struct btrfs_workqueue *wq,
 		      struct btrfs_work *work);
 void btrfs_destroy_workqueue(struct btrfs_workqueue *wq);
-- 
1.9.0
