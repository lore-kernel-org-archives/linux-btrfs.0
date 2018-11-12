Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA45C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 10:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57034223C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 10:24:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iz3mKqVa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57034223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbeKLUQh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbeKLUQh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 15:16:37 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B936223C8
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 10:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542018242;
        bh=eo2+TCZ4kz5M+/Im4xMCLD1qpMoLhfL7JLS1zAFVR7g=;
        h=From:To:Subject:Date:From;
        b=iz3mKqVaBuVoKMgZsflcTN6KS0/fHc+iFMiivXjEOQ5N7HeDFoH/ey+U1lOI0L3Hk
         PIPZjiWkB3Pd+aFuIdeK1Oz6fADzjJaemHBlF4+84bbdNpWmYpVh8MZ1O9df65La//
         IJWJvrm0f/yJ4Qv0fpq/qVJkW8wLnzrG6dsKwh78=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix rare chances for data loss when doing a fast fsync
Date:   Mon, 12 Nov 2018 10:23:58 +0000
Message-Id: <20181112102358.5669-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

After the simplification of the fast fsync patch done recently by commit
b5e6c3e170b7 ("btrfs: always wait on ordered extents at fsync time") and
commit e7175a692765 ("btrfs: remove the wait ordered logic in the
log_one_extent path"), we got a very short time window where we can get
extents logged without writeback completing first or extents logged
without logging the respective data checksums. Both issues can only happen
when doing a non-full (fast) fsync.

As soon as we enter btrfs_sync_file() we trigger writeback, then lock the
inode and then wait for the writeback to complete before starting to log
the inode. However before we acquire the inode's lock and after we started
writeback, it's possible that more writes happened and dirtied more pages.
If that happened and those pages get writeback triggered while we are
logging the inode (for example, the VM subsystem triggering it due to
memory pressure, or another concurrent fsync), we end up seeing the
respective extent maps in the inode's list of modified extents and will
log matching file extent items without waiting for the respective
ordered extents to complete, meaning that either of the following will
happen:

1) We log an extent after its writeback finishes but before its checksums
   are added to the csum tree, leading to -EIO errors when attempting to
   read the extent after a log replay.

2) We log an extent before its writeback finishes.
   Therefore after the log replay we will have a file extent item pointing
   to an unwritten extent (and without the respective data checksums as
   well).

This could not happen before the fast fsync patch simplification, because
for any extent we found in the list of modified extents, we would wait for
its respective ordered extent to finish writeback or collect its checksums
for logging if it did not complete yet.

Fix this by triggering writeback again after acquiring the inode's lock
and before waiting for ordered extents to complete.

Fixes: e7175a692765 ("btrfs: remove the wait ordered logic in the log_one_extent path")
Fixes: b5e6c3e170b7 ("btrfs: always wait on ordered extents at fsync time")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2be00e873e92..6483757f0c09 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2064,6 +2064,30 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	atomic_inc(&root->log_batch);
 
 	/*
+	 * Before we acquired the inode's lock, someone may have dirtied more
+	 * pages in the target range. We need to make sure that writeback for
+	 * any such pages does not start while we are logging the inode, because
+	 * if it does, any of the following might happen when we are not doing a
+	 * full inode sync:
+	 *
+	 * 1) We log an extent after its writeback finishes but before its
+	 *    checksums are added to the csum tree, leading to -EIO errors
+	 *    when attempting to read the extent after a log replay.
+	 *
+	 * 2) We can end up logging an extent before its writeback finishes.
+	 *    Therefore after the log replay we will have a file extent item
+	 *    pointing to an unwritten extent (and no data checksums as well).
+	 *
+	 * So trigger writeback for any eventual new dirty pages and then we
+	 * wait for all ordered extents to complete below.
+	 */
+	ret = start_ordered_ops(inode, start, end);
+	if (ret) {
+		inode_unlock(inode);
+		goto out;
+	}
+
+	/*
 	 * We have to do this here to avoid the priority inversion of waiting on
 	 * IO of a lower priority task while holding a transaciton open.
 	 */
-- 
2.11.0

