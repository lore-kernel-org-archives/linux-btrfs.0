Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25797283FE6
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782168976; cv=none; b=n+ebUv19+jdj5pZo5cnYeB6BP8DhU3Lyu6grGtbdP9GZWwIFGRkc6IOt09ydJ6lk7lnmHGFcI+xA2wvvAFBVO67n5h3oCM/OXA8sei5lDMHmejSnzJya4gUloYcL+RexvQvKsAVqJ4ea1GXq2q0AhO31+mcESp4qgwLSWvBinoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782168976; c=relaxed/simple;
	bh=UotKLX3Lt51Ff643WKOsetz0uzL81C4duf/M6cKYMf8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTxyk+CZYzN2b4vh+WRi0f0Tc+tXfZEFAPIe48wl5pIs/5gDkY9h2nuQKRayHI1vKQeeM/aclTJm1bNIIuwy4c3YDN9FTa7B4mufTBGYO3JUsRo1/y4/P1ZFWWfofMbd5+L4ySMCH/8fj/43hNqtVE5CWW0zLpdtGBLeoJh3OMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RzXg5dTO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RzXg5dTO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RzXg5dTO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RzXg5dTO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FDC970A88
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7HkuF13+vzEho3AdcVLHVsKmewm6++B7ALQjpsVu87k=;
	b=RzXg5dTOnlkk03Sqv1Lb65Yo6P5gZLWhKB0DQqzS0cXytCX4Hv2OJtEhC/279YMsFb1i+C
	ad76eP8Wag/5e1fqTMWyQfF21mTbEwmfrGwQtWw5KuEYX+YMyw+trHE0fu6n++SuXRTNqE
	ccPtJH45EtbB7w9p1EG+sE7eJDQtHc8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=RzXg5dTO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7HkuF13+vzEho3AdcVLHVsKmewm6++B7ALQjpsVu87k=;
	b=RzXg5dTOnlkk03Sqv1Lb65Yo6P5gZLWhKB0DQqzS0cXytCX4Hv2OJtEhC/279YMsFb1i+C
	ad76eP8Wag/5e1fqTMWyQfF21mTbEwmfrGwQtWw5KuEYX+YMyw+trHE0fu6n++SuXRTNqE
	ccPtJH45EtbB7w9p1EG+sE7eJDQtHc8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18174779A8
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iBW2LoO9OWq0OQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: print-tree: print header owner as signed
Date: Tue, 23 Jun 2026 08:25:40 +0930
Message-ID: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
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
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0FDC970A88
X-Spam-Score: -3.01
Message-ID: <20260622225540.9ZqL0Mh2J9h-lFv7N3RWN2wumRXixcik8a0xiNBBO-c@z>

When dumpping a tree block, btrfs_header::owner is printed as
unsigned, which can result in numbers that are hard to read, e.g:

 BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space 1676 owner 18446744073709551607

For the above output, 18446744073709551607 is (s64)-9, the root id of data
reloc tree.

Despite those pre-defined root ids that are already negative, existing
subvolume trees will not have any negative values, as subvolume trees can
only utilize the lower 48 bits, so there will be no output change for
existing subvolumes, thus no extra confusion.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/print-tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 87e60a2d4bd8..53e726119ca7 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -449,9 +449,9 @@ void btrfs_print_leaf(const struct extent_buffer *l)
 	nr = btrfs_header_nritems(l);
 
 	btrfs_info(fs_info,
-		   "leaf %llu gen %llu total ptrs %d free space %d owner %llu",
+		   "leaf %llu gen %llu total ptrs %d free space %d owner %lld",
 		   btrfs_header_bytenr(l), btrfs_header_generation(l), nr,
-		   btrfs_leaf_free_space(l), btrfs_header_owner(l));
+		   btrfs_leaf_free_space(l), (s64)btrfs_header_owner(l));
 	print_eb_refs_lock(l);
 	for (i = 0 ; i < nr ; i++) {
 		char key_buf[KEY_TYPE_BUF_SIZE];
@@ -600,10 +600,10 @@ void btrfs_print_tree(const struct extent_buffer *c, bool follow)
 		return;
 	}
 	btrfs_info(fs_info,
-		   "node %llu level %d gen %llu total ptrs %d free spc %u owner %llu",
+		   "node %llu level %d gen %llu total ptrs %d free spc %u owner %lld",
 		   btrfs_header_bytenr(c), level, btrfs_header_generation(c),
 		   nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
-		   btrfs_header_owner(c));
+		   (s64)btrfs_header_owner(c));
 	print_eb_refs_lock(c);
 	for (i = 0; i < nr; i++) {
 		btrfs_node_key_to_cpu(c, &key, i);
-- 
2.54.0

