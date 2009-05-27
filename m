From: =?EUC-KR?B?yKu9xSBzaGluIGhvbmc=?= <hongshin@gmail.com>
Subject: [PATCH] BTRFS: fix data race
Date: Wed, 27 May 2009 21:43:18 +0900
Message-ID: <2014bcab0905270543s44976c64p2cda48bd4f3c8b8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes a bug which may result race condition
between btrfs_start_workers() and worker_loop().

btrfs_start_workers() executed in a parent thread writes
on workers->worker and worker_loop() in a child thread
reads workers->worker. However, there is no synchronization
enforcing the order of two operations.

This patch makes btrfs_start_workers() writes workers->worker
before it starts a child thread with worker_loop() in order to
resolve possible race condition.

--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -273,10 +273,10 @@
                INIT_LIST_HEAD(&worker->worker_list);
                spin_lock_init(&worker->lock);
                atomic_set(&worker->num_pending, 0);
+               worker->workers = workers;
                worker->task = kthread_run(worker_loop, worker,
                                           "btrfs-%s-%d", workers->name,
                                           workers->num_workers + i);
-               worker->workers = workers;
                if (IS_ERR(worker->task)) {
                        kfree(worker);
                        ret = PTR_ERR(worker->task);
