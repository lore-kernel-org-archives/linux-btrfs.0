From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] async-thread: fix possible memory leak
Date: Fri, 25 Jul 2008 13:34:03 +0800
Message-ID: <488965CB.1000308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When kthread_run() returns failure, this worker hasn't been
added to the list, so btrfs_stop_workers() won't free it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 async-thread.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/async-thread.c b/async-thread.c
index 8d4cc46..5fe6a0d 100644
--- a/async-thread.c
+++ b/async-thread.c
@@ -187,6 +187,7 @@ int btrfs_start_workers(struct btrfs_workers *workers, int num_workers)
 		worker->task = kthread_run(worker_loop, worker, "btrfs");
 		worker->workers = workers;
 		if (IS_ERR(worker->task)) {
+			kfree(worker);
 			ret = PTR_ERR(worker->task);
 			goto fail;
 		}
-- 
1.5.4.rc3
