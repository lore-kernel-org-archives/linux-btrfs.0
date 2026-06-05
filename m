Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53374B8DF5
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650101; cv=none; b=CqBqCqcUcGZh2+B4EGHSl45t//Jsz+8EJH6mAhN/a+iG+/Jzf+4LydklZepVrgPFOiUcG+ufKcdwxKf2mDnM6/lHOng8R+pOvU0OH3RflH4VQBeJeqOpr9WDJa+Ps0e3i/NjyjL+Df5rkTLlQPA513j9ihF3xxI6a+wh6VLnTzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650101; c=relaxed/simple;
	bh=AWHpO3ZQlcZO8hSv3HgMkZ4RWowPEaoROjUEeVY6Tak=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aj0LbVjGHe7bvUIXoW8c2D8wyc7k5MHFjT3qL/+Kr4Hh1u4ZLnDFAHIcejv/LZ8wzRXH9WUMPzGGwl12TS6MdKobiXwNcO0Qmvzc2TyY8DG3qg1Up1COFJaE6miFjMV5N5R06/aFGdiDKwHcwIHcKygTHtIyJCcneCuaDdSj6T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JiE0SwU5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JiE0SwU5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JiE0SwU5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JiE0SwU5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 10F377587C
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OU1jdzJefEGQ7rdWPUJljA1qH+DoymXDL9sMvboOU50=;
	b=JiE0SwU51bWkTKY+Vl5e1w7vCHsdCmoLFAWL/8ofeFaJu9jGLBJW0iDsXamBnCVPPZPr6q
	WB7kBUxHgzkUWUSKMYSuKB7aqeFKldGxfRKX0+Z2jRy1clGPqXCeHOaN3ic1Mr6DDYWGiL
	gbnsQnCpXU8Rku9vizvU0X+SJ1P/N9E=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OU1jdzJefEGQ7rdWPUJljA1qH+DoymXDL9sMvboOU50=;
	b=JiE0SwU51bWkTKY+Vl5e1w7vCHsdCmoLFAWL/8ofeFaJu9jGLBJW0iDsXamBnCVPPZPr6q
	WB7kBUxHgzkUWUSKMYSuKB7aqeFKldGxfRKX0+Z2jRy1clGPqXCeHOaN3ic1Mr6DDYWGiL
	gbnsQnCpXU8Rku9vizvU0X+SJ1P/N9E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 131DD779A8
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oJLrLGmQImrFDAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 09:01:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: remove btrfs_dio_data::submitted
Date: Fri,  5 Jun 2026 18:31:05 +0930
Message-ID: <b5edab94d02e7687d67f940cb14dd4df86dcc5e8.1780645090.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780645090.git.wqu@suse.com>
References: <cover.1780645090.git.wqu@suse.com>
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
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
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
index 8efe3a722206..e25f36eddb51 100644
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

