Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44245 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdHYFQQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 01:16:16 -0400
Subject: [PATCH] btrfs: fix NULL pointer dereference from free_reloc_roots()
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, dsterba@suse.com
Date: Fri, 25 Aug 2017 14:15:14 +0900
Message-ID: <150363811494.24591.5585689547237978902.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__del_reloc_root should be called before freeing up reloc_root->node.
If not, calling __del_reloc_root() dereference reloc_root->node, causing
the system BUG.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/relocation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 65661d1aae4e..6445de8e9ece 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2393,11 +2393,11 @@ void free_reloc_roots(struct list_head *list)
 	while (!list_empty(list)) {
 		reloc_root = list_entry(list->next, struct btrfs_root,
 					root_list);
+		__del_reloc_root(reloc_root);
 		free_extent_buffer(reloc_root->node);
 		free_extent_buffer(reloc_root->commit_root);
 		reloc_root->node = NULL;
 		reloc_root->commit_root = NULL;
-		__del_reloc_root(reloc_root);
 	}
 }
 

