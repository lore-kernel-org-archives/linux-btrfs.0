Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:7619 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752483AbeAaDJi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 22:09:38 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v3 5/7] btrfs-progs: do clean up for redundancy value assignment
Date: Wed, 31 Jan 2018 11:09:17 +0800
Message-ID: <1517368159-12858-6-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although skinny_metadata's type is int, its value just can be 0/1.
And if condition be true only when skinny_metadata equals 1,
so in if's executive part, set skinny_metadata to 1 is redundancy.
Remove it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 extent-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index 055582c..9201c56 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1005,7 +1005,6 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		extra_size = -1;
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID && skinny_metadata) {
-		skinny_metadata = 1;
 		key.type = BTRFS_METADATA_ITEM_KEY;
 		key.offset = owner;
 	} else if (skinny_metadata) {
-- 
1.9.1



