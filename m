Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DFF1A680E
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782022407; cv=none; b=lupyl29wvfAUou3ECT9wo/y5fFpcTSqR1GHqGRIKFnwhM6qSGHRaIcvhze/nWoyLVGxA5imGhkVbNe+mk6UB/uosTMxd5NW/SI1Op1pZh9jmRgJUC0jn2IPCH9m29u93VrMPJMUoSx6i515uudtsi0XovveSg2K1o2cXC+jSblw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782022407; c=relaxed/simple;
	bh=8t9kXQGAqLejLgEVx/YLyculWL/8mskN1UlvkVC7qaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwqUtgdGI7biP0EQb4qb2xM1btwyfEHNQXv+1qlEUGln414j8RVxSdVoZyRzE2z/HAXC7pTbcKKptzpgoMV/581DwI9HuOfCwT+0BGlo/tNQMHMqU3sZ6KPZXvDyQUGQA3IaJep4p54+w2GbZJgvjiWdPak2I65seZ3BptGMusk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lj9DR/49; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lj9DR/49; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lj9DR/49";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lj9DR/49"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 43304758AD;
	Sun, 21 Jun 2026 06:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782022403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XQIAKjaP+9jfwA4B7+gi661siv2Vdu2+tgq6Q+zPXfM=;
	b=Lj9DR/49mVbhRoDeIXHPt7kxCocMIzc1MkQ85Yxo2OElYYKrkavY7AnQ5pGcXMSBpnhCaS
	Q7FivGWlQo31Dxxy69TZroGF1WrQBccKWEWbZi9hOQ8ytF+0jB3gv4x3ahA5yaA20z+PDN
	PLh5XdiEweLnrZVEipShP4JMQmVGDQo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782022403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XQIAKjaP+9jfwA4B7+gi661siv2Vdu2+tgq6Q+zPXfM=;
	b=Lj9DR/49mVbhRoDeIXHPt7kxCocMIzc1MkQ85Yxo2OElYYKrkavY7AnQ5pGcXMSBpnhCaS
	Q7FivGWlQo31Dxxy69TZroGF1WrQBccKWEWbZi9hOQ8ytF+0jB3gv4x3ahA5yaA20z+PDN
	PLh5XdiEweLnrZVEipShP4JMQmVGDQo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4B97779AB;
	Sun, 21 Jun 2026 06:13:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QF9BJAGBN2oJSAAAD6G6ig
	(envelope-from <wqu@suse.com>); Sun, 21 Jun 2026 06:13:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 2/2] btrfs: reject inline file extent item in get_new_location()
Date: Sun, 21 Jun 2026 15:42:59 +0930
Message-ID: <96c2603f3ddf2a84e36758102dce178256696913.1782022263.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782022263.git.wqu@suse.com>
References: <cover.1782022263.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Commit a6908f88c9da ("btrfs: validate data reloc tree file extent item
members") introduced extra checks on file extent items for data reloc
inodes, but it checks file extent offset without checking if the file
extent is inlined.

This can lead to either false alerts (as the offset member is inside the
inlined data) or even read beyond the item range.

This has already triggered a warning in a syzbot report.
Although the root fix is to avoid compression for data reloc inodes, for
the sake of consistency, reject inlined file extents first.

Fixes: a6908f88c9da ("btrfs: validate data reloc tree file extent item members")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fb85bc8b345c..62b38db00b12 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -892,6 +892,13 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 	leaf = path->nodes[0];
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
+	if (unlikely(btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)) {
+		btrfs_print_leaf(leaf);
+		btrfs_err(fs_info,
+	"unexpected inline file extent item for data reloc inode %llu key offset %llu",
+			  btrfs_ino(BTRFS_I(reloc_inode)), bytenr);
+		return -EUCLEAN;
+	}
 
 	/*
 	 * The cluster-boundary key searched above is always written by
-- 
2.54.0

