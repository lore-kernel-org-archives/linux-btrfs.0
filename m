Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F938C6786F
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 00:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0283A20664
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 00:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="0nuzy4He"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0283A20664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbeJaJKb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 05:10:31 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35516 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbeJaJKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 05:10:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id 32-v6so6476291pgu.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 17:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQ6rqXQXbCFJ6GGCv+neYgOTUu5Gm9/bxu7i6KeT7+8=;
        b=0nuzy4HeySjNzIj2QG06XTLnWs1h8B0/iQ+RiAJTljZ8JhDrv537bB4gRcqXslvq2P
         /5MQcJ/mTWFhm9m1IPGMMjO0TZ6QOCJI2t1waSrI9+SBoWK/8ouLYkqZTSR+/C+4MT8e
         grzJvk+gQMXY5mTET4DobyIzU0gZJ41Yto8DSO7SY8JN0ITW2Tv7UikKvieg69MPMdaX
         BQCW1q6rn7AUILDVRHv1JgqyU7I+G1hzErx5e4o30XLYU1is7hDRQIHKPdctktWCm09X
         V63Jl3bRzhI5qAUc6lcvawlLMcE2Zg2HQoiNS5KCtHcoJmeOWcChBvYUMYAQBoPGxvDs
         AFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQ6rqXQXbCFJ6GGCv+neYgOTUu5Gm9/bxu7i6KeT7+8=;
        b=ENkRRau+tCCctEF36Ctr3OWkEgh30WC9rjo+CgQyBV2QrjZmq3pgOutP/6HKuanVuF
         zlUt2jYkfYXaGjqUftuw7yn4X4oR6yh7N2oP1WE075f88S2b25UYTE762QWdszKSVGTU
         MZT58XSVEzstdSTfl5Yxm0oJPtp3+pITdiL8pLT/+edq2ek6YlmEB+vvA4P3+nhYOWRL
         20oAJIFoyHRtDWgyn0bAZSMyhk4rcKOTycOWC8+nidrumfxsZAg5fs/WmS5ApKb3p74V
         3SXrDffaXEWmnOV9JWN+69OxLfE6KMrg5FBSJtYES+oLlay73s9K2H29NEZmJjl1pYHl
         fJ0w==
X-Gm-Message-State: AGRZ1gLvIyWU1VHYHeu/XpkE61Axeg2f5O/ebESt6uIpPnYgRM9c4RJQ
        ZdQLlmcZluZVGDeOrIpm2Glwqik6D5I=
X-Google-Smtp-Source: AJdET5ekQUGIvK0oX4YFpd1zlKzaGy4blVT8pXnDsSXlAkxtOMz7L/PKmYxIKYqEmZ1YH2cljLLimg==
X-Received: by 2002:a63:5a57:: with SMTP id k23mr837861pgm.5.1540944889648;
        Tue, 30 Oct 2018 17:14:49 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:86b2])
        by smtp.gmail.com with ESMTPSA id f13-v6sm27960120pfa.109.2018.10.30.17.14.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Oct 2018 17:14:48 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH] Btrfs: fix missing delayed iputs on unmount
Date:   Tue, 30 Oct 2018 17:14:42 -0700
Message-Id: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
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
We found this with a stress test that our containers team runs. I'm
wondering if this same race could have caused any other issues other
than this new iput thing, but I couldn't identify any.

 fs/btrfs/disk-io.c | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0ab41da91d1..7c17284ae3c2 100644
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
@@ -3931,6 +3904,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	int ret;
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
+	kthread_park(fs_info->cleaner_kthread);
 
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
-- 
2.19.1

