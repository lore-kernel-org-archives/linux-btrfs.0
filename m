Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:46654 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753942AbdJSSQM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:16:12 -0400
Received: by mail-qt0-f196.google.com with SMTP id 1so15589492qtn.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 11:16:12 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8] btrfs: switch args for comp_*_refs
Date: Thu, 19 Oct 2017 14:15:58 -0400
Message-Id: <1508436962-6851-5-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
References: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make it more consistent, we want the inserted ref to be compared against
what's already in there.  This will make the order go from lowest seq ->
highest seq, which will make us more likely to make forward progress if
there's a seqlock currently held.

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
2.7.5

