Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36007 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751059AbbCNWd5 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Sat, 14 Mar 2015 18:33:57 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs: change the insertion criteria for the qgroup operations rbtree
Date: Sat, 14 Mar 2015 07:03:27 +0000
Message-Id: <1426316607-765-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1426279397-9047-1-git-send-email-fdmanana@suse.com>
References: <1426279397-9047-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After looking at Liu Bo's recent patch (titled
"Btrfs: fix comp_oper to get right order") I realized the search made by
qgroup_oper_exists() was buggy because its rbtree navigation comparison
function, comp_oper_exist(), only looks at the fields bytenr and ref_root
of a tree node, ignoring the seq field completely. This was wrong because
when we insert a node into the rbtree we use comp_oper(), which takes a
decision based first on bytenr, then on seq and then on the ref_root field.
That means qgroup_oper_exists() could miss the fact that at least one
operation with given bytenr and ref_root exists.

Consider the following simple example of a 3 nodes qgroup operations
rbtree (created using comp_oper before this patch), where each node's key
is a tuple with the shape (bytenr, seq, ref_root, op):

                          [ (4096, 2, 20, op X) ]
                         /                       \
                        /                         \
   [ (4096, 1, 5, op Y) ]                         [ (4096, 3, 10, op Z) ]

qgroup_oper_exists() when called to search for an existing operation for
bytenr 4096 and ref root 10 wouldn't find anything because it would go to
the left subtree instead of the right subtree, since comp_oper_exits()
ignores the seq field completely.

Fix this by changing the insertion navigation function to use the ref_root
field right after using the bytenr field and before using the seq field,
so that qgroup_oper_exists() / comp_oper_exist() work as expected.

This patch applies on top of the patch mentioned above from Liu.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Added a fancy example rbtree to the commit message in order to better
    explain the bug. No code changes.

 fs/btrfs/qgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 058c79e..683862a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1256,14 +1256,14 @@ static int comp_oper(struct btrfs_qgroup_operation *oper1,
 		return -1;
 	if (oper1->bytenr > oper2->bytenr)
 		return 1;
-	if (oper1->seq < oper2->seq)
-		return -1;
-	if (oper1->seq > oper2->seq)
-		return 1;
 	if (oper1->ref_root < oper2->ref_root)
 		return -1;
 	if (oper1->ref_root > oper2->ref_root)
 		return 1;
+	if (oper1->seq < oper2->seq)
+		return -1;
+	if (oper1->seq > oper2->seq)
+		return 1;
 	if (oper1->type < oper2->type)
 		return -1;
 	if (oper1->type > oper2->type)
-- 
2.1.3

