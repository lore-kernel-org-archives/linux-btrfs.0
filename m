Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8FB283FE6
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782168982; cv=none; b=bzy7eTbWabLhM1SxNKY5zNurAxipRG1ws6wU7/B2EuhX1h86eZbPDFfZEHPQ/B0iI8tY3zlSrC1+3ZxD/bAKP66L2/JbxfR5gIGgDVH5Rx62dwqQ09pqWfJrbCAS/Bj30wP86W/JbwAbcnDiO/49orjgQFYQLzJ78dFwJnV6QTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782168982; c=relaxed/simple;
	bh=aE4zOPksyvDe6M7IPzuddw/Z7bnLdRCTy3Rk5LxMLdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3CdpuPQ5EyY4NkPswWmVu1qsRehwhJjANC/wqgjcDDXzj7F/GPHVds4oTUBEyekK0ftCxj9+Y+jOqJQnPydF9f/HywSUaA8VydzfKO906xeYAt/1ZDAj2lhCA+0ajU/5Hx2l9FxXo4sjr24RxOoT49nMB28GxXAHU+r1R6QsD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sOSrwB0B; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r1vkQ3mc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sOSrwB0B";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r1vkQ3mc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E9F1770AD6;
	Mon, 22 Jun 2026 22:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2OHDwc38vlocbMIzqDd7Ne3P/Tn0061xwzxeVJdjF0=;
	b=sOSrwB0BO+KGgCQt2PcbLrDbuFd4nKcwRyPl3tiFK4ZZp3FEmzB8lYgJrOlDMPBwIbwpZq
	5NMgxfqF69Jmdkim23dr+kn5nYn8WqvAY3hYj+tYflD+RqZflEo0HMTPA64h9a5pfx2Yln
	GTzuA/qi/92bweOUfkWhG2QZ51aNODA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2OHDwc38vlocbMIzqDd7Ne3P/Tn0061xwzxeVJdjF0=;
	b=r1vkQ3mcA9ITHDfFKkc/jeJPtLIYr0FQsmXGNtlOpbKvtLss8oCivjorRTbMEw9MBG9Gw1
	tQC51HARozAgDuS/kK1PZHYYpTe3L363/VkifQU4o2mBDWgqfBDHO4ZQfcmycbhcBLO5NU
	5s2i1/XKt0WJLyJVXP6xW+VHJK7EIIk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A56DC779A8;
	Mon, 22 Jun 2026 22:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oCCOFYW9OWq0OQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 22 Jun 2026 22:56:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: reject inline file extent item in get_new_location()
Date: Tue, 23 Jun 2026 08:25:41 +0930
Message-ID: <619560576690f592ba60044c4761bd7fca204ae9.1782168847.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782168847.git.wqu@suse.com>
References: <cover.1782168847.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

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
index e1dd9939f4f1..f5fac0e34494 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -893,6 +893,13 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
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

