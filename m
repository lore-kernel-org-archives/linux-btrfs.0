Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491AB3876CD
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786316415; cv=none; b=Ipwqxep1TEBBKrmlNyLzJoC/5pyPmEdfPf9f9+7dCuhs3qguX6D2rEea13HHT+ihtlrQtNXF2rX9pqdqUIbqyXDSVLBkcqneHKJ/ixhTtmQ3VS+dn1shbewZUNaqBcc4pM9olNAt1imSwHQWgGGolmmPjNTZ3dvlT2YlQBN1JkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786316415; c=relaxed/simple;
	bh=eSslJPb84mqx2HZDxAqsndWmcreU2sAuh8987nFKmRY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cJHGN7ujCXhnwwDvq22JWTG0pyzH+/4Ywpvj1d0r/SYEECnDp2YihO7GfVvBJkqJToxAiCl+4aVxZ/LujzRovfigc9q79eoJpUrI7n/QAAaayHxSyDm0pV32Dw3+2J5Lq+MxrcuBcsMuh9XIf5KCK7tVMpVDjdcaw98hrVZ4faQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MfYOOIA3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=doNbpu1A; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MfYOOIA3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="doNbpu1A"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F32C3F68
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 22:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786316401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pseIWRD9g1KYvqwIDYnB2/zV01r8qwL7wjT4KaG5UnE=;
	b=MfYOOIA32hqlGDtqkBRBLL8cmYTtGzGiXxJRgONE7/mH7cD6Gn6yyyH1qVVUFwl42Z0xE7
	L9GJLQuut/yCNvZb+a5TEFAHWdmG9eJdBVSA+VUZ4E3UtL6P/UFPaXCJg9ZCZKz/YmA5Q7
	jY+/4oHZvKvviTFuM86jpjSA8nr9BZo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=doNbpu1A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786316397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pseIWRD9g1KYvqwIDYnB2/zV01r8qwL7wjT4KaG5UnE=;
	b=doNbpu1AEgGpFYg568i5wxXc++NJiJM4sAHPOBpKepYtvdo+5SCWK24ofwQV/lAigKTLh5
	Jmw3LsRJwTLMmAwOFwqrWmOWoiuDUrDBIIZOhk+EQ6ndtF/l9JLyd68a6SECORZ2xTnHui
	jQJo9CSFIT5jw7h1kQDnylxp8SSBerU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1757F779B6
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 22:59:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ujyuK2sGeWqNcwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 22:59:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: props: ensure data buffer is NUL terminated
Date: Mon, 10 Aug 2026 08:29:33 +0930
Message-ID: <a47ac74a9d7d7e51eeb4f47eeafc09ac512815e7.1786316357.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 3F32C3F68
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Btrfs stores its specific XATTR strings in XATTR_ITEM without NUL
termination. e.g:

	item 6 key (257 XATTR_ITEM 550297449) itemoff 15812 itemsize 51
		location key (0 UNKNOWN.0 0) type XATTR
		transid 10 data_len 4 name_len 17
		name: btrfs.compression
		data zlib

Note that both name and data have no extra NUL termination byte.

Meanwhile we have a lot of call sites that are calling
strncmp()/strcmp() which requires both strings to be NUL terminated.

For name buffer it's fine, as we allocate the name buffer by name_len +
1, and manually set the byte at @name_len to '\0' after reading the
name.

But it's not the case for data buffer, and inside prop_compression_*(),
we have all kinds of call sites calling strncmp()/strcmp(), including:

- prop_compression_validate()
- prop_compression_apply()

Those strncmp()/strcmp() can read at most 4 bytes, which can go beyond
the value_buf[] allocated, especially when the image is maliciously
crafted.

Avoid such problem by following the name_len handling, by allocating one
extra byte for value_buf[] and always set the byte at @data_len to '\0'
so the value_buf[] is always NUL terminated.

Fixes: 63541927c8d1 ("Btrfs: add support for inode properties")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/props.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index bb77d46376d4..4dfe8708e5ba 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -234,16 +234,17 @@ static int iterate_object_props(struct btrfs_root *root,
 			if (!handler)
 				goto next_dir_item;
 
-			if (data_len > value_buf_len) {
+			if (data_len >= value_buf_len) {
 				kfree(value_buf);
-				value_buf_len = data_len;
-				value_buf = kmalloc(data_len, GFP_NOFS);
+				value_buf_len = data_len + 1;
+				value_buf = kmalloc(value_buf_len, GFP_NOFS);
 				if (!value_buf) {
 					ret = -ENOMEM;
 					goto out;
 				}
 			}
 			read_extent_buffer(leaf, value_buf, data_ptr, data_len);
+			value_buf[data_len] = '\0';
 
 			iterator(ctx, handler, value_buf, data_len);
 next_dir_item:
-- 
2.54.0

