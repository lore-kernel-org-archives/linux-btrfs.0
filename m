Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E92C35296
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2647923AFA
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgLHQ0N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 11:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730427AbgLHQ0M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2020 11:26:12 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A847C061257
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2020 08:25:36 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 143so1351081qke.10
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2020 08:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oA3hm6Lz9XJnQgK6Q6/s2qKe4ojAA4p4PR7GlNhtccg=;
        b=yNj8eThT+J7UNauo4bIe+avOGulx5iqdHXcqBStErqI9ZEALFClSyfddPj3vD1Ge5n
         xjdqmjqhnsJ3UZx8gZX3IWuhmClDfdWSyScP1FSJmVxRyDAaMXEmg0Nuve7PsHos0wec
         o4gHm0wTz4jnZNlF6+ZGGiZfzc/pxnU4BBbAUV2bMc51SdSB8tIRBKy4RBf/lT0TkPzm
         Ugj9svbe9VdIg+9hg4hBOMgTq9i76itt81j4S+rIi6vyP3JCjJjqWygihv3aQ0R1b95e
         Tuqaqa9wvnwRXRRyYt1VdtF9psRP12ypTM3lupVEkLE9SIEXSQmN9tUDccPNAEIKRUnZ
         7zWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oA3hm6Lz9XJnQgK6Q6/s2qKe4ojAA4p4PR7GlNhtccg=;
        b=tg+yZw8TBAIV8uOnPn2eR7AGeeJiNOAFfklkMUjlZ/9bLUDIYxgN+uGIMFZ6PXEY0N
         /6NNqiNi6rIg3zVkUhljx+iQBxUTN6+C1MJAufzKgOn+nXCiXLCB+plyy83zboFkft2n
         n12XT4/F3JAefjdPczv0H4MRhEP/fPdNdAy1DigepeYJAB2MmbM+BwNmTSy0SEfjQq80
         dwt3otVnBrtSIhGS7MDzCmAIKKfRu1v7T9X0YHGtxpcovtuWwuRYXKD2XzKqMp2R+t0o
         sUg/cB6K01qkMJxwqpb+VCquvMLev3YzV95sUdg2O/PLGCUxSrVZRHLNCIH+3FN5ACCi
         KpvQ==
X-Gm-Message-State: AOAM5328kS/ijM9OL27+XOvFvLAJqVg3Wg+1AozHTMMyt53DloXQrX/d
        B61ftIjIobkdAz6bewCsR3pXBp6N/pk43BZ/
X-Google-Smtp-Source: ABdhPJytYMWZMW9aTN4Vjtz8jQpXJqUQkwrpRA6NtB4dg1VUMDHsDZh0H9ClHaZHOAWk4yZf8miQsw==
X-Received: by 2002:a05:620a:113b:: with SMTP id p27mr30288216qkk.29.1607444735487;
        Tue, 08 Dec 2020 08:25:35 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id u15sm13685987qkj.122.2020.12.08.08.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 08:25:34 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 43/52] btrfs: do proper error handling in create_reloc_inode
Date:   Tue,  8 Dec 2020 11:23:50 -0500
Message-Id: <7c658b951087cc905e2f6821348f2cb3998e506d.1607444471.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1607444471.git.josef@toxicpanda.com>
References: <cover.1607444471.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We already handle some errors in this function, and the callers do the
correct error handling, so clean up the rest of the function to do the
appropriate error handling.

There's a little extra work that needs to be done here, as we create the
inode item before we create the orphan item.  We could potentially add
the orphan item, but if we failed to create the inode item we would have
to abort the transaction.  Instead add a helper to delete the inode item
we created in the case that we're unable to look up the inode (this
would likely be caused by an ENOMEM), which if it succeeds means we can
avoid a transaction abort in this particular error case.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/relocation.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 328a78399ddb..b5d644a87dcf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3599,6 +3599,35 @@ static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static void delete_orphan_inode(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root, u64 objectid)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = objectid;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		goto out;
+	}
+	ret = btrfs_del_item(trans, root, path);
+out:
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
+	btrfs_free_path(path);
+}
+
 /*
  * helper to create inode for data relocation.
  * the inode is in data relocation tree and its link count is 0
@@ -3625,10 +3654,16 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 		goto out;
 
 	err = __insert_orphan_inode(trans, root, objectid);
-	BUG_ON(err);
+	if (err)
+		goto out;
 
 	inode = btrfs_iget(fs_info->sb, objectid, root);
-	BUG_ON(IS_ERR(inode));
+	if (IS_ERR(inode)) {
+		delete_orphan_inode(trans, root, objectid);
+		err = PTR_ERR(inode);
+		inode = NULL;
+		goto out;
+	}
 	BTRFS_I(inode)->index_cnt = group->start;
 
 	err = btrfs_orphan_add(trans, BTRFS_I(inode));
-- 
2.26.2

