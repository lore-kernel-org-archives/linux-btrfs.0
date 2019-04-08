Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B3AC282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 04:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFBE620880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 04:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfDHE2E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 00:28:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:46164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbfDHE2E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 00:28:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7207ADE1
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Apr 2019 04:28:02 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs: tree-checker: Don't check device size as we can have valid 0 total_bytes
Date:   Mon,  8 Apr 2019 12:27:56 +0800
Message-Id: <20190408042756.25969-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Under the following call traces, btrfs can commit device with 0
total_bytes onto disk:
btrfs_rm_device()
|- btrfs_shrink_device()
|  |- btrfs_device_set_total_bytes(device, 0)
|  |- btrfs_update_device()
|  |- btrfs_commit_transaction() #1
|- btrfs_rm_dev_item()

This will trigger write time tree checker warning.
And further more, this can create valid btrfs with device->total_bytes
== 0 and triggering read time tree-checker if power loss happens after
above transaction #1 but before next transaction.

So this dev item check is too restrict.

Please fold this patch into commit 87d87c6dcbbe ("btrfs: tree-checker:
Verify dev item") in misc-next branch.

The fuzzed image can be already addressed by commit 1b3922a8bc74
("btrfs: Use real device structure to verify dev extent") thus we don't
need that strict check anymore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index d2c3c1f8870d..974208ac56da 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -657,16 +657,11 @@ static int check_dev_item(struct extent_buffer *leaf,
 	}
 
 	/*
-	 * Since btrfs device add doesn't check device size at all, we could
-	 * have device item whose size is smaller than 1M which is useless, but
-	 * still valid.
-	 * So here we can only check the obviously wrong case.
+	 * For device total_bytes, we don't have solid way to check it, as it can
+	 * be 0 for device removal.
+	 * device size check can only be done by dev extents check.
 	 */
-	if (btrfs_device_total_bytes(leaf, ditem) == 0) {
-		dev_item_err(leaf, slot,
-			     "invalid total bytes: have 0");
-		return -EUCLEAN;
-	}
+
 	if (btrfs_device_bytes_used(leaf, ditem) >
 	    btrfs_device_total_bytes(leaf, ditem)) {
 		dev_item_err(leaf, slot,
-- 
2.21.0

