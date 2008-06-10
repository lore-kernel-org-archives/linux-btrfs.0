From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: [PATCH] Changed type field to be %x for tree header (line in btrfs_print_tree)
Date: Tue, 10 Jun 2008 11:46:50 -0400
Message-ID: <484EA1EA.7000006@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010407020200070502090606"
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010407020200070502090606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------010407020200070502090606
Content-Type: text/x-diff;
 name="0001-Changed-type-field-to-be-x-for-tree-header-like-in.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Changed-type-field-to-be-x-for-tree-header-like-in.patc";
 filename*1="h"

This makes it easier to visually match keys - see:
print-tree.c:btrfs_print_tree():329:

	printf("\tkey %d (%llu %x %llu) block %llu (%llu) gen %llu\n",

I'm not sure if this breaks any other parsers?

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 debug-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/debug-tree.c b/debug-tree.c
index fa5c90c..9185dc2 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -190,7 +190,7 @@ int main(int ac, char **av)
 				break;
 			}
 			if (!skip && !extent_only) {
-				printf("tree %llu %u %llu\n",
+				printf("tree %llu %x %llu\n",
 				       (unsigned long long)found_key.objectid,
 				       found_key.type,
 				       (unsigned long long)found_key.offset);
-- 
1.5.4.3


--------------010407020200070502090606--
