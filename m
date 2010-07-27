From: bchociej@gmail.com
Subject: [RFC PATCH 1/5] Btrfs: Add experimental hot data hash list index
Date: Tue, 27 Jul 2010 17:00:19 -0500
Message-ID: <1280268023-18408-2-git-send-email-bchociej@gmail.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com,
	linux-kernel@vger.kernel.org
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bcchocie@us.ibm.com>

Adds a hash table structure to efficiently lookup the data temperature
of a file. Also adds a function to calculate that temperature based on
some metrics kept in custom frequency data structs.

Signed-off-by: Ben Chociej <bcchocie@us.ibm.com>
Signed-off-by: Matt Lupfer <mrlupfer@us.ibm.com>
Signed-off-by: Conor Scott <crscott@us.ibm.com>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Steve French <sfrench@us.ibm.com>
---
 fs/btrfs/hotdata_hash.c |  111 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hotdata_hash.h |   89 +++++++++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+), 0 deletions(-)
 create mode 100644 fs/btrfs/hotdata_hash.c
 create mode 100644 fs/btrfs/hotdata_hash.h

diff --git a/fs/btrfs/hotdata_hash.c b/fs/btrfs/hotdata_hash.c
new file mode 100644
index 0000000..a0de853
--- /dev/null
+++ b/fs/btrfs/hotdata_hash.c
@@ -0,0 +1,111 @@
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/hash.h>
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
+#include "async-thread.h"
+#include "ctree.h"
+
+/* set thread to update temperatures every 5 minutes */
+#define HEAT_UPDATE_DELAY (HZ * 60 * 5)
+
+struct heat_hashlist_node *alloc_heat_hashlist_node(gfp_t mask)
+{
+	struct heat_hashlist_node *node;
+
+	node = kmalloc(sizeof(struct heat_hashlist_node), mask);
+	if (!node || IS_ERR(node))
+		return node;
+	INIT_HLIST_NODE(&node->hashnode);
+	node->freq_data = NULL;
+	node->hlist = NULL;
+
+	return node;
+}
+
+void free_heat_hashlists(struct btrfs_root *root)
+{
+	int i;
+
+	/* Free node/range heat hash lists */
+	for (i = 0; i < HEAT_HASH_SIZE; i++) {
+		struct hlist_node *pos = NULL, *pos2 = NULL;
+		struct heat_hashlist_node *heatnode = NULL;
+
+		hlist_for_each_safe(pos, pos2,
+			&root->heat_inode_hl[i].hashhead) {
+			heatnode = hlist_entry(pos, struct heat_hashlist_node,
+				hashnode);
+			hlist_del(pos);
+			kfree(heatnode);
+		}
+
+		hlist_for_each_safe(pos, pos2,
+			&root->heat_range_hl[i].hashhead) {
+			heatnode = hlist_entry(pos, struct heat_hashlist_node,
+				hashnode);
+			hlist_del(pos);
+			kfree(heatnode);
+		}
+	}
+}
+
+/*
+ * Function that converts btrfs_freq_data structs to integer temperature
+ * values, determined by some constants in .h.
+ *
+ * This is not very calibrated, though we've gotten it in the ballpark.
+ */
+int btrfs_get_temp(struct btrfs_freq_data *fdata)
+{
+	u32 result = 0;
+
+	struct timespec ckt = current_kernel_time();
+	u64 cur_time = timespec_to_ns(&ckt);
+
+	u32 nrr_heat = fdata->nr_reads << NRR_MULTIPLIER_POWER;
+	u32 nrw_heat = fdata->nr_writes << NRW_MULTIPLIER_POWER;
+
+	u64 ltr_heat = (cur_time - timespec_to_ns(&fdata->last_read_time))
+			>> LTR_DIVIDER_POWER;
+	u64 ltw_heat = (cur_time - timespec_to_ns(&fdata->last_write_time))
+			>> LTW_DIVIDER_POWER;
+
+	u64 avr_heat = (((u64) -1) - fdata->avg_delta_reads)
+			>> AVR_DIVIDER_POWER;
+	u64 avw_heat = (((u64) -1) - fdata->avg_delta_writes)
+			>> AVR_DIVIDER_POWER;
+
+	if (ltr_heat >= ((u64) 1 << 32))
+		ltr_heat = 0;
+	else
+		ltr_heat = ((u64) 1 << 32) - ltr_heat;
+	/* ltr_heat is now guaranteed to be u32 safe */
+
+	if (ltw_heat >= ((u64) 1 << 32))
+		ltw_heat = 0;
+	else
+		ltw_heat = ((u64) 1 << 32) - ltw_heat;
+	/* ltw_heat is now guaranteed to be u32 safe */
+
+	if (avr_heat >= ((u64) 1 << 32))
+		avr_heat = (u32) -1;
+	/* avr_heat is now guaranteed to be u32 safe */
+
+	if (avw_heat >= ((u64) 1 << 32))
+		avr_heat = (u32) -1;
+	/* avw_heat is now guaranteed to be u32 safe */
+
+	nrr_heat = nrr_heat >> (3 - NRR_COEFF_POWER);
+	nrw_heat = nrw_heat >> (3 - NRW_COEFF_POWER);
+	ltr_heat = ltr_heat >> (3 - LTR_COEFF_POWER);
+	ltw_heat = ltw_heat >> (3 - LTW_COEFF_POWER);
+	avr_heat = avr_heat >> (3 - AVR_COEFF_POWER);
+	avw_heat = avw_heat >> (3 - AVW_COEFF_POWER);
+
+	result = nrr_heat + nrw_heat + (u32) ltr_heat +
+		 (u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;
+
+	return result >> (32 - HEAT_HASH_BITS);
+}
diff --git a/fs/btrfs/hotdata_hash.h b/fs/btrfs/hotdata_hash.h
new file mode 100644
index 0000000..46bf61e
--- /dev/null
+++ b/fs/btrfs/hotdata_hash.h
@@ -0,0 +1,89 @@
+#ifndef __HOTDATAHASH__
+#define __HOTDATAHASH__
+
+#include <linux/list.h>
+#include <linux/hash.h>
+
+#define HEAT_HASH_BITS 8
+#define HEAT_HASH_SIZE (1 << HEAT_HASH_BITS)
+#define HEAT_HASH_MASK (HEAT_HASH_SIZE - 1)
+#define HEAT_MIN_VALUE 0
+#define HEAT_MAX_VALUE (HEAT_HASH_SIZE - 1)
+#define HEAT_HOT_MIN (HEAT_HASH_SIZE - 50)
+
+/*
+ * The following comments explain what exactly comprises a unit of heat.
+ *
+ * Each of six values of heat are calculated and combined in order to form an
+ * overall temperature for the data:
+ *
+ * NRR - number of reads since mount
+ * NRW - number of writes since mount
+ * LTR - time elapsed since last read (ns)
+ * LTW - time elapsed since last write (ns)
+ * AVR - average delta between recent reads (ns)
+ * AVW - average delta between recent writes (ns)
+ *
+ * These values are divided (right-shifted) according to the *_DIVIDER_POWER
+ * values defined below to bring the numbers into a reasonable range. You can
+ * modify these values to fit your needs. However, each heat unit is a u32 and
+ * thus maxes out at 2^32 - 1. Therefore, you must choose your dividers quite
+ * carefully or else they could max out or be stuck at zero quite easily.
+ *
+ * (E.g., if you chose AVR_DIVIDER_POWER = 0, nothing less than 4s of atime
+ * delta would bring the temperature above zero, ever.)
+ *
+ * Finally, each value is added to the overall temperature between 0 and 8
+ * times, depending on its *_COEFF_POWER value. Note that the coefficients are
+ * also actually implemented with shifts, so take care to treat these values
+ * as powers of 2. (I.e., 0 means we'll add it to the temp once; 1 = 2x, etc.)
+ */
+
+#define NRR_MULTIPLIER_POWER 23
+#define NRR_COEFF_POWER 0
+#define NRW_MULTIPLIER_POWER 23
+#define NRW_COEFF_POWER 0
+#define LTR_DIVIDER_POWER 30
+#define LTR_COEFF_POWER 1
+#define LTW_DIVIDER_POWER 30
+#define LTW_COEFF_POWER 1
+#define AVR_DIVIDER_POWER 40
+#define AVR_COEFF_POWER 0
+#define AVW_DIVIDER_POWER 40
+#define AVW_COEFF_POWER 0
+
+/* TODO a kmem cache for entry structs */
+
+struct btrfs_root;
+
+/* Hash list heads for heat hash table */
+struct heat_hashlist_entry {
+	struct hlist_head hashhead;
+	rwlock_t rwlock;
+	u32 temperature;
+};
+
+/* Nodes stored in each hash list of hash table */
+struct heat_hashlist_node {
+	struct hlist_node hashnode;
+	struct btrfs_freq_data *freq_data;
+	struct heat_hashlist_entry *hlist;
+};
+
+struct heat_hashlist_node *alloc_heat_hashlist_node(gfp_t mask);
+void free_heat_hashlists(struct btrfs_root *root);
+
+/*
+ * Returns a value from 0 to HEAT_MAX_VALUE indicating the temperature of the
+ * file (and consequently its bucket number in hashlist)
+ */
+int btrfs_get_temp(struct btrfs_freq_data *fdata);
+
+/*
+ * recalculates temperatures for inode or range
+ * and moves around in heat hash table based on temp
+ */
+void btrfs_update_heat_index(struct btrfs_freq_data *fdata,
+			       struct btrfs_root *root);
+
+#endif /* __HOTDATAHASH__ */
-- 
1.7.1
