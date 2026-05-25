Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81034316199
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 04:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779684937; cv=none; b=J9Oz+AzzGEUPyrRnuAMsm3VCUQt25SMWvaKMYSBOYFv1NoAXpmmnjLV3cjDUNMIyDi01MRKitdHCr39ZsU7tqSD9hEd6WhakbhjgEOz77PvGRlxYaMx/aedcDvNu5KorVXZFhpa8MhdihJZHM9b0wXqsLunUzPFHIKVuwbd/84o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779684937; c=relaxed/simple;
	bh=SWS57+zDSunyKNrUdyFTCturWTSc6m2sEG6C7wuYKo0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VaCo9LrV79BldBHFilg4UFEZwXnc0uZsorQVkPnMfsl+sWUjdHVXD3gipq+2b8V/jB2uSWPIVOciK7M1xqFDDf9pcmii4XnQTRUotB2DwmEW6gxL8KxHzfiXCtbkZMV3TrxkCAeF4O0yKflJC5oCBs+jkeAXpg3S2PMQXb9EcRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P0qX2cbj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P0qX2cbj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P0qX2cbj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P0qX2cbj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 809026888C
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 04:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779684933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nK9OP3NjqqxQ8f4bjpgCG1qcZ4ZDBSY7yBW2HuWsd0g=;
	b=P0qX2cbj/zxvfK3lYWx7bxOLPWhgrgOACbcCYu2JCoEWdKhYbLvw2j5SfcLIWNj/ui2VEq
	6PFoUdhikli2VQVeMQRCt+06T30gME9TKmRs5cKLIoDNVJ0Bzz3s9GzNJ+oD1o1xD9dLtm
	f0mriCH1S+T8c4u0qp8rxVviWFjoL0w=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779684933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nK9OP3NjqqxQ8f4bjpgCG1qcZ4ZDBSY7yBW2HuWsd0g=;
	b=P0qX2cbj/zxvfK3lYWx7bxOLPWhgrgOACbcCYu2JCoEWdKhYbLvw2j5SfcLIWNj/ui2VEq
	6PFoUdhikli2VQVeMQRCt+06T30gME9TKmRs5cKLIoDNVJ0Bzz3s9GzNJ+oD1o1xD9dLtm
	f0mriCH1S+T8c4u0qp8rxVviWFjoL0w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B6EB559A7A
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 04:55:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ROCeHUTWE2pkCAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 04:55:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
Date: Mon, 25 May 2026 14:25:10 +0930
Message-ID: <821ee12cd5a6f24206259a42d48c47fb3731da79.1779684900.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

Previously btrfs forces direct writes to fall back to buffered ones if the
inode has data checksum or the profile has duplication.

That fallback is to avoid the content being modified that the final
content may mismatch with the checksum or the other mirrors.

That brings a pretty huge performance cost, which already caused some
concern at that time.

But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
buffer direct I/O") introduced a new method by copying the content into
new pages, and do all the operations based on the newly allocated pages.

So let btrfs to utilize the new flag for direct writes if we require
stable folios.

There is a quick benchmark, using the following fio setup:

 fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
     --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
     --bs=$blocksize

Unit is MiB/s.

 Blocksize | Zero-copy (*) | Buffered |   Bounce
-----------+---------------+----------+-----------
        4K |          35.1 |     17.1 |      33.8
       64K |           522 |      251 |       492

*: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
   fallback to buffered write if the inode requires checksum")

Although with page bouncing the performance is only around 95% of
true-zero copy, it's still almost double the performance of buffered
fallback.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 43 ++++++++++++++-----------------------------
 1 file changed, 14 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 57167d56dc72..719b94497c41 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -768,10 +768,23 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
 static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
 					 size_t done_before)
 {
+	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
 	struct btrfs_dio_data data = { 0 };
+	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
+				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
+
+	/*
+	 * If the inode requires datacsum or data profile requires duplication,
+	 * We can not do zero-copy using the folio provided by user space.
+	 * Has to bounce the folios to prevent modification during writeback.
+	 */
+	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
+	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
+		dio_flags |= IOMAP_DIO_BOUNCE;
 
 	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
+			      dio_flags, &data, done_before);
 }
 
 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
@@ -800,8 +813,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	unsigned int ilock_flags = 0;
 	struct iomap_dio *dio;
-	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
-				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -815,16 +826,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
 		ilock_flags |= BTRFS_ILOCK_SHARED;
 
-	/*
-	 * If our data profile has duplication (either extra mirrors or RAID56),
-	 * we can not trust the direct IO buffer, the content may change during
-	 * writeback and cause different contents written to different mirrors.
-	 *
-	 * Thus only RAID0 and SINGLE can go true zero-copy direct IO.
-	 */
-	if (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0)
-		goto buffered;
-
 relock:
 	ret = btrfs_inode_lock(BTRFS_I(inode), ilock_flags);
 	if (ret < 0)
@@ -865,22 +866,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
 		goto buffered;
 	}
-	/*
-	 * We can't control the folios being passed in, applications can write
-	 * to them while a direct IO write is in progress.  This means the
-	 * content might change after we calculated the data checksum.
-	 * Therefore we can end up storing a checksum that doesn't match the
-	 * persisted data.
-	 *
-	 * To be extra safe and avoid false data checksum mismatch, if the
-	 * inode requires data checksum, just fallback to buffered IO.
-	 * For buffered IO we have full control of page cache and can ensure
-	 * no one is modifying the content during writeback.
-	 */
-	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
-		goto buffered;
-	}
 
 	/*
 	 * The iov_iter can be mapped to the same file range we are writing to.
-- 
2.54.0

