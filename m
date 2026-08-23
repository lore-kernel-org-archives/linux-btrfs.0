Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2D441A8F;
	Sun, 23 Aug 2026 11:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787483976; cv=none; b=i49L5YacgLEODBsbBeUJU7uHfyEGo4pjAZf8t/YKJaYGTAMKY1ehVfbjl3zeggNzDuOICjxrSC0vOuEAJStjkbXviBGUGZYJWl7lCqO1j2Rd3IMd5HU0GGsNiKri8w5z29kNFClzzlzvfgqdAcH/pQEPICLZmmGZ7pO3/F6Eirg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787483976; c=relaxed/simple;
	bh=gcMW9xyOp4Ce6JzhCzJs131ZlCyLwnFgbMFJuQa7uB0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bXhcN541EQawBA7tEI8iXxztVAVnHk+MIra/B31k8zqks76qUMA8bru8IxlpMKOdZ5JN9UY4DQvPe6T6C9PYZt2KTQUB7SF9rzy1i7rys8H4DIKyfznzpYLr9hKvD9HwT3rRNi1fFbPds0ZPdDoP823LWE1RrNeqdJyX0aJKej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 67NBHvbd037693;
	Sun, 23 Aug 2026 20:17:57 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 67NBHv9a037688
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 23 Aug 2026 20:17:57 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <8dedfc40-9cae-44ff-9960-e0eb1825e963@I-love.SAKURA.ne.jp>
Date: Sun, 23 Aug 2026 20:17:57 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v6] loop: Fix NULL pointer dereference in lo_rw_aio()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
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
 <30ccdd3c-6353-4a0f-bdc7-230ec3bf4765@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <30ccdd3c-6353-4a0f-bdc7-230ec3bf4765@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav405.rs.sakura.ne.jp
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
programming) so that we won't hit NULL pointer dereference problem.

Link: https://syzkaller.appspot.com/bug?extid=cd8a9a308e879a4e2c28 [1]
Link: https://syzkaller.appspot.com/bug?extid=bc273027d5643e48e5b3 [2]
Link: https://lkml.kernel.org/r/fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp [3]
Fixes: 65565ca5f99b ("block: unify the synchronous bi_end_io callbacks")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Changes in v6:
  Drop debug code for emitting BUG: message, which is intended for helping
  filesystem developers identify the caller of an I/O request that failed to
  wait for completion.

 drivers/block/loop.c | 53 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6f12976035b0..feebc9999926 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1769,8 +1769,59 @@ static void lo_release(struct gendisk *disk)
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
-- 
2.52.0

