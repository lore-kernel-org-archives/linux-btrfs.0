Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBD733C192;
	Thu,  3 Sep 2026 23:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788479489; cv=none; b=nV3NdUdUFxsCdhgifcfRNwBc3RDe9JLZgh0P2Tnjxd7JeHasbgqR/G578pX4o+PhT2p6kRhxZ4AtCTt6AMzJYr5/5xIJX2Hq3SFnDkKfOHPbZtBAlV1x+ekIKqG0HRXdfz7L3vE+amLOUE2TMst+EtJseLSUFA2TigfVS9EwASQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788479489; c=relaxed/simple;
	bh=whx3MwuuqeUZLwexkSsMN1tzlP1OB0NfURrM/yY9dtw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=khKe6/FfuP83S/VbOM22fMBFu/VodUwh+0mKIxvMP++jwoWWZqd4fETvqs3eob7nCD/LbiLCsYBa6Ta1/uUO8VM8+0144YQnxkMPyp+X2OesM0c7fLwR1+ZGBKRXLWMRBO/H21ya4KMSsO0lO3X+6DVMisQ/pi4Fq1m84DqE19w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 683Nol7J013836;
	Fri, 4 Sep 2026 08:50:47 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 683NokUa013833
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 4 Sep 2026 08:50:47 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <dc2f1e00-5e10-4e02-9415-c6ecb2cbc6b3@I-love.SAKURA.ne.jp>
Date: Fri, 4 Sep 2026 08:50:46 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v8] loop: Fix NULL pointer dereference in lo_rw_aio()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Bart Van Assche <bvanassche@acm.org>,
        Markus Elfring <Markus.Elfring@web.de>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, lkp@intel.com,
        oe-lkp@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Oliver Sang <oliver.sang@intel.com>,
        linux-btrfs@vger.kernel.org
References: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
 <550ff0b4-df39-46d2-9781-c8688df10c93@web.de>
 <38ad64c1-edc7-431d-8f52-fba572ebf3eb@I-love.SAKURA.ne.jp>
 <372ca5f6-81a0-4f6c-8f55-ebeeada9f955@acm.org>
 <27bcb147-bead-4432-8cd0-981489f36228@acm.org>
 <c41e9198-86a8-4bcd-a608-6f457b24f345@I-love.SAKURA.ne.jp>
 <7e51bca8-218a-40b8-8ff8-fc59671f5add@acm.org>
 <3bb080d0-4421-4012-8a62-6a2bf165cbd9@I-love.SAKURA.ne.jp>
 <d2f387b9-031a-4306-9323-56f98a8241b7@acm.org>
 <e5518546-701e-4d3c-a077-18e34aa8c188@I-love.SAKURA.ne.jp>
 <c0df5f39-d103-4e36-9807-df0ae0247772@acm.org>
 <c2ab2547-63b3-48cf-87c1-fc53219e360a@I-love.SAKURA.ne.jp>
 <d0471919-9b71-4d24-9fb8-5f1d7f3792ca@acm.org>
 <903a22a2-432c-4e72-bc09-7898becf2f3e@I-love.SAKURA.ne.jp>
 <d7e26d4b-d9b9-47c0-9658-c241499209b5@acm.org>
 <9ac07477-b2be-482b-9e97-87acf9635307@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <9ac07477-b2be-482b-9e97-87acf9635307@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav212.rs.sakura.ne.jp
X-Virus-Status: clean

