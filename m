Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE817C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5B3720834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="b6UJ0E16"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5B3720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbeLCPUr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:47 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36530 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPUq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:46 -0500
Received: by mail-yw1-f66.google.com with SMTP id y194so5524707ywg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GhTGuLJR3TTmW9f1Z2iNY5zzX2M92cRLSuapIejz8FE=;
        b=b6UJ0E167ETa2nuCLPRFgHcMpopC1D9sg3QKAjFTrPF+vVlthTrv7aBX/mpWbag8sb
         FviFTCuMMMVcud7cG9s7H67J8Nb8cpmlGwQt5+WuGybe1RLD/iQZNHUQNyYbT54PXyCk
         bwykGz4BN2fxgxHU8gzz+wVn3uv++BwHapW7rKGOFjlF4kgNuUQkrjxWkpFkculDND9c
         gR025Fpt6itOTFfcIQQO+0K8cib5/J973rUYZMtDFf/3YvsTmLbdk5bNj5yIo+5AK4Ka
         Xp62NntngN2Agk3RHcGLkuy6ObaE58vP9PQ/Adg5+AYkwfrCF+VZwRi/hcOgDkE+VJEd
         ulNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GhTGuLJR3TTmW9f1Z2iNY5zzX2M92cRLSuapIejz8FE=;
        b=G03ONGysW0n/KQ2ZiiId0CBTcLahzZh8nONgz6DEBNyYdcLRLmkCs5+nr1THMRNbU8
         n1l5dt25xWYx/mdSFVFWSdeMUQfB3ibeDNhJHj1720mxcxjENNyNCRDI3u6OIuWAid0p
         cdDyi8YbabfAemTFYIWGXF67lJUJzjXVwZXauQXKXv0Pnq/r3l/WqFt42Y24t8FeOiNL
         sI/YgzyN11dB//mm2pWVl3xeLeeFu55zc0mdjyQySrcHFf9+mcTIzFv25iqxbce5QLuU
         QZueGR58JTAjsQg8unZSwss4ZQWgQGoFlC6Tm5ObUOwP7xjnI9QP1kh0tCPV+tEmu/4Y
         6uUA==
X-Gm-Message-State: AA+aEWYzC5gnTtQX0eWqup5nk0k6PgwBbKSUcsCvdFybWo+q5AepyWVL
        UgFIvwsuYj/emeYJZ1pvahWMonDfKn8=
X-Google-Smtp-Source: AFSGD/Vj/9jgjg4H+IY4LVwERJip+HQESw5AiFq8m3vKSKVTGbieiJjUlzfd4wqpSyfji3ft2irY0w==
X-Received: by 2002:a81:b64c:: with SMTP id h12mr16483692ywk.296.1543850444992;
        Mon, 03 Dec 2018 07:20:44 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m3sm4400917ywe.90.2018.12.03.07.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:44 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 02/10] btrfs: add cleanup_ref_head_accounting helper
Date:   Mon,  3 Dec 2018 10:20:30 -0500
Message-Id: <20181203152038.21388-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We were missing some quota cleanups in check_ref_cleanup, so break the
ref head accounting cleanup into a helper and call that from both
check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure that
we don't screw up accounting in the future for other things that we add.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 67 +++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c36b3a42f2bb..e3ed3507018d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2443,6 +2443,41 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
 	return ret ? ret : 1;
 }
 
+static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
+					struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_delayed_ref_root *delayed_refs =
+		&trans->transaction->delayed_refs;
+
+	if (head->total_ref_mod < 0) {
+		struct btrfs_space_info *space_info;
+		u64 flags;
+
+		if (head->is_data)
+			flags = BTRFS_BLOCK_GROUP_DATA;
+		else if (head->is_system)
+			flags = BTRFS_BLOCK_GROUP_SYSTEM;
+		else
+			flags = BTRFS_BLOCK_GROUP_METADATA;
+		space_info = __find_space_info(fs_info, flags);
+		ASSERT(space_info);
+		percpu_counter_add_batch(&space_info->total_bytes_pinned,
+				   -head->num_bytes,
+				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
+
+		if (head->is_data) {
+			spin_lock(&delayed_refs->lock);
+			delayed_refs->pending_csums -= head->num_bytes;
+			spin_unlock(&delayed_refs->lock);
+		}
+	}
+
+	/* Also free its reserved qgroup space */
+	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
+				      head->qgroup_reserved);
+}
+
 static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 			    struct btrfs_delayed_ref_head *head)
 {
@@ -2478,31 +2513,6 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 	spin_unlock(&head->lock);
 	spin_unlock(&delayed_refs->lock);
 
-	trace_run_delayed_ref_head(fs_info, head, 0);
-
-	if (head->total_ref_mod < 0) {
-		struct btrfs_space_info *space_info;
-		u64 flags;
-
-		if (head->is_data)
-			flags = BTRFS_BLOCK_GROUP_DATA;
-		else if (head->is_system)
-			flags = BTRFS_BLOCK_GROUP_SYSTEM;
-		else
-			flags = BTRFS_BLOCK_GROUP_METADATA;
-		space_info = __find_space_info(fs_info, flags);
-		ASSERT(space_info);
-		percpu_counter_add_batch(&space_info->total_bytes_pinned,
-				   -head->num_bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
-
-		if (head->is_data) {
-			spin_lock(&delayed_refs->lock);
-			delayed_refs->pending_csums -= head->num_bytes;
-			spin_unlock(&delayed_refs->lock);
-		}
-	}
-
 	if (head->must_insert_reserved) {
 		btrfs_pin_extent(fs_info, head->bytenr,
 				 head->num_bytes, 1);
@@ -2512,9 +2522,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	/* Also free its reserved qgroup space */
-	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
-				      head->qgroup_reserved);
+	cleanup_ref_head_accounting(trans, head);
+
+	trace_run_delayed_ref_head(fs_info, head, 0);
 	btrfs_delayed_ref_unlock(head);
 	btrfs_put_delayed_ref_head(head);
 	return 0;
@@ -6991,6 +7001,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (head->must_insert_reserved)
 		ret = 1;
 
+	cleanup_ref_head_accounting(trans, head);
 	mutex_unlock(&head->mutex);
 	btrfs_put_delayed_ref_head(head);
 	return ret;
-- 
2.14.3

