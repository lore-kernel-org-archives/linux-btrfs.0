Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC44C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08AB421848
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710750;
	bh=eB6sOHKx+1f6HArChl6ljUETiLpl6r0leUMUINcKlbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=EO21Mu4k8qPmXFpQjZMvu2VxypqPDIjap/G5qQjIcAIaEY1KjiV9ANzqUVuL5NbcT
	 qOXsd2eM5daTc8xWmNIAh7k0fHY/2OQ6LRDuvsOQv8DPTQjBUfkMVJm/EFsf0zfTtW
	 NqLrn9BiXmrnMtlBkzCRUfxxDlEnyCG3JBG0SY14=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfA1VZo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:25:44 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45459 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfA1VYv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:51 -0500
Received: by mail-yb1-f195.google.com with SMTP id t11so2165190ybi.12;
        Mon, 28 Jan 2019 13:24:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V9/6QDtWudym7hvxLzXEVyuXETxb6FE0Jk6cpZNUt5M=;
        b=jSe29YILpeXOWAC91sVqt35NDpDGKkW+KThhEl3Aqxz9xOS5X8MAPcXC9wN0F/W32+
         qt4Cr0Sxjhkinci3HY9onNEGd52V8jEPaH+u22k0Be37egQDD73RKLsv/Ke1+M0HMrGW
         tyMbKKiMMfMs7ohh6DDpMdYjHmGUJrk1M1yiOgvDuNBRNxHmF6m6FVkRlGeQfwU2VKYs
         s7HZVgmmwVFCD8ZU4WBrpKnZKdWCKGpWj2gwg6tKoGPDxzP/9X6moZwPXHoEjiLeAttp
         UuSrdf0ncDqY4h3cWQVshvhBywWRYArP3ZEFQEe09FmY3Q0Njw4cqJ0VUNgE+INWCbP5
         uO2A==
X-Gm-Message-State: AJcUukclGPK6bMksn6Dk2n0GQK6nYF6ZBT9eOJZY02kjylAkeKdibBSn
        3A5eX869mGVnrqjqnYJfYac=
X-Google-Smtp-Source: ALg8bN7KZDdZErYD7mTbh9im250KZSnbK4Opl2eppGF1IYPoGva8TiMYQd8rEuR/STISn1knirlSpg==
X-Received: by 2002:a25:2f92:: with SMTP id v140mr22633996ybv.257.1548710690360;
        Mon, 28 Jan 2019 13:24:50 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:49 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 04/11] btrfs: unify compression ops with workspace_manager
Date:   Mon, 28 Jan 2019 16:24:30 -0500
Message-Id: <20190128212437.11597-5-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Make the workspace_manager own the interface operations rather than
managing index-paired arrays for the workspace_manager and compression
operations.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index bda7e8d2cbc7..b7e986e16640 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -777,6 +777,7 @@ const struct btrfs_compress_op btrfs_heuristic_compress = {
 };
 
 struct workspace_manager {
+	const struct btrfs_compress_op *ops;
 	struct list_head idle_ws;
 	spinlock_t ws_lock;
 	/* Number of free workspaces */
@@ -802,6 +803,8 @@ void __init btrfs_init_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+		wsm[i].ops = btrfs_compress_op[i];
+
 		INIT_LIST_HEAD(&wsm[i].idle_ws);
 		spin_lock_init(&wsm[i].ws_lock);
 		atomic_set(&wsm[i].total_ws, 0);
@@ -811,7 +814,7 @@ void __init btrfs_init_compress(void)
 		 * Preallocate one workspace for each compression type so
 		 * we can guarantee forward progress in the worst case
 		 */
-		workspace = btrfs_compress_op[i]->alloc_workspace();
+		workspace = wsm[i].ops->alloc_workspace();
 		if (IS_ERR(workspace)) {
 			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
 		} else {
@@ -874,7 +877,7 @@ static struct list_head *find_workspace(int type)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = btrfs_compress_op[type]->alloc_workspace();
+	workspace = wsm[type].ops->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -932,7 +935,7 @@ static void free_workspace(int type, struct list_head *workspace)
 	}
 	spin_unlock(ws_lock);
 
-	btrfs_compress_op[type]->free_workspace(workspace);
+	wsm[type].ops->free_workspace(workspace);
 	atomic_dec(total_ws);
 wake:
 	cond_wake_up(ws_wait);
@@ -950,7 +953,7 @@ static void free_workspaces(void)
 		while (!list_empty(&wsm[i].idle_ws)) {
 			workspace = wsm[i].idle_ws.next;
 			list_del(workspace);
-			btrfs_compress_op[i]->free_workspace(workspace);
+			wsm[i].ops->free_workspace(workspace);
 			atomic_dec(&wsm[i].total_ws);
 		}
 	}
-- 
2.17.1

