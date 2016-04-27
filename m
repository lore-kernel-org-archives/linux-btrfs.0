Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35441 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbcD0DwE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 23:52:04 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 3/3] block: avoid to call .bi_end_io() recursively
Date: Wed, 27 Apr 2016 11:51:54 +0800
Message-Id: <1461729114-22989-1-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1461729047-22837-1-git-send-email-ming.lei@canonical.com>

There were reports about heavy stack use by recursive calling
.bi_end_io()([1][2][3]). For example, more than 16K stack is
consumed in a single bio complete path[3], and in [2] stack
overflow can be triggered if 20 nested dm-crypt is used.

Also patches[1] [2] [3] were posted for addressing the issue,
but never be merged. And the idea in these patches is basically
similar, all serializes the recursive calling of .bi_end_io() by
percpu list.

This patch still takes the same idea, but uses bio_list to
implement it, which turns out more simple and the code becomes
more readable meantime.

One corner case which wasn't covered before is that
bi_endio() may be scheduled to run in process context(such
as btrfs), and this patch just bypasses the optimizing for
that case because one new context should have enough stack space,
and this approach isn't capable of optimizing it too because
there isn't easy way to get a per-task linked list head.

xfstests(-g auto) is run with this patch and no regression is
found on ext4, xfs and btrfs.

[1] http://marc.info/?t=121428502000004&r=1&w=2
[2] http://marc.info/?l=dm-devel&m=139595190620008&w=2
[3] http://marc.info/?t=145974644100001&r=1&w=2

Cc: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/bio.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 807d25e..6b4ca7b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -68,6 +68,8 @@ static DEFINE_MUTEX(bio_slab_lock);
 static struct bio_slab *bio_slabs;
 static unsigned int bio_slab_nr, bio_slab_max;
 
+static DEFINE_PER_CPU(struct bio_list *, bio_end_list) = { NULL };
+
 static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 {
 	unsigned int sz = sizeof(struct bio) + extra_size;
@@ -1737,6 +1739,58 @@ static inline bool bio_remaining_done(struct bio *bio)
 	return false;
 }
 
+static void __bio_endio(struct bio *bio)
+{
+	if (bio->bi_end_io)
+		bio->bi_end_io(bio);
+}
+
+/* disable local irq when manipulating the percpu bio_list */
+static void unwind_bio_endio(struct bio *bio)
+{
+	struct bio_list *bl;
+	unsigned long flags;
+
+	/*
+	 * We can't optimize if bi_endio() is scheduled to run from
+	 * process context because there isn't easy way to get a
+	 * per-task bio list head or allocate a per-task variable.
+	 */
+	if (!in_interrupt()) {
+		/*
+		 * It has to be a top calling when it is run from
+		 * process context.
+		 */
+		WARN_ON(this_cpu_read(bio_end_list));
+		__bio_endio(bio);
+		return;
+	}
+
+	local_irq_save(flags);
+	bl = __this_cpu_read(bio_end_list);
+	if (!bl) {
+		struct bio_list bl_in_stack;
+
+		bl = &bl_in_stack;
+		bio_list_init(bl);
+		__this_cpu_write(bio_end_list, bl);
+	} else {
+		bio_list_add(bl, bio);
+		goto out;
+	}
+
+	while (bio) {
+		local_irq_restore(flags);
+		__bio_endio(bio);
+		local_irq_save(flags);
+
+		bio = bio_list_pop(bl);
+	}
+	__this_cpu_write(bio_end_list, NULL);
+ out:
+	local_irq_restore(flags);
+}
+
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
@@ -1765,8 +1819,7 @@ again:
 		goto again;
 	}
 
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio);
+	unwind_bio_endio(bio);
 }
 EXPORT_SYMBOL(bio_endio);
 
-- 
1.9.1

