Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD3CC64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 14:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D99242064E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 14:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="drC6gKhK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D99242064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbeJIVWk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 17:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeJIVWj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 17:22:39 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB472064E
        for <linux-btrfs@vger.kernel.org>; Tue,  9 Oct 2018 14:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539093932;
        bh=zdMyp0crPCpjQQQB5/GKpYIiwcJlXuIg4vPENAIrV7I=;
        h=From:To:Subject:Date:From;
        b=drC6gKhK5KtpQgcDIxTY+ZUnPNoI+MjKHZ6YhHYRvMwFOAaeZX1sxnapBZc5+C3Aj
         9an3ORkxFyNWKm1b/wohHEIzu8J4znOC5rzWcUR1Ib+ZmdeF4iCN8XK9Fu1JtPPJEA
         terd4gWLXCn7wWgo+hKXxBUIzXrKwHYExbpHbdss=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix wrong dentries after fsync of file that got its parent replaced
Date:   Tue,  9 Oct 2018 15:05:29 +0100
Message-Id: <20181009140529.21196-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

In a scenario like the following:

  mkdir /mnt/A               # inode 258
  mkdir /mnt/B               # inode 259
  touch /mnt/B/bar           # inode 260

  sync

  mv /mnt/B/bar /mnt/A/bar
  mv -T /mnt/A /mnt/B
  fsync /mnt/B/bar

  <power fail>

After replaying the log we end up with file bar having 2 hard links, both
with the name 'bar' and one in the directory with inode number 258 and the
other in the directory with inode number 259. Also, we end up with the
directory inode 259 still existing and with the directory inode 258 still
named as 'A', instead of 'B'. In this scenario, file 'bar' should only
have one hard link, located at directory inode 258, the directory inode
259 should not exist anymore and the name for directory inode 258 should
be 'B'.

This incorrect behaviour happens because when attempting to log the old
parents of an inode, we skip any parents that no longer exist. Fix this
by forcing a full commit if an old parent no longer exists.

A test case for fstests follows soon.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5e83991eb064..eeeeed455dba 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5580,9 +5580,33 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 
 			dir_inode = btrfs_iget(fs_info->sb, &inode_key,
 					       root, NULL);
-			/* If parent inode was deleted, skip it. */
-			if (IS_ERR(dir_inode))
-				continue;
+			/*
+			 * If the parent inode was deleted, return an error to
+			 * fallback to a transaction commit. This is to prevent
+			 * getting an inode that was moved from one parent A to
+			 * a parent B, got its former parent A deleted and then
+			 * it got fsync'ed, from existing at both parents after
+			 * a log replay (and the old parent still existing).
+			 * Example:
+			 *
+			 * mkdir /mnt/A
+			 * mkdir /mnt/B
+			 * touch /mnt/B/bar
+			 * sync
+			 * mv /mnt/B/bar /mnt/A/bar
+			 * mv -T /mnt/A /mnt/B
+			 * fsync /mnt/B/bar
+			 * <power fail>
+			 *
+			 * If we ignore the old parent B which got deleted,
+			 * after a log replay we would have file bar linked
+			 * at both parents and the old parent B would still
+			 * exist.
+			 */
+			if (IS_ERR(dir_inode)) {
+				ret = PTR_ERR(dir_inode);
+				goto out;
+			}
 
 			if (ctx)
 				ctx->log_new_dentries = false;
-- 
2.11.0

