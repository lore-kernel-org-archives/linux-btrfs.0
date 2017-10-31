Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:58809 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdJaGIW (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 02:08:22 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: print-tree: Print offset as tree objectid
Date: Tue, 31 Oct 2017 14:07:58 +0800
Message-Id: <20171031060758.531-2-wqu@suse.com>
In-Reply-To: <20171031060758.531-1-wqu@suse.com>
References: <20171031060758.531-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For case like tree reloc trees and subvolume trees, their key offset is
the tree id.

For case like tree treloc tree for data reloc tree,
The key will be outputted as:
(TREE_RELOC ROOT_ITEM 18446744073709551607)

The minus number is long and even guys with real engineer brains can't
easily get the meaning.

This patch will change the output format to:
(TREE_RELOC ROOT_ITEM DATA_RELOC_TREE)

While for special offset value like 0 or (u64)-1, it's still shown as
is.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index 687f871db302..326fafcea763 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -794,6 +794,18 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
 		printf(" 0x%016llx)", (unsigned long long)offset);
 		break;
+
+	/*
+	 * For those key offset, they are points to tree id, print them
+	 * in human readable format other than tree id.
+	 * Especially useful for trees like data/tree reloc tree, whose
+	 * tree id can be minus.
+	 */
+	case BTRFS_ROOT_ITEM_KEY:
+		printf(" ");
+		print_objectid(stdout, offset, type);
+		printf(")");
+		break;
 	default:
 		if (offset == (u64)-1)
 			printf(" -1)");
-- 
2.14.3

