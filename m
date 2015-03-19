Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60310 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbbCSGEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:53 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] Btrfs-progs: qgroup: print info and limits type in btrfs-debug-tree.
Date: Thu, 19 Mar 2015 14:00:56 +0800
Message-ID: <1426744864-7031-4-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have restructured the btrfs_qgroup, and we are using
objectid for btrfs_qgroup_info_item now. Then we need to
print the objectid in btrfs-debug-tree.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 print-tree.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index 3a7c13c..7cb9563 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -644,6 +644,22 @@ static void print_objectid(u64 objectid, u8 type)
 		printf("%llu/%llu", objectid >> 48,
 			objectid & ((1ll << 48) - 1));
 		return;
+	case BTRFS_QGROUP_INFO_KEY:
+		if (objectid == 0)
+			printf("MIXED");
+		else if (objectid == BTRFS_QGROUP_DATA_INFO_OBJECTID)
+			printf("DATA");
+		else
+			printf("METADATA");
+		return;
+	case BTRFS_QGROUP_LIMIT_KEY:
+		if (objectid == BTRFS_QGROUP_DATA_LIMIT_OBJECTID)
+			printf("DATA");
+		else if (objectid == BTRFS_QGROUP_METADATA_LIMIT_OBJECTID)
+			printf("METADATA");
+		else
+			printf("MIXED");
+		return;
 	case BTRFS_UUID_KEY_SUBVOL:
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf("0x%016llx", (unsigned long long)objectid);
-- 
1.8.4.2

