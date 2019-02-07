Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EF8C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 16:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF8C7218D3
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 16:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="uyWujV/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfBGQye (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:54:34 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46646 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfBGQye (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 11:54:34 -0500
Received: by mail-qt1-f195.google.com with SMTP id y20so563689qtm.13
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 08:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=BVcZxVJyUGYeXnUFNfJG+2teKSsIe5446UfFY+SvcbQ=;
        b=uyWujV/PMmLGDm/Jn2RYeIaTOJ6b5R42JUm4PWrHh6N7GjQdOL2g25TcpvpbiHjCvY
         ls7Ze6RRDBdYg4Q4UQg9SpSuDT8nPgAxmKRq6S2yENDh5A+wRMoaOnePq396+DMnE6Vx
         ZpvYWSDyspir+SZWG1gSowTKuTWhEEEAfBkSoaXS4bBsAiQq4e3COnJSEDhXRb6il2Do
         uwCmRqNCqWEWGf3u9QiPRuEic1nLCva1YYjH+CfU8MLQYOFBd27nXN+6H/VEl8Pg7sBS
         pfkxvsgc8NgnM3+OWswaA0jBSpwHuiyiNmvAhC4cdXnwRvpQzGPoNHB0XkZE4xJ7aZqR
         DbHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=BVcZxVJyUGYeXnUFNfJG+2teKSsIe5446UfFY+SvcbQ=;
        b=T1vR0/w4kZdxSYymClSu9+714+NjEM/mr0IbBofy/MXe6iiwnUS2taN5AEUxQMrTFb
         eK4u1lPfdXOVEKxuWishxpe916stlGOuVr9Tjj/qin7afplb/ONLTOKnBw0M9xLbStVW
         m+9gsof90T/GjluYXPeb6WvkHN4FCF817Vd2LbFddLv6hADoot5NNBf4mms7vNs6Kdm7
         p+W/IubjgpcpqhNk5pihun7dGlPub8ogeSq4gIYCvME0Vwyb8sw6Bq/dKXTtb/ikov3F
         LVOtERv7xiwndX+xJQOMV2Vw4vc6l87C7R9Nwl5cBWPj0ifxxsDfNlWp5uLIOA04+FzO
         e4PA==
X-Gm-Message-State: AHQUAubl0khniCYPYVT0qESrf6xljV8xqjRqB/AvRkAK5hv3hoZpuDE1
        SE3+tgGy6L/Uzd8MXuCV6DK9J90uEyE=
X-Google-Smtp-Source: AHgI3IaXs8nIO9W5t/cS4QULSpENeIycQJDSKVYTQYeO4pWi3QM5FT8WVUBTHSgTeaDi1OWlRInbLQ==
X-Received: by 2002:a0c:b994:: with SMTP id v20mr11064498qvf.27.1549558472732;
        Thu, 07 Feb 2019 08:54:32 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j14sm16764110qtc.65.2019.02.07.08.54.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Feb 2019 08:54:32 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/2] btrfs: reserve space for inheriting properties
Date:   Thu,  7 Feb 2019 11:54:25 -0500
Message-Id: <20190207165426.15866-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190207165426.15866-1-josef@toxicpanda.com>
References: <20190207165426.15866-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We've been seeing errors on our build servers related to failing to
inherit inode properties.  This is because we do not pre-reserve space
for them, instead trying to reserve space with NO_FLUSH at inheritance
time.  NO_FLUSH can transiently fail, but we'll still complain.  It's
just an extra credit, so simply add that to the places that call
btrfs_new_inode and call it good enough.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 78 ++++++++++++++++++++++----------------------------------
 fs/btrfs/ioctl.c | 27 ++++++++++++--------
 2 files changed, 46 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6126de9b8b9c..0da4a9d6d9fe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -59,6 +59,14 @@ struct btrfs_dio_data {
 	int overwrite;
 };
 
+/*
+ * 2 for inode item and ref
+ * 2 for dir items
+ * 1 for xattr if selinux is on
+ * 1 for inherited properties
+ */
+#define BTRFS_NEW_INODE_ITEMS 6
+
 static const struct inode_operations btrfs_dir_inode_operations;
 static const struct inode_operations btrfs_symlink_inode_operations;
 static const struct inode_operations btrfs_dir_ro_inode_operations;
@@ -6479,12 +6487,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	/*
-	 * 2 for inode item and ref
-	 * 2 for dir items
-	 * 1 for xattr if selinux is on
-	 */
-	trans = btrfs_start_transaction(root, 5);
+	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
@@ -6543,12 +6546,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	/*
-	 * 2 for inode item and ref
-	 * 2 for dir items
-	 * 1 for xattr if selinux is on
-	 */
-	trans = btrfs_start_transaction(root, 5);
+	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
@@ -6695,12 +6693,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	u64 objectid = 0;
 	u64 index = 0;
 
