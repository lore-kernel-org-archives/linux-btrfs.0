Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21766C04EBF
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5EBE214DB
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5EBE214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbeLFG7L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:59:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:59422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbeLFG7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:59:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D052AED3
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 06:59:09 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/8] btrfs: delayed-ref: Introduce better documented delayed ref structures
Date:   Thu,  6 Dec 2018 14:58:56 +0800
Message-Id: <20181206065903.11343-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181206065903.11343-1-wqu@suse.com>
References: <20181206065903.11343-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Current delayed ref interface has several problems:
- Longer and longer parameter lists
  bytenr
  num_bytes
  parent
  ref_root
  owner
  offset
  for_reloc << Only qgroup code cares.

- Different interpretation for the same parameter
  Above @owner for data ref is ino owning this extent,
  while for tree ref, it's level. They are even in different size range.
  For level we only need 0~8, while for ino it's
  BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID.

  And @offset doesn't even makes sense for tree ref.

  Such parameter reuse may look clever as an hidden union, but it
  destroys code readability.

To solve both problems, we introduce a new structure, btrfs_ref to solve
them:

- Structure instead of long parameter list
  This makes later expansion easier, and better documented.

- Use btrfs_ref::type to distinguish data and tree ref

- Use proper union to store data/tree ref specific structures.

- Use separate functions to fill data/tree ref data, with a common generic
  function to fill common bytenr/num_bytes members.

All parameters will find its place in btrfs_ref, and an extra member,
real_root, inspired by ref-verify code, is newly introduced for later
qgroup code, to record which tree is triggered this extent modification.

This patch doesn't touch any code, but provides the basis for incoming
refactors.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.h | 109 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d8fa12d3f2cc..e36d6b05d85e 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -176,6 +176,81 @@ struct btrfs_delayed_ref_root {
 	u64 qgroup_to_skip;
 };
 
+enum btrfs_ref_type {
+	BTRFS_REF_NOT_SET = 0,
+	BTRFS_REF_DATA,
+	BTRFS_REF_METADATA,
+	BTRFS_REF_LAST,
+};
+
+struct btrfs_data_ref {
+	/*
+	 * For EXTENT_DATA_REF
+	 *
+	 * @ref_root:	current owner of the extent.
+	 * 		may differ from btrfs_ref::real_root.
+	 * @ino: 	inode number of the owner.
+	 * @offset:	*CALCULATED* offset. Not EXTENT_DATA key offset.
+	 *
+	 */
+	u64 ref_root;
+	u64 ino;
+	u64 offset;
+};
+
+struct btrfs_tree_ref {
+	/* Common for all sub types and skinny combination */
+	int level;
+
+	/*
+	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
+	 *
+	 * root here may differ from btrfs_ref::real_root.
+	 */
+	u64 root;
+
+	/* For non-skinny metadata, no special member needed */
+};
+
+struct btrfs_ref {
+	enum btrfs_ref_type type;
+	int action;
+
+	/*
+	 * Use full backref(SHARED_BLOCK_REF or SHARED_DATA_REF) for this
+	 * extent and its children.
+	 * Set for reloc trees.
+	 */
+	unsigned int use_fullback:1;
+
+	/*
+	 * Whether this extent should go through qgroup record.
+	 * Normally false, but for certain case like delayed subtree scan,
+	 * this can hugely reduce qgroup overhead.
+	 */
+	unsigned int skip_qgroup:1;
+
+	/*
+	 * Who owns this reference modification, optional.
+	 *
+	 * One example:
+	 * When creating reloc tree for source fs, it will increase tree block
+	 * ref for children tree blocks.
+	 * In that case, btrfs_ref::real_root = reloc tree,
+	 * while btrfs_ref::tree_ref::root = fs tree.
+	 */
+	u64 real_root;
+	u64 bytenr;
+	u64 len;
+
+	/* Common @parent for SHARED_DATA_REF/SHARED_BLOCK_REF */
+	u64 parent;
+	union {
+		struct btrfs_data_ref data_ref;
+		struct btrfs_tree_ref tree_ref;
+	};
+};
+
 extern struct kmem_cache *btrfs_delayed_ref_head_cachep;
 extern struct kmem_cache *btrfs_delayed_tree_ref_cachep;
 extern struct kmem_cache *btrfs_delayed_data_ref_cachep;
@@ -184,6 +259,40 @@ extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
 int __init btrfs_delayed_ref_init(void);
 void __cold btrfs_delayed_ref_exit(void);
 
+static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
+				int action, u64 bytenr, u64 len, u64 real_root,
+				u64 parent)
+{
+	generic_ref->action = action;
+	generic_ref->bytenr = bytenr;
+	generic_ref->len = len;
+	generic_ref->real_root = real_root;
+	generic_ref->parent = parent;
+}
+
+static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
+				int level, u64 root)
+{
+	/* If @real_root not set, use @root as fallback */
+	if (!generic_ref->real_root)
+		generic_ref->real_root = root;
+	generic_ref->tree_ref.level = level;
+	generic_ref->tree_ref.root = root;
+	generic_ref->type = BTRFS_REF_METADATA;
+}
+
+static inline void btrfs_init_data_ref(struct btrfs_ref *generic_ref,
+				u64 ref_root, u64 ino, u64 offset)
+{
+	/* If @real_root not set, use @root as fallback */
+	if (!generic_ref->real_root)
+		generic_ref->real_root = ref_root;
+	generic_ref->data_ref.ref_root = ref_root;
+	generic_ref->data_ref.ino = ino;
+	generic_ref->data_ref.offset = offset;
+	generic_ref->type = BTRFS_REF_DATA;
+}
+
 static inline struct btrfs_delayed_extent_op *
 btrfs_alloc_delayed_extent_op(void)
 {
-- 
2.19.2

