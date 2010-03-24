From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 2/2] md/raid456: switch to btrq for multicore operation
Date: Wed, 24 Mar 2010 07:53:20 -0700
Message-ID: <20100324145320.15371.81326.stgit@dwillia2-linux>
References: <20100324144904.15371.2317.stgit@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100324144904.15371.2317.stgit@dwillia2-linux>
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs workqueue is designed for load balancing cpu intensive
operations.  Reuse it in md/raid456 for distributing stripe processing
across multiple cores.
---

 drivers/md/Kconfig |    1 +
 drivers/md/raid5.c |   79 ++++++++++++++++++++++++++++++----------------------
 drivers/md/raid5.h |   13 +++++----
 3 files changed, 54 insertions(+), 39 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 922c36c..09ade02 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -129,6 +129,7 @@ config MD_RAID456
 	select ASYNC_PQ
 	select ASYNC_RAID6_RECOV
 	select BLK_BBU if MD_RAID456_BBU
+	select BTRQ if MULTICORE_RAID456
 	---help---
 	  A RAID-5 set of N drives with a capacity of C MB per drive provides
 	  the capacity of C * (N - 1) MB, and protects against a failure
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 90d7678..4afa625 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1084,7 +1084,7 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
 
-static void __raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
+static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
@@ -1149,34 +1149,9 @@ static void __raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	put_cpu();
 }
 
-#ifdef CONFIG_MULTICORE_RAID456
-static void async_run_ops(void *param, async_cookie_t cookie)
-{
-	struct stripe_head *sh = param;
-	unsigned long ops_request = sh->ops.request;
-
-	clear_bit_unlock(STRIPE_OPS_REQ_PENDING, &sh->state);
-	wake_up(&sh->ops.wait_for_ops);
-
-	__raid_run_ops(sh, ops_request);
-	release_stripe(sh);
-}
-
-static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
-{
-	/* since handle_stripe can be called outside of raid5d context
-	 * we need to ensure sh->ops.request is de-staged before another
-	 * request arrives
-	 */
-	wait_event(sh->ops.wait_for_ops,
-		   !test_and_set_bit_lock(STRIPE_OPS_REQ_PENDING, &sh->state));
-	sh->ops.request = ops_request;
 
-	atomic_inc(&sh->count);
-	async_schedule(async_run_ops, sh);
-}
-#else
-#define raid_run_ops __raid_run_ops
+#ifdef CONFIG_MULTICORE_RAID456
+static void stripe_work(struct btrq_work *work);
 #endif
 
 static int grow_one_stripe(raid5_conf_t *conf)
@@ -1189,9 +1164,10 @@ static int grow_one_stripe(raid5_conf_t *conf)
 	memset(sh, 0, sizeof(*sh) + (disks-1)*sizeof(struct r5dev));
 	sh->raid_conf = conf;
 	spin_lock_init(&sh->lock);
-	#ifdef CONFIG_MULTICORE_RAID456
-	init_waitqueue_head(&sh->ops.wait_for_ops);
-	#endif
+#ifdef CONFIG_MULTICORE_RAID456
+	sh->work.func = stripe_work;
+	sh->work.flags = 0;
+#endif
 
 	if (grow_buffers(sh, disks)) {
 		shrink_buffers(sh, disks);
@@ -1307,9 +1283,10 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 
 		nsh->raid_conf = conf;
 		spin_lock_init(&nsh->lock);
-		#ifdef CONFIG_MULTICORE_RAID456
-		init_waitqueue_head(&nsh->ops.wait_for_ops);
-		#endif
+#ifdef CONFIG_MULTICORE_RAID456
+		nsh->work.func = stripe_work;
+		nsh->work.flags = 0;
+#endif
 
 		list_add(&nsh->lru, &newstripes);
 	}
@@ -3441,6 +3418,26 @@ static void handle_stripe6(struct stripe_head *sh)
 	return_io(return_bi);
 }
 
+#ifdef CONFIG_MULTICORE_RAID456
+static void stripe_work(struct btrq_work *work)
+{
+	struct stripe_head *sh = container_of(work, struct stripe_head, work);
+
+	if (sh->raid_conf->level == 6)
+		handle_stripe6(sh);
+	else
+		handle_stripe5(sh);
+	release_stripe(sh);
+}
+
+static void handle_stripe(struct stripe_head *sh)
+{
+	raid5_conf_t *conf = sh->raid_conf;
+
+	atomic_inc(&sh->count);
+	btrq_queue_worker(&conf->workqueue, &sh->work);
+}
+#else
 static void handle_stripe(struct stripe_head *sh)
 {
 	if (sh->raid_conf->level == 6)
@@ -3448,6 +3445,7 @@ static void handle_stripe(struct stripe_head *sh)
 	else
 		handle_stripe5(sh);
 }
+#endif
 
 static void raid5_activate_delayed(raid5_conf_t *conf)
 {
@@ -4546,6 +4544,9 @@ static void free_conf(raid5_conf_t *conf)
 	raid5_free_percpu(conf);
 	kfree(conf->disks);
 	kfree(conf->stripe_hashtbl);
+#ifdef CONFIG_MULTICORE_RAID456
+	btrq_stop_workers(&conf->workqueue);
+#endif
 	kfree(conf);
 }
 
@@ -4683,6 +4684,16 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
 	conf->bypass_threshold = BYPASS_THRESHOLD;
+#ifdef CONFIG_MULTICORE_RAID456
+	sprintf(conf->queue_name, "%s_%s", mdname(mddev), mddev->pers->name);
+	btrq_init_workers(&conf->workqueue, conf->queue_name,
+			  min_t(unsigned long, num_online_cpus() + 2, 8), NULL);
+	if (btrq_start_workers(&conf->workqueue, 1)) {
+		printk(KERN_ERR "raid5: failed to start thread pool for %s\n",
+		       mdname(mddev));
+		goto abort;
+	}
+#endif
 
 	conf->raid_disks = mddev->raid_disks;
 	if (mddev->reshape_position == MaxSector)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index dd70835..81c027b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -3,6 +3,7 @@
 
 #include <linux/raid/xor.h>
 #include <linux/dmaengine.h>
+#include <linux/btrqueue.h>
 
 /*
  *
@@ -214,6 +215,9 @@ struct stripe_head {
 	int			disks;		/* disks in stripe */
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
+#ifdef CONFIG_MULTICORE_RAID456
+	struct btrq_work	work;
+#endif
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -224,10 +228,6 @@ struct stripe_head {
 	struct stripe_operations {
 		int 		     target, target2;
 		enum sum_check_flags zero_sum_result;
-		#ifdef CONFIG_MULTICORE_RAID456
-		unsigned long	     request;
-		wait_queue_head_t    wait_for_ops;
-		#endif
 	} ops;
 	struct r5dev {
 		struct bio	req;
@@ -302,7 +302,6 @@ struct r6_state {
 #define	STRIPE_FULL_WRITE	13 /* all blocks are set to be overwritten */
 #define	STRIPE_BIOFILL_RUN	14
 #define	STRIPE_COMPUTE_RUN	15
-#define	STRIPE_OPS_REQ_PENDING	16
 
 /*
  * Operation request flags
@@ -382,6 +381,10 @@ struct raid5_private_data {
 	int			bypass_count; /* bypassed prereads */
 	int			bypass_threshold; /* preread nice */
 	struct list_head	*last_hold; /* detect hold_list promotions */
+#ifdef CONFIG_MULTICORE_RAID456
+	struct btrq_workers	workqueue;
+	char			queue_name[20];
+#endif
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
 	/* unfortunately we need two cache names as we temporarily have

