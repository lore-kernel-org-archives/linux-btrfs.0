Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8F0231C9F
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774245121; cv=none; b=TkfDUNbEvOyaBp924TOz+23R8goa2exNcaH3gda+eavqW9lLEVHTzpgTAYUvX6uZdEa2/iC5EiSai1RDpBuDlYtDV+nXVTpB3kt3UKujlo4YUswpap336HbVGmMiG7XIQdybsEIlJHIVeS6+o6YuBVp03aImals6p6upoL3gmFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774245121; c=relaxed/simple;
	bh=q+C9JqQPxoB3+qB9AWg6QTYSyL+DGHkgTyZmWDdivMI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjll1nuTpPTKhP0jZ1aim1eYZdfuId+8ET2wDKkjD275LdV60iI0D5fVvtejl6bnQwCsRYOdUfPRubNGz2bTYJU5xL//9fVxt8jpBZpoT03sA3Ny+vuSkszF//BGwRPfIp5LhMEoJ4fa6zmluGU6/Q5+Cith9NukTKtay7S69C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qeo/3Kph; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qeo/3Kph; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qeo/3Kph";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qeo/3Kph"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 670744D341
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774245117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YHmi63QkAJq1e1Cl273N2ErXBm6dEn+1JhRteVUYWY8=;
	b=qeo/3KphPlCATRAVUbb4Kwi+AGDiVV057CWnDGl/Kqk92S+9lA2yWJNHkvm4peu6W0HI0I
	rKIlOg9Y4oUdLKnEd8D8l8msbrdDSBkiA17MJgXPztijNl0mBSlIvn3jRsEDZTeovXvyAx
	gf3BitQcR7I1n6yyk4+bnBoyU3q10WA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="qeo/3Kph"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774245117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YHmi63QkAJq1e1Cl273N2ErXBm6dEn+1JhRteVUYWY8=;
	b=qeo/3KphPlCATRAVUbb4Kwi+AGDiVV057CWnDGl/Kqk92S+9lA2yWJNHkvm4peu6W0HI0I
	rKIlOg9Y4oUdLKnEd8D8l8msbrdDSBkiA17MJgXPztijNl0mBSlIvn3jRsEDZTeovXvyAx
	gf3BitQcR7I1n6yyk4+bnBoyU3q10WA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0DE643704
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AG6rGPzUwGlCAQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 05:51:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: mkfs/rootdir: add hole detection
Date: Mon, 23 Mar 2026 16:21:36 +1030
Message-ID: <8b28a3340826a0d8ec00961211ab0b62190eb622.1774244873.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774244873.git.wqu@suse.com>
References: <cover.1774244873.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 670744D341
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Currently mkfs.btrfs --rootdir can not detect holes, thus it will always
read out the content of the files then write them into the destination
filesystem.

This can be time consuming for both the IO and checksum calculation, so
it can save a lot of CPU and IO time to skip those holes.

This patch adds such detection through SEEK_DATA flag for lseek64().

There are some minor corner cases:

- If the @file_pos is already inside a hole covering EOF
  lseek64() will return -1 and set errno to ENXIO.
  We need to properly handle this case other than treating it as an
  error.

- The host fs may have a different block size
  The returned offset from lseek64() is only aligned to the host fs
  block size, which can be different from the target btrfs block size.
  This is especially important as we are going to support all block
  sizes, thus we need to take extra care.

  Here we make it simple by rejecting any returned position that is not
  aligned to the target fs block size, and fallback to regular
  read/write path.

  In theory we can do better, but I believe 4K fs block will be the
  standard thus we do not need to bother too much yet.

- Limit the read length to the next hole start
  Otherwise we can read out the hole just after the non-hole range.

- Prevent return value overflow of add_file_item_extent()
  Since we can get a huge hole, and that function returns the number of
  bytes processed, for a huge hole (>= 2GiB) the length will
  overflow INT_MAX and make the caller treat the return value as an error.

  Here we limit the hole lenght to 1GiB to prevent overflow.

Here is a simple benchmark, almost the best case scenario:

 rootdir/
 \- middle_hole

The file "middle_hole" is generated by the following command:

 xfs_io -f -c "pwrite 2g 4k" -c "truncate 5g" middle_hole

So it's a single 4K block at the middle of 5G sparse file.

Unpatched timed mkfs:

 real	0m24.824s
 user	0m22.213s
 sys	0m2.078s

Patched timed mkfs:

 real	0m0.026s
 user	0m0.006s
 sys	0m0.007s

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 7bdd6245f0d6..ed0fcfccd42a 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -798,6 +798,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	bool datasum = true;
 	ssize_t comp_ret;
 	u64 flags = btrfs_stack_inode_flags(btrfs_inode);
+	off64_t next;
 
 	if (g_do_reflink || flags & BTRFS_INODE_NOCOMPRESS)
 		do_comp = false;
@@ -807,9 +808,38 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 		do_comp = false;
 	}
 
-	buf_size = do_comp ? BTRFS_MAX_COMPRESSED : MAX_EXTENT_SIZE;
-	to_read = min(file_pos + buf_size, source->size) - file_pos;
+	next = lseek64(source->fd, file_pos, SEEK_DATA);
+	/* The current offset is inside a hole to the next of the file. */
+	if (next == (off64_t)-1 && errno == ENXIO)
+		next = round_up(source->size, sectorsize);
+	if (next != (off64_t)-1 && next > file_pos && IS_ALIGNED(next, sectorsize)) {
+		/*
+		 * Limit the hole size to 1G, this is to avoid overflow int type,
+		 * or a hole length >= 2G can be treated as an error.
+		 */
+		const u64 length = min_t(u64, next - file_pos, SZ_1G);
 
+		btrfs_set_stack_file_extent_num_bytes(&stack_fi, length);
+		btrfs_set_stack_file_extent_ram_bytes(&stack_fi, length);
+		ret = btrfs_insert_file_extent(trans, root, objectid, file_pos, &stack_fi);
+		if (ret < 0) {
+			error("cannot insert hole for range [%llu, %llu)",
+			      file_pos, file_pos + length);
+			return ret;
+		}
+		return length;
+	}
+
+	/*
+	 * We have skippted to the next data, try to locate the next hole
+	 * to limit the read size.
+	 */
+	next = lseek64(source->fd, file_pos, SEEK_HOLE);
+	if (next == (off64_t)-1 || !IS_ALIGNED(next, sectorsize) || next > source->size)
+		next = source->size;
+
+	buf_size = do_comp ? BTRFS_MAX_COMPRESSED : MAX_EXTENT_SIZE;
+	to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
 	bytes_read = 0;
 
 	while (bytes_read < to_read) {
@@ -874,7 +904,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 			btrfs_set_stack_inode_flags(btrfs_inode, flags);
 
 			buf_size = MAX_EXTENT_SIZE;
-			to_read = min(file_pos + buf_size, source->size) - file_pos;
+			to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
 
 			while (bytes_read < to_read) {
 				ssize_t ret_read;
-- 
2.53.0

