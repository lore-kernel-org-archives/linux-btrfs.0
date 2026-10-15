Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223E054705B
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 00:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023940; cv=none; b=KKAVLFSqxFimvdMiY/V7B30K8tsC/7wXPOxKIIMlLyI0546MQn0yf6Yg0n5v8HuGvr/oNn2RSghOJaxSIdAFrkmlAnvtmM2WtlUT4n9cj3LfuM7P0/j1Rwkp1d2Dgnb5o2C+wk3HweVvctJ2hz4d7T2LPHzSR4s7xqpHvwyydE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023940; c=relaxed/simple;
	bh=mUOa1H869qMukWEf0XEMpUiqNPOriMhm8L34g8t/k04=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hHFXHN8wHx0zFAl4p3rJs9k7aI5Px15X23sFPsx88/tsnaBaYZ61lBjqlIl4NF6IsHbnngtmxB62Pn8cSG+Kf0lBK+zJ9KVO0YuaM6qVnGS0v2eRD2a/XrWcSojrhsPnnscpoJVYTJFy1nJ93QG7nUJ1Ak5j4hQKuxiendXgtmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JtM2DQPx; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JtM2DQPx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JtM2DQPx";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JtM2DQPx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FDBF1F390
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 00:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792023937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VnBMRidPgsx99ft+orDUGJPu4IgN5H3ypg11x96GFjI=;
	b=JtM2DQPxhpHdfkJ4cw9RncBtgrRYMs/RRgaRspkjH49BLsn+io9QXN3WW0FCHTPAGy/f90
	Rj5nXbNbstgR+Xo9GtDMhIcX5nj89vObF7xEg/KYs9yhmkNDlsUaWjZ9mIKAhN/ob3JuEv
	y7sKy3euOSbk6FIxb/wF3OdUKJRneWk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792023937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VnBMRidPgsx99ft+orDUGJPu4IgN5H3ypg11x96GFjI=;
	b=JtM2DQPxhpHdfkJ4cw9RncBtgrRYMs/RRgaRspkjH49BLsn+io9QXN3WW0FCHTPAGy/f90
	Rj5nXbNbstgR+Xo9GtDMhIcX5nj89vObF7xEg/KYs9yhmkNDlsUaWjZ9mIKAhN/ob3JuEv
	y7sKy3euOSbk6FIxb/wF3OdUKJRneWk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE34C1373D
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 00:25:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OcsrDX8d0GofBQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 00:25:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: receive: fix and enhance inlined lzo decompression
Date: Thu, 15 Oct 2026 10:55:02 +1030
Message-ID: <35f1c7d8ac6a562617fdd7a5cf11d6f0e4ae4090.1792023874.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

[BUG]
There is a bug report of heap memory overflow during receive if
--force-decompress is utilized:

=================================================================
==557235==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x5020000000c0 at pc 0x5c38d895e8b9 bp 0x7ffdaefad510 sp 0x7ffdaefad500
WRITE of size 1 at 0x5020000000c0 thread T0
    #0 0x5c38d895e8b8 in lzo1x_decompress_safe /tmp/tmp.aIYhV2VAge/lzo-2.10/minilzo/minilzo.c:6313
    #1 0x5c38d88623cb in decompress_lzo cmds/receive.c:1165
    #2 0x5c38d886274f in decompress_and_write cmds/receive.c:1222
    #3 0x5c38d8863459 in process_encoded_write cmds/receive.c:1320
    #4 0x5c38d8785daf in read_and_process_cmd common/send-stream.c:505
    #5 0x5c38d878a16f in btrfs_read_and_process_send_stream common/send-stream.c:654
    #6 0x5c38d88650fc in do_receive cmds/receive.c:1589
    #7 0x5c38d88664ab in cmd_receive cmds/receive.c:1827
    #8 0x5c38d869729b in cmd_execute cmds/commands.h:126
    #9 0x5c38d8698a6b in main /home/kevinv/btrfs-progs/btrfs.c:474
    #10 0x72779f02a1c9 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #11 0x72779f02a28a in __libc_start_main_impl ../csu/libc-start.c:360
    #12 0x5c38d8697184 in _start (/home/kevinv/btrfs-progs/btrfs+0x89184) (BuildId: a2ab208cbd7ebc744934a9ed7a8963a20b35fcf4)

0x5020000000c0 is located 0 bytes after 16-byte region [0x5020000000b0,0x5020000000c0)
allocated by thread T0 here:
    #0 0x72779f4fd340 in calloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:77
    #1 0x5c38d8862634 in decompress_and_write cmds/receive.c:1191
    #2 0x5c38d8863459 in process_encoded_write cmds/receive.c:1320
    #3 0x5c38d8785daf in read_and_process_cmd common/send-stream.c:505
    #4 0x5c38d878a16f in btrfs_read_and_process_send_stream common/send-stream.c:654
    #5 0x5c38d88650fc in do_receive cmds/receive.c:1589
    #6 0x5c38d88664ab in cmd_receive cmds/receive.c:1827
    #7 0x5c38d869729b in cmd_execute cmds/commands.h:126
    #8 0x5c38d8698a6b in main /home/kevinv/btrfs-progs/btrfs.c:474
    #9 0x72779f02a1c9 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #10 0x72779f02a28a in __libc_start_main_impl ../csu/libc-start.c:360
    #11 0x5c38d8697184 in _start (/home/kevinv/btrfs-progs/btrfs+0x89184) (BuildId: a2ab208cbd7ebc744934a9ed7a8963a20b35fcf4)

