From: Amit Gud <amitgud@gmail.com>
Subject: [PATCH] Fix race in worker_loop
Date: Sat, 21 Mar 2009 19:24:33 -0700
Message-ID: <49C5A161.1000908@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010902070802090409010007"
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010902070802090409010007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Chris,

Experiencing sporadic hangs during umount(2) on UML. Patch below seem to
fix it if not already fixed. Based on 2.6.29-rc8. Tested with mounting
and umounting iteratively 100 times. Without the fix, the race is hit
within 10 tries.


AG
-- 
May the source be with you.
http://www.cis.ksu.edu/~gud


--------------010902070802090409010007
Content-Type: text/x-patch;
 name="btrfs-fix-umount-hang.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs-fix-umount-hang.patch"

Need to check kthread_should_stop after schedule_timeout() before calling schedule(). This causes threads to sleep with potentially no one to wake them up causing mount(2) to hang in btrfs_stop_workers waiting for threads to stop. Race, IMO, is more evident on UP than on SMP.

Signed-off-by: Amit Gud <gud@ksu.edu>

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c84ca1f..4c1f3e5 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -195,6 +195,9 @@ again_locked:
 				if (!list_empty(&worker->pending))
 					continue;
 
+				if (kthread_should_stop())
+					return 0;
+
 				/* still no more work?, sleep for real */
 				spin_lock_irq(&worker->lock);
 				set_current_state(TASK_INTERRUPTIBLE);

--------------010902070802090409010007--
