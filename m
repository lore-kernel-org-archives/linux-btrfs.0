Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36324 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdIKVM5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:12:57 -0400
Received: by mail-qk0-f195.google.com with SMTP id i14so6150779qke.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:12:56 -0700 (PDT)
From: josef@toxicpanda.com
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 08/10] btrfs: switch args for comp_*_refs
Date: Mon, 11 Sep 2017 17:12:34 -0400
Message-Id: <1505164356-13474-9-git-send-email-jbacik@fb.com>
In-Reply-To: <1505164356-13474-1-git-send-email-jbacik@fb.com>
References: <1505164356-13474-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Because seriously?  ref2 and then ref1?

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 7374710..c5de6c7 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -40,8 +40,8 @@ struct kmem_cache *btrfs_delayed_extent_op_cachep;
 /*
  * compare two delayed tree backrefs with same bytenr and type
  */
-static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
-			  struct btrfs_delayed_tree_ref *ref1)
+static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref1,
+			  struct btrfs_delayed_tree_ref *ref2)
 {
 	if (ref1->node.type == BTRFS_TREE_BLOCK_REF_KEY) {
 		if (ref1->root < ref2->root)
@@ -60,8 +60,8 @@ static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
 /*
  * compare two delayed data backrefs with same bytenr and type
  */
-static int comp_data_refs(struct btrfs_delayed_data_ref *ref2,
-			  struct btrfs_delayed_data_ref *ref1)
+static int comp_data_refs(struct btrfs_delayed_data_ref *ref1,
+			  struct btrfs_delayed_data_ref *ref2)
 {
 	if (ref1->node.type == BTRFS_EXTENT_DATA_REF_KEY) {
 		if (ref1->root < ref2->root)
-- 
2.7.4