SUMMARY: AddressSanitizer: heap-buffer-overflow /tmp/tmp.aIYhV2VAge/lz

[CAUSE]
During lzo decompression, btrfs-progs always assume that the output
buffer is block aligned, even for inlined extents.

However since kernel commit 3eaf5f082c4c ("btrfs: extract inlined
creation into a dedicated delalloc helper"), btrfs will create inlined
compressed extents with tailing zero included.

For zlib and zstd it's fine as they provide multi-shot APIs, if the
output is exhausted, zlib/zstd doesn't error out, allowing us to
gracefully end the decompression.

But LZO has no multi-shot API, thus we have to ensure the output is
large enough to contain one fs block.
For inlined case, the output buffer contains only i_size bytes, which
can be smaller than a block.

This makes inline lzo extents decompression to write the full block into
the output buffer, overflow the heap.

[FIX]
Follow the kernel by introducing a dedicated inline decompression path,
and do extra validation for inlined decompression.

There is also a similar bug in the regular path, that crafted stream can
intentionally create a segment that doesn't take a full block.
In that case we still advance output buffer by blocksize, which can
cause the last block to overflow the buffer.

Also fix that by always limiting the output buffer size comparing to
@unencoded_len.

Issue: #1184
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/receive.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/cmds/receive.c b/cmds/receive.c
index 20c4e14bcead..e939cabeaea5 100644
--- a/cmds/receive.c
+++ b/cmds/receive.c
@@ -1115,6 +1115,64 @@ static int decompress_zstd(struct btrfs_receive *rctx, const char *encoded_buf,
 #endif
 
 #if COMPRESSION_LZO
+static int decompress_lzo_inline(const char *encoded_data, u64 encoded_len,
+				 char *unencoded_data, u64 unencoded_len,
+				 unsigned int sector_size)
+{
+	u32 in_len;
+	lzo_uint out_len;
+	void *buffer = NULL;
+	int ret;
+
+	/*
+	 * Compressed data should not reach sector_size.
+	 * And uncompressed data should not exceed sector_size.
+	 */
+	if (unlikely(encoded_len >= sector_size || unencoded_len > sector_size)) {
+		error("invalid lzo inlined extent, encoded_len=%llu unencoded_len=%llu blocksize=%u",
+		      encoded_len, unencoded_len, sector_size);
+		return -EUCLEAN;
+	}
+
+	memcpy(&in_len, encoded_data, 4);
+	in_len = le32toh(in_len);
+	if (in_len != encoded_len) {
+		error("invalid lzo header, header len=%u encoded len=%llu",
+		      in_len, encoded_len);
+		return -EIO;
+	}
+
+	memcpy(&in_len, encoded_data + 4, 4);
+	in_len = le32toh(in_len);
+
+	/*
+	 * There should be only one segment for an inlined lzo extent, and
+	 * there should be no padding either.
+	 */
+	if (in_len != encoded_len - 4 * 2) {
+		error("invalid lzo inlined header, segment len=%u encoded_len=%llu",
+		      in_len, encoded_len);
+		return -EUCLEAN;
+	}
+	buffer = calloc(1, sector_size);
+	if (!buffer) {
+		error_mem("lzo output buffer: %m");
+		return -ENOMEM;
+	}
+	out_len = sector_size;
+	ret = lzo1x_decompress_safe((void *)(encoded_data + 4 * 2), in_len,
+				    buffer, &out_len, NULL);
+	if (ret != LZO_E_OK) {
+		error("lzo1x_decompress_safe failed: %d", ret);
+		ret = -EIO;
+		goto out;
+	}
+	memcpy(unencoded_data, buffer, unencoded_len);
+out:
+	free(buffer);
+	return ret;
+}
+
 static int decompress_lzo(const char *encoded_data, u64 encoded_len,
 			  char *unencoded_data, u64 unencoded_len,
 			  unsigned int sector_size)
@@ -1122,10 +1180,23 @@ static int decompress_lzo(const char *encoded_data, u64 encoded_len,
 	uint32_t total_len;
 	size_t in_pos, out_pos;
 
-	if (encoded_len < 4) {
+	/* There should be at least 2 LZO headers, then payload. */
+	if (encoded_len < 4 * 2) {
 		error("lzo header is truncated");
 		return -EIO;
 	}
+	/* Looks like an inlined, pass to dedicated helper. */
+	if (encoded_len < sector_size || unencoded_len < sector_size)
+		return decompress_lzo_inline(encoded_data, encoded_len,
+				unencoded_data, unencoded_len, sector_size);
+
+	/* Everything should be aligned. */
+	if (unlikely(!IS_ALIGNED(encoded_len, sector_size) ||
+		     !IS_ALIGNED(unencoded_len, sector_size))) {
+		error("unaligned lzo extent, encoded_len=%llu unencoded_len=%llu blocksize=%u",
+		      encoded_len, unencoded_len, sector_size);
+		return -EIO;
+	}
 	memcpy(&total_len, encoded_data, 4);
 	total_len = le32toh(total_len);
 	if (total_len > encoded_len) {
@@ -1161,7 +1232,7 @@ static int decompress_lzo(const char *encoded_data, u64 encoded_len,
 			return -EIO;
 		}
 
-		dst_len = sector_size;
+		dst_len = min_t(u64, sector_size, unencoded_len - out_pos);
 		ret = lzo1x_decompress_safe((void *)(encoded_data + in_pos),
 					    src_len,
 					    (void *)(unencoded_data + out_pos),
-- 
2.56.0

