Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C47C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 08:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6AD2183F
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 08:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfCMIzW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:55:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:39104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727067AbfCMIzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 04:55:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C62B0AF74;
        Wed, 13 Mar 2019 08:55:19 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
Subject: [PATCH 2/6] btrfs: tree-checker: Verify dev item
Date:   Wed, 13 Mar 2019 16:55:07 +0800
Message-Id: <20190313085511.23540-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313085511.23540-1-wqu@suse.com>
References: <20190313085511.23540-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
For fuzzed image whose DEV_ITEM has invalid total_bytes as 0, then
kernel will just panic:
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
  #PF error: [normal kernel read fault]
  PGD 800000022b2bd067 P4D 800000022b2bd067 PUD 22b2bc067 PMD 0
  Oops: 0000 [#1] SMP PTI
  CPU: 0 PID: 1106 Comm: mount Not tainted 5.0.0-rc8+ #9
  RIP: 0010:btrfs_verify_dev_extents+0x2a5/0x5a0
  Call Trace:
   open_ctree+0x160d/0x2149
   btrfs_mount_root+0x5b2/0x680

[CAUSE]
If device extent verification finds a deivce with 0 total_bytes, then it
assumes it's a seed dummy, then search for seed devices.

But in this case, there is no seed device at all, causing NULL pointer.

[FIX]
Since this is caused by fuzzed image, let's go the tree-check way, just
add a new verification for device item.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202691
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 84 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c      |  9 -----
 fs/btrfs/volumes.h      |  9 +++++
 3 files changed, 93 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index fe3f37c23c29..5ccb4be583ea 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -594,6 +594,87 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+
+__printf(4, 5)
+__cold
+static void dev_item_err(const struct btrfs_fs_info *fs_info,
+			 const struct extent_buffer *eb, int slot,
+			 const char *fmt, ...)
+{
+	struct btrfs_key key;
+	struct va_format vaf;
+	va_list args;
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	btrfs_crit(fs_info,
+	"corrupt %s: root=%llu block=%llu slot=%d devid=%llu %pV",
+		btrfs_header_level(eb) == 0 ? "leaf" : "node",
+		btrfs_header_owner(eb), btrfs_header_bytenr(eb), slot,
+		key.objectid, &vaf);
+	va_end(args);
+}
+
+static int check_dev_item(struct btrfs_fs_info *fs_info,
+			  struct extent_buffer *leaf,
+			  struct btrfs_key *key, int slot)
+{
+	struct btrfs_dev_item *ditem;
+	u64 max_devid = max(BTRFS_MAX_DEVS(fs_info), BTRFS_MAX_DEVS_SYS_CHUNK);
+
+	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
+		dev_item_err(fs_info, leaf, slot,
+			     "invalid objectid: has=%llu expect=%llu",
+			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
+		goto error;
+	}
+	if (key->offset > max_devid) {
+		dev_item_err(fs_info, leaf, slot,
+			     "invalid devid: has=%llu expect=[0, %llu]",
+			     key->offset, max_devid);
+		goto error;
+	}
+	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
+	if (btrfs_device_id(leaf, ditem) != key->offset) {
+		dev_item_err(fs_info, leaf, slot,
+			     "devid mismatch: key has=%llu item has=%llu",
+			     key->offset, btrfs_device_id(leaf, ditem));
+		goto error;
+	}
+
+	/*
+	 * Since btrfs device add doesn't check device size at all, we could
+	 * have device item whose size is smaller than 1M which is useless, but
+	 * still valid.
+	 * So here we can only check the obviously wrong case.
+	 */
+	if (btrfs_device_total_bytes(leaf, ditem) == 0) {
+		dev_item_err(fs_info, leaf, slot,
+			     "invalid total bytes: have 0");
+		goto error;
+	}
+	if (btrfs_device_bytes_used(leaf, ditem) >
+	    btrfs_device_total_bytes(leaf, ditem)) {
+		dev_item_err(fs_info, leaf, slot,
+			     "invalid bytes used: have %llu expect [0, %llu]",
+			     btrfs_device_bytes_used(leaf, ditem),
+			     btrfs_device_total_bytes(leaf, ditem));
+		goto error;
+	}
+	/*
+	 * Remaining members like io_align/type/gen/dev_group aren't really
+	 * utilized.
+	 * Skip them to make later usage of them easier.
+	 */
+	return 0;
+error:
+	return -EUCLEAN;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -624,6 +705,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk,
 					      key->offset);
 		break;
+	case BTRFS_DEV_ITEM_KEY:
+		ret = check_dev_item(fs_info, leaf, key, slot);
+		break;
 	}
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e3822870f1e..0b839ecbe73f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4964,15 +4964,6 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 	btrfs_set_fs_incompat(info, RAID56);
 }
 
-#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
-			- sizeof(struct btrfs_chunk))		\
-			/ sizeof(struct btrfs_stripe) + 1)
-
-#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
-				- 2 * sizeof(struct btrfs_disk_key)	\
-				- 2 * sizeof(struct btrfs_chunk))	\
-				/ sizeof(struct btrfs_stripe) + 1)
-
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			       u64 start, u64 type)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ed806649a473..481c012eae79 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -258,6 +258,15 @@ struct btrfs_fs_devices {
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
 
+#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
+			- sizeof(struct btrfs_chunk))		\
+			/ sizeof(struct btrfs_stripe) + 1)
+
+#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
+				- 2 * sizeof(struct btrfs_disk_key)	\
+				- 2 * sizeof(struct btrfs_chunk))	\
+				/ sizeof(struct btrfs_stripe) + 1)
+
 /*
  * we need the mirror number and stripe index to be passed around
  * the call chain while we are processing end_io (especially errors).
-- 
2.21.0

