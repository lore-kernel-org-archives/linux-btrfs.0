Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34202 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbcDHJic (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 05:38:32 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@canonical.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [RFC PATCH v1] block: avoid to call .bi_end_io() recursively
Date: Fri,  8 Apr 2016 17:38:11 +0800
Message-Id: <1460108291-2387-1-git-send-email-ming.lei@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There were reports about heavy stack use by
recursive calling .bi_end_io().[1][2][3]

Also these patches[1] [2] [3] were posted for
addressing the issue. And the idea is basically
similar, all serializes the recursive calling
of .bi_end_io() by percpu list.

This patch still takes the same idea, but uses
bio_list to implement it, which turns out more
simple and the code becomes more readable meantime.

xfstests(-g auto) is run with this patch and no
regression is found on ext4, but when testing
btrfs, generic/224 and generic/323 causes kernel
oops.

[1] http://marc.info/?t=121428502000004&r=1&w=2
[2] http://marc.info/?l=dm-devel&m=139595190620008&w=2
[3] http://marc.info/?t=145974644100001&r=1&w=2

Cc: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
V1:
	- change to RFC
	- fix when unwind_bio_endio() is called recursively
	- run xfstest again: no regression found on ext4,
	but generic/323 and generic/224 cause kernel oops 

 block/bio.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f124a0a..e2d0970 100644
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
@@ -1737,6 +1739,45 @@ static inline bool bio_remaining_done(struct bio *bio)
 	return false;
 }
 
+/* disable local irq when manipulating the percpu bio_list */
+static void unwind_bio_endio(struct bio *bio)
+{
+	struct bio_list *bl;
+	unsigned long flags;
+	bool clear_list = false;
+
+	preempt_disable();
+	local_irq_save(flags);
+
+	bl = this_cpu_read(bio_end_list);
+	if (!bl) {
+		struct bio_list bl_in_stack;
+
+		bl = &bl_in_stack;
+		bio_list_init(bl);
+		this_cpu_write(bio_end_list, bl);
+		clear_list = true;
+	} else {
+		bio_list_add(bl, bio);
+		goto out;
+	}
+
+	while (bio) {
+		local_irq_restore(flags);
+
+		if (bio->bi_end_io)
+			bio->bi_end_io(bio);
+
+		local_irq_save(flags);
+		bio = bio_list_pop(bl);
+	}
+	if (clear_list)
+		this_cpu_write(bio_end_list, NULL);
+ out:
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
@@ -1765,8 +1806,7 @@ again:
 		goto again;
 	}
 
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio);
+	unwind_bio_endio(bio);
 }
 EXPORT_SYMBOL(bio_endio);
 
-- 
1.9.1

