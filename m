Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCACC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA442084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CA442084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbeLLHbR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:31:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:39660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbeLLHbR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:31:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39E14ADDD
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:31:15 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/8] btrfs: delayed-ref: Introduce better documented delayed ref structures
Date:   Wed, 12 Dec 2018 15:30:55 +0800
Message-Id: <20181212073102.7736-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212073102.7736-1-wqu@suse.com>
References: <20181212073102.7736-1-wqu@suse.com>
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
  ---------- so far so good
  ref_root
  owner
  offset
  ---------- I don't feel good now

- Different interpretation for the same parameter
  Above @owner for data ref is inode number (u64),
  while for tree ref, it's level (int).

  They are even in different size range.
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
@real_root, inspired by ref-verify code, is newly introduced for later
qgroup code, to record which tree is triggered this extent modification.

This patch doesn't touch any code, but provides the basis for incoming
refactors.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.h | 116 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 09e242159acf..7f700e00c77a 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -176,6 +176,90 @@ struct btrfs_delayed_ref_root {
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
+	/* For EXTENT_DATA_REF */
+
+	/* Root who refers to this data extent */
+	u64 ref_root;
+
+	/* Inode who refers to this data extent */
+	u64 ino;
+
+	/*
+	 * file_offset - extent_offset
+	 *
+	 * file_offset is the key.offset of the EXTENT_DATA key.
+	 * extent_offset is btrfs_file_extent_offset() of the EXTENT_DATA data.
+	 */
+	u64 offset;
+};
+
+struct btrfs_tree_ref {
+	/*
+	 * Level of this tree block
+	 *
+	 * Shared for skinny (TREE_BLOCK_REF) and normal tree ref.
+	 */
+	int level;
+
+	/*
+	 * Root who refers to this tree block.
+	 *
+	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
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
+	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
+	 * SHARED_DATA_REF) for this extent and its children.
+	 * Set for reloc trees.
+	 */
+	bool only_backreferences:1;
+
+	/*
+	 * Whether this extent should go through qgroup record.
+	 *
+	 * Normally false, but for certain case like delayed subtree scan,
+	 * setting this flag can hugely reduce qgroup overhead.
+	 */
+	bool skip_qgroup:1;
+
+	/*
+	 * Optional. To which root this modification is for.
+	 * Mostly used for qgroup optimization.
+	 *
+	 * When unset, data/tree ref init code will populate it.
+	 * In certain case, we're modifying reference for a different root.
+	 * E.g. Cow fs tree blocks for balance.
+	 * In that case, tree_ref::root will be fs tree, but we're doing this
+	 * for reloc tree, then we should set @real_root to reloc tree.
+	 */
+	u64 real_root;
+	u64 bytenr;
+	u64 len;
+
+	/* Bytenr of the parent tree block */
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
@@ -184,6 +268,38 @@ extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
 int __init btrfs_delayed_ref_init(void);
 void __cold btrfs_delayed_ref_exit(void);
 
+static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
+				int action, u64 bytenr, u64 len, u64 parent)
+{
+	generic_ref->action = action;
+	generic_ref->bytenr = bytenr;
+	generic_ref->len = len;
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

