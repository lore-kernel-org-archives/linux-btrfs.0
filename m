Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:54505 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbaAJKkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 05:40:09 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: neilb@suse.de
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        amadvance@gmail.com
Subject: [RFC v3 3/3] crypto: async_tx: Extends crypto/async_tx to support up to six parities
Date: Fri, 10 Jan 2014 11:38:43 +0100
Message-Id: <1389350323-19021-4-git-send-email-amadvance@gmail.com>
In-Reply-To: <1389350323-19021-1-git-send-email-amadvance@gmail.com>
References: <1389350323-19021-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes crypto/async_tx to use the new raid interface and
generalize its interface to support an arbitrary number of parities.

New functions available are async_raid_gen() to compute parity,
async_raid_val() to validate parity and async_raid_rec() to recover
data. They are a one-to-one matching with the syncronous ones provided
by the raid library.

Note that triple parity and beyond are handled in syncronous mode.

It also changes md/raid5.c to remove the RAID6 P/Q logic as now it's
completely handled by the async_tx/raid layer.
Another change in raid5.c is the double spare page instead of single
one, needed for parity validation. This avoids a double parity
computation in the RAID6 syncronous case.

For kernel 3.13-rc4.

WARNING! This patch is not tested, and it's NOT meant for inclusion at
this stage. It's only example code to show how the new raid library could
be integrated in existing code.

Signed-off-by: Andrea Mazzoleni <amadvance@gmail.com>
---
 crypto/async_tx/async_pq.c          | 257 +++++++++++++++++++-------------
 crypto/async_tx/async_raid6_recov.c | 286 +++++++++++++++++++++++++++++-------
 drivers/md/Kconfig                  |   1 +
 drivers/md/raid5.c                  | 206 +++++++-------------------
 drivers/md/raid5.h                  |   2 +-
 include/linux/async_tx.h            |  15 +-
 6 files changed, 448 insertions(+), 319 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index d05327c..8bacac4 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/raid/raid.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
 #include <linux/gfp.h>
@@ -33,15 +34,6 @@
  */
 static struct page *pq_scribble_page;
 
-/* the struct page *blocks[] parameter passed to async_gen_syndrome()
- * and async_syndrome_val() contains the 'P' destination address at
- * blocks[disks-2] and the 'Q' destination address at blocks[disks-1]
- *
- * note: these are macros as they are used as lvalues
- */
-#define P(b, d) (b[d-2])
-#define Q(b, d) (b[d-1])
-
 /**
  * do_async_gen_syndrome - asynchronously calculate P and/or Q
  */
