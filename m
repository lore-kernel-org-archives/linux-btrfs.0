Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EC4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 07:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D624E2133F
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 07:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbeLRH5q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 02:57:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:37692 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbeLRH5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 02:57:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39F35AD07
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 07:57:44 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: image: Only enlarge result image if it's regular file
Date:   Tue, 18 Dec 2018 15:57:40 +0800
Message-Id: <20181218075740.23723-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
misc-test/021 will fail with the following error message:

  ====== RUN CHECK root_helper btrfs-progs/btrfs-image -r btrfs-progs/tests//test.img /dev/loop2
  ERROR: failed to enlarge result image: Invalid argument
  ERROR: failed to fix chunks and devices mapping, the fs may not be mountable: Invalid argument
  extent buffer leak: start 30638080 len 16384
  extent buffer leak: start 30408704 len 16384
  WARNING: dirty eb leak (aborted trans): start 30408704 len 16384
  ERROR: restore failed: Invalid argument
  failed: root_helper btrfs-progs/btrfs-image -r btrfs-progs/tests//test.img /dev/loop2
  test failed for case 021-image-multi-devices

[CAUSE]
For misc-test/021, we're using loopback device, which doesn't support
ftruncate.
That's why it returns EINVAL.

[FIX]
Only call ftruncate64() if we're operating on a regluar file.

Fixes: a7a44164c84e ("btrfs-progs: image: Use correct device size when restoring")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/image/main.c b/image/main.c
index cff5cc87662c..4fba8283cec7 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2101,6 +2101,7 @@ static int fixup_device_size(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_key key;
+	struct stat buf;
 	u64 devid, cur_devid;
 	u64 dev_size; /* Get from last dev extents */
 	int ret;
@@ -2147,12 +2148,19 @@ static int fixup_device_size(struct btrfs_trans_handle *trans,
 
 	btrfs_set_stack_device_total_bytes(dev_item, dev_size);
 	btrfs_set_stack_device_bytes_used(dev_item, mdres->alloced_chunks);
-	/* Don't forget to enlarge the real file */
-	ret = ftruncate64(out_fd, dev_size);
+	ret = fstat(out_fd, &buf);
 	if (ret < 0) {
-		error("failed to enlarge result image: %m");
+		error("failed to stat result image: %m");
 		return -errno;
 	}
+	if (S_ISREG(buf.st_mode)) {
+		/* Don't forget to enlarge the real file */
+		ret = ftruncate64(out_fd, dev_size);
+		if (ret < 0) {
+			error("failed to enlarge result image: %m");
+			return -errno;
+		}
+	}
 
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
-- 
2.20.0

