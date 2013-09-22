Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:43843 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3IVMbj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 08:31:39 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 22 Sep 2013 22:31:37 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id D363F2CE8051
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 22:31:35 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8MCExa766846924
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 22:14:59 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8MCVYLD023844
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 22:31:35 +1000
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com
Subject: [PATCH] btrfs-progs: verify_space_cache: Fix memory leak.
Date: Sun, 22 Sep 2013 18:01:31 +0530
Message-ID: <12213854.o0zn9z9jeG@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Free btrfs_path structure before returning due to failure of calls to
btrfs_search_slot() or btrfs_next_leaf() functions.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 cmds-check.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e08b79d..c947156 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3227,14 +3227,19 @@ static int verify_space_cache(struct btrfs_root *root,
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_free_path(path);
 		return ret;
+	}
+
 	ret = 0;
 	while (1) {
 		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
 			ret = btrfs_next_leaf(root, path);
-			if (ret < 0)
+			if (ret < 0) {
+				btrfs_free_path(path);
 				return ret;
+			}
 			if (ret > 0) {
 				ret = 0;
 				break;
-- 
1.8.3.1


