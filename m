Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4105C55181
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 06:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D599206D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 06:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgDVGvA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:51:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:51394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgDVGvA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 02:51:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BFC5EAB91;
        Wed, 22 Apr 2020 06:50:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        u-boot@lists.denx.de
Cc:     marek.behun@nic.cz
Subject: [PATCH U-BOOT 12/26] fs: btrfs: Cross port struct btrfs_root to ctree.h
Date:   Wed, 22 Apr 2020 14:49:55 +0800
Message-Id: <20200422065009.69392-13-wqu@suse.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200422065009.69392-1-wqu@suse.com>
References: <20200422065009.69392-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With write related members deleted.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f068db6505e0..e8dcab1a0b5d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -68,6 +68,23 @@ enum btrfs_tree_block_status {
 	BTRFS_TREE_BLOCK_INVALID_OFFSETS,
 };
 
+struct btrfs_root {
+	struct extent_buffer *node;
+	struct btrfs_root_item root_item;
+	struct btrfs_key root_key;
+	struct btrfs_fs_info *fs_info;
+	u64 objectid;
+	u64 last_trans;
+
+	int ref_cows;
+	int track_dirty;
+
+	u32 type;
+	u64 last_inode_alloc;
+
+	struct rb_node rb_node;
+};
+
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
-- 
2.26.0

