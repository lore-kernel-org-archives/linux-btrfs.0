Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17A63EBF29
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180667; cv=none; b=gx48/cmM9W9tVePMfpi0fY42XgZAQpqQykDkOcvDVCpTlvlziHtcHY6VB40i/QVOMGmg7SAhh7uf/mvNSgUdsn0kkJnKVAQuES47d561jiwsj87OpYpbC44BtWyREeW5NAn7GW6xuzPROpiyZ1UZhYSIxAZdOSe6sWQuX+GIsiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180667; c=relaxed/simple;
	bh=cpIBgDq4LclOOLGeDZQhVVsFjreULXA7Nv0XV3JaETY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch7lSBi42dzc43jWztyvtrIB7eIHeU4JlaODtr1hB4nCYDmExi8sNVX4mo4ntMuknOIMyxcJhduJ0sLn5z4CwYCbFa58JqABz8AaFicBxo0ILgs88VEi446xplZoro5QZEw4+hOSMS4X2CQOwgMbRnMyjInU8WgFGroWpu85E0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fBvIhWNK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fBvIhWNK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fBvIhWNK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fBvIhWNK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C72976A7C2;
	Tue, 14 Apr 2026 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TOAiDNl1s2SmQnRr/tDoFw17FSKs8B8MzS5i2qQbBYg=;
	b=fBvIhWNK4R6nflukQmFnSSlYHDFJMm+WkgeEfxsu+438KFTSKzaeJMbY3qP5VLU0bLyOZU
	Kg3M32ipCGDnxQLE3aiKNdR6Mt+2VlXiWiptYrTB5T4o9L4ZtjrmPmdPLowYv+SNhI8y72
	iuksBr1NLiqlH4t9SNxwmzd8mVEHePk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TOAiDNl1s2SmQnRr/tDoFw17FSKs8B8MzS5i2qQbBYg=;
	b=fBvIhWNK4R6nflukQmFnSSlYHDFJMm+WkgeEfxsu+438KFTSKzaeJMbY3qP5VLU0bLyOZU
	Kg3M32ipCGDnxQLE3aiKNdR6Mt+2VlXiWiptYrTB5T4o9L4ZtjrmPmdPLowYv+SNhI8y72
	iuksBr1NLiqlH4t9SNxwmzd8mVEHePk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C13714B4F9;
	Tue, 14 Apr 2026 15:31:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iGosL7dd3mkpPAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Apr 2026 15:31:03 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: do more kmalloc_obj()/kmalloc_objs() conversions
Date: Tue, 14 Apr 2026 17:30:33 +0200
Message-ID: <546d39cfcc54907cd5cbe5758e2e332d3fb01cc3.1776180388.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776180388.git.dsterba@suse.com>
References: <cover.1776180388.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Do a few more (trivial) conversions that started in commit 69050f8d6d075d
("treewide: Replace kmalloc with kmalloc_obj for non-scalar types").

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/relocation.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3ebaf5880125fa..9cbae3cf8bdd1e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -590,7 +590,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	struct btrfs_key root_key;
 	int ret = 0;
 
-	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
+	root_item = kmalloc_obj(*root_item, GFP_NOFS);
 	if (!root_item)
 		return ERR_PTR(-ENOMEM);
 
@@ -2944,7 +2944,7 @@ static int relocate_file_extent_cluster(struct reloc_control *rc)
 	if (!cluster->nr)
 		return 0;
 
-	ra = kzalloc(sizeof(*ra), GFP_NOFS);
+	ra = kzalloc_obj(*ra, GFP_NOFS);
 	if (!ra)
 		return -ENOMEM;
 
@@ -3863,7 +3863,7 @@ static int add_remap_tree_entries(struct btrfs_trans_handle *trans, struct btrfs
 
 	max_items = BTRFS_LEAF_DATA_SIZE(trans->fs_info) / sizeof(struct btrfs_item);
 
-	data_sizes = kzalloc(sizeof(u32) * min_t(u32, num_entries, max_items), GFP_NOFS);
+	data_sizes = kzalloc_objs(u32, min_t(u32, num_entries, max_items), GFP_NOFS);
 	if (!data_sizes)
 		return -ENOMEM;
 
@@ -4454,7 +4454,7 @@ static int create_remap_tree_entries(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
-	space_runs = kmalloc(sizeof(*space_runs) * extent_count, GFP_NOFS);
+	space_runs = kmalloc_objs(*space_runs, extent_count, GFP_NOFS);
 	if (!space_runs) {
 		mutex_unlock(&bg->free_space_lock);
 		return -ENOMEM;
@@ -4543,7 +4543,7 @@ static int create_remap_tree_entries(struct btrfs_trans_handle *trans,
 	mutex_unlock(&bg->free_space_lock);
 
 	max_entries = extent_count + 2;
-	entries = kmalloc(sizeof(*entries) * max_entries, GFP_NOFS);
+	entries = kmalloc_objs(*entries, max_entries, GFP_NOFS);
 	if (!entries) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.53.0

