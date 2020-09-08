Return-Path: <SRS0=ITJn=CR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B763C43461
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 10:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11655208C7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599560873;
	bh=bjYgOy319MqJeM405sKBkOqtPYQ9tpilZe2tTuXh/lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
	 References:List-ID:From;
	b=NjV5hA2449eAJN7NKcG1WMEgyn26TaQr72Zy4XisnQcvjXLK5VrVwhlYrQRqleHfA
	 l2XMiiUfQ+3HD0wCU5e+Tfs/ynf9n0ETogIdY2zkt4Q3ZArYVyC+R+pXLQYIYm6Pnt
	 PQi/ru5Ssak4vedD6MtKDzrqSfCsJOvn7fp6KY4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgIHK1v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 06:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgIHK1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Sep 2020 06:27:39 -0400
Received: from falcondesktop.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4D2215A4;
        Tue,  8 Sep 2020 10:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599560857;
        bh=bjYgOy319MqJeM405sKBkOqtPYQ9tpilZe2tTuXh/lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=WaQ6Q69a/3Mkv8Srqbmt9HHTvNEeGLr8GsI+1SB4ydlbg7tkJnN2SntjgtqKFjAzR
         xsvZOvOa+iVwGRDK+gAJ/WkfqgicppvJ8ifnkSip7BmXuZFHSxFCo/H2KqCfR+JSgR
         7ZDjk+eB137Qle/qzo1WR1gWWC/PXa7RI2Pm+2NY=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 5/5] btrfs: rename btrfs_insert_clone_extent() to a more generic name
Date:   Tue,  8 Sep 2020 11:27:24 +0100
Message-Id: <708d9e3e76a589d5362b063f01d1d1c58c0e4184.1599560101.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1599560101.git.fdmanana@suse.com>
References: <cover.1599560101.git.fdmanana@suse.com>
In-Reply-To: <cover.1599560101.git.fdmanana@suse.com>
References: <cover.1599560101.git.fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Now that we use the same mechanism to replace all the extents in a file
range with either a hole, an existing extent (when cloning) or a new
extent (when using fallocate), the name of btrfs_insert_clone_extent()
no longer reflects its genericity.

So rename it to btrfs_insert_replace_extent(), since what it does is
to either insert an existing extent or a new extent into a file range.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 241b34e44a6c..32ceda264b7d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2570,7 +2570,7 @@ static int btrfs_punch_hole_lock_range(struct inode *inode,
 	return 0;
 }
 
-static int btrfs_insert_clone_extent(struct btrfs_trans_handle *trans,
+static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 				     struct inode *inode,
 				     struct btrfs_path *path,
 				     struct btrfs_replace_extent_info *extent_info,
@@ -2768,7 +2768,7 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 		if (extent_info && drop_end > extent_info->file_offset) {
 			u64 replace_len = drop_end - extent_info->file_offset;
 
-			ret = btrfs_insert_clone_extent(trans, inode, path,
+			ret = btrfs_insert_replace_extent(trans, inode, path,
 							extent_info, replace_len);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
@@ -2864,7 +2864,7 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 
 	}
 	if (extent_info) {
-		ret = btrfs_insert_clone_extent(trans, inode, path, extent_info,
+		ret = btrfs_insert_replace_extent(trans, inode, path, extent_info,
 						extent_info->data_len);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
-- 
2.26.2

