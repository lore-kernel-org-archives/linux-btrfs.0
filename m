Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:54860 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdI2Toa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:30 -0400
Received: by mail-qt0-f194.google.com with SMTP id i13so903787qtc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:30 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 15/21] btrfs: switch args for comp_*_refs
Date: Fri, 29 Sep 2017 15:43:59 -0400
Message-Id: <1506714245-23072-16-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because seriously?  ref2 and then ref1?

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index a2973340a94f..bc940bb374cf 100644
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

