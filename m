Return-Path: <SRS0=ITJn=CR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E489AC43461
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 10:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F4221532
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 10:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599560918;
	bh=RQIQD1d0w1eSmhBE6x2epMlcSGq0i+8al6wCnvZnImE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
	 References:List-ID:From;
	b=qKbLx1+bcbADkkUcV5STNkFoPuJnJYwuMUS5rxLw0Rlm0Uynul72z5twJdK7WMhFM
	 Nu0PJuFjgF8W1jZsh92PJmKnmx1cO/XPrCfaZS751N+fDyUv78e6SE/twFLG8W0DN2
	 nz52XScLn8Sin/jEtsfVC6v648DM+3MbC/Gl+G/0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgIHK2g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 06:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729794AbgIHK1e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Sep 2020 06:27:34 -0400
Received: from falcondesktop.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A0B21D6C;
        Tue,  8 Sep 2020 10:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599560854;
        bh=RQIQD1d0w1eSmhBE6x2epMlcSGq0i+8al6wCnvZnImE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Yk1gJ+8tJuq1X5ZThCDjJjmSczUmztlAAqL73J9AZwlbNMTMM/HXxx1IrYw+czk2h
         OQGxW1PaI90Pnb/nYbAyKra247Kz5XoP9c8QqMORlqz7L0Fes+Dnsm1RCv9r/88a0+
         MKHyfRUfkTVnaUOB6PBcd9iCqUDsmlu02qZYVM70=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/5] btrfs: remove item_size member of struct btrfs_clone_extent_info
Date:   Tue,  8 Sep 2020 11:27:21 +0100
Message-Id: <6b02195ffe4787d75f5117b3d8d1c42c5462734d.1599560101.git.fdmanana@suse.com>
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

The value of item_size of struct btrfs_clone_extent_info is always set to
the size of a non-inline file extent item, and in fact the infratructure
that uses this structure (btrfs_punch_hole_range()) does not work with
inline file extents at all (and it is not supposed to).

So just remove that field from the structure and use directly
sizeof(struct btrfs_file_extent_item) instead. Also assert that the
file extent type is not inline at btrfs_insert_clone_extent().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/file.c    | 5 +++--
 fs/btrfs/inode.c   | 1 -
 fs/btrfs/reflink.c | 1 -
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 67ca25daf9c8..3e648b0d5d60 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1189,8 +1189,8 @@ struct btrfs_clone_extent_info {
 	u64 data_offset;
 	u64 data_len;
 	u64 file_offset;
+	/* Pointer to a file extent item of type regular or prealloc. */
 	char *extent_buf;
-	u32 item_size;
 	/*
 	 * Set to true when attempting to replace a file range with a new extent
 	 * described by this structure, set to false when attempting to clone an
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 73827c9c7a70..28794a98778a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2596,15 +2596,16 @@ static int btrfs_insert_clone_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = clone_info->file_offset;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      clone_info->item_size);
+				      sizeof(struct btrfs_file_extent_item));
 	if (ret)
 		return ret;
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 	write_extent_buffer(leaf, clone_info->extent_buf,
 			    btrfs_item_ptr_offset(leaf, slot),
-			    clone_info->item_size);
+			    sizeof(struct btrfs_file_extent_item));
 	extent = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+	ASSERT(btrfs_file_extent_type(leaf, extent) != BTRFS_FILE_EXTENT_INLINE);
 	btrfs_set_file_extent_offset(leaf, extent, clone_info->data_offset);
 	btrfs_set_file_extent_num_bytes(leaf, extent, clone_len);
 	if (clone_info->is_new_extent)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a9a4c3d5984c..0281895268f7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9616,7 +9616,6 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.data_len = len;
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
-	extent_info.item_size = sizeof(stack_fi);
 	extent_info.is_new_extent = true;
 	extent_info.qgroup_reserved = ret;
 	extent_info.insertions = 0;
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 3c03126b52b1..020da4d65b64 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -462,7 +462,6 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			clone_info.data_len = datal;
 			clone_info.file_offset = new_key.offset;
 			clone_info.extent_buf = buf;
-			clone_info.item_size = size;
 			clone_info.is_new_extent = false;
 			ret = btrfs_punch_hole_range(inode, path, drop_start,
 					new_key.offset + datal - 1, &clone_info,
-- 
2.26.2

