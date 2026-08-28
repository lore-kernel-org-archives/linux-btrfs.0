Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89EC36F8E5
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 09:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909332; cv=none; b=eyNrLyT9Xf8iMaS84vHcPXEB9Hf1xrXEGjGUenSW9tgBMIx8XfH7h7FFU//K4UhUyO7xsaI4yrAFJi1bfm8npUjEWvm2rDuhX7uuLHy6BxA3ba10s97Ual4wVKWNj/D5rERxHd7u/0gNHN6T5o/bX8nvbjS0oIIG58CvkUXV8oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909332; c=relaxed/simple;
	bh=bAickSvBtKo9sLnG2oDpLW7wBHI4i3V4Ir7n7zDMrAk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rgXvInNnmyEqx8gHfnGWNB57GU+BFvao5gLFCW99BoUr2raz02hsSXmzyDcjPFPjzKkCEtVEX0ya1M/zjq2sirPsRLAWJph1ZcAM2YQpERH8orvsz8KSN8ZFvnr6E90fq0NU5bGUHshM/gWXA1NK0KE1j8+4jHeGIFMBTsUVhjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tGI0GWs9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lxs9Kzka; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tGI0GWs9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lxs9Kzka"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 885531F892
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 09:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787909324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UWE3gpeRM8zmymnZhuaghO1y0XbPwOHdVIPjNSlugiM=;
	b=tGI0GWs9X290M8QfGQosFyCA41ss70LlYf4OE7SGlzXVzLDpUv9sEqx6V+GgbRAU4UV3d5
	yjZlt+yTJ2B7hZtwYkQi3SzEggFMnGeLL/UAXvVihCduvl0afUKxxzjUBsIh2lEO9itkIr
	Hl3qXvTWdxKfO42sRLEhKB1/EIwTD3I=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Lxs9Kzka
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787909320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UWE3gpeRM8zmymnZhuaghO1y0XbPwOHdVIPjNSlugiM=;
	b=Lxs9KzkaOt5M7wc7ynzI3cemhFyW2P3ypDGC3iuAG1HFpCzamprIVWxfUeTW+BQewwmHmL
	UXJOKyv5p8tpKGvOFLQXaQfW9u/MICG/An5HShWfq8tTLS5dLboSVgDKPhz+Z+jIjqo8aI
	tJq0zte7+5gnWr/JMjMUFIcqVXLeO6A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6ED0D13674
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 09:28:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uVddB8dUkWpOeAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 09:28:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use IOMAP_DIO_BOUNCE flag for direct reads
Date: Fri, 28 Aug 2026 18:58:16 +0930
Message-ID: <1219d8d9ed105a922d9af6130e08532e2907ea17.1787909265.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 885531F892
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Similar to direct writes, if the inode requires data checksum, we should
use a stable buffer for IO, or even for direct reads an unstable buffer
(e.g. the buffer is being modified during the direct read) can lead to
checksum mismatch and even cause read failure.

To address the potential problems of unstable dio read buffers, use
IOMAP_DIO_BOUNCE for dio reads if the inode requires data checksum.

This will bring a small performance drop, around 7% for my benchmark,
which is definitely observable on modern NVME SSDs, but the overhead is
still much smaller compared to data checksum:

 Fio command line:

 # fio --name=randread --filename $mnt/foobar --ioengine=libaio --size=4G \
    --rw=randread --bs=64k --iodepth=64 --runtime=60 --time_based --direct=1

 The VM setup:

 10 vCPUs (host-passthrough), 8G RAM, target storage has cache=none
 option, is backed by a cheap DRAM-less 1T mainstream PCIe4 SSD.

                                 | Bandwidth (MiB/s) |   Diff
 --------------------------------+-------------------+-----------
 Nodatasum, zero-copy (Baseline) | 988               |     0
 Datasum, zero-copy (unpatched)  | 853               | -13.7%
 Datasum, bounce (patched)       | 794               | -19.6%

The difference between data csum bounce and zero-copy is only 7%, which
is much more acceptable than falling back to buffered IO.

Meanwhile just enabling data checksum, even for the fastest CRC32C, the
read performance drops around 13.7%.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index ed1779ccb4de..0c9386f1922b 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -818,9 +818,23 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
 			      size_t done_before)
 {
 	struct btrfs_dio_data data = { 0 };
+	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
+
+	/*
+	 * Data checksum requires stable buffer.
+	 *
+	 * And unlike dio writes, reads are always from one single
+	 * mirror, so there is no need to consider mirror/parity profiles.
+	 */
+	if (!(BTRFS_I(file_inode(iocb->ki_filp))->flags & BTRFS_INODE_NODATASUM)) {
+		/* Bounce will allocate memory, breaking NOWAIT. */
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		dio_flags |= IOMAP_DIO_BOUNCE;
+	}
 
 	return iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
+			    dio_flags, &data, done_before);
 }
 
 static bool need_stable_write(struct btrfs_inode *inode)
-- 
2.55.0

