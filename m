Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62591 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751195AbdFAIzd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 04:55:33 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 5/9] btrfs: Check namelen in 'btrfs_check_ref_name_override'
Date: Thu, 1 Jun 2017 16:57:12 +0800
Message-ID: <20170601085716.25898-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Call 'btrfs_is_namelen_valid' before reading name.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ae51144571e2..fdab0f021197 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4562,6 +4562,11 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 			this_len = sizeof(*extref) + this_name_len;
 		}
 
+		ret = btrfs_is_namelen_valid(eb, slot, name_ptr, this_name_len);
+		if (!ret) {
+			ret = -EIO;
+			goto out;
+		}
 		if (this_name_len > name_len) {
 			char *new_name;
 
-- 
2.13.0



