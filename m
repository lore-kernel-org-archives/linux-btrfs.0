Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404Ab3HNXRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:23 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHMZl006157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSs017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/15] btrfs-progs: fix in-place byte swapping
Date: Wed, 14 Aug 2013 16:16:39 -0700
Message-Id: <1376522205-16992-10-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Storing fixed-endian values in native cpu types defeats the purpose of
using sparse endian types to find endian conversion bugs.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 print-tree.c | 6 +++---
 uuid-tree.c  | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 761448d..913b1bb 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -688,11 +688,11 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 		return;
 	}
 	while (item_size) {
-		u64 subvol_id;
+		__le64 subvol_id;
 
 		read_extent_buffer(l, &subvol_id, offset, sizeof(u64));
-		subvol_id = le64_to_cpu(subvol_id);
-		printf("\t\tsubvol_id %llu\n", (unsigned long long)subvol_id);
+		printf("\t\tsubvol_id %llu\n",
+			(unsigned long long)le64_to_cpu(subvol_id));
 		item_size -= sizeof(u64);
 		offset += sizeof(u64);
 	}
diff --git a/uuid-tree.c b/uuid-tree.c
index 3a4c48e..39c3f3f 100644
--- a/uuid-tree.c
+++ b/uuid-tree.c
@@ -43,6 +43,7 @@ static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u8 type,
 	struct btrfs_ioctl_search_args search_arg;
 	struct btrfs_ioctl_search_header *search_header;
 	u32 item_size;
+	__le64 lesubid;
 
 	btrfs_uuid_to_key(uuid, &key_objectid, &key_offset);
 
@@ -82,8 +83,8 @@ static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u8 type,
 	}
 
 	/* return first stored id */
-	memcpy(subid, search_header + 1, sizeof(*subid));
-	*subid = le64_to_cpu(*subid);
+	memcpy(&lesubid, search_header + 1, sizeof(lesubid));
+	*subid = le64_to_cpu(lesubid);
 
 out:
 	return ret;
-- 
1.7.11.7

