Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A772C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 599E220675
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="qUHLWgYn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbfAKPVM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:21:12 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43566 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfAKPVL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 10:21:11 -0500
Received: by mail-qt1-f193.google.com with SMTP id i7so19157191qtj.10
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 07:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=3mI873Pq04W2n8OL+kvk9dbcJX9s+iX8qTSoSCTEPeg=;
        b=qUHLWgYnsyEvOXR/qbWOmhosWhg3rSlLgv/M6xD7iEvd9etWcwJU2wZtPjAsku4XW6
         M+ArvDeUadSR3W/lno3HKCD87G5Mhff1pOnyoH3P6FeFA9bH6zzvZsBDBOBDK/lj9HV1
         5JwpGzC3T3AZS0GvHXHuutgRuPdz7X3R7GdPF3Ky/csaCtI6EqfU56QCTMTZBcbI5Hog
         USxRoAuz9B7i5qK+6crYVcxPRu4uRpMjFDCKHzPqDLa0ExbkWWY7Qbp/NUH2KvNPOq/v
         Jc/dQnomPZy01EBiO7AmfktX3b/xggDu/tvJ8kWtzdI5NZQJwgXoVWodIRnAdpHBsWOQ
         Iadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=3mI873Pq04W2n8OL+kvk9dbcJX9s+iX8qTSoSCTEPeg=;
        b=ZmtFuby1uU1Lp7rOmRQ1R18S18arvhc/L94X5flD63xkisnE8+cdYBMYJNOyPoYfeG
         mjdfJWYrlZDwl8GEVkGrFnjVgvHCK/xWqkLL8qbvk1WMVI31m6sGtjeiZVu+zKcp/L2i
         bYx5Yw9aX9GoYFf3nPZOQKtmkdN2/6RTtluvXm7/icvcxk9SXwKKSQ8TW9LJZJVbqsKY
         YiljWW/SL1F9/otlq3dyuJPqh2LsbH2pZ1lk+xwG2PWH0SVUYCLxmPVnEK2bSWAQ9Wjr
         Zho99npJ6AY/ttDZbKiRghx/eZIgTkKkINZpOboC3pQL/lx3xnvQVDAu9pG77u0VOXeZ
         E1CQ==
X-Gm-Message-State: AJcUukf4GRDiZ1Ge34k8U9ntLYapZMFmMa01pJw4FMj+97Lu8+Fua/Y5
        PXAUPJwYaRBbOpTlAk15hPX9UtKsYZk=
X-Google-Smtp-Source: ALg8bN6jLsDNBFxHxwuKJEoiB5ZF86tfS8BM45Dw+HKT0EAMohs+NoJ424Y5ISdDiQhgghiGTEOyxA==
X-Received: by 2002:ac8:4910:: with SMTP id e16mr13946302qtq.332.1547220070354;
        Fri, 11 Jan 2019 07:21:10 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o42sm48139503qtc.90.2019.01.11.07.21.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jan 2019 07:21:09 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Date:   Fri, 11 Jan 2019 10:21:02 -0500
Message-Id: <20190111152103.17001-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190111152103.17001-1-josef@toxicpanda.com>
References: <20190111152103.17001-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The cleaner thread usually takes care of delayed iputs, with the
exception of the btrfs_end_transaction_throttle path.  Delaying iputs
means we are potentially delaying the eviction of an inode and it's
respective space.  The cleaner thread only gets woken up every 30
seconds, or when we require space.  If there are a lot of inodes that
need to be deleted we could induce a serious amount of latency while we
wait for these inodes to be evicted.  So instead wakeup the cleaner if
it's not already awake to process any new delayed iputs we add to the
list.  If we suddenly need space we will less likely be backed up
behind a bunch of inodes that are waiting to be deleted, and we could
possibly free space before we need to get into the flushing logic which
will save us some latency.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h   | 3 +++
 fs/btrfs/disk-io.c | 3 +++
 fs/btrfs/inode.c   | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c8ddbacb6748..dc56a4d940c3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -769,6 +769,9 @@ bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr);
  */
 #define BTRFS_FS_BALANCE_RUNNING		18
 
+/* Indicate that the cleaner thread is awake and doing something. */
+#define BTRFS_FS_CLEANER_RUNNING		19
+
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c5918ff8241b..f40f6fdc1019 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1669,6 +1669,8 @@ static int cleaner_kthread(void *arg)
 	while (1) {
 		again = 0;
 
+		set_bit(BTRFS_FS_CLEANER_RUNNING, &fs_info->flags);
+
 		/* Make the cleaner go to sleep early. */
 		if (btrfs_need_cleaner_sleep(fs_info))
 			goto sleep;
@@ -1715,6 +1717,7 @@ static int cleaner_kthread(void *arg)
 		 */
 		btrfs_delete_unused_bgs(fs_info);
 sleep:
+		clear_bit(BTRFS_FS_CLEANER_RUNNING, &fs_info->flags);
 		if (kthread_should_park())
 			kthread_parkme();
 		if (kthread_should_stop())
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8ac7abe2ae9b..0b9f3e482cea 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3264,6 +3264,8 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	ASSERT(list_empty(&binode->delayed_iput));
 	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
 	spin_unlock(&fs_info->delayed_iput_lock);
+	if (!test_bit(BTRFS_FS_CLEANER_RUNNING, &fs_info->flags))
+		wake_up_process(fs_info->cleaner_kthread);
 }
 
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
-- 
2.14.3

