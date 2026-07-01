Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0DD4C6D
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864575; cv=none; b=t8J8+T5KU/W7uDp/uSWV4Zygqhv36e06DTN5vH5NtBOdKn8ceXf1uSke4GXA149sF15jdUsz4p92YY5Z4hoWxKLx/QS5cXTa2t554sWmlOv8NOJeibcItBFkq4GbeHxgbYNkDKErbsKPpCzs/5O04u+gZgvfTEOoj1WLyRKhd/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864575; c=relaxed/simple;
	bh=w2mUuHj4zexnUpUgbu7rmHQt27e9i93uR/z/h2OuoKk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YCF1p1ByFcBDjYfjZbkTT5MUOcA8ZaamLCmzJLvpZaqNJaYe1Bbhx5FxMepaYDAHCkxymuUFjBf90HGBPUmAsM1IIkReMj1jR0OA28eNOXaCidgRAvg/FA1RmnEIvV91PW+KAxymJNYYvttCtGcYn2bwT9DuPzDp5fIdGGd1Vwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pV5+G71C; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pV5+G71C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pV5+G71C";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pV5+G71C"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D534371E0F
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 00:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782864571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zV2QhXV68K/zoBdyzsCsA5FV0WMGS4Fzx0Vml5HTZy8=;
	b=pV5+G71C3vQy/eRc1wUS6XMLPWILV+bhBhA67guR1Ie5f3jt+mbvXqtPYG2oskiu3oEl2n
	Cbl+54Iur4cWupChRk3Cmjm8lFTVNlVQ4YbsSALqtTmiW+rPmzHDAusijmKTFO40+i5IEG
	Zg8+FEVsAAYdagQ/A4TYtzgz8mGKmN0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782864571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zV2QhXV68K/zoBdyzsCsA5FV0WMGS4Fzx0Vml5HTZy8=;
	b=pV5+G71C3vQy/eRc1wUS6XMLPWILV+bhBhA67guR1Ie5f3jt+mbvXqtPYG2oskiu3oEl2n
	Cbl+54Iur4cWupChRk3Cmjm8lFTVNlVQ4YbsSALqtTmiW+rPmzHDAusijmKTFO40+i5IEG
	Zg8+FEVsAAYdagQ/A4TYtzgz8mGKmN0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB3F9779AA
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 00:09:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5IupIrpaRGqASgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 00:09:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: update the direct IO behavior notes for version 7.3
Date: Wed,  1 Jul 2026 09:39:12 +0930
Message-ID: <ae799abcfe1a52d8cc73f1a43565fa2f558999e5.1782864511.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
X-Spam-Level: 
X-Spam-Score: -2.80

Since v7.3 will use IOMAP_DIO_BOUNCE flag to address the performance
drop of falling back to buffer IO, update the direct IO behavior notes
to avoid confusion.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/ch-checksumming.rst |  7 ++++++-
 Documentation/ch-compression.rst  | 13 ++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/ch-checksumming.rst b/Documentation/ch-checksumming.rst
index 39dc79079aef..8ccdb79e25e4 100644
--- a/Documentation/ch-checksumming.rst
+++ b/Documentation/ch-checksumming.rst
@@ -17,10 +17,15 @@ has a detached checksum stored in the checksum tree.
 
    To avoid this, kernel starting with version 6.14 will force a direct
    write to fall back to buffered, if the inode requires a data checksum.
-   This will bring a small performance penalty. If you require true zero-copy
+   This will bring an observable performance penalty. If you require true zero-copy
    direct writes, then set the ``NODATASUM`` flag for the inode and make
    sure the direct IO buffer is fully aligned to block size.
 
+   The kernel starting with version 7.3 will address the unstable buffer by bouncing
+   the buffer if the inode requires data checksums.
+   Although this is not true zero-copy, it's still better than falling back to buffered,
+   achieving 95% of true zero-copy performance.
+
 There are several checksum algorithms supported. The default and backward
 compatible algorithm is *crc32c*. Since kernel 5.5 there are three more with different
 characteristics and trade-offs regarding speed and strength. The following list
diff --git a/Documentation/ch-compression.rst b/Documentation/ch-compression.rst
index df0ed188faa2..7a53fc5b9832 100644
--- a/Documentation/ch-compression.rst
+++ b/Documentation/ch-compression.rst
@@ -171,17 +171,20 @@ Compatibility
 Compression requires both data checksums and COW, so either *nodatasum* or
 *nodatasum* mount option/inode flag will result in no compression.
 
-Direct IO reads of compressed data will always fallback to buffered reads.
+Direct IO reads of compressed data will always falls back to buffered reads.
 
-Direct IO write behavior depends on the inode flag.
-For inodes with data checksum, direct IO writes always fallback to buffered
-writes, thus can generate compressed data if the mount option/inode flags
-allows that.
+Direct IO write behavior depends on the inode flag and kernel version.
+
+Before v7.3, for inodes with data checksums, direct IO writes always fallback
+to buffered writes, thus can generate compressed data if the mount option/inode
+flags allow that.
 
 For inodes without data checksums, direct IO writes will not populate page cache,
 and since the inode has no data checksums, no compressed data will be generated
 anyway.
 
+Starting with kernel v7.3, no compression is performed, no matter if the inode has data checksums or not.
+
 The compression algorithms have been added over time so the version
 compatibility should be also considered, together with other tools that may
 access the compressed data like bootloaders.
-- 
2.54.0

