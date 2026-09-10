Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F244BFE8A
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005987; cv=none; b=Cw21xuUB6rBJhzNv+JDGQMhnMd3PfzGFiUARMFoFnEoPPslSR2tYLGz9hTJNFHzpL91KKphCw6P9BDg/+i0blWJ2gZBgAnFe1AIaAKSx6x7pJ9XDdYLATj6b0OMJZCjAmqmiV+8Ay4DH82D/eEoNqXPhBKQV6s9QvNYZ1z75TMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005987; c=relaxed/simple;
	bh=bk+3fg9W8c2IsHkPQTVi7YfkwX0ksieBGI/ZLqMTSac=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKpXaw9KShbesCejEWJPcTPd7+TpRQqeZgnjnNXh+b6bTKCIsv9QHpGBiTAEZYQiH9x6nAQT5N0YaM3A8qGvUNBTDdDbhQ3ADYkX334+17l6fRt68BSflKqnQjeFn6m0wTHD3yr9/wZ0JpraobWO2T9uqXtsA3u/FCtDA8wxfAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ejOSXT2h; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SidbiIs6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ejOSXT2h";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SidbiIs6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EC0161FD63
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789005980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=87OK8xBNRAEwx+CDmfOnn5fdcqInPUQXDvlUWtPBb7I=;
	b=ejOSXT2h9pFiK/IB9YrxVDK731m2Jx1ugYDjG8E60nNXvFv1F0J+po/DZjUHzumCLSPv7R
	M1/uPb7/rfa9ZmUUOdgi2vWwjVMnwXkJ9JMgwMk+V1rOTutjRJOXBZnWtADXrCxLFP20MY
	Lf4MaPJRpKyxIteNbJJks5Q8P/jbE+s=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789005975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=87OK8xBNRAEwx+CDmfOnn5fdcqInPUQXDvlUWtPBb7I=;
	b=SidbiIs6daG8ua4JDtQ7RwaDmQYxrJmfdFZ6qeI9x0LMoKAMaicFoR4APDy91b8H0Nui8q
	o/AtRzUel4yZXyQOayAua18jNnGeJPv0WRVCpoTt9CTCjBlIivvglfxdF3EoM2Wi8lLcWx
	PH3tRJJ6TsircUbrQcfKNL5boEWpUoY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3D6D13889
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SJweIJYQomqaHgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: simplify heuristic_collect_sample() to handle large folios better
Date: Thu, 10 Sep 2026 11:35:53 +0930
Message-ID: <ebe8073819826f9be3be73cd1140f564e0215b7d.1789003160.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789003160.git.wqu@suse.com>
References: <cover.1789003160.git.wqu@suse.com>
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

Currently heuristic_collect_sample() is purely page size based, and it
has a lot of extra handling just inside the page.

However we already have large folio support, there is no need to look up
the same folio again and again.

Simplify the handling by:

- Use @cur as the iterator instead of page index

- Handle the sample copying on a per-folio basis
  Although kmap_local_folio() requires an offset to handle HIGHMEM
  page mapping, we have rejected large folios for HIGHMEM systems
  completely.

  So we can safely handle all sample copying inside the folio in one
  go.

- Remove unnecessary unaligned range handling
  All the range passed in should be block aligned, thus there is no need
  to handle cases where sample crosses the block boundary.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 0134b9253702..ad90e14032db 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1489,10 +1489,8 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 				     struct heuristic_ws *ws)
 {
 	const u32 blocksize = BTRFS_I(inode)->root->fs_info->sectorsize;
-	struct folio *folio;
-	pgoff_t index, index_end;
-	u32 i, curr_sample_pos;
-	u8 *in_data;
+	u64 cur = start;
+	u32 curr_sample_pos = 0;
 
 	ASSERT(IS_ALIGNED(start, blocksize) && IS_ALIGNED(end + 1, blocksize));
 
@@ -1508,33 +1506,27 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 	if (end + 1 - start > BTRFS_MAX_UNCOMPRESSED)
 		end = start + BTRFS_MAX_UNCOMPRESSED - 1;
 
-	index = start >> PAGE_SHIFT;
-	index_end = end >> PAGE_SHIFT;
+	while (cur < end) {
+		struct folio *folio;
+		void *in_data;
+		u64 next_pos;
 
-	curr_sample_pos = 0;
-	while (index <= index_end) {
-		folio = filemap_get_folio(inode->i_mapping, index);
+		folio = filemap_get_folio(inode->i_mapping, cur >> PAGE_SHIFT);
+		/* All folios inside the range should exist and be locked. */
 		ASSERT(!IS_ERR(folio));
-		in_data = kmap_local_folio(folio,
-				offset_in_folio(folio, (u64)index << PAGE_SHIFT));
-		/* Handle case where the start is not aligned to PAGE_SIZE */
-		i = start % PAGE_SIZE;
-		while (i < PAGE_SIZE - SAMPLING_READ_SIZE) {
-			/* Don't sample any garbage from the last page */
-			if (start > end + 1 - SAMPLING_READ_SIZE)
-				break;
-			memcpy(&ws->sample[curr_sample_pos], &in_data[i],
-					SAMPLING_READ_SIZE);
-			i += SAMPLING_INTERVAL;
-			start += SAMPLING_INTERVAL;
+		next_pos = min_t(u64, end + 1, folio_next_pos(folio));
+		in_data = kmap_local_folio(folio, 0);
+
+		for (; cur < next_pos; cur += SAMPLING_INTERVAL) {
+			memcpy(&ws->sample[curr_sample_pos],
+			       in_data + offset_in_folio(folio, cur),
+			       SAMPLING_READ_SIZE);
 			curr_sample_pos += SAMPLING_READ_SIZE;
 		}
 		kunmap_local(in_data);
 		folio_put(folio);
-
-		index++;
+		cur = next_pos;
 	}
-
 	ws->sample_size = curr_sample_pos;
 }
 
-- 
2.55.0

