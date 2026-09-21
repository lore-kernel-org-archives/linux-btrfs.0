Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3741990C7
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789951504; cv=none; b=tE+gnObvY+by5Y2yj4g1zlzR6A45ZwHU6qCuEuVpKMgvGcXQslVsF+FjjQXPlCz5UivdTxIZULhdsrAa7Hyt2ZY5lNPUxCsEzXTR7w9EZGkYiUBOIJ8aG/9rxbwELBddLi1MCEYCSr2RyQfPUQYxEhNph24dQW6pDMjNq6eoNUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789951504; c=relaxed/simple;
	bh=AYOp+kDsKdY2egN4VxKxaMaCzd9NGgoQ61QvvnsgM6c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWzCmzrm+yPd3jbFB6I2NuCNQ+6gnmOu4065/DzjEePhIwXUZlvZpyg/J6whwaNJQ1vLldheub8VzQPMUgBSkKcc/JFVIBgk9p2+wQcO90K2B4yf6QyhJbhCZHbLZPZH/MbYveaNRxqG5P8n7qWscKBSeKmAeIEDybV2sEjFkuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LAZqQG/O; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LAZqQG/O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LAZqQG/O";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LAZqQG/O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E1FCF21A9E
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789951500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8cWfj769PCh9D7FsJoVbOGd1cnZiDABnfCxMGaSicY=;
	b=LAZqQG/OkxuerAqQiFo3/haCcgGijjpDHZiQHPIJzz9+utqfv15dHEFY5P0wZa5h1Iqfvw
	Ui27PjgEnBKFwl5bHelB8zzDKRkan40G/Osqq0sYlH0rEHP0ugFT1UyiGfZ9t/lOGENhBv
	Mv+FUOdwp3Mi3IFLk0oIlx3s0mkUxEo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789951500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8cWfj769PCh9D7FsJoVbOGd1cnZiDABnfCxMGaSicY=;
	b=LAZqQG/OkxuerAqQiFo3/haCcgGijjpDHZiQHPIJzz9+utqfv15dHEFY5P0wZa5h1Iqfvw
	Ui27PjgEnBKFwl5bHelB8zzDKRkan40G/Osqq0sYlH0rEHP0ugFT1UyiGfZ9t/lOGENhBv
	Mv+FUOdwp3Mi3IFLk0oIlx3s0mkUxEo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D047C13793
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:44:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m/o+Ogd+sGqATwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 00:44:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: remove the trailing zeros from compressed inline extent
Date: Mon, 21 Sep 2026 10:14:34 +0930
Message-ID: <62413fbeb36f117b398756fc0054254e84e6e41d.1789951424.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789951424.git.wqu@suse.com>
References: <cover.1789951424.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[BEHAVIOR CHANGE]
After commit 3eaf5f082c4c ("btrfs: extract inlined creation into a
dedicated delalloc helper"), btrfs changed its behavior when generating
compressed inlined extents.

Previously the compression input was the file range [0, i_size), but
after that commit the input is file range [0, sectorsize).

This means the decompression handling needs to have a buffer that is no
smaller than sectorsize, or the decompression will fail.

This has already caused problems for other projects, like u-boot and
btrfs-restore from btrfs-progs.
Although those projects are fixed with a more robust decompression path,
this kernel change also causes extra space usage for compressed inlined
extents:

 All doing a 3K writes with content filled with 0xcd

 Before:
        item 6 key (257 EXTENT_DATA 0) itemoff 15794 itemsize 69
                generation 9 type 0 (inline)
                inline extent data size 48 ram_bytes 3072 compression 2 (lzo) encryption 0

 After:
         item 6 key (257 EXTENT_DATA 0) itemoff 15781 itemsize 82
                generation 9 type 0 (inline)
                inline extent data size 61 ram_bytes 3072 compression 2 (lzo) encryption 0

This behavior change also increased the lzo compressed size from 48 bytes to 61 bytes.

[FIX WITH A NEW BEHAVIOR CHANGE]
The previous patch "btrfs: lzo: fix space saving checks" fixed a
regression in lzo_compress_bio() where it didn't properly handle ranges
smaller than a sector.

With that regression fixed, we can finally pass the range [0, i_size) into
btrfs_compress_bio(), and this gets rid of the trailing zeros,
restoring the old behavior, along with the older and better
compression ratio.

However we need a tiny behavior change to ensure a stable i_size and
prevent races between inline writeback and isize expansion.
This is done by an early check rejecting i_size >= blocksize.

For i_size < blocksize, btrfs_setsize() will call
btrfs_cont_expand() and try to lock the folio, so btrfs_setsize() will
wait for writeback to finish before expanding i_size, killing the race.

For i_size > blocksize, we do not need to inline anyway.

The above two cases match the old behaviors.

But for i_size == blocksize, previously we allowed a compressed inline
extent as long as the compressed data is small enough.

However this exposed a race window without the new rejection, where the
isize is 4K and blocksize is 4K:

             Writeback                |           Setsize
 -------------------------------------+----------------------------------
 btrfs_run_delalloc_range()           |
 |- run_delalloc_inline()             |
 |                                    | btrfs_setsize()
 |                                    | |- btrfs_cont_expand()
 |                                    | |  Doing nothing as the oldsize
 |                                    | |  is already aligned
 |                                    | |- i_size_write()
 |                                    |    Now the isize is 128K
 |- i_size = i_size_read()            |
 |  Which is 128K                     |
 |- btrfs_compress_bio(len = 128K)    |
    This leads to incorrect end.      |

So here to keep the i_size stable during writeback, we have to reject
any i_size >= blocksize, causing a minor behavior change to compressed
inline extents.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 53f4532593b3..0a795bb460c8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2325,6 +2325,27 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 	int ret;
 
 	ASSERT(folio_pos(locked_folio) == 0);
+
+	/*
+	 * It's possible that the i_size is expanded while writeback is running.
+	 * There is no special locking to prevent isize being updated.
+	 *
+	 * But for unaligned i_size, btrfs_setsize() will need to lock the
+	 * folio (which is held by us) before updating the isize, so if
+	 * i_size < blocksize btrfs_setsize() will wait for us.
+	 *
+	 * The only problem is when i_size == blocksize and compression is on.
+	 * In that case we previously allowed inline as long as the compressed
+	 * data is smaller than blocksize.
+	 * But since the i_size is already aligned, btrfs_setsize() would not
+	 * need to lock the folio, so btrfs_setsize() can race with us.
+	 *
+	 * Thus here we reject i_size >= blocksize to prevent racing with
+	 * btrfs_setsize() expansion.
+	 */
+	if (i_size >= blocksize)
+		return 1;
+
 	/*
 	 * If an mmap writer could modify the folio while we copy it into an
 	 * inline extent we might see only part of their modification then
@@ -2342,12 +2363,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
 		}
-		/*
-		 * We need to pass blocksize and not i_size, otherwise we can't
-		 * create compressed inline extents for data smaller than sector
-		 * size with lzo.
-		 */
-		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
+		cb = btrfs_compress_bio(inode, 0, i_size, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
 			cb = NULL;
 			/* Just fall back to non-compressed case. */
-- 
2.55.0