syzbot is reporting NULL pointer dereference in lo_rw_aio() [1][2].
An analysis by the Gemini AI collaborator [3] considers that this problem
is caused by a timing shift primarily exposed by commit 65565ca5f99b
("block: unify the synchronous bi_end_io callbacks"), along with helper
refactorings like commit 92c3737a2473 ("block: add a bio_submit_or_kill
helper").

But due to difficulty of reproducing this race, discussion about what is
happening and how to fix this problem is stalling. Also, we haven't
identified how many filesystems are subjected to this problem.

Therefore, introduce a grace period for flushing outstanding I/O
(which should be a good thing from the perspective of defensive
programming) so that we won't hit NULL pointer dereference problem.

However, calling drain_workqueue() from __loop_clr_fd() with
disk->open_mutex held causes lockdep warnings. We need to flush
outstanding I/O without disk->open_mutex held. But we can't use task work
context, for there is no way to reliably wait for completion of a task work
function inside a loadable module when module unloading code for that
loadable module has started. We need to use a callback function which is
embedded into a built-in module so that it can reliably wait for completion
of synchronous teardown for the loop driver module.

Therefore, add a dedicated callback for the loop module to the block core
layer, and invoke that callback immediately after disk->open_mutex is
released. It is possible that multiple threads invoke that callback
when a teardown work was scheduled because disk->open_mutex was already
released, but concurrently calling flush_work() in order to wait for
completion of an outstanding teardown work will be safe.

Link: https://syzkaller.appspot.com/bug?extid=cd8a9a308e879a4e2c28 [1]
Link: https://syzkaller.appspot.com/bug?extid=bc273027d5643e48e5b3 [2]
Link: https://lkml.kernel.org/r/fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp [3]
Link: https://lkml.kernel.org/r/9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp [4]
Fixes: 65565ca5f99b ("block: unify the synchronous bi_end_io callbacks")
Assisted-by: Gemini-Pro
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
What this patch does is basically the same with the v6 patch. Can this be
a possible alternative for Bart's

  Releasing and reacquiring disk->open_mutex from __loop_clr_fd() seems
  risky to me. There is plenty of code in block/bdev.c that assumes that
  disk->open_mutex is not released by lo_release().

comment?

 block/bdev.c           |  2 ++
 drivers/block/loop.c   | 65 +++++++++++++++++++++++++++++++++---------
 include/linux/blkdev.h |  5 ++++
 3 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..7ce5acaacf43 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1188,6 +1188,8 @@ void bdev_release(struct file *bdev_file)
 	else
 		blkdev_put_whole(bdev);
 	mutex_unlock(&disk->open_mutex);
+	if (bdev->bd_disk->fops->post_release)
+		bdev->bd_disk->fops->post_release(bdev->bd_disk);
 
 	module_put(disk->fops->owner);
 put_no_open:
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6f12976035b0..620298978706 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,6 +75,7 @@ struct loop_device {
 	struct gendisk		*lo_disk;
 	struct mutex		lo_mutex;
 	bool			idr_visible;
+	struct work_struct	lo_clr_work;
 };
 
 struct loop_cmd {
@@ -1134,13 +1135,42 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	return error;
 }
 
-static void __loop_clr_fd(struct loop_device *lo)
+static void __loop_clr_fd(struct work_struct *work)
 {
+	struct loop_device *lo = container_of(work, struct loop_device, lo_clr_work);
+	struct gendisk *disk = lo->lo_disk;
 	struct queue_limits lim;
 	struct file *filp;
 	gfp_t gfp = lo->old_gfp_mask;
 	int err;
 
+	/* Step 1: Flush all outstanding I/O, without open_mutex held. */
+	/*
+	 * Since loop_queue_rq() is called with RCU read lock, this synchronize_rcu()
+	 * makes sure that no more queue_work() calls are made from loop_queue_work()
+	 * from loop_queue_rq(). Subsequent loop_queue_rq() calls which are made after
+	 * this synchronize_rcu() returned shall see lo->lo_state != Lo_bound and
+	 * return with BLK_STS_IOERR.
+	 */
+	synchronize_rcu();
+	/*
+	 * This drain_workqueue() makes sure that no more loop_handle_cmd() calls are
+	 * made from loop_process_work() from loop_workfn()/loop_rootcg_workfn().
+	 */
+	drain_workqueue(lo->workqueue);
+	/*
+	 * This blk_mq_freeze_queue() waits for completion of all outstanding I/O
+	 * which has been scheduled via loop_queue_rq(), by waiting for q_usage_counter
+	 * to reach 0. Since the lo->lo_state != Lo_bound check in loop_queue_rq()
+	 * guarantees that no more new I/O requests are made, we can call
+	 * blk_mq_unfreeze_queue() immediately after blk_mq_freeze_queue() returns.
+	 */
+	blk_mq_unfreeze_queue(lo->lo_queue, blk_mq_freeze_queue(lo->lo_queue));
+
+	/* Step 2: Perform remaining cleanup, with open_mutex held. */
+	mutex_lock(&disk->open_mutex);
+	WARN_ON_ONCE(lo->lo_state != Lo_rundown);
+
 	spin_lock_irq(&lo->lo_lock);
 	filp = lo->lo_backing_file;
 	lo->lo_backing_file = NULL;
@@ -1151,12 +1181,7 @@ static void __loop_clr_fd(struct loop_device *lo)
 	lo->lo_sizelimit = 0;
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
 
-	/*
-	 * Reset the block size to the default.
-	 *
-	 * No queue freezing needed because this is called from the final
-	 * ->release call only, so there can't be any outstanding I/O.
-	 */
+	/* Reset the block size to the default. */
 	lim = queue_limits_start_update(lo->lo_queue);
 	lim.logical_block_size = SECTOR_SIZE;
 	lim.physical_block_size = SECTOR_SIZE;
@@ -1199,11 +1224,9 @@ static void __loop_clr_fd(struct loop_device *lo)
 	WRITE_ONCE(lo->lo_state, Lo_unbound);
 	mutex_unlock(&lo->lo_mutex);
 
-	/*
-	 * Need not hold lo_mutex to fput backing file. Calling fput holding
-	 * lo_mutex triggers a circular lock dependency possibility warning as
-	 * fput can take open_mutex which is usually taken before lo_mutex.
-	 */
+	/* Step 3: Drop refcounts, without open_mutex held. */
+	mutex_unlock(&disk->open_mutex);
+
 	fput(filp);
 }
 
@@ -1769,8 +1792,22 @@ static void lo_release(struct gendisk *disk)
 	need_clear = (lo->lo_state == Lo_rundown);
 	mutex_unlock(&lo->lo_mutex);
 
+	/*
+	 * In order to flush outstanding I/O (without open_mutex for deadlock
+	 * avoidance) before clearing the backing device, defer __loop_clr_fd()
+	 * to WQ context and let lo_post_release() wait for completion.
+	 * The Lo_rundown state guarantees that lo_open() will fail with -ENXIO.
+	 */
 	if (need_clear)
-		__loop_clr_fd(lo);
+		queue_work(system_long_wq, &lo->lo_clr_work);
+}
+
+static void lo_post_release(struct gendisk *disk)
+{
+	struct loop_device *lo = disk->private_data;
+
+	/* Wait for __loop_clr_fd() to complete. */
+	flush_work(&lo->lo_clr_work);
 }
 
 static void lo_free_disk(struct gendisk *disk)
@@ -1789,6 +1826,7 @@ static const struct block_device_operations lo_fops = {
 	.owner =	THIS_MODULE,
 	.open =         lo_open,
 	.release =	lo_release,
+	.post_release = lo_post_release,
 	.ioctl =	lo_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	lo_compat_ioctl,
@@ -2034,6 +2072,7 @@ static int loop_add(int i)
 	lo = kzalloc_obj(*lo);
 	if (!lo)
 		goto out;
+	INIT_WORK(&lo->lo_clr_work, __loop_clr_fd);
 	lo->worker_tree = RB_ROOT;
 	INIT_LIST_HEAD(&lo->idle_worker_list);
 	timer_setup(&lo->timer, loop_free_idle_workers_timer, TIMER_DEFERRABLE);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..5172d6bdd9e7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1605,6 +1605,11 @@ struct block_device_operations {
 	 * driver.
 	 */
 	int (*alternative_gpt_sector)(struct gendisk *disk, sector_t *sector);
+	/*
+	 * Special callback for synchronous cleanup without open_mutex.
+	 * Needed by loop devices.
+	 */
+	void (*post_release)(struct gendisk *disk);
 };
 
 #ifdef CONFIG_COMPAT
-- 
2.55.0
