Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7D5C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8686420834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="u3nRdZtJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8686420834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbeLCQHF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 11:07:05 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33812 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbeLCQHF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 11:07:05 -0500
Received: by mail-yb1-f195.google.com with SMTP id a67-v6so5509577ybg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 08:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=5RgYwqqSVSFbkShpgn7NvEoDIwCv3RrCPhGohzTUgTQ=;
        b=u3nRdZtJwEcCmCvvW4q0UU00DQx8Y2j4tA5hy9guzxT2bNP1s1czGB4R+HapCK8z05
         9y15iNJjPGot698VhxsGZZSCyMK/S0zAq8yR1RWbZWbQRJlNY61ndW13rmtjf0BsPHxO
         lKES/LoPYtPAlEEnSDjak0WItIpX0uR9cM3oRAEzqw+VvIAesw1TOFJK9Jh8pk8fz+0K
         7COP2ygERaDC7yFnzmQaxKqnBN2ny1Goa97BpMHUvmDunwakoc+Yrj+XG/g9YpQ+iRk3
         B9sYaaIjF5TM0UCrK1Df+EwyvY4eoR6lstwMoo5UFTONUNBJwK6la5E57RWiduW3QfbP
         A0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=5RgYwqqSVSFbkShpgn7NvEoDIwCv3RrCPhGohzTUgTQ=;
        b=XE5bDxCirt1sKE3z8foRtfYv+aQE9f11lIvu5saMYZfIeYZS90bLvYPMoQ5/uFinKD
         rr8wK4RRUltapFyOnOe9B3W+8qgqqZn8orW5Vt1/XeLdYdiYWfvPexWE/Bkcs5K80ZWh
         S0oZu7niS7wLc85fK88SmSS+Gtq5+fh/EkeJPkIAZxI+ULodqR8rl7kKna54Bi6y6sJ1
         BJLa/ciyi0KddsPlxiWTIlMOHyQtDEQ8f7rk5PAQQCLCC8IO5Z7fAiXc8UciWazw2Uo8
         LfbB5FqaitnjTtEm2ndFezyEJe/NfUtACIEF9if6Ai7Xs0JrdIrzpLstXKRLoUgfH//s
         MRTQ==
X-Gm-Message-State: AA+aEWamnNis+wURuJGTOIIPJKNZRUuUiZI0UgXeSOB/YujHSqRemHC7
        7TL4R3MyGfLYcJVWU5+BsuN8fPrTo+0=
X-Google-Smtp-Source: AFSGD/UrBiFieFISkfjrPYA1zBoJU1FjkyDI4/KxBZylT+WOxbPvnv9DGjMY2I7ZxZeOHpS9G43row==
X-Received: by 2002:a25:3b88:: with SMTP id i130-v6mr11727018yba.170.1543853218274;
        Mon, 03 Dec 2018 08:06:58 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j12sm1406963ywk.43.2018.12.03.08.06.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 08:06:57 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Date:   Mon,  3 Dec 2018 11:06:51 -0500
Message-Id: <20181203160652.25078-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203160652.25078-1-josef@toxicpanda.com>
References: <20181203160652.25078-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The cleaner thread usually takes care of delayed iputs, with the
exception of the btrfs_end_transaction_throttle path.  The cleaner
thread only gets woken up every 30 seconds, so instead wake it up to do
it's work so that we can free up that space as quickly as possible.

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

