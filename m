Return-Path: <SRS0=6pDE=46=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E38C4CECE
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 21:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2E132074F
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 21:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Yd9FuFC+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgCMVXo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 17:23:44 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:43216 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgCMVXo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Mar 2020 17:23:44 -0400
Received: by mail-qv1-f67.google.com with SMTP id c28so5431577qvb.10
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2020 14:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YBJkJuMpBGnG4PHi3yFYn+w8JBNwF9a/L5wN0S+C4BI=;
        b=Yd9FuFC+f9xjT1WRQgkGlkYA02u6Zx1vG09rlhhW3CpjA8qWjtcpmFSMQXQHRNFsWj
         rVEOxcWVml/oeeOUFVgWuNUr9B+kAbbRqlCvbTncFUHCD+rm3ohMEyvBD89xlV6PO88M
         g9/G4d3TA+RdEC6MTBptFIqZ6FXTm2DG5WtF7lodMmRqkR0RJyIdI2exfpbS28iHCipH
         nY9ATAXJV4IIknANBZJ7vksX+QYExzMI8Uuxluz1du67dVYehkWUB7jh2B7WFnD2t2Qu
         xmvuMXmQgbp0WLlgrKBRv96Dt6WBvnbAqZS5+xtN8pnI00i7yT/ZE278oIQHikGFR++o
         lxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YBJkJuMpBGnG4PHi3yFYn+w8JBNwF9a/L5wN0S+C4BI=;
        b=jCVChb+ZTmVQT+Y/yTFuoWDoMwvgNQSfQ2PR5rKMDLjUFhqrfUEKHTe0byYwmBU471
         ri3bc2+UkiyjImxSXM26x0HeFJkHYOAZ5gR3Y5XUsKs7Nkv640zfeIagCqJgdj7cSrul
         q7kRm24HdpYnd6Ut7IjYDROUcCpqBjqyKmR8kB2F7Mfn3Ypg1UWiuNpYqE84s0gMoO7W
         /l+RK7mKR3zMxmqcHrZguhJRrt2qr/rkKjdg4ZKpxcARmQWINg9I6d5ZvYXyB4zNv7hz
         CedikeFsQuxa9Qf/Tqt2HUbWvBkN2M0ENZUTMbKh9NO/FF/ShIJz7NsXTQKFmFv/b2R4
         motw==
X-Gm-Message-State: ANhLgQ07kFNRnbZoX2WQqXcPcrqDyeVtAEcFMYyQCk83HeVnrSpgCohM
        fdtKMn1MlcegL7I3SFgjzGKo/pA3tJpceg==
X-Google-Smtp-Source: ADFU+vtcu6EZMI4iswnBrZth0zZdpneZPY+x4wnEbOm97sMUlbFA3+q/Q8ZD0JZSmf6w82gq8ZNYwg==
X-Received: by 2002:ad4:514b:: with SMTP id g11mr14717482qvq.25.1584134621456;
        Fri, 13 Mar 2020 14:23:41 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id q7sm797361qti.58.2020.03.13.14.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:23:40 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 05/13] btrfs: squash should_end_transaction
Date:   Fri, 13 Mar 2020 17:23:22 -0400
Message-Id: <20200313212330.149024-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313212330.149024-1-josef@toxicpanda.com>
References: <20200313212330.149024-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We used to call should_end_transaction() in __btrfs_end_transaction, but
we no longer do that and it's a tiny function, so squash it into
btrfs_should_end_transaction.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 309a2a60040f..f6eecb402f5b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -855,27 +855,21 @@ void btrfs_throttle(struct btrfs_fs_info *fs_info)
 	wait_current_trans(fs_info);
 }
 
-static int should_end_transaction(struct btrfs_trans_handle *trans)
-{
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-
-	if (btrfs_should_throttle_delayed_refs(trans) ||
-	    btrfs_check_space_for_delayed_refs(fs_info))
-		return 1;
-
-	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
-}
-
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 
 	smp_mb();
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START ||
 	    cur_trans->delayed_refs.flushing)
 		return 1;
 
-	return should_end_transaction(trans);
+	if (btrfs_should_throttle_delayed_refs(trans) ||
+	    btrfs_check_space_for_delayed_refs(fs_info))
+		return 1;
+
+	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
 }
 
 static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans)
-- 
2.24.1

