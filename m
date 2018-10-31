Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E714C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 17:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0F420657
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 17:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="cBZ31fSU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB0F420657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbeKACFM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 22:05:12 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:45384 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbeKACFM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 22:05:12 -0400
Received: by mail-pg1-f173.google.com with SMTP id s3-v6so7657628pga.12
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 10:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0uWMi9Y8dVkPqrlojutJwrW7OS1qztyI26+t2Hh0Jz8=;
        b=cBZ31fSUAIxdq2TF3HUp5jSbvmgZxHuIKFBnORZL0EwrIxNTZRXUNY3ehv1yb5/ba3
         C7VVR4BF2a/Nx1JRPmnnk/m3tcuvARk1UdX8E/n8App/0kjGF/HwuHz3bk7pMcGw5mRH
         77eAaUzWwbtIXLHZTM3zJ1+tAJv7q2UqX4M7RR9ObrItGuldbOfLcX18JtdMNTufCtmn
         uvs8aPRI5ivK5KO6fB6WWvlAmE0mrwbaS6nqfODeq7imqyavySdIQU8aodRDn6YipSuY
         b64EiYyg/cLzvU5YZIlT9WEumxfClW7U7ViRZYSqTmwiA/YziumjU9n2YksxZWN6q2R/
         5RJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0uWMi9Y8dVkPqrlojutJwrW7OS1qztyI26+t2Hh0Jz8=;
        b=GlGKp8mersC+nuLuVPQd//LT0zy9FlGd+mxnoomFws4H2v70SxcC0hj0amNG0OTc9G
         uZJmB5fHYcTCvRBuxsk2JWrs/pm/qhU1NzcKX1inKRiMPyMZ70V5eIfWlB8TVsyo06X/
         HWYtOHK1VJi8pFfjkcq4VLiwOQZWOQgXIgRclyZGinYVrXjpBNX7nbDl2I2pUy3apc2B
         InggSdQX1+KeXb/BmUQTuWEyxoJp0ItdKNFzb5w71h7row2GGE65RJS701twC0qtrAsh
         EnkfoKBOtQd6rzjkYq5pXjzl22jOMhpEJhGlKuAysPEQFKSgy7zhGekg2AK7kwtxYvjO
         UfZQ==
X-Gm-Message-State: AGRZ1gKz+P6evDWha9Gd8wHxeK96sdj7uIlHuxeEDKMvynuYQEsuhQoE
        QPQbOM8PRlqJkkPM2UFnA7Ct/FsmIFk=
X-Google-Smtp-Source: AJdET5drtynyjIRgRMpfMLC/ig/lvCcM3gsh5XOpDUzU9gzY1qVUruGfYL4aLB9AIF+8bBzSzYGYGA==
X-Received: by 2002:a62:39d2:: with SMTP id u79-v6mr4271155pfj.116.1541005578035;
        Wed, 31 Oct 2018 10:06:18 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:deee])
        by smtp.gmail.com with ESMTPSA id v19-v6sm31671465pgl.80.2018.10.31.10.06.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 10:06:17 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Date:   Wed, 31 Oct 2018 10:06:08 -0700
Message-Id: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

There's a race between close_ctree() and cleaner_kthread().
close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
sees it set, but this is racy; the cleaner might have already checked
the bit and could be cleaning stuff. In particular, if it deletes unused
block groups, it will create delayed iputs for the free space cache
inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
longer running delayed iputs after a commit. Therefore, if the cleaner
creates more delayed iputs after delayed iputs are run in
btrfs_commit_super(), we will leak inodes on unmount and get a busy
inode crash from the VFS.

Fix it by parking the cleaner before we actually close anything. Then,
any remaining delayed iputs will always be handled in
btrfs_commit_super(). This also ensures that the commit in close_ctree()
is really the last commit, so we can get rid of the commit in
cleaner_kthread().

Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changes from v1:

- Add a comment explaining why it needs to be a kthread_park(), not
  kthread_stop()
- Update later comment now that the cleaner thread is definitely stopped

 fs/btrfs/disk-io.c | 51 ++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0ab41da91d1..40bcc45d827d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1664,9 +1664,8 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int again;
-	struct btrfs_trans_handle *trans;
 
-	do {
+	while (1) {
 		again = 0;
 
 		/* Make the cleaner go to sleep early. */
@@ -1715,42 +1714,16 @@ static int cleaner_kthread(void *arg)
 		 */
 		btrfs_delete_unused_bgs(fs_info);
 sleep:
+		if (kthread_should_park())
+			kthread_parkme();
+		if (kthread_should_stop())
+			return 0;
 		if (!again) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (!kthread_should_stop())
-				schedule();
+			schedule();
 			__set_current_state(TASK_RUNNING);
 		}
-	} while (!kthread_should_stop());
-
-	/*
-	 * Transaction kthread is stopped before us and wakes us up.
-	 * However we might have started a new transaction and COWed some
-	 * tree blocks when deleting unused block groups for example. So
-	 * make sure we commit the transaction we started to have a clean
-	 * shutdown when evicting the btree inode - if it has dirty pages
-	 * when we do the final iput() on it, eviction will trigger a
-	 * writeback for it which will fail with null pointer dereferences
-	 * since work queues and other resources were already released and
-	 * destroyed by the time the iput/eviction/writeback is made.
-	 */
-	trans = btrfs_attach_transaction(root);
-	if (IS_ERR(trans)) {
-		if (PTR_ERR(trans) != -ENOENT)
-			btrfs_err(fs_info,
-				  "cleaner transaction attach returned %ld",
-				  PTR_ERR(trans));
-	} else {
-		int ret;
-
-		ret = btrfs_commit_transaction(trans);
-		if (ret)
-			btrfs_err(fs_info,
-				  "cleaner open transaction commit returned %d",
-				  ret);
 	}
-
-	return 0;
 }
 
 static int transaction_kthread(void *arg)
@@ -3931,6 +3904,13 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	int ret;
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
+	/*
+	 * We don't want the cleaner to start new transactions, add more delayed
+	 * iputs, etc. while we're closing. We can't use kthread_stop() yet
+	 * because that frees the task_struct, and the transaction kthread might
+	 * still try to wake up the cleaner.
+	 */
+	kthread_park(fs_info->cleaner_kthread);
 
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
@@ -3958,9 +3938,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 
 	if (!sb_rdonly(fs_info->sb)) {
 		/*
-		 * If the cleaner thread is stopped and there are
-		 * block groups queued for removal, the deletion will be
-		 * skipped when we quit the cleaner thread.
+		 * The cleaner kthread is stopped, so do one final pass over
+		 * unused block groups.
 		 */
 		btrfs_delete_unused_bgs(fs_info);
 
-- 
2.19.1

