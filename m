Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15100 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751531AbdFFJzW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 05:55:22 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 5/9] btrfs: Check name_len in btrfs_check_ref_name_override
Date: Tue, 6 Jun 2017 17:57:04 +0800
Message-ID: <20170606095708.494-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In 'btrfs_log_inode', 'btrfs_search_forward' gets the buffer and then
'btrfs_check_ref_name_override' will read name from inode_ref/inode_extref
for the first time.

Call 'btrfs_is_name_len_valid' before reading name.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 06c7ceb07282..f20ef211a73d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4562,6 +4562,12 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 			this_len = sizeof(*extref) + this_name_len;
 		}
 
+		ret = btrfs_is_name_len_valid(eb, slot, name_ptr,
+					      this_name_len);
+		if (!ret) {
+			ret = -EIO;
+			goto out;
+		}
 		if (this_name_len > name_len) {
 			char *new_name;
 
-- 
2.13.0



