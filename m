From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: [PATCH] Don't exist from cleaner_kthread and transaction_kthread
	until kthread_should_stop is true
Date: Thu, 3 Sep 2009 19:12:47 +0900
Message-ID: <2014bcab0909030312i73f6cccfib1e612da0501cfc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

upstream commit 2ad49887150894b9ed6a87a76b409adceee6b074

Motivated from the commit,
I found that cleaner_kthread() and transaction_kthread()
can result similar error since these two function can exit
even though kthread_should_stop() is not true.

In order to resolve the bug, break statements are changed
into continue statements in order to wait until kthread_should_stop()
becomes true.


--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c

--- a/fs/btrfs/disk-io.c   2009-08-17 06:19:38.000000000 +0900
+++ a/fs/btrfs/disk-io.c 2009-09-03 19:09:14.640625000 +0900
@@ -1435,7 +1435,7 @@
        do {
                smp_mb();
                if (root->fs_info->closing)
-                       break;
+                       continue;

                vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
                mutex_lock(&root->fs_info->cleaner_mutex);
@@ -1447,7 +1447,7 @@
                } else {
                        smp_mb();
                        if (root->fs_info->closing)
-                               break;
+                               continue;
                        set_current_state(TASK_INTERRUPTIBLE);
                        schedule();
                        __set_current_state(TASK_RUNNING);
@@ -1468,7 +1468,7 @@
        do {
                smp_mb();
                if (root->fs_info->closing)
-                       break;
+                       continue;

                delay = HZ * 30;
                vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
@@ -1499,7 +1499,7 @@
                        refrigerator();
                } else {
                        if (root->fs_info->closing)
-                               break;
+                               continue;
                        set_current_state(TASK_INTERRUPTIBLE);
                        schedule_timeout(delay);
                        __set_current_state(TASK_RUNNING);
