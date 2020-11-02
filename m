Return-Path: <SRS0=KFuw=EI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED431C388F2
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Nov 2020 07:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1552221FF
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Nov 2020 07:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UEnjJ7wP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgKBHbX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 02:31:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:44118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgKBHbV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Nov 2020 02:31:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604302280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fWvBZviczV9Wz6AR6xlBLzNE41HcgXB/TRqIGz895O0=;
        b=UEnjJ7wPHK/5bxF5pKoE7RZYl8eKgbgcWh7/XBDuZgxtSnrNmlVBtuuWTC1704WtMrpr+c
        PZ3OlKSo5/WcbJ3EzFoxL3lgKYD35YJ+X/yzQHpzrse1MN4IeR6XZbMJGWb9O5Ee2J81+Y
        0e31E7NlNCYqsWWbW/jq1lVbzddQr2w=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9C9FFACF6
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2020 07:31:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix build warning due to u64 devided by u32 for 32bit arch
Date:   Mon,  2 Nov 2020 15:31:14 +0800
Message-Id: <20201102073114.66750-1-wqu@suse.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
When building the kernel with subpage preparation patches, 32bit arches
will complain about the following linking error:

   ld: fs/btrfs/extent_io.o: in function `release_extent_buffer':
   fs/btrfs/extent_io.c:5340: undefined reference to `__udivdi3'

[CAUSE]
For 32bits, dividing u64 with u32 need to call div_u64(), not directly
call u64 / u32.

[FIX]
Instead of calling the div_u64() macros, here we introduce a helper,
btrfs_sector_shift(), to calculate the sector shift, and we just do bit
shift to avoid executing the expensive division instruction.

The sector_shift may be better cached in btrfs_fs_info, but so far there
are only very limited callers for that, thus the fs_info::sector_shift
can be there for further cleanup.

David, can this patch be folded into the offending commit?
The patch is small enough, and doesn't change btrfs_fs_info.
Thus should be OK to fold.

Fixes: ef57afc454fb ("btrfs: extent_io: make btrfs_fs_info::buffer_radix to take sector size devided values")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h     |  5 +++++
 fs/btrfs/extent_io.c | 14 +++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8a83bce3225c..eb282af985f5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3489,6 +3489,11 @@ static inline int __btrfs_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag)
 	return !!(btrfs_super_compat_ro_flags(disk_super) & flag);
 }
 
+static inline u8 btrfs_sector_shift(struct btrfs_fs_info *fs_info)
+{
+	return ilog2(fs_info->sectorsize);
+}
+
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 80b35885004a..3452019aef79 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5129,10 +5129,10 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 					 u64 start)
 {
 	struct extent_buffer *eb;
+	u8 sector_shift = btrfs_sector_shift(fs_info);
 
 	rcu_read_lock();
-	eb = radix_tree_lookup(&fs_info->buffer_radix,
-			       start / fs_info->sectorsize);
+	eb = radix_tree_lookup(&fs_info->buffer_radix, start >> sector_shift);
 	if (eb && atomic_inc_not_zero(&eb->refs)) {
 		rcu_read_unlock();
 		/*
@@ -5167,6 +5167,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 					u64 start)
 {
 	struct extent_buffer *eb, *exists = NULL;
+	u8 sector_shift = btrfs_sector_shift(fs_info);
 	int ret;
 
 	eb = find_extent_buffer(fs_info, start);
@@ -5184,7 +5185,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	}
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
-				start / fs_info->sectorsize, eb);
+				start >> sector_shift, eb);
 	spin_unlock(&fs_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
@@ -5215,6 +5216,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *exists = NULL;
 	struct page *p;
 	struct address_space *mapping = fs_info->btree_inode->i_mapping;
+	u8 sector_shift = btrfs_sector_shift(fs_info);
 	int uptodate = 1;
 	int ret;
 
@@ -5292,7 +5294,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
-				start / fs_info->sectorsize, eb);
+				start >> sector_shift, eb);
 	spin_unlock(&fs_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
@@ -5337,6 +5339,8 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 static int release_extent_buffer(struct extent_buffer *eb)
 	__releases(&eb->refs_lock)
 {
+	u8 sector_shift = btrfs_sector_shift(eb->fs_info);
+
 	lockdep_assert_held(&eb->refs_lock);
 
 	WARN_ON(atomic_read(&eb->refs) == 0);
@@ -5348,7 +5352,7 @@ static int release_extent_buffer(struct extent_buffer *eb)
 
 			spin_lock(&fs_info->buffer_lock);
 			radix_tree_delete(&fs_info->buffer_radix,
-					  eb->start / fs_info->sectorsize);
+					  eb->start >> sector_shift);
 			spin_unlock(&fs_info->buffer_lock);
 		} else {
 			spin_unlock(&eb->refs_lock);
-- 
2.29.1

