Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8031282F09
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780887776; cv=none; b=nnRsEXal+kyvh+twwVF2Q9FYSGHl9O/XljAD8r7rjsNejT3+xAunZJAyzkYCPbjM+tRrEm9GXmLK8pG2KJtm4CtAgpYe1vhmogTpaKxmEvHdQ1rQdKaDH4rLHrFPQk9ONJ5xOznYDE3Mu7plhwAQo8jALEaYzr3z8xyWEjnPx2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780887776; c=relaxed/simple;
	bh=yPf+kwtjKSDbw8/cssyHO2j5xroPq6ozhiVPbaCrG8w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0JIRnqmWhldS9bhNT2Cf+Als2BsGCCzMDUtYjKhUB8Jz91r5/kjjw+C++UVYUNTvnTal0wYh7fEK8DuizFpu7UWOV0O3jsurNN/TkCFU1xuhlXTQ30TBXSFZCaMRYZz1Bdt07A+qzrLFz4nFBEhWjvCX5WayIZ1fGd5ncGM7Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Z6wF8Mlo; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Z6wF8Mlo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z6wF8Mlo";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z6wF8Mlo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44E2475C88
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 03:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780887762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ynbMTtkVwi62wie8URiDWiXOb6rASzlcGfsel1rPNc4=;
	b=Z6wF8MloyG+SH7rRCH1rMDWRo1kmIGDQ3YTyrkxsEuD95+3gMZDTxJAncmwL+huoLmPp1D
	uuLHhIhDBBqKlrtbtQOkuori9DPt1GKFQF0I7fXlaP706pS7zyg5L6rn4gshDzOxzgs2eD
	FW87OTbmPd8bdgTSEo9QU6bXkwbYmPQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780887762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ynbMTtkVwi62wie8URiDWiXOb6rASzlcGfsel1rPNc4=;
	b=Z6wF8MloyG+SH7rRCH1rMDWRo1kmIGDQ3YTyrkxsEuD95+3gMZDTxJAncmwL+huoLmPp1D
	uuLHhIhDBBqKlrtbtQOkuori9DPt1GKFQF0I7fXlaP706pS7zyg5L6rn4gshDzOxzgs2eD
	FW87OTbmPd8bdgTSEo9QU6bXkwbYmPQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 460D3779A7
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 03:02:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mGdYOdAwJmpaeAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 03:02:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: remove btrfs_dio_data::submitted
Date: Mon,  8 Jun 2026 12:32:15 +0930
Message-ID: <df85dda9d2b93cf62649060519717b3ef1530d48.1780873489.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780873489.git.wqu@suse.com>
References: <cover.1780873489.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
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
X-Spam-Level: 

That member is to record how many bytes are submitted for a direct
read/write, utilized by iomap_end() callback to handle short IO cases.

However iomap_end() callback is already providing an internally tracked
@written member, which is doing the same accounting and providing the
same value as btrfs_dio_data::submitted.

There is no need to duplicate the work, just remove
btrfs_dio_data::submitted.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..b2add124cc89 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -14,7 +14,6 @@
 #include "ordered-data.h"
 
 struct btrfs_dio_data {
-	ssize_t submitted;
 	loff_t old_isize;
 	struct extent_changeset *data_reserved;
 	struct btrfs_ordered_extent *ordered;
@@ -619,7 +618,6 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 {
 	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
 	struct btrfs_dio_data *dio_data = iter->private;
-	size_t submitted = dio_data->submitted;
 	const bool write = !!(flags & IOMAP_WRITE);
 	int ret = 0;
 
@@ -630,9 +628,9 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		return 0;
 	}
 
-	if (submitted < length) {
-		pos += submitted;
-		length -= submitted;
+	if (written < length) {
+		pos += written;
+		length -= written;
 		if (write) {
 			/*
 			 * Got a short write and have updated the isize, need to
@@ -659,7 +657,7 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 			if (dio_data->updated_isize) {
 				u64 new_isize;
 
-				if (submitted == 0)
+				if (written == 0)
 					new_isize = dio_data->old_isize;
 				else
 					new_isize = max(dio_data->old_isize, pos);
@@ -772,8 +770,6 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	dip->file_offset = file_offset;
 	dip->bytes = bio->bi_iter.bi_size;
 
-	dio_data->submitted += bio->bi_iter.bi_size;
-
 	/*
 	 * Check if we are doing a partial write.  If we are, we need to split
 	 * the ordered extent to match the submitted bio.  Hang on to the
-- 
2.54.0

