Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37309 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3EGTJx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 15:09:53 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 049A69A0694
	for <linux-btrfs@vger.kernel.org>; Tue,  7 May 2013 13:09:53 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id IshsE8PWW1wV8qff (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 07 May 2013 13:09:52 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: sanity check the number of items in a leaf
Date: Tue, 7 May 2013 15:09:50 -0400
Message-ID: <1367953790-23756-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit this while working on fsck, I got some weird corruption where the number
of items was way higher than what would fit in a leaf, which would make things
blow up.  This fixes the problem by catching it and returning an error so we
gracefully exit instead of segfaulting.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 ctree.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/ctree.c b/ctree.c
index 16f4daa..851d14a 100644
--- a/ctree.c
+++ b/ctree.c
@@ -638,6 +638,12 @@ int btrfs_check_leaf(struct btrfs_root *root,
 	struct btrfs_disk_key key;
 	u32 nritems = btrfs_header_nritems(buf);
 
+	if (nritems == 0 || nritems * sizeof(struct btrfs_item) > buf->len)  {
+		fprintf(stderr, "invalid number of items %llu\n",
+			(unsigned long long)buf->start);
+		goto fail;
+	}
+
 	if (btrfs_header_level(buf) != 0) {
 		fprintf(stderr, "leaf is not a leaf %llu\n",
 		       (unsigned long long)btrfs_header_bytenr(buf));
-- 
1.7.7.6

