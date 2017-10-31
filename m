Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:21414 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752879AbdJaFjI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 01:39:08 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id AACE4AC00C9
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:39:05 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 0367546E73A
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:39:05 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: ins: print uuid only if it exists
Message-ID: <7979b9a1-37d6-9eec-79a7-1730b8338b7f@jp.fujitsu.com>
Date: Tue, 31 Oct 2017 14:39:01 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

UUID of ROOT_ITEM is empty if it is not subvolume (and not created by
kernel). So, just skip it if it is empty just like parent/received UUID.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 print-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 8abd760..9d1b862 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -581,8 +581,10 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		flags_str);
 
 	if (root_item.generation == root_item.generation_v2) {
-		uuid_unparse(root_item.uuid, uuid_str);
-		printf("\t\tuuid %s\n", uuid_str);
+		if (!empty_uuid(root_item.uuid)) {
+			uuid_unparse(root_item.uuid, uuid_str);
+			printf("\t\tuuid %s\n", uuid_str);
+		}
 		if (!empty_uuid(root_item.parent_uuid)) {
 			uuid_unparse(root_item.parent_uuid, uuid_str);
 			printf("\t\tparent_uuid %s\n", uuid_str);
-- 
2.9.5

