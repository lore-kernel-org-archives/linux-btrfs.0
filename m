Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3703EC817
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541568; cv=none; b=SBU1jRoSCZs/rnUTd6hF619Vy1CbGqiNyx+2BkyrWFjlBeePugov8hXVewtTTrmL4UC441aOo15D7KPmz9FVlS/6gi1wk5nR41NHjp15EC0mjhTlmjs3SLnKVRxDcaMuFErhXgF7yS49l+K7Z/1IMNZr6X/GS4ZQy40QuXKwBjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541568; c=relaxed/simple;
	bh=Noonsb13+DbN4Pek6TVstnDYtF2HUEX/Ct7YnZEiY9o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gj5eQTka14DBED0QG25jyqTnYZRX+Rb8TNO1u4OqIG3smghO8iEvcmhTI5R+RrKJZPilkIa7teOQPPhcCkBI2Pflqo6XA3FhHJmb8zYXtQkwAh2aSP4DtaOWKD5KGghhdnqG2Rzy67+ygrx8VJKZSGiRZX9nM5yrp2RLRY/UrZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aAR/iSwi; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FNvVXCaJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aAR/iSwi";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FNvVXCaJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E7D0321C45
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mSTl8WbOr34XGs61yi75jHZcgawIp5mZWVgKf7VEhAI=;
	b=aAR/iSwiHN7RMWcF2VYTBuG/8EaL7y/kYEftLo6W2IA1Clg4q6Y1duz+0xLezs8Uy7LnrX
	75R/FPlVLgmk2a6/ZKBDuYznaI7aaGF9M9eZVhxPAY0cQme7j+f3n/YvS+afqu9Hq30WtW
	gE9uJrWJdXkldztDIRE6dWrzGUhk/A4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mSTl8WbOr34XGs61yi75jHZcgawIp5mZWVgKf7VEhAI=;
	b=FNvVXCaJh3TFDEpleCdvrgr1bXCRSPFiq+yhxcxWMP3U+z0EClt+2aJEQevjvJ751btPRw
	yTMAu8QU1Zhi6mwyO0u8B4YJ8c5AA4dxTf5cTMRp5yIrmPICrRRYpcb2kkxO8zRFJmfH/x
	XEclv/88aqlW/pB4pS7zSB08zluKtTw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A12F9136DB
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ts9hJK88qmr0ZAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: restore: handle inlined extent larger than 4K
Date: Wed, 16 Sep 2026 16:22:04 +0930
Message-ID: <ced5849aa3013d88b96d658dccfa2d1630a84e2d.1789541428.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789541428.git.wqu@suse.com>
References: <cover.1789541428.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Most btrfs are already using 4K sectorsize, but for systems with 64K
page size, it's possible to create large inlined extent that is larger
than 4K:

	item 6 key (257 EXTENT_DATA 0) itemoff 56802 itemsize 8213
		generation 9 type 0 (inline)
		inline extent data size 8192 ram_bytes 8192 compression 0 (none)

In that case, btrfs-restore will crash as its input buffer is only 4K
sized.

Enhance btrfs-restore to handle larger block size correctly, by allocate
a block-sized buffer at input buffer.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/restore.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/cmds/restore.c b/cmds/restore.c
index 00471b486ac6..b982f2de4699 100644
--- a/cmds/restore.c
+++ b/cmds/restore.c
@@ -295,7 +295,8 @@ static int copy_one_inline(struct btrfs_root *root, int fd,
 {
 	struct extent_buffer *leaf = path->nodes[0];
 	struct btrfs_file_extent_item *fi;
-	char buf[4096];
+	const u32 blocksize = root->fs_info->sectorsize;
+	char *inbuf;
 	char *outbuf;
 	u64 ram_size;
 	u64 out_buf_len;
@@ -306,16 +307,23 @@ static int copy_one_inline(struct btrfs_root *root, int fd,
 	int inline_item_len;
 	int compress;
 
+	inbuf = malloc(blocksize);
+	if (!inbuf) {
+		error_mem(NULL);
+		return -ENOMEM;
+	}
+
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 	ptr = btrfs_file_extent_inline_start(fi);
 	len = btrfs_file_extent_ram_bytes(leaf, fi);
 	inline_item_len = btrfs_file_extent_inline_item_len(leaf, path->slots[0]);
-	read_extent_buffer(leaf, buf, ptr, inline_item_len);
+	read_extent_buffer(leaf, inbuf, ptr, inline_item_len);
 
 	compress = btrfs_file_extent_compression(leaf, fi);
 	if (compress == BTRFS_COMPRESS_NONE) {
-		done = pwrite(fd, buf, len, pos);
+		done = pwrite(fd, inbuf, len, pos);
+		free(inbuf);
 		if (done < len) {
 			error("short inline write, wanted %d, did %zd: %m",
 					len, done);
@@ -329,17 +337,20 @@ static int copy_one_inline(struct btrfs_root *root, int fd,
 	outbuf = malloc(out_buf_len);
 	if (!outbuf) {
 		error_mem(NULL);
+		free(inbuf);
 		return -ENOMEM;
 	}
 
-	ret = decompress(root, buf, outbuf, inline_item_len, &out_buf_len,
+	ret = decompress(root, inbuf, outbuf, inline_item_len, &out_buf_len,
 			 compress);
 	if (ret) {
+		free(inbuf);
 		free(outbuf);
 		return ret;
 	}
 
 	done = pwrite(fd, outbuf, ram_size, pos);
+	free(inbuf);
 	free(outbuf);
 	if (done < ram_size) {
 		error("short compressed inline write, wanted %llu, did %zd: %m",
-- 
2.55.0

