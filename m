Return-Path: <SRS0=11YW=ZI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA50CC43215
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E8F214DE
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Nov 2019 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921622;
	bh=1Y55KVJFBoohB1r9B+QbKqjxNBNey+IOHMAq3LWOavs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rqhMZYuKws9IbK7EQ498eolTb2pUe87rqnvUTbSqhmtURhTGp6U4Ms6EjCH7f0Sdb
	 PvVVj90D8WY+5Tq7h8GKaJXWY4yRrhPwp2u4rIuxe7AYAA76ydzKTk3eaMwm+5khym
	 YE7mhH3b8RF7kIbFrAv96Qc1stX4MALnlMMnhui8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfKPPll (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbfKPPlk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:40 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C120320729;
        Sat, 16 Nov 2019 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918900;
        bh=1Y55KVJFBoohB1r9B+QbKqjxNBNey+IOHMAq3LWOavs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tcXMB9oYbRLNWlBoRLV2UYSFAToC8Um/wRjAlhO4VhIsqu4ZECeV7p/Jq90R0uXH
         YMEvcMUkHSKwUtrXdTSDLKKv2AzZdylwXBkSXdQ29uAWdEfUjxlvG86wWxo7eJXxCD
         hGz7N054Z3OVglDl5G1AavqHxXOFV7MM5L6lNsfk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Bo <bo.liu@linux.alibaba.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 028/237] Btrfs: fix alignment in declaration and prototype of btrfs_get_extent
Date:   Sat, 16 Nov 2019 10:37:43 -0500
Message-Id: <20191116154113.7417-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Liu Bo <bo.liu@linux.alibaba.com>

[ Upstream commit de2c6615dcddf2af868c5cbd1db2e9e73b4beb58 ]

This fixes btrfs_get_extent to be consistent with our existing
declaration style.

Note: For the record, indentation styles that are accepted are both,
aligning under the opening ( and tab or double tab indentation on the
next line.  Preferrably not spliting the type or long expressions in the
argument lists.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h | 4 ++--
 fs/btrfs/inode.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cc2d268e2cd7a..3a5a09e8e20e2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3183,8 +3183,8 @@ struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
-		struct page *page, size_t pg_offset,
-		u64 start, u64 end, int create);
+				    struct page *page, size_t pg_offset,
+				    u64 start, u64 end, int create);
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f0f7bc5d2e4a0..62a7c6a88c3e8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6862,9 +6862,9 @@ static noinline int uncompress_inline(struct btrfs_path *path,
  * This also copies inline extents directly into the page.
  */
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
-		struct page *page,
-	    size_t pg_offset, u64 start, u64 len,
-		int create)
+				    struct page *page,
+				    size_t pg_offset, u64 start, u64 len,
+				    int create)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int ret;
-- 
2.20.1

