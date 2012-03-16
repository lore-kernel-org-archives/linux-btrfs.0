From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/async-thread.c: decrease workers->num_workers only
 on worker can be freed in btrfs_stop_workers
Date: Fri, 16 Mar 2012 11:04:40 +0800
Message-ID: <4F62ADC8.1030502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If the worker cannot be freed, decrease workers->num_workers can
corrupt the statistics. The workers->num_workers should be decreased
only when the worker can be stopped and freed in btrfs_stop_workers.


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 0cc20b3..5a7d756 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -413,9 +413,9 @@ int btrfs_stop_workers(struct btrfs_workers *workers)
 				    worker_list);
 
 		atomic_inc(&worker->refs);
-		workers->num_workers -= 1;
 		if (!list_empty(&worker->worker_list)) {
 			list_del_init(&worker->worker_list);
+			workers->num_workers--;
 			put_worker(worker);
 			can_stop = 1;
 		} else
-- 
1.7.1