-	/*
-	 * 2 items for inode and ref
-	 * 2 items for dir items
-	 * 1 for xattr if selinux is on
-	 */
-	trans = btrfs_start_transaction(root, 5);
+	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
@@ -9428,14 +9421,11 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		down_read(&fs_info->subvol_sem);
 
 	/*
-	 * We want to reserve the absolute worst case amount of items.  So if
-	 * both inodes are subvols and we need to unlink them then that would
-	 * require 4 item modifications, but if they are both normal inodes it
-	 * would require 5 item modifications, so we'll assume their normal
-	 * inodes.  So 5 * 2 is 10, plus 2 for the new links, so 12 total items
-	 * should cover the worst case number of items we'll modify.
+	 * The same math from btrfs_rename applies here, except we need an extra
+	 * 2 items for the new links.
 	 */
-	trans = btrfs_start_transaction(root, 12);
+	trans = btrfs_start_transaction(root,
+					(BTRFS_NEW_INODE_ITEMS << 1) + 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_notrans;
@@ -9768,19 +9758,19 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&fs_info->subvol_sem);
 	/*
-	 * We want to reserve the absolute worst case amount of items.  So if
-	 * both inodes are subvols and we need to unlink them then that would
-	 * require 4 item modifications, but if they are both normal inodes it
-	 * would require 5 item modifications, so we'll assume they are normal
-	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
-	 * should cover the worst case number of items we'll modify.
-	 * If our rename has the whiteout flag, we need more 5 units for the
-	 * new inode (1 inode item, 1 inode ref, 2 dir items and 1 xattr item
-	 * when selinux is enabled).
+	 * We want to reserve the absolute worst case amount of items.  Subvol
+	 * inodes don't have an inode item to worry about and don't have a
+	 * selinux attr, so we use the BTRFS_NEW_INODE_ITEMS counter for how
+	 * much it costs per inode to modify.  Worse case we'll have to mess
+	 * with 2 inodes, so 2 x BTRFS_NEW_INODE_ITEMS, and then we need an
+	 * extra reservation for the new link.
+	 *
+	 * If our rename has the whiteout flag we need a full new inode which
+	 * means another set of BTRFS_NEW_INODE_ITEMS.
 	 */
-	trans_num_items = 11;
+	trans_num_items = (BTRFS_NEW_INODE_ITEMS << 1) + 1;
 	if (flags & RENAME_WHITEOUT)
-		trans_num_items += 5;
+		trans_num_items += BTRFS_NEW_INODE_ITEMS;
 	trans = btrfs_start_transaction(root, trans_num_items);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
@@ -10149,14 +10139,8 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info))
 		return -ENAMETOOLONG;
 
-	/*
-	 * 2 items for inode item and ref
-	 * 2 items for dir items
-	 * 1 item for updating parent inode item
-	 * 1 item for the inline extent item
-	 * 1 item for xattr if selinux is on
-	 */
-	trans = btrfs_start_transaction(root, 7);
+	/* 1 item for the inline extent item */
+	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
@@ -10427,10 +10411,8 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	u64 index;
 	int ret = 0;
 
-	/*
-	 * 5 units required for adding orphan entry
-	 */
-	trans = btrfs_start_transaction(root, 5);
+	/* 1 unit required for adding orphan entry */
+	trans = btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f38a659c918c..21f8ab2d8570 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -83,6 +83,17 @@ struct btrfs_ioctl_send_args_32 {
 			       struct btrfs_ioctl_send_args_32)
 #endif
 
+/*
+ * 1 - parent dir inode
+ * 2 - dir entries
+ * 1 - root item
+ * 2 - root ref/backref
+ * 1 - root of snapshot
+ * 1 - UUID item
+ * 1 - properties
+ */
+#define BTRFS_NEW_ROOT_ITEMS 9
+
 static int btrfs_clone(struct inode *src, struct inode *inode,
 		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
 		       int no_time_update);
@@ -596,7 +607,8 @@ static noinline int create_subvol(struct inode *dir,
 	 * The same as the snapshot creation, please see the comment
 	 * of create_snapshot().
 	 */
-	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 8, false);
+	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
+					       BTRFS_NEW_ROOT_ITEMS, false);
 	if (ret)
 		goto fail_free;
 
@@ -804,17 +816,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
 			     BTRFS_BLOCK_RSV_TEMP);
-	/*
-	 * 1 - parent dir inode
-	 * 2 - dir entries
-	 * 1 - root item
-	 * 2 - root ref/backref
-	 * 1 - root of snapshot
-	 * 1 - UUID item
-	 */
+
 	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
-					&pending_snapshot->block_rsv, 8,
-					false);
+					&pending_snapshot->block_rsv,
+					BTRFS_NEW_ROOT_ITEMS, false);
 	if (ret)
 		goto dec_and_free;
 
-- 
2.14.3

