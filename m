From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 4/7] Btrfs: fix increasing num_workers_starting twice
Date: Thu, 29 Jul 2010 16:29:42 +0800
Message-ID: <4C513BF6.5030906@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

num_workers_starting is increased twice when the btrfs uses generic workers
to create a new kthread.

The reason is following:
start_new_worker_func() calls btrfs_start_workers() to start a new kthread,
this function will add 1 to ->num_workers_starting, but ->num_workers_starting
has been increased by check_pending_worker_creates()

we use __btrfs_start_workers() instead of btrfs_start_workers() to fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..eb3ec2d 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -84,11 +84,14 @@ struct worker_start {
 	struct btrfs_workers *queue;
 };
 
+static int __btrfs_start_workers(struct btrfs_workers *workers,
+					int num_workers);
+
 static void start_new_worker_func(struct btrfs_work *work)
 {
 	struct worker_start *start;
 	start = container_of(work, struct worker_start, work);
-	btrfs_start_workers(start->queue, 1);
+	__btrfs_start_workers(start->queue, 1);
 	kfree(start);
 }
 
-- 
1.7.0.1
