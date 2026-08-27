Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E11346E43
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787813765; cv=none; b=coJrZ6c1Vo5M+BMYUwz6xVmsSScjNmqXDN/4frfwi1vCUyvsl50oXIfstAi7e7a3jwFUzU4SKTc7fM3hgDtTMuSE975U4nuZTAjoj97mCYVxBQrNzWneNU/Fc4QUpgNTCqvAsF17bmXqEzJCuDMIxVS0cVykmkuAD0htADwzr6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787813765; c=relaxed/simple;
	bh=/1eTS7zgsntZjE5fK7LFls3THW8rDbWEb/y9kraTBSo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcF4CYoq64v34dxHdu6c9rqLR3RDazpBNXUCH2iW4hAAFKTsB9SCU/rAkWWfUhE1qJIzERGhVHoYwr85Eu8weEOHHpA4VbWgcQkHqFrIxUuG9ir+p/pVEUmJnHCepBhdPj49GxfbBL9/7WNlBzbiFIbbWoUxRyn/HDvVM3vEnWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fBV1p61H; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=e/+OGyDr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fBV1p61H";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="e/+OGyDr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 85DCD2120A
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787813757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zKBTQoWfmDNt0XW4P+a7RWaFZgLdkIBcqQazUUzuZPk=;
	b=fBV1p61HeSDDva8lCWASpgfY2kecJ1ni2DRK30yTjJT3GblidxXd3R2pxltN0pnxMcWTCJ
	YAwmKM9GlBEkMic27PjaxRuPt1phBClv2CyPjYYfzCOU+L/806gljv6Bp/HS27GRJ96jOi
	CRzbCsClBhepEgEQW//8Eui5sO49+QY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787813753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zKBTQoWfmDNt0XW4P+a7RWaFZgLdkIBcqQazUUzuZPk=;
	b=e/+OGyDrc3AvRNmN1/HFCHLM8iEMy+jn5LDfYmAqq+zdzWdOptBD11jK6R6GUlfGdFO6vt
	eeInD61Nmxgao0+CGU6ZBRT/9bC5Sy3ZVLQcmdvlW+x0EhVgFsDypmkeY3DImmD/g+4iZ/
	kOM0Mc6K6QR6yO/96HtiKEUQT4xtuOk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E2ED13533
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CHIMC3jfj2oiXgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 06:55:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: avoid long stall when dropping a non-shared large subvolume
Date: Thu, 27 Aug 2026 16:25:30 +0930
Message-ID: <d04f7f42099ff33df9ec8c08aaf36ab838dc4193.1787812966.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787812966.git.wqu@suse.com>
References: <cover.1787812966.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Commit 011b46c30476 ("btrfs: skip subtree scan if it's too high to avoid
low stall in btrfs_commit_transaction()") introduced a mechanism to skip
large subtree during snapshot dropping.

But even for a subvolume without any shared tree blocks, we can still
queue quite a lot of qgroup records into one transaction, and cause a
long qgroup related stall.

So also add a check against the subvolume root level, to determine if we
need to mark qgroup inconsistent.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 11 +++++++++++
 fs/btrfs/qgroup.c      | 19 +++++++++++++++++++
 fs/btrfs/qgroup.h      |  2 ++
 3 files changed, 32 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d6a4390ee34a..8977e9ad0d44 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6315,6 +6315,17 @@ int btrfs_drop_snapshot(struct btrfs_root *root, bool update_ref, bool for_reloc
 	set_bit(BTRFS_ROOT_DELETING, &root->state);
 	unfinished_drop = test_bit(BTRFS_ROOT_UNFINISHED_DROP, &root->state);
 
+	/*
+	 * For subvolume dropping, check if the subvolume is large enough
+	 * so that we need to mark qgroup inconsistent to avoid long qgroup
+	 * stall.
+	 *
+	 * Even for a subvolume without any snapshot, there can still be
+	 * a lot of qgroup records queued into one transaction.
+	 */
+	if (!for_reloc)
+		btrfs_qgroup_check_tree_drop(fs_info, rootid,
+					     btrfs_header_level(root->node));
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
 		path->nodes[level] = btrfs_lock_root_node(root);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cc08e7b2f68f..cefeedcd6826 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2751,6 +2751,25 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+void btrfs_qgroup_check_tree_drop(struct btrfs_fs_info *fs_info,
+				  u64 rootid, u8 level)
+{
+	u8 drop_subtree_thres;
+
+	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_FULL)
+		return;
+
+	if (!btrfs_is_fstree(rootid))
+		return;
+
+	spin_lock(&fs_info->qgroup_lock);
+	drop_subtree_thres = fs_info->qgroup_drop_subtree_thres;
+	spin_unlock(&fs_info->qgroup_lock);
+
+	if (level >= drop_subtree_thres)
+		qgroup_mark_inconsistent(fs_info, "subtree level reached threshold");
+}
+
 static void qgroup_iterator_nested_add(struct list_head *head, struct btrfs_qgroup *qgroup)
 {
 	if (!list_empty(&qgroup->nested_iterator))
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 7cc1a079a0b4..c8db380f1576 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -378,6 +378,8 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level);
+void btrfs_qgroup_check_tree_drop(struct btrfs_fs_info *fs_info,
+				  u64 rootid, u8 level);
 int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 				u64 num_bytes, struct ulist *old_roots,
 				struct ulist *new_roots);
-- 
2.55.0

