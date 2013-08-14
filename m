Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933370Ab3HNXRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:22 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHMmG015833
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSr017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/15] btrfs-progs: fix extent key endian bug in repair
Date: Wed, 14 Aug 2013 16:16:38 -0700
Message-Id: <1376522205-16992-9-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extents rebuilt from backrefs can have their objectid mangled.  The code
tried to build a disk_key by hand and got the swabbing backwards.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-check.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2318aed..2d5162c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3931,9 +3931,12 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			bi = (struct btrfs_tree_block_info *)(ei + 1);
 			memset_extent_buffer(leaf, 0, (unsigned long)bi,
 					     sizeof(*bi));
-			memset(&copy_key, 0, sizeof(copy_key));
 
-			copy_key.objectid = le64_to_cpu(rec->info_objectid);
+			btrfs_set_disk_key_objectid(&copy_key,
+						    rec->info_objectid);
+			btrfs_set_disk_key_type(&copy_key, 0);
+			btrfs_set_disk_key_offset(&copy_key, 0);
+
 			btrfs_set_tree_block_level(leaf, bi, rec->info_level);
 			btrfs_set_tree_block_key(leaf, bi, &copy_key);
 
-- 
1.7.11.7

