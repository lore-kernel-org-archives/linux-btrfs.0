Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1DF1DDC1B
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 09:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782033132; cv=none; b=aJkDWznrzet70KYlyVPO61JxJIJWqMLsiWpPCsLFXD8uFqv1KMXQx+r87TluQ+ys50nl2bp3yQiWyiVEz2OntmjnkFpsHLtqiiAiifI8duBRFsaIOk3fN3yJhNmeL0U4F6fy/rp8kcSPvD5djdvscOdnlc73kzcPQgXW9XIQiNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782033132; c=relaxed/simple;
	bh=UotKLX3Lt51Ff643WKOsetz0uzL81C4duf/M6cKYMf8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=s/cu0bmW20BPBJveHMvluEjRP8U1t+qwLGWvf7AqEgZKhzoeAWAktZe7mWKVFfjPSsGsrAhQM19BQGwIaYwtmm1y4YIy8h4f/vpw/jD0eV5UTM9WeDTogMrJHlcExfceH+ifBtwWr5sUYPt5MeO15sFxRj1fNpEUs21U53psYNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KJ6r1m5C; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KJ6r1m5C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KJ6r1m5C";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KJ6r1m5C"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F77D6E1D5
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 09:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782033128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7HkuF13+vzEho3AdcVLHVsKmewm6++B7ALQjpsVu87k=;
	b=KJ6r1m5CmhhydYP1Udsbfq59IAsWqMT6NTVi3bvpx5amcX9k4wWykCkdckPJgCUYkI5UQu
	onm2r1necKzI1uIj+3wI2lVMJ5ltmZvUpeaIsLhaSjgVuKzIPV5C1LWxZKdrArh3dhtz5O
	Wzt27IQrR0/jjPRpwtibXj/TFio3D4Y=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KJ6r1m5C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782033128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7HkuF13+vzEho3AdcVLHVsKmewm6++B7ALQjpsVu87k=;
	b=KJ6r1m5CmhhydYP1Udsbfq59IAsWqMT6NTVi3bvpx5amcX9k4wWykCkdckPJgCUYkI5UQu
	onm2r1necKzI1uIj+3wI2lVMJ5ltmZvUpeaIsLhaSjgVuKzIPV5C1LWxZKdrArh3dhtz5O
	Wzt27IQrR0/jjPRpwtibXj/TFio3D4Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39831779A8
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 09:12:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V9KFNeaqN2opbAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 09:12:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: print-tree: print header owner as signed
Date: Sun, 21 Jun 2026 18:41:48 +0930
Message-ID: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3F77D6E1D5
X-Spam-Flag: NO
X-Spam-Score: -3.01
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

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

