Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932122AbdERDjU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 10/32] btrfs-progs: Refactor nodesize user in extent_io.c
Date: Thu, 18 May 2017 11:38:35 +0800
Message-ID: <20170518033857.15002-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent_io.c b/extent_io.c
index 915c6ed8..26a67865 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -765,7 +765,7 @@ int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 			u64 stripe_len = this_len;
 
 			this_len = min(this_len, bytes_left);
-			this_len = min(this_len, (u64)info->tree_root->nodesize);
+			this_len = min(this_len, (u64)info->nodesize);
 
 			eb = malloc(sizeof(struct extent_buffer) + this_len);
 			if (!eb) {
-- 
2.13.0



