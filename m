Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C94B2E3AF1;
	Sun,  7 Jun 2026 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829741; cv=none; b=qvg7l7AQi2c/uQgPsIoTRiMr8YRGyBbQ23zahUsVb3SyPD+o9jEB5ozTM/+7vMmWjq+gNodqK70O3kKzQkOshbhbsv0jG0//gpMwID5XLzl3RPHvA2LymSNKcXOiy1i8ocul4azJnr5/pbOF4yTlwg+Tc4rU5OkHZBM3/gNPaeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829741; c=relaxed/simple;
	bh=2Ke8GL6eZs0K05NJS+Nqfez/Em+cRte7rAqtogW1I8g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jbVRZVJz7aWi7dnJ0NSkgyOqweBhe+/FSTYARb7Mt16LYSd81vs1I/AhmZGV84tW6po/0Mi/c1JkdAaKaS8zLSyqpkFNny+bNjfieV2GiBhqlCJ4bNnOab1CCKxYoiFfgxJ8+j2zLinUeRgGlYypmig36/SMp+eS/AlzeV6cY7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 657AsxJ2063554;
	Sun, 7 Jun 2026 19:54:59 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 657Asxm5063536
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 7 Jun 2026 19:54:59 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <3244d4dd-8254-47c0-9609-b1db53450c7c@I-love.SAKURA.ne.jp>
Date: Sun, 7 Jun 2026 19:54:58 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v4] loop: Fix NULL pointer dereference in lo_rw_aio()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Hillf Danton <hdanton@sina.com>
References: <20260529220600.1226-1-hdanton@sina.com>
 <b27609f0-59f0-403d-90af-274c55df817e@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <b27609f0-59f0-403d-90af-274c55df817e@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav404.rs.sakura.ne.jp
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

Therefore, this patch introduces a grace period for flushing pending I/O
requests (which should be a good thing from the perspective of defensive
programming) so that we won't hit NULL pointer dereference problem, and
also emits BUG: message in order to help filesystem developers identify
the caller of an I/O request that failed to wait for completion so that
filesystem developers can fix such caller to wait for completion.

Note that emitting BUG: message is enabled only if CONFIG_KCOV=y, for
this check is a waste of computation resources for almost all users.

Link: https://syzkaller.appspot.com/bug?extid=cd8a9a308e879a4e2c28 [1]
Link: https://syzkaller.appspot.com/bug?extid=bc273027d5643e48e5b3 [2]
Link: https://lkml.kernel.org/r/fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp [3]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/block/loop.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0000913f7efc..4ff254d8b623 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -85,8 +85,26 @@ struct loop_cmd {
 	struct bio_vec *bvec;
 	struct cgroup_subsys_state *blkcg_css;
 	struct cgroup_subsys_state *memcg_css;
+#ifdef CONFIG_KCOV
+	unsigned long stack_entries[30];
+	int stack_nr;
+	pid_t pid;
+	char comm[TASK_COMM_LEN];
+#endif
 };
 
+static void loop_check_io_race(struct loop_device *lo, struct loop_cmd *cmd)
+{
+#ifdef CONFIG_KCOV
+	if (unlikely(data_race(READ_ONCE(lo->lo_state)) == Lo_rundown)) {
+		pr_err("BUG: %s/%u is doing I/O request on loop%d in Lo_rundown state.\n",
+		       cmd->comm, cmd->pid, lo->lo_number);
+		printk("Call trace:\n");
+		stack_trace_print(cmd->stack_entries, cmd->stack_nr, 4);
+	}
+#endif
+}
+
 #define LOOP_IDLE_WORKER_TIMEOUT (60 * HZ)
 #define LOOP_DEFAULT_HW_Q_DEPTH 128
 
@@ -1747,8 +1765,59 @@ static void lo_release(struct gendisk *disk)
 	need_clear = (lo->lo_state == Lo_rundown);
 	mutex_unlock(&lo->lo_mutex);
 
-	if (need_clear)
+	if (need_clear) {
+		/*
+		 * Temporarily release disk->open_mutex in order to flush pending I/O
+		 * requests before clearing the backing device.
+		 *
+		 * This is a layering violation. But since bdev->bd_disk->fops->release()
+		 * (which is mapped to lo_release()) is the final function which
+		 * blkdev_put_whole() from bdev_release() calls immediately before
+		 * releasing disk->open_mutex, this changes nothing except opens a new
+		 * race window for allowing disk->fops->open() (which is mapped to
+		 * lo_open()) to be called.
+		 *
+		 * Even if lo_open() is called from blkdev_get_whole() due to this race,
+		 * the Lo_rundown state guarantees that lo_open() will fail with -ENXIO.
+		 * Thus, there will be effectively no change caused by this violation.
+		 */
+		mutex_unlock(&lo->lo_disk->open_mutex);
+		/*
+		 * Now that loop_queue_rq() sees lo->lo_state != Lo_bound,
+		 * wait for already started loop_queue_rq() to complete.
+		 */
+		synchronize_rcu();
+		/*
+		 * Now that no more works are scheduled by loop_queue_rq(),
+		 * wait for already scheduled works to complete.
+		 */
+		drain_workqueue(lo->workqueue);
+		/*
+		 * Now that no more AIO requests are scheduled by lo_rw_aio(),
+		 * wait for already started AIO to complete.
+		 *
+		 * Due to synchronize_rcu() + drain_workqueue() sequence above,
+		 * calling blk_mq_unfreeze_queue() immediately after blk_mq_freeze_queue()
+		 * returns has to be safe, for loop_queue_rq() no longer schedules new
+		 * lo_rw_aio() works and lo_rw_aio() no longer submits new AIO requests.
+		 *
+		 * Deferring blk_mq_unfreeze_queue() does not help because we are about
+		 * to clear the backing device and drop the refcount for the backing device.
+		 * There is nothing we can do if blk_mq_freeze_queue() fails to flush.
+		 */
+		blk_mq_unfreeze_queue(lo->lo_queue, blk_mq_freeze_queue(lo->lo_queue));
+		/*
+		 * Perform remaining cleanup, with disk->open_mutex held.
+		 *
+		 * The lo->lo_state should remain Lo_rundown despite we temporarily
+		 * released disk->open_mutex, for I am the only and the last user of
+		 * this loop device because lo_open() cannot succeed.
+		 */
+		mutex_lock(&lo->lo_disk->open_mutex);
+		if (WARN_ON(data_race(READ_ONCE(lo->lo_state)) != Lo_rundown))
+			return;
 		__loop_clr_fd(lo);
+	}
 }
 
 static void lo_free_disk(struct gendisk *disk)
@@ -1855,10 +1924,18 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
 	struct loop_device *lo = rq->q->queuedata;
 
+#ifdef CONFIG_KCOV
+	cmd->stack_nr = stack_trace_save(cmd->stack_entries, ARRAY_SIZE(cmd->stack_entries), 0);
+	cmd->pid = current->pid;
+	get_task_comm(cmd->comm, current);
+#endif
+
 	blk_mq_start_request(rq);
 
-	if (data_race(READ_ONCE(lo->lo_state)) != Lo_bound)
+	if (data_race(READ_ONCE(lo->lo_state)) != Lo_bound) {
+		loop_check_io_race(lo, cmd);
 		return BLK_STS_IOERR;
+	}
 
 	switch (req_op(rq)) {
 	case REQ_OP_FLUSH:
@@ -1901,6 +1978,7 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	int ret = 0;
 	struct mem_cgroup *old_memcg = NULL;
 
+	loop_check_io_race(lo, cmd);
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
 		goto failed;
-- 
2.47.3