@@ -119,7 +111,8 @@ do_async_gen_syndrome(struct dma_chan *chan,
  * do_sync_gen_syndrome - synchronously calculate a raid6 syndrome
  */
 static void
-do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
+do_sync_gen_syndrome(struct page **blocks, unsigned int offset,
+		     int data_disks, int parity_disks,
 		     size_t len, struct async_submit_ctl *submit)
 {
 	void **srcs;
@@ -130,72 +123,93 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	else
 		srcs = (void **) blocks;
 
-	for (i = 0; i < disks; i++) {
-		if (blocks[i] == NULL) {
-			BUG_ON(i > disks - 3); /* P or Q can't be zero */
+	/* map NULL data to zero page */
+	for (i = 0; i < data_disks; ++i) {
+		if (blocks[i] == NULL)
 			srcs[i] = (void*)raid6_empty_zero_page;
-		} else
+		else
 			srcs[i] = page_address(blocks[i]) + offset;
 	}
-	raid6_call.gen_syndrome(disks, len, srcs);
+
+	/* map NULL parity to scribble page */
+	for (i = 0; i < parity_disks; ++i) {
+		if (blocks[data_disks + i] == NULL) {
+			srcs[data_disks + i] = pq_scribble_page;
+			BUG_ON(len + offset > PAGE_SIZE);
+		} else {
+			srcs[data_disks + i] = blocks[data_disks + i];
+		}
+	}
+
+	raid_gen(data_disks, parity_disks, len, srcs);
+
 	async_tx_sync_epilog(submit);
 }
 
 /**
- * async_gen_syndrome - asynchronously calculate a raid6 syndrome
- * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
+ * async_raid_gen - asynchronously calculate a raid syndrome
+ * @blocks: source data blocks from idx 0..data_disks-1,
+ *   and dest parity blocks from idx data_disks..data_disks+parity_disks-1
  * @offset: common offset into each block (src and dest) to start transaction
- * @disks: number of blocks (including missing P or Q, see below)
+ * @data_disks: number of data blocks
+ * @parity_disks: number of parity blocks
  * @len: length of operation in bytes
  * @submit: submission/completion modifiers
  *
  * General note: This routine assumes a field of GF(2^8) with a
  * primitive polynomial of 0x11d and a generator of {02}.
  *
- * 'disks' note: callers can optionally omit either P or Q (but not
- * both) from the calculation by setting blocks[disks-2] or
- * blocks[disks-1] to NULL.  When P or Q is omitted 'len' must be <=
- * PAGE_SIZE as a temporary buffer of this size is used in the
- * synchronous path.  'disks' always accounts for both destination
- * buffers.  If any source buffers (blocks[i] where i < disks - 2) are
- * set to NULL those buffers will be replaced with the raid6_zero_page
- * in the synchronous path and omitted in the hardware-asynchronous
- * path.
+ * Callers can optionally omit some parities (but not all) from the
+ * calculation by setting the respective pointer in blocks[] to NULL.
+ * When some parity is omitted 'len' must be <= PAGE_SIZE as a temporary
+ * buffer of this size is used in the synchronous path.
+ * If any source data buffers are set to NULL those buffers will be replaced
+ * with the raid6_zero_page in the synchronous path and omitted in the
+ * hardware-asynchronous path.
  */
 struct dma_async_tx_descriptor *
-async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
+async_raid_gen(struct page **blocks, unsigned int offset,
+		   int data_disks, int parity_disks,
 		   size_t len, struct async_submit_ctl *submit)
 {
-	int src_cnt = disks - 2;
-	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
-						      &P(blocks, disks), 2,
-						      blocks, src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
-	struct dmaengine_unmap_data *unmap = NULL;
 
-	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
+	struct dma_chan *chan = NULL;
+	struct dma_device *device = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
+	/* async is supported only for two parities */
+	if (parity_disks == 2)
+		chan = async_tx_find_channel(submit, DMA_PQ,
+					      &blocks[data_disks], parity_disks,
+					      blocks, data_disks, len);
+	if (chan)
+		device = chan->device;
 	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
+		unmap = dmaengine_get_unmap_data(device->dev, data_disks + parity_disks, GFP_NOIO);
+
+	BUG_ON(data_disks + parity_disks >= RAID_DATA_MAX);
 
 	if (unmap &&
-	    (src_cnt <= dma_maxpq(device, 0) ||
+	    (data_disks <= dma_maxpq(device, 0) ||
 	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = 0;
-		unsigned char coefs[src_cnt];
+		unsigned char coefs[data_disks];
 		int i, j;
+		struct page **parity = &blocks[data_disks];
+
+		BUG_ON(parity[0] == 0 && parity[1] == 0);
 
 		/* run the p+q asynchronously */
-		pr_debug("%s: (async) disks: %d len: %zu\n",
-			 __func__, disks, len);
+		pr_debug("%s: (async) disks: data: %d parity: %d len: %zu\n",
+			__func__, data_disks, parity_disks, len);
 
 		/* convert source addresses being careful to collapse 'empty'
 		 * sources and update the coefficients accordingly
 		 */
 		unmap->len = len;
-		for (i = 0, j = 0; i < src_cnt; i++) {
+		for (i = 0, j = 0; i < data_disks; i++) {
 			if (blocks[i] == NULL)
 				continue;
 			unmap->addr[j] = dma_map_page(device->dev, blocks[i], offset,
@@ -210,8 +224,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		 * so use BIDIRECTIONAL mapping
 		 */
 		unmap->bidi_cnt++;
-		if (P(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, P(blocks, disks),
+		if (parity[0])
+			unmap->addr[j++] = dma_map_page(device->dev, parity[0],
 							offset, len, DMA_BIDIRECTIONAL);
 		else {
 			unmap->addr[j++] = 0;
@@ -219,8 +233,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		}
 
 		unmap->bidi_cnt++;
-		if (Q(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, Q(blocks, disks),
+		if (parity[1])
+			unmap->addr[j++] = dma_map_page(device->dev, parity[1],
 						       offset, len, DMA_BIDIRECTIONAL);
 		else {
 			unmap->addr[j++] = 0;
@@ -235,43 +249,40 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	dmaengine_unmap_put(unmap);
 
 	/* run the pq synchronously */
-	pr_debug("%s: (sync) disks: %d len: %zu\n", __func__, disks, len);
+	pr_debug("%s: (sync) disks: data: %d parity: %d len: %zu\n",
+		__func__, data_disks, parity_disks, len);
 
 	/* wait for any prerequisite operations */
 	async_tx_quiesce(&submit->depend_tx);
 
-	if (!P(blocks, disks)) {
-		P(blocks, disks) = pq_scribble_page;
-		BUG_ON(len + offset > PAGE_SIZE);
-	}
-	if (!Q(blocks, disks)) {
-		Q(blocks, disks) = pq_scribble_page;
-		BUG_ON(len + offset > PAGE_SIZE);
-	}
-	do_sync_gen_syndrome(blocks, offset, disks, len, submit);
+	do_sync_gen_syndrome(blocks, offset, data_disks, parity_disks, len, submit);
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(async_gen_syndrome);
+EXPORT_SYMBOL_GPL(async_raid_gen);
 
 static inline struct dma_chan *
-pq_val_chan(struct async_submit_ctl *submit, struct page **blocks, int disks, size_t len)
+pq_val_chan(struct async_submit_ctl *submit, struct page **blocks,
+	    int data_disks, int parity_disks, size_t len)
 {
 	#ifdef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
 	return NULL;
 	#endif
 	return async_tx_find_channel(submit, DMA_PQ_VAL, NULL, 0,  blocks,
-				     disks, len);
+				     data_disks + parity_disks, len);
 }
 
 /**
- * async_syndrome_val - asynchronously validate a raid6 syndrome
- * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
+ * async_raid_val - asynchronously validate a raid syndrome
+ * @blocks: data blocks from idx 0..data_disks-1,
+ *   and parity blocks from idx data_disks..data_disks+parity_disks-1
  * @offset: common offset into each block (src and dest) to start transaction
- * @disks: number of blocks (including missing P or Q, see below)
+ * @data_disks: number of data blocks
+ * @parity_disks: number of parity blocks
  * @len: length of operation in bytes
  * @pqres: on val failure SUM_CHECK_P_RESULT and/or SUM_CHECK_Q_RESULT are set
- * @spare: temporary result buffer for the synchronous case
+ * @spare: vector of temporary page buffers for the synchronous case.
+ *   This vector must contain one page for each parity_disks.
  * @submit: submission / completion modifiers
  *
  * The same notes from async_gen_syndrome apply to the 'blocks',
@@ -280,33 +291,41 @@ pq_val_chan(struct async_submit_ctl *submit, struct page **blocks, int disks, si
  * specified.
  */
 struct dma_async_tx_descriptor *
-async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
-		   size_t len, enum sum_check_flags *pqres, struct page *spare,
+async_raid_val(struct page **blocks, unsigned int offset,
+		   int data_disks, int parity_disks,
+		   size_t len, enum sum_check_flags *pqres, struct page **spare,
 		   struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
-	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_chan *chan = NULL;
+	struct dma_device *device = NULL;
 	struct dma_async_tx_descriptor *tx;
-	unsigned char coefs[disks-2];
+	unsigned char coefs[data_disks];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
 	struct dmaengine_unmap_data *unmap = NULL;
 
-	BUG_ON(disks < 4);
-
+	/* async is supported only for two parities */
+	if (parity_disks == 2)
+		chan = pq_val_chan(submit, blocks, data_disks, parity_disks, len);
+	if (chan)
+		device = chan->device;
 	if (device)
-		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
+		unmap = dmaengine_get_unmap_data(device->dev,
+			data_disks + parity_disks, GFP_NOIO);
 
-	if (unmap && disks <= dma_maxpq(device, 0) &&
+	if (unmap &&
+	    data_disks >= 2 &&
+	    (data_disks + parity_disks) <= dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
 		struct device *dev = device->dev;
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
+		struct page **parity = &blocks[data_disks];
 
-		pr_debug("%s: (async) disks: %d len: %zu\n",
-			 __func__, disks, len);
+		pr_debug("%s: (async) disks: data:%d parity:%d len: %zu\n",
+			 __func__, data_disks, parity_disks, len);
 
 		unmap->len = len;
-		for (i = 0; i < disks-2; i++)
+		for (i = 0; i < data_disks; i++)
 			if (likely(blocks[i])) {
 				unmap->addr[j] = dma_map_page(dev, blocks[i],
 							      offset, len,
@@ -317,21 +336,21 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 				j++;
 			}
 
-		if (!P(blocks, disks)) {
+		if (!parity[0]) {
 			pq[0] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
 		} else {
-			pq[0] = dma_map_page(dev, P(blocks, disks),
+			pq[0] = dma_map_page(dev, parity[0],
 					     offset, len,
 					     DMA_TO_DEVICE);
 			unmap->addr[j++] = pq[0];
 			unmap->to_cnt++;
 		}
-		if (!Q(blocks, disks)) {
+		if (!parity[1]) {
 			pq[1] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
 		} else {
-			pq[1] = dma_map_page(dev, Q(blocks, disks),
+			pq[1] = dma_map_page(dev, parity[1],
 					     offset, len,
 					     DMA_TO_DEVICE);
 			unmap->addr[j++] = pq[1];
@@ -358,16 +377,14 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 
 		return tx;
 	} else {
-		struct page *p_src = P(blocks, disks);
-		struct page *q_src = Q(blocks, disks);
 		enum async_tx_flags flags_orig = submit->flags;
 		dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 		void *scribble = submit->scribble;
 		void *cb_param_orig = submit->cb_param;
-		void *p, *q, *s;
+		struct page **parity = &blocks[data_disks];
 
-		pr_debug("%s: (sync) disks: %d len: %zu\n",
-			 __func__, disks, len);
+		pr_debug("%s: (sync) disks: data:%d paritiy:%d len: %zu\n",
+			 __func__, data_disks, parity_disks, len);
 
 		/* caller must provide a temporary result buffer and
 		 * allow the input parameters to be preserved
@@ -377,35 +394,69 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		/* wait for any prerequisite operations */
 		async_tx_quiesce(&submit->depend_tx);
 
-		/* recompute p and/or q into the temporary buffer and then
+		/* recompute parity into the temporary buffer and then
 		 * check to see the result matches the current value
 		 */
 		tx = NULL;
 		*pqres = 0;
-		if (p_src) {
+
+		/* remove any missing parity at the end, reducing the */
+		/* computation complexity required */
+		while (parity_disks > 0 && parity[parity_disks-1] == 0)
+			--parity_disks;
+
+		if (parity_disks == 1) {
+			void *c_ptr;
+			void *p_ptr;
+
+			/* special case with only one parity */
 			init_async_submit(submit, ASYNC_TX_XOR_ZERO_DST, NULL,
 					  NULL, NULL, scribble);
-			tx = async_xor(spare, blocks, offset, disks-2, len, submit);
+			BUG_ON(spare[0] == 0);
+			tx = async_xor(spare[0], blocks, offset, data_disks, len, submit);
 			async_tx_quiesce(&tx);
-			p = page_address(p_src) + offset;
-			s = page_address(spare) + offset;
-			*pqres |= !!memcmp(p, s, len) << SUM_CHECK_P;
-		}
 
-		if (q_src) {
-			P(blocks, disks) = NULL;
-			Q(blocks, disks) = spare;
+			c_ptr = page_address(parity[0]) + offset;
+			p_ptr = page_address(spare[0]) + offset;
+			*pqres |= !!memcmp(c_ptr, p_ptr, len) << SUM_CHECK_P;
+		} else if (parity_disks >= 2) {
+			/* general case with at least two parities */
+			struct page *copy[parity_disks];
+			int i;
+
+			/* save the parity pointers */
+			for (i = 0; i < parity_disks; ++i)
+				copy[i] = parity[i];
+
+			/* uses the spare buffers for the new parity */
+			for (i = 0; i < parity_disks; ++i) {
+				BUG_ON(spare[i] == 0);
+				parity[i] = spare[i];
+			}
+
 			init_async_submit(submit, 0, NULL, NULL, NULL, scribble);
-			tx = async_gen_syndrome(blocks, offset, disks, len, submit);
+			tx = async_raid_gen(blocks, offset, data_disks, parity_disks, len, submit);
 			async_tx_quiesce(&tx);
-			q = page_address(q_src) + offset;
-			s = page_address(spare) + offset;
-			*pqres |= !!memcmp(q, s, len) << SUM_CHECK_Q;
-		}
 
-		/* restore P, Q and submit */
-		P(blocks, disks) = p_src;
-		Q(blocks, disks) = q_src;
+			/* comparison of the result */
+			for (i = 0; i < parity_disks; ++i) {
+				void *c_ptr;
+				void *p_ptr;
+
+				/* don't check for missing parities */
+				if (copy[i] == 0)
+					continue;
+
+				c_ptr = page_address(copy[i]) + offset;
+				p_ptr = page_address(parity[i]) + offset;
+				if (memcmp(c_ptr, p_ptr, len) != 0)
+					*pqres |= 1 << (SUM_CHECK_P+i);
+			}
+
+			/* restore original parity */
+			for (i = 0; i < parity_disks; ++i)
+				parity[i] = copy[i];
+		}
 
 		submit->cb_fn = cb_fn_orig;
 		submit->cb_param = cb_param_orig;
@@ -415,7 +466,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		return NULL;
 	}
 }
-EXPORT_SYMBOL_GPL(async_syndrome_val);
+EXPORT_SYMBOL_GPL(async_raid_val);
 
 static int __init async_pq_init(void)
 {
@@ -437,5 +488,5 @@ static void __exit async_pq_exit(void)
 module_init(async_pq_init);
 module_exit(async_pq_exit);
 
-MODULE_DESCRIPTION("asynchronous raid6 syndrome generation/validation");
+MODULE_DESCRIPTION("asynchronous raid syndrome generation/validation");
 MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 934a849..ac43523 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/raid/raid.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
 #include <linux/dmaengine.h>
@@ -297,7 +298,7 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
 	blocks[disks-1] = dq;
 
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
+	tx = async_raid_gen(blocks, 0, disks-2, 2, bytes, submit);
 
 	/* Restore pointer table */
 	blocks[faila]   = dp;
@@ -346,41 +347,16 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
  * @blocks: array of source pointers where the last two entries are p and q
  * @submit: submission/completion modifiers
  */
-struct dma_async_tx_descriptor *
+static struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 			struct page **blocks, struct async_submit_ctl *submit)
 {
-	void *scribble = submit->scribble;
 	int non_zero_srcs, i;
 
 	BUG_ON(faila == failb);
-	if (failb < faila)
-		swap(faila, failb);
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
 
-	/* if a dma resource is not available or a scribble buffer is not
-	 * available punt to the synchronous path.  In the 'dma not
-	 * available' case be sure to use the scribble buffer to
-	 * preserve the content of 'blocks' as the caller intended.
-	 */
-	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
-		void **ptrs = scribble ? scribble : (void **) blocks;
-
-		async_tx_quiesce(&submit->depend_tx);
-		for (i = 0; i < disks; i++)
-			if (blocks[i] == NULL)
-				ptrs[i] = (void *) raid6_empty_zero_page;
-			else
-				ptrs[i] = page_address(blocks[i]);
-
-		raid6_2data_recov(disks, bytes, faila, failb, ptrs);
-
-		async_tx_sync_epilog(submit);
-
-		return NULL;
-	}
-
 	non_zero_srcs = 0;
 	for (i = 0; i < disks-2 && non_zero_srcs < 4; i++)
 		if (blocks[i])
@@ -409,7 +385,6 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 		return __2data_recov_n(disks, bytes, faila, failb, blocks, submit);
 	}
 }
-EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
 
 /**
  * async_raid6_datap_recov - asynchronously calculate a data and the 'p' block
@@ -419,7 +394,7 @@ EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
  * @blocks: array of source pointers where the last two entries are p and q
  * @submit: submission/completion modifiers
  */
-struct dma_async_tx_descriptor *
+static struct dma_async_tx_descriptor *
 async_raid6_datap_recov(int disks, size_t bytes, int faila,
 			struct page **blocks, struct async_submit_ctl *submit)
 {
@@ -435,28 +410,6 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
 
-	/* if a dma resource is not available or a scribble buffer is not
-	 * available punt to the synchronous path.  In the 'dma not
-	 * available' case be sure to use the scribble buffer to
-	 * preserve the content of 'blocks' as the caller intended.
-	 */
-	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
-		void **ptrs = scribble ? scribble : (void **) blocks;
-
-		async_tx_quiesce(&submit->depend_tx);
-		for (i = 0; i < disks; i++)
-			if (blocks[i] == NULL)
-				ptrs[i] = (void*)raid6_empty_zero_page;
-			else
-				ptrs[i] = page_address(blocks[i]);
-
-		raid6_datap_recov(disks, bytes, faila, ptrs);
-
-		async_tx_sync_epilog(submit);
-
-		return NULL;
-	}
-
 	good_srcs = 0;
 	good = -1;
 	for (i = 0; i < disks-2; i++) {
@@ -497,7 +450,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	} else {
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
-		tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
+		tx = async_raid_gen(blocks, 0, disks-2, 2, bytes, submit);
 	}
 
 	/* Restore pointer table */
@@ -524,8 +477,233 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 
 	return tx;
 }
-EXPORT_SYMBOL_GPL(async_raid6_datap_recov);
+
+/**
+ * async_raid6_data_recov - asynchronously calculate a data block
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: block size
+ * @faila: failed drive index
+ * @blocks: array of source pointers where the last two entries are p and q
+ * @submit: submission/completion modifiers
+ */
+static struct dma_async_tx_descriptor *
+async_raid6_data_recov(int disks, size_t bytes, int faila,
+			struct page **blocks, struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+	int data_disks = disks - 2;
+	struct page *dest;
+
+	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
+
+	/* replace data wiht P block */
+	dest = blocks[faila];
+	blocks[faila] = blocks[data_disks];
+
+	/* reconstruct data */
+	init_async_submit(submit, flags | ASYNC_TX_XOR_ZERO_DST,
+		tx, cb_fn, cb_param, scribble);
+	tx = async_xor(dest, blocks, 0, data_disks, bytes, submit);
+
+	/* restore pointer */
+	blocks[faila] = dest;
+
+	return tx;
+}
+
+/**
+ * async_raid6_data_recov - asynchronously calculate the 'p' block
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: block size
+ * @blocks: array of source pointers where the last two entries are p and q
+ * @submit: submission/completion modifiers
+ */
+static struct dma_async_tx_descriptor *
+async_raid6_p_recov(int disks, size_t bytes,
+			struct page **blocks, struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+	int data_disks = disks - 2;
+	struct page *dest;
+
+	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
+
+	dest = blocks[data_disks];
+
+	/* reconstruct data */
+	init_async_submit(submit, flags | ASYNC_TX_XOR_ZERO_DST,
+		tx, cb_fn, cb_param, scribble);
+	tx = async_xor(dest, blocks, 0, data_disks, bytes, submit);
+
+	return tx;
+}
+
+/**
+ * async_raid6_q_recov - asynchronously calculate the 'q' block
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: block size
+ * @blocks: array of source pointers where the last two entries are p and q
+ * @submit: submission/completion modifiers
+ */
+static struct dma_async_tx_descriptor *
+async_raid6_q_recov(int disks, size_t bytes,
+			struct page **blocks, struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+	int data_disks = disks - 2;
+	struct page *dest;
+
+	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
+
+	/* clear P to avoid to rebuild it */
+	dest = blocks[data_disks];
+	blocks[data_disks] = NULL;
+
+	/* recompute Q */
+	init_async_submit(submit, flags, tx, cb_fn, cb_param, scribble);
+	tx = async_raid_gen(blocks, 0, data_disks, 2, bytes, submit);
+
+	/* restore pointer */
+	blocks[data_disks] = dest;
+
+	return tx;
+}
+
+/**
+ * async_raid6_dataq_recov - asynchronously calculate a data and the 'q' block
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: block size
+ * @faila: failed drive index
+ * @blocks: array of source pointers where the last two entries are p and q
+ * @submit: submission/completion modifiers
+ */
+static struct dma_async_tx_descriptor *
+async_raid6_dataq_recov(int disks, size_t bytes, int faila,
+			struct page **blocks, struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+	int data_disks = disks - 2;
+	struct page *dest;
+
+	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
+
+	/* replace data wiht P block */
+	dest = blocks[faila];
+	blocks[faila] = blocks[data_disks];
+
+	/* reconstruct data */
+	init_async_submit(submit, ASYNC_TX_FENCE | ASYNC_TX_XOR_ZERO_DST,
+			tx, NULL, NULL, scribble);
+	tx = async_xor(dest, blocks, 0, data_disks, bytes, submit);
+
+	/* restore pointer */
+	blocks[faila] = dest;
+
+	/* clear P to avoid to rebuild it */
+	dest = blocks[data_disks];
+	blocks[data_disks] = NULL;
+
+	/* recompute Q */
+	init_async_submit(submit, flags, tx, cb_fn, cb_param, scribble);
+	tx = async_raid_gen(blocks, 0, data_disks, 2, bytes, submit);
+
+	/* restore pointer */
+	blocks[data_disks] = dest;
+
+	return tx;
+}
+
+struct dma_async_tx_descriptor *
+async_raid_rec(int rec_disks, int *rec_index,
+			int data_disks, int parity_disks, size_t bytes,
+			struct page **blocks, struct async_submit_ctl *submit)
+{
+	int disks = data_disks + parity_disks;
+	void *scribble = submit->scribble;
+	void **ptrs;
+	int i;
+
+	/* async is supported only for two parities */
+	/* and it needs both dma resources and the scribble buffer */
+	if (parity_disks == 2
+		&& scribble
+		&& async_dma_find_channel(DMA_PQ)) {
+
+		if (rec_disks == 1) {
+			/* recover data from P */
+			if (rec_index[0] < data_disks)
+				return async_raid6_data_recov(data_disks,
+					bytes, rec_index[0], blocks, submit);
+
+			/* recompute P */
+			if (rec_index[0] == data_disks)
+				return async_raid6_p_recov(disks, bytes,
+					blocks, submit);
+
+			/* recompute Q */
+			return async_raid6_q_recov(disks, bytes, blocks, submit);
+		}
+
+		if (rec_disks == 2) {
+			/* recover two data from P and Q */
+			if (rec_index[1] < data_disks)
+				return async_raid6_2data_recov(disks, bytes,
+					rec_index[0], rec_index[1], blocks,
+					submit);
+
+			/* recover data and P from Q */
+			if (rec_index[1] == data_disks)
+				return async_raid6_datap_recov(disks, bytes,
+					rec_index[0], blocks, submit);
+
+			/* recover data and Q from P */
+			if (rec_index[1] == data_disks + 1)
+				return async_raid6_dataq_recov(disks, bytes,
+					rec_index[0], blocks, submit);
+
+			/* recompute P and Q */
+			return async_raid_gen(blocks, 0, data_disks, 2, bytes,
+				submit);
+		}
+	}
+
+	/* in the 'dma not available' case be sure to use the scribble */
+	/* buffer preserve the content of 'blocks' as the caller intended */
+	ptrs = scribble ? scribble : (void **)blocks;
+
+	/* proceed syncronously */
+	async_tx_quiesce(&submit->depend_tx);
+
+	for (i = 0; i < disks; ++i)
+		if (blocks[i] == NULL)
+			ptrs[i] = (void *)raid6_empty_zero_page;
+		else
+			ptrs[i] = page_address(blocks[i]);
+
+	raid_rec(rec_disks, rec_index, data_disks, parity_disks, bytes, ptrs);
+
+	async_tx_sync_epilog(submit);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(async_raid_rec);
 
 MODULE_AUTHOR("Dan Williams <dan.j.williams@intel.com>");
-MODULE_DESCRIPTION("asynchronous RAID-6 recovery api");
+MODULE_DESCRIPTION("asynchronous raid recovery api");
 MODULE_LICENSE("GPL");
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f2ccbc3..6b0e3ae 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -121,6 +121,7 @@ config MD_RAID10
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
+	select RAID_CAUCHY
 	select RAID6_PQ
 	select ASYNC_MEMCPY
 	select ASYNC_XOR
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cc055da..6474655 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -45,7 +45,8 @@
 
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
-#include <linux/raid/pq.h>
+#include <linux/raid/raid.h>
+#include <linux/raid/helper.h>
 #include <linux/async_tx.h>
 #include <linux/module.h>
 #include <linux/async.h>
@@ -1165,170 +1166,60 @@ static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
+ops_run_compute6(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
+	int i, count;
 	int disks = sh->disks;
-	struct page **blocks = percpu->scribble;
-	int target;
-	int qd_idx = sh->qd_idx;
-	struct dma_async_tx_descriptor *tx;
-	struct async_submit_ctl submit;
-	struct r5dev *tgt;
-	struct page *dest;
-	int i;
-	int count;
-
-	if (sh->ops.target < 0)
-		target = sh->ops.target2;
-	else if (sh->ops.target2 < 0)
-		target = sh->ops.target;
-	else
-		/* we should only have one valid target */
-		BUG();
-	BUG_ON(target < 0);
-	pr_debug("%s: stripe %llu block: %d\n",
-		__func__, (unsigned long long)sh->sector, target);
-
-	tgt = &sh->dev[target];
-	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
-	dest = tgt->page;
-
-	atomic_inc(&sh->count);
-
-	if (target == qd_idx) {
-		count = set_syndrome_sources(blocks, sh);
-		blocks[count] = NULL; /* regenerating p is not necessary */
-		BUG_ON(blocks[count+1] != dest); /* q should already be set */
-		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
-				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
-		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
-	} else {
-		/* Compute any data- or p-drive using XOR */
-		count = 0;
-		for (i = disks; i-- ; ) {
-			if (i == target || i == qd_idx)
-				continue;
-			blocks[count++] = sh->dev[i].page;
-		}
-
-		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
-				  NULL, ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
-		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
-	}
-
-	return tx;
-}
-
-static struct dma_async_tx_descriptor *
-ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
-{
-	int i, count, disks = sh->disks;
-	int syndrome_disks = sh->ddf_layout ? disks : disks-2;
+	int parity_disks = 2;
+	int data_disks = sh->ddf_layout ? disks : disks - parity_disks;
 	int d0_idx = raid6_d0(sh);
-	int faila = -1, failb = -1;
 	int target = sh->ops.target;
 	int target2 = sh->ops.target2;
-	struct r5dev *tgt = &sh->dev[target];
-	struct r5dev *tgt2 = &sh->dev[target2];
-	struct dma_async_tx_descriptor *tx;
 	struct page **blocks = percpu->scribble;
 	struct async_submit_ctl submit;
+	int nfail;
+	int fail[RAID_PARITY_MAX];
 
 	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
 		 __func__, (unsigned long long)sh->sector, target, target2);
-	BUG_ON(target < 0 || target2 < 0);
-	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
-	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
+
+	BUG_ON(target >= 0 && !test_bit(R5_Wantcompute, &sh->dev[target].flags));
+	BUG_ON(target2 >= 0 && !test_bit(R5_Wantcompute, &sh->dev[target2].flags));
 
 	/* we need to open-code set_syndrome_sources to handle the
-	 * slot number conversion for 'faila' and 'failb'
+	 * slot number conversion
 	 */
 	for (i = 0; i < disks ; i++)
 		blocks[i] = NULL;
+	nfail = 0;
 	count = 0;
 	i = d0_idx;
 	do {
-		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
+		int slot = raid6_idx_to_slot(i, sh, &count, data_disks);
 
 		blocks[slot] = sh->dev[i].page;
 
-		if (i == target)
-			faila = slot;
-		if (i == target2)
-			failb = slot;
+		if (i == target || i == target2) {
+			raid_insert(nfail, fail, slot);
+			++nfail;
+		}
+
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
 
-	BUG_ON(faila == failb);
-	if (failb < faila)
-		swap(faila, failb);
-	pr_debug("%s: stripe: %llu faila: %d failb: %d\n",
-		 __func__, (unsigned long long)sh->sector, faila, failb);
 
-	atomic_inc(&sh->count);
+	pr_debug("%s: stripe: %llu nfail: %d\n",
+		 __func__, (unsigned long long)sh->sector, nfail);
 
-	if (failb == syndrome_disks+1) {
-		/* Q disk is one of the missing disks */
-		if (faila == syndrome_disks) {
-			/* Missing P+Q, just recompute */
-			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
-					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu));
-			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
-						  STRIPE_SIZE, &submit);
-		} else {
-			struct page *dest;
-			int data_target;
-			int qd_idx = sh->qd_idx;
-
-			/* Missing D+Q: recompute D from P, then recompute Q */
-			if (target == qd_idx)
-				data_target = target2;
-			else
-				data_target = target;
+	atomic_inc(&sh->count);
 
-			count = 0;
-			for (i = disks; i-- ; ) {
-				if (i == data_target || i == qd_idx)
-					continue;
-				blocks[count++] = sh->dev[i].page;
-			}
-			dest = sh->dev[data_target].page;
-			init_async_submit(&submit,
-					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
-					  NULL, NULL, NULL,
-					  to_addr_conv(sh, percpu));
-			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
-				       &submit);
-
-			count = set_syndrome_sources(blocks, sh);
-			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
-					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu));
-			return async_gen_syndrome(blocks, 0, count+2,
-						  STRIPE_SIZE, &submit);
-		}
-	} else {
-		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
-				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
-		if (failb == syndrome_disks) {
-			/* We're missing D+P. */
-			return async_raid6_datap_recov(syndrome_disks+2,
-						       STRIPE_SIZE, faila,
-						       blocks, &submit);
-		} else {
-			/* We're missing D+D. */
-			return async_raid6_2data_recov(syndrome_disks+2,
-						       STRIPE_SIZE, faila, failb,
-						       blocks, &submit);
-		}
-	}
+	init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
+		  ops_complete_compute, sh,
+		  to_addr_conv(sh, percpu));
+	return async_raid_rec(nfail, fail, data_disks, parity_disks,
+		STRIPE_SIZE, blocks, &submit);
 }
 
-
 static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
@@ -1547,7 +1438,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 
 	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
 			  sh, to_addr_conv(sh, percpu));
-	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+	async_raid_gen(blocks, 0, count, 2, STRIPE_SIZE,  &submit);
 }
 
 static void ops_complete_check(void *stripe_head_ref)
@@ -1612,7 +1503,7 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
 			  sh, to_addr_conv(sh, percpu));
-	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
+	async_raid_val(srcs, 0, count, 2, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
 
@@ -1636,10 +1527,7 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 		if (level < 6)
 			tx = ops_run_compute5(sh, percpu);
 		else {
-			if (sh->ops.target2 < 0 || sh->ops.target < 0)
-				tx = ops_run_compute6_1(sh, percpu);
-			else
-				tx = ops_run_compute6_2(sh, percpu);
+			tx = ops_run_compute6(sh, percpu);
 		}
 		/* terminate the chain if reconstruct is not set to be run */
 		if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
@@ -5521,7 +5409,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	get_online_cpus();
 	for_each_possible_cpu(cpu) {
 		percpu = per_cpu_ptr(conf->percpu, cpu);
-		safe_put_page(percpu->spare_page);
+		safe_put_page(percpu->spare_page[0]);
+		safe_put_page(percpu->spare_page[1]);
 		kfree(percpu->scribble);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5553,14 +5442,17 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (conf->level == 6 && !percpu->spare_page)
-			percpu->spare_page = alloc_page(GFP_KERNEL);
+		if (conf->level == 6 && !percpu->spare_page[0]) {
+			percpu->spare_page[0] = alloc_page(GFP_KERNEL);
+			percpu->spare_page[1] = alloc_page(GFP_KERNEL);
+		}
 		if (!percpu->scribble)
 			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
 
 		if (!percpu->scribble ||
-		    (conf->level == 6 && !percpu->spare_page)) {
-			safe_put_page(percpu->spare_page);
+		    (conf->level == 6 && !percpu->spare_page[0])) {
+			safe_put_page(percpu->spare_page[0]);
+			safe_put_page(percpu->spare_page[1]);
 			kfree(percpu->scribble);
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
@@ -5569,9 +5461,11 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		safe_put_page(percpu->spare_page);
+		safe_put_page(percpu->spare_page[0]);
+		safe_put_page(percpu->spare_page[1]);
 		kfree(percpu->scribble);
-		percpu->spare_page = NULL;
+		percpu->spare_page[0] = NULL;
+		percpu->spare_page[1] = NULL;
 		percpu->scribble = NULL;
 		break;
 	default:
@@ -5584,7 +5478,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 static int raid5_alloc_percpu(struct r5conf *conf)
 {
 	unsigned long cpu;
-	struct page *spare_page;
+	struct page *spare_page[2];
 	struct raid5_percpu __percpu *allcpus;
 	void *scribble;
 	int err;
@@ -5598,12 +5492,18 @@ static int raid5_alloc_percpu(struct r5conf *conf)
 	err = 0;
 	for_each_present_cpu(cpu) {
 		if (conf->level == 6) {
-			spare_page = alloc_page(GFP_KERNEL);
-			if (!spare_page) {
+			spare_page[0] = alloc_page(GFP_KERNEL);
+			if (!spare_page[0]) {
+				err = -ENOMEM;
+				break;
+			}
+			spare_page[1] = alloc_page(GFP_KERNEL);
+			if (!spare_page[1]) {
 				err = -ENOMEM;
 				break;
 			}
-			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
+			per_cpu_ptr(conf->percpu, cpu)->spare_page[0] = spare_page[0];
+			per_cpu_ptr(conf->percpu, cpu)->spare_page[1] = spare_page[1];
 		}
 		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
 		if (!scribble) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 01ad8ae..5395f28 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -456,7 +456,7 @@ struct r5conf {
 	int			recovery_disabled;
 	/* per cpu variables */
 	struct raid5_percpu {
-		struct page	*spare_page; /* Used when checking P/Q in raid6 */
+		struct page	*spare_page[2]; /* Used when checking P/Q in raid6 */
 		void		*scribble;   /* space for constructing buffer
 					      * lists and performing address
 					      * conversions
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 179b38f..7222a18d 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -185,20 +185,19 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 struct dma_async_tx_descriptor *async_trigger_callback(struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
-async_gen_syndrome(struct page **blocks, unsigned int offset, int src_cnt,
+async_raid_gen(struct page **blocks, unsigned int offset,
+		   int data_disks, int parity_disks,
 		   size_t len, struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
-async_syndrome_val(struct page **blocks, unsigned int offset, int src_cnt,
-		   size_t len, enum sum_check_flags *pqres, struct page *spare,
+async_raid_val(struct page **blocks, unsigned int offset,
+		   int data_disks, int parity_disks,
+		   size_t len, enum sum_check_flags *pqres, struct page **spare,
 		   struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
-async_raid6_2data_recov(int src_num, size_t bytes, int faila, int failb,
-			struct page **ptrs, struct async_submit_ctl *submit);
-
-struct dma_async_tx_descriptor *
-async_raid6_datap_recov(int src_num, size_t bytes, int faila,
+async_raid_rec(int rec_disks, int *rec_indexes,
+			int data_disks, int parity_disks, size_t bytes,
 			struct page **ptrs, struct async_submit_ctl *submit);
 
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
-- 
1.7.12.1

