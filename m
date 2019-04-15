Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E925CC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B56B520651
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555316981;
	bh=PDSTdF5u4F304v9Nhn8o2kx4AGJ20qmFZ66upUT9jLU=;
	h=From:To:Subject:Date:List-ID:From;
	b=goGos/ejqIYtO+Kgd0HjpN0cMkg8bK7Yh6s+0gRhSeQwVXnPIVnjJXL4UQq8FpQG3
	 UT1+6dc0BmcIU//PQWgLacyFlLHfWGDY1VhGG6GXiA7a7VYScl24aAqqzwmsjK0LI8
	 RwTtPufIYGfxEElyxPBBMfnkmFTTn55K0oMNx6Us=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfDOI3k (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfDOI3k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 04:29:40 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5270C20651
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 08:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555316979;
        bh=PDSTdF5u4F304v9Nhn8o2kx4AGJ20qmFZ66upUT9jLU=;
        h=From:To:Subject:Date:From;
        b=hOQuTaVwsXgyT5JMONZWSkDgWPpvEk277mFapxlLShQm97uh8cmJSzJ+VPlu1xvUE
         ShwhhK1px1DQps9f8/FI8gAPZVPYdm9rmVXeAVmp78x5yrMdSTKZhfMyKI75L2MFZf
         IuW5RdIFVJXwSp+4w9USd6uOXCG0i/NFecQyob60=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: send, flush dellaloc in order to avoid data loss
Date:   Mon, 15 Apr 2019 09:29:36 +0100
Message-Id: <20190415082936.2173-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When we set a subvolume to read-only mode we do not flush dellaloc for any
of its inodes (except if the filesystem is mounted with -o flushoncommit),
since it does not affect correctness for any subsequent operations - except
for a future send operation. The send operation will not be able to see the
delalloc data since the respective file extent items, inode item updates,
backreferences, etc, have not hit yet the subvolume and extent trees.

Effectively this means data loss, since the send stream will not contain
any data from existing delalloc. Another problem from this is that if the
writeback starts and finishes while the send operation is in progress, we
have the subvolume tree being being modified concurrently which can result
in send failing unexpectedly with EIO or hitting runtime errors, assertion
failures or hitting BUG_ONs, etc.

Simple reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ btrfs subvolume create /mnt/sv
  $ xfs_io -f -c "pwrite -S 0xea 0 108K" /mnt/sv/foo

  $ btrfs property set /mnt/sv ro true
  $ btrfs send -f /tmp/send.stream /mnt/sv

  $ od -t x1 -A d /mnt/sv/foo
  0000000 ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea
  *
  0110592

  $ umount /mnt
  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt

  $ btrfs receive -f /tmp/send.stream /mnt
  $ echo $?
  0
  $ od -t x1 -A d /mnt/sv/foo
  0000000
  # ---> empty file

Since this a problem that affects send only, fix it in send by flushing
dellaloc for all the roots used by the send operation before send starts
to process the commit roots.

This is a problem that affects send since it was introduced (commit
31db9f7c23fbf7 ("Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive"))
but backporting it to older kernels has some dependencies:

- For kernels between 3.19 and 4.20, it depends on commit 3cd24c698004d2
  ("btrfs: use tagged writepage to mitigate livelock of snapshot") because
  the function btrfs_start_delalloc_snapshot() does not exist before that
  commit. So one has to either pick that commit or replace the calls to
  btrfs_start_delalloc_snapshot() in this patch with calls to
  btrfs_start_delalloc_inodes().

- For kernels older than 3.19 it also requires commit e5fa8f865b3324
  ("Btrfs: ensure send always works on roots without orphans") because
  it depends on the function ensure_commit_roots_uptodate() which that
  commits introduced.

- No dependencies for 5.0+ kernels.

A test case for fstests follows soon.

CC: stable@vger.kernel.org # 3.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7ea2d6b1f170..fe700b228b5d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6579,6 +6579,38 @@ static int ensure_commit_roots_uptodate(struct send_ctx *sctx)
 	return btrfs_commit_transaction(trans);
 }
 
+/*
+ * Make sure any existing dellaloc is flushed for any root used by a send
+ * operation so that we do not miss any data and we do not race with writeback
+ * finishing and changing a tree while send is using the tree. This could
+ * happen if a subvolume is in RW mode, has delalloc, is turned to RO mode and
+ * a send operation then uses the subvolume.
+ * After flushing delalloc ensure_commit_roots_uptodate() must be called.
+ */
+static int flush_delalloc_roots(struct send_ctx *sctx)
+{
+	struct btrfs_root *root = sctx->parent_root;
+	int ret;
+	int i;
+
+	if (root) {
+		ret = btrfs_start_delalloc_snapshot(root);
+		if (ret)
+			return ret;
+		btrfs_wait_ordered_extents(root, U64_MAX, 0, U64_MAX);
+	}
+
+	for (i = 0; i < sctx->clone_roots_cnt; i++) {
+		root = sctx->clone_roots[i].root;
+		ret = btrfs_start_delalloc_snapshot(root);
+		if (ret)
+			return ret;
+		btrfs_wait_ordered_extents(root, U64_MAX, 0, U64_MAX);
+	}
+
+	return 0;
+}
+
 static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
 {
 	spin_lock(&root->root_item_lock);
@@ -6803,6 +6835,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 			NULL);
 	sort_clone_roots = 1;
 
+	ret = flush_delalloc_roots(sctx);
+	if (ret)
+		goto out;
+
 	ret = ensure_commit_roots_uptodate(sctx);
 	if (ret)
 		goto out;
-- 
2.11.0

