From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: [PATCH] Check kthread_should_stop() before schedule() in worker_loop
Date: Thu, 6 Nov 2008 20:50:14 +0800
Message-ID: <977a2be20811060450s3eee9bb5n2f71b01d03b95987@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
  In worker_loop(), the func should check whether it has been requested to stop
before it decides to schedule out. Otherwise if the stop request(also
the last wake_up())
sent by btrfs_stop_workers() happens when worker_loop() running after
the "while" judgement
and before schedule(), woker_loop() will schedule away and never be woken up,
which will also cause btrfs_stop_workers() wait forever.

Thanks,
Zhu Yanhai
---
diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index d82efd7..423ef27 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -119,7 +119,8 @@ static int worker_loop(void *arg)
                } else {
                        set_current_state(TASK_INTERRUPTIBLE);
                        spin_unlock_irq(&worker->lock);
-                       schedule();
+                       if (!kthread_should_stop())
+                               schedule();
                        __set_current_state(TASK_RUNNING);
                }
        } while (!kthread_should_stop());
---
