Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EF9C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 22:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 758D920684
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 22:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="XgSZfayj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfCFWNI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:13:08 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44973 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCFWNI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2019 17:13:08 -0500
Received: by mail-qt1-f194.google.com with SMTP id d2so14804222qti.11
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Mar 2019 14:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=n4BEXmrJoWQra4+cBebIYvXcauwJIcvvzkJqfVuy2iA=;
        b=XgSZfayjqSE87McCGEIOvAmctTnxJMc2tgVC+Hz7ZDr7NkA9RZvQqqf9ijj9yAQb/3
         oCSIEHhDSnZDCYxIPRd0g7qJfFWrg10LoXgSd9Np+BnFik/W6xyIJqN2KuQ8kCJTTy2H
         JEyDIVDfjJx0TSgQnwljzM+/TkpD1eG/2zCWR9RPFKOW62i/Idfs6WnvuaoJSQ8X1USO
         4v1BTg06ToCLrLfc/yzV1o4ONtM1J2yoderobQN2NI0lYV9uwgC7qXN0h6XBvpTqeZJR
         qfAvKp3E67FKZKkwOofOBCbGoXw4w/m3UdSK93FDsQ8+GRldhGMj9bFe3AzyUI65OaLt
         wGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=n4BEXmrJoWQra4+cBebIYvXcauwJIcvvzkJqfVuy2iA=;
        b=GpG05CiBxUVmMcGaz+sy95B6YXeqg1etHkZfw8K3jnWKGImNLBwxR9BT0sowK/bH5W
         LZ4Vdi6W1HZIFAzkC1iG0ufbm0hEtgVvvfyQ9D2OsT7Mx1rrVW4aVl3vFd0C4Emm2atq
         Kr7eZZ9OvU4usDVAITqGkbER9K0tx1HB4IV0oXPTHMItg6RHE68CEcRN6XxZ/Gt5hymZ
         5s14kVx32cmR4qxwiAqQpDLs3/tTkhxCSbOZUwa+F2P2QFRP3rGf+X6OBz0lbUfQa0+3
         elpll0cR/nBnKihfGdFID4lnhrpOSnMlW2W9y+ZKpD/rwAWxlX8cbSNKTFeOeE0lZoYz
         SkSw==
X-Gm-Message-State: APjAAAWcoQRqtRHgLAqKC2C9SGFNOw/FD00EU0skbz0Hh+Wn+9UzUspz
        0/aXlxYDWTRRi6zJ6xThsjRj6RKsBIMTYg==
X-Google-Smtp-Source: APXvYqzHqnO3F0UR+VF4kDR6K1u83soGCq9tBbNsIYznJyuDHle+2TQgmqndnHqwHRzyGEa+6CDb5A==
X-Received: by 2002:a0c:b660:: with SMTP id q32mr8335785qvf.50.1551910386867;
        Wed, 06 Mar 2019 14:13:06 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i33sm1907301qti.74.2019.03.06.14.13.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 14:13:05 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove WARN_ON() in log_dir_items
Date:   Wed,  6 Mar 2019 17:13:04 -0500
Message-Id: <20190306221304.29503-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When Filipe added the recursive directory logging stuff he specifically
didn't take the directory i_mutex for the children directories that we
need to log because of lockdep.  This is generally fine, but can lead to
this WARN_ON() tripping if we happen to run delayed deletion's in
between our first search and our second search of dir_item/dir_indexes
for this directory.  We expect this to happen, so the WARN_ON() isn't
necessary.  Drop the WARN_ON() and add a comment so we know why this
case can happen.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/tree-log.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f06454a55e00..bccb62c1c587 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3578,9 +3578,16 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	/* find the first key from this transaction again */
+	/*
+	 * Find the first key from this transaction again.  See the note for
+	 * log_new_dir_dentries, if we're logging a directory recursively we
+	 * won't be holding its i_mutex, which means we can modify the directory
+	 * while we're logging it.  If we remove an entry between our first
+	 * search and this search we'll not find the key again and can just
+	 * bail.
+	 */
 	ret = btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
-	if (WARN_ON(ret != 0))
+	if (ret != 0)
 		goto done;
 
 	/*
-- 
2.14.3

