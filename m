Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE068149C6F
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 00:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780533026; cv=none; b=IMY/YIEfmdYylHSoYvL43KN4sSuKakfw/M2h2TAiFRm3sbe/4dr+v6oJrqZ9m/vZZDW/ry0SBaTbFVkfYAT29z7NSXLvdXgfpfzp1kMq/4Mg1MjRSjac/0NpHkb15jKGGXkZzeLKWZfM+gLqjKNaXQ5/yBOKWU7wcdwjRYl3esQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780533026; c=relaxed/simple;
	bh=fKWYOqSuVngu/rwGA6wgdKfu/MEcBR7lnNB+pCS/n6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzS0aiK2bo1jj1Vx3RB8TxC84X6XY1X4s4mINJCUkGjUVT/itz21xpJ5MB4cLAvmSAO1/YXQO/EAunnKb3FKQMjUbmEyy3FZoZYvXQe1103+ASNH+1XQX1SG5GUdYM1UedxDkgVozGoTvqO/cm8idKbhyOzj5Ig18y2jl07sN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=udGeNsNK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MVMXdMD7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="udGeNsNK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MVMXdMD7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D16ED6AA4A;
	Thu,  4 Jun 2026 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780533016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uU+ah5HiTWSIz+71+DeYFL41s2h4ORkA8TapJUnwd4U=;
	b=udGeNsNKoA/eT3+O0u2V6UVwwHUOIo9BgZQWy4oucwfLaKmxpl521dn2RpM2AOu95U5xFj
	GJXPgu66b5XfZv5Psbe3JEQxpJG7UHWeR2ZIIf4BOzJrMrI7COz3Yhq2D+5lFwpAxEc4p4
	CzIy6C8oKYDW8EqA6YyQcUaP9Gfd9tA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780533014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uU+ah5HiTWSIz+71+DeYFL41s2h4ORkA8TapJUnwd4U=;
	b=MVMXdMD7ppH0Cp3Ojr68vUzB80Upbj0CbjPTHPzv3dVpl4VOJtcaG0+keYZZpXS3sq3Pxy
	pL0SDzYnnS1+A8NDhnM4Yaa097hhvubAi8rRJwGj4YoMQCSnplrs8+C2SC4ac7JU0Y0TWo
	CdYJyOy/jOmWR0GCwbOATdV6l6mgAwE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E37A779A8;
	Thu,  4 Jun 2026 00:30:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oI0mCxXHIGqsVgAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 04 Jun 2026 00:30:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>
Subject: [PATCH v3 3/3] btrfs: retry faulting in the pages after a zero sized short direct write
Date: Thu,  4 Jun 2026 09:59:48 +0930
Message-ID: <b509ca00181f9486d3529285506cf50a607bfe54.1780528155.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780528155.git.wqu@suse.com>
References: <cover.1780528155.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

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

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 412309825d6f..460326d34143 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -978,7 +978,7 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (ret > 0)
 		written = ret;
 
-	if (iov_iter_count(from) > 0 && (ret == -EFAULT || ret > 0)) {
+	if (iov_iter_count(from) > 0 && (ret == -EFAULT || ret >= 0)) {
 		const size_t left = iov_iter_count(from);
 		/*
 		 * We have more data left to write. Try to fault in as many as
-- 
2.54.0

