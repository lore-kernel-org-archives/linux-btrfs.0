Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36558 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbbJHLtm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 07:49:42 -0400
Received: by pablk4 with SMTP id lk4so53169924pab.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2015 04:49:41 -0700 (PDT)
Received: from arch-nb.localdomain ([211.106.186.1])
        by smtp.gmail.com with ESMTPSA id qp5sm45081721pbc.43.2015.10.08.04.49.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 08 Oct 2015 04:49:40 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: cleanup iterating over prop_handlers array
Date: Thu,  8 Oct 2015 20:49:34 +0900
Message-Id: <1444304974-30423-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch eliminates the last item of prop_handlers array which is used
to check end of array and instead uses ARRAY_SIZE macro.
Though this is a very tiny optimization, using ARRAY_SIZE macro is a
good practice to iterate array.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 fs/btrfs/props.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index dca137b04095..f9e60231f685 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -49,18 +49,16 @@ static struct prop_handler prop_handlers[] = {
 		.extract = prop_compression_extract,
 		.inheritable = 1
 	},
-	{
-		.xattr_name = NULL
-	}
 };
 
 void __init btrfs_props_init(void)
 {
-	struct prop_handler *p;
+	int i;
 
 	hash_init(prop_handlers_ht);
 
-	for (p = &prop_handlers[0]; p->xattr_name; p++) {
+	for (i = 0; i < ARRAY_SIZE(prop_handlers); i++) {
+		struct prop_handler *p = &prop_handlers[i];
 		u64 h = btrfs_name_hash(p->xattr_name, strlen(p->xattr_name));
 
 		hash_add(prop_handlers_ht, &p->node, h);
@@ -301,15 +299,16 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 			 struct inode *inode,
 			 struct inode *parent)
 {
-	const struct prop_handler *h;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
+	int i;
 
 	if (!test_bit(BTRFS_INODE_HAS_PROPS,
 		      &BTRFS_I(parent)->runtime_flags))
 		return 0;
 
-	for (h = &prop_handlers[0]; h->xattr_name; h++) {
+	for (i = 0; i < ARRAY_SIZE(prop_handlers); i++) {
+		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes;
 
-- 
2.6.0

