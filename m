Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E26800;
	Thu, 16 Jul 2026 00:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784160394; cv=none; b=dG2i6JHYJzA6eKUL2zQ+/Pt5aQIih6Y0ltBfkl4j/BLYkNIu/B9Ojn9ZUwvybOj8K1cbkv18+Qswze1a5zcZRsGMlVM4pa+oSnqj05I+vsc9hhui/wpN0vEpviHhNizZUGveZCCM6MvYQjvGzKdZBq1r+UKDLYI1NoUzFMPNjBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784160394; c=relaxed/simple;
	bh=loSeqtYK/NiwA8y+TJKqU21Bz/sXV4REkqmYxgZEsnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pz+HQZ6wezHiBAc25OdXwMacN3ZqGMpotR5k/78bnzktbOuHTtrP97CQfJMKwE+FVJP6/EXzYlMuXX4CtZLoWJ5kx0B7CaN49KUtyP6jGiWXT4+qyzIkocFrlUW/B3MLxNsxYs55sFUuwloMWn4JTYJqp3r8xqJ7z9yQv5WzKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 66G05doR008344;
	Thu, 16 Jul 2026 09:05:39 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 66G05cIj008339
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 16 Jul 2026 09:05:38 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <30ccdd3c-6353-4a0f-bdc7-230ec3bf4765@I-love.SAKURA.ne.jp>
Date: Thu, 16 Jul 2026 09:05:38 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v5] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, linux-block
 <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Mark Brown <broonie@kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        oe-lkp@lists.linux.dev, kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>, Hillf Danton <hdanton@sina.com>
References: <20260714043834.554-1-hdanton@sina.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260714043834.554-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav404.rs.sakura.ne.jp

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
Fixes: 65565ca5f99b ("block: unify the synchronous bi_end_io callbacks")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
syzbot has tested this patch (with debug printk() added) using linux-next,
and I confirmed that this patch does not cause new problems for syzbot.

I was expecting that Al Viro can reproduce xfs/259 problem with debug printk(),
but I have to remove this patch (with debug printk() added) from linux-next
because the debug printk() causes performance problem for unmount stress tests
( https://lkml.kernel.org/r/202607151655.9d74999d-lkp@intel.com ).

Anyway, like I have explained in
https://lkml.kernel.org/r/9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp ,
I think that the xfs/259 problem should be addressed by updating the "umount" user,
for the "target is busy" problem can be reproduced with 7.0 and 7.1 kernels if
delay injection is used.

Therefore, I think that we should proceed to the next step; i.e. identify
who is issuing I/O requests too late and fix such users. But I had to stop
testing this patch using linux-next before syzbot succeeds to find such users.

We can't use "#syz test" because this problem has no reproducers. Since I can
no longer continue floating debug printk() for this problem, sending this patch
to upstream will become the only way to identify who is issuing I/O requests
too late.

drivers/block/loop.c | 83 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 310de0463beb..c3b607a3ddc4 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -85,8 +85,27 @@ struct loop_cmd {
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
+	if (unlikely(data_race(READ_ONCE(lo->lo_state)) == Lo_rundown &&
+		     disk_openers(lo->lo_disk) == 0)) {
+		pr_err("BUG: %s/%u is doing I/O request on loop%d in Lo_rundown state.\n",
+		       cmd->comm, cmd->pid, lo->lo_number);
+		printk("Call Trace:\n");
+		stack_trace_print(cmd->stack_entries, cmd->stack_nr, 4);
+	}
+#endif
+}
+
 #define LOOP_IDLE_WORKER_TIMEOUT (60 * HZ)
 #define LOOP_DEFAULT_HW_Q_DEPTH 128
 
@@ -1743,8 +1762,59 @@ static void lo_release(struct gendisk *disk)
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
@@ -1851,10 +1921,18 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
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
@@ -1897,6 +1975,7 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	int ret = 0;
 	struct mem_cgroup *old_memcg = NULL;
 
+	loop_check_io_race(lo, cmd);
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
 		goto failed;
-- 
2.52.0


