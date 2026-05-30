Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A2430E85C
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780112096; cv=none; b=H4+dXlPEjjrZIxh/laaarGIFLL9a7vutmpua06N9k5SgGJWQAT2ay3qYvxsFku0/bz72pZfMGo//LLjMWdkIL/uNWnPVWphxNBnh2GAtBU65Jeg32ne1L1vOAyKkuCnfcnZlzFwRlhlaCLLzxVtiHh3LFiHt8IvtH8Uja/XqAAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780112096; c=relaxed/simple;
	bh=SdpBQUk1+93EX4ZjOwTtnKiLVhuj6EpTL9t5zzkCKew=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiH5dp0xSOs1P7cb32brnNrgAqEDnBeSe0G0JvrXxmRhvc1TBFQ4Evcy82gE3J5+rL1JQZ9ylxTYcazM7TL6zjErNGGCwlJSGy6AfltTfIAOUyQXNiZ0YLo+xqceXu1MasJZv6skRYoqz3D3o4vxtmw+zOIR6aagX1+Vm6JAFzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Xs4jnYNp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Xs4jnYNp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Xs4jnYNp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Xs4jnYNp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C905A6745A
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuYANAVZiVHo4t1zHInw191+zKu3MnGdNzCD978m+0U=;
	b=Xs4jnYNpgKQRM6uJGMiNyXeV8xnFPpLXcLKwz0b3B5UyNtdn7TmVRkadrWL2lOmSIwq/jW
	V2mtcYJ8KYd1ljZDqjAnKn9Rs9XLKR+NbiDOkIyqDWqI3rPemh/74fPTsZN8rS4DhFWfbM
	QcCT5++hx1zz5HRq+ps4sTlbN6oZBwA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780112085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuYANAVZiVHo4t1zHInw191+zKu3MnGdNzCD978m+0U=;
	b=Xs4jnYNpgKQRM6uJGMiNyXeV8xnFPpLXcLKwz0b3B5UyNtdn7TmVRkadrWL2lOmSIwq/jW
	V2mtcYJ8KYd1ljZDqjAnKn9Rs9XLKR+NbiDOkIyqDWqI3rPemh/74fPTsZN8rS4DhFWfbM
	QcCT5++hx1zz5HRq+ps4sTlbN6oZBwA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 124C7779A7
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8DqUMdRaGmorcgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 03:34:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: retry faulting in the pages after a zero sized short direct write
Date: Sat, 30 May 2026 13:04:19 +0930
Message-ID: <70c80c02852c233abb0b3cde0c99efc37f14f9d8.1780112003.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780112003.git.wqu@suse.com>
References: <cover.1780112003.git.wqu@suse.com>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]

Currently btrfs_direct_write() will not try to fault in the pages, but
directly fall back to buffered writes, if the first page of the buffer
can not be faulted in.

For example, during generic/362 with nodatasum mount option, there is a
write at file offset 0, length PAGE_SIZE, and the page is not faulted in.
Then we go the following callchain and directly fall back to buffered
IO:

 btrfs_direct_write()
 |- btrfs_dio_write()
 |-  __iomap_dio_rw()
 |  |- iomap_iter()
 |  |  |- btrfs_dio_iomap_begin()
 |  |     Now an ordered extent is allocated for the 4K write.
 |  |
 |  |- iomi.status = iomap_dio_iter()
 |  |  Where iomap_dio_iter() returned -EFAULT.
 |  |
 |  |- ret = iomap_iter()
 |  |  |- btrfs_dio_iomap_end()
 |  |  |  | return -ENOTBLK
 |  |  |- return -ENOTBLK
 |  |- if (ret == -ENOTBLK) { ret = 0; }
 |     Now the return value is reset to 0.
 |
 |- ret = iomap_dio_complete()
 |  Since no byte is submitted, @ret is now zero.
 |
 |- if (iov_iter_count() > 0 && (ret == -EFAULT || ret > 0))
 |  @ret is zero, thus not meeting the above retry condition
 |
 |- Fallback to buffered

Just slightly loosen the condition to allow retry faulting in pages after
a zero sized short write.

Unlike the previous two bug fixes, this one is not really cause any real
bug, but only reducing the chance to do zero-copy direct IO.
Thus it doesn't really require stable-CC nor fixes-tag.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index fd53fac7186e..99c959be8de7 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -960,7 +960,7 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (ret > 0)
 		written = ret;
 
-	if (iov_iter_count(from) > 0 && (ret == -EFAULT || ret > 0)) {
+	if (iov_iter_count(from) > 0 && (ret == -EFAULT || ret >= 0)) {
 		const size_t left = iov_iter_count(from);
 		/*
 		 * We have more data left to write. Try to fault in as many as
-- 
2.54.0

