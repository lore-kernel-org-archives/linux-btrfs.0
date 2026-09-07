Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2890D3783C6
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 04:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756488; cv=none; b=Wisg6QRawxUf3N+p2UZrMdEkAlOUlG4D3H/eSvFpMQHbOObea4Dw0TAVN73Va6TkhSxA8n4a/0/+dnP6seLX4zV3ph0fIqvErQo5/nw+eQmDIEHk4hg3jtsGaG1369Ou1wh6xH5ms7Br673GKcLVrYmFXdLhhHD0QWv79UteZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756488; c=relaxed/simple;
	bh=yE73HYjIWFsMgXM5M9g2jmcIxbPu6z7OKfJu9nuOozk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dKR43jQC4C95cnrwB7DptS+Tk3UFGUtR6LFsvF1tnUxmcPgshgjrmssatzR4D7qNz76FCcmwpnpK6KilE2NirnTTf2IBv7Jj/SM87poWi/Oabe9Q7YR4A+6HEtfqoaNpsir/rz05rnExURbrFyAUTVwY6WzwShqBcne/fIngIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Juvz6RhL; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Juvz6RhL"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6b1afdf98dfso1949999eaf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 21:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756486; x=1789361286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dp9p5ajTef11aSUbLM0CCYywOKyybhsy5AMpH775xoI=;
        b=Juvz6RhLg8meuLQOqT9qKBrXrGWz9q77uTEzj/OjoULMGD0bNBcZngZHnbVCJ1nX0C
         2dabxu4eO0sombDaZMfyJqs/kbwZdAVQBZ2nZXAV9TM6bHK5yhAF7j2GP2g9L8FqmuMz
         lJprsyeGpBKgT712ifgTZ48GaOcRgmOIbB0ln1CgVUDrIPY/vmHIFcECu+zrcVgFO2Mr
         5dfGCbpLQ7nEclrC2k5iv/+c2K0+iXNQr21xOs5dTA8RRP2ewl6ZLezfDRAZg8uF2kkp
         kDMV159HWB7ORCypPDLpwPu1XfIFSeCHs/JfztoVrmOqvaPt41j+1ehXnY1SyPMMf/vZ
         cpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756486; x=1789361286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dp9p5ajTef11aSUbLM0CCYywOKyybhsy5AMpH775xoI=;
        b=EOJg3kRbcqSlNZP1c5YthGAWJw/v64yHI2ZDG71ZeugjerS58SzxxXrJK/C0VOzbn1
         kYZdB5gmMHASZ7s014sB9ZoezInQPhDJVCiGpsvvsbKv7jFYmMkvXnFoeOD639gB9q+Y
         zkWTU2/0RpMVFC2X098I9AH4fptGpfThGO1stX2SxoZURm91BG78Ee1U8RZFSRtcswLI
         NMF/JbSggRJVnITr0Y/pDvTwwONfUf3FlMV0Idn8JfFVgwFuaqkGh/8VgFLU9HpOUKQ/
         KbX+qpKgRE/dqK/7vsvuwDFj+Uvf1dIGtqU52XRJUy2HlNiJHNDR3YPx4Mu4ReLGg761
         NEvg==
X-Gm-Message-State: AFuF++mbbBZpfEOYdw4I11zkmFist+HAzHavrlTHpcWCGwa6BIjaPagG
	qyCQtrq7HS5wFyrO94Y7WTBVBYPH8lD7j79Fo68yBVS4y8hg+pVA2G3K
X-Gm-Gg: AYBFou3YVDwwPHycFL3WeHfeoDksB6t/Ku2BwzIn8Ga55lKFwdFP+cL4GZnInBHjHAs
	AdeEC0ojHXBQrG3ficgVRfmAZGQS/PBNMMd74NQ1Dxn8fBQMQCXrffrntflcbJAFAFlz1e6KbY8
	XrZTrFZTRXbDfI4jfz3YNLN+rRNdiefvnUGRh2I2eR9oMUsMBPN7iHmZqJr2bVlJjimoqQULHp7
	lvijKx68/bDw4l4mBow40MuArH+ST6r42bIK5pDQZ+a+4rxfZpPrLsb0sfS9J46Q8y+lB8xM8MS
	XV5mt2A9RYIVzH3zvY+aEnW2r7JvNgYQMBQgZJuZgSOxeYlomUo0Ziyirp/cMx09fqYZFWDyTXn
	JpZYt64OovWD2J5H44URrfRAmK1L+/cwuFzML3P5nd1BYvWDyLilPCKDPF9ubpjGmOsbGbA+YFU
	s2B/b7wfBznX0EY4BNq8qIGxU9dE66yUf7diuCsrhK94hKsSqAAXUzwJan+nIZlQqMKgG1rpH58
	DP9km4KQhGJjKs=
X-Received: by 2002:a4a:ec49:0:b0:6b8:d957:2803 with SMTP id 006d021491bc7-6b8d9572e0bmr6372376eaf.20.1788756485966;
        Sun, 06 Sep 2026 21:48:05 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143240d86c3sm21615763c88.0.2026.09.06.21.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:48:05 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: fix typos and repeated words in comments
Date: Mon,  7 Sep 2026 10:18:01 +0530
Message-ID: <20260907044801.9088-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix misspellings and repeated words in comments, found with
scripts/checkpatch.pl and codespell.  Only touches comments, no code
changes.

Changes since v1:
 - the typo and repeated-word patches are folded into one, as they only
   touch comments
 - rebased onto btrfs for-next
 - picked up the further typos codespell found, which David Sterba
   listed: Temporarilly, Checksume, coresponding, caclulated, wheather
   and cannnot ("commited" in block-group.h was already fixed by v1)

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/btrfs/block-group.h          | 2 +-
 fs/btrfs/extent-io-tree.c       | 2 +-
 fs/btrfs/fs.c                   | 2 +-
 fs/btrfs/raid56.c               | 8 ++++----
 fs/btrfs/send.c                 | 2 +-
 fs/btrfs/transaction.h          | 2 +-
 fs/btrfs/tree-checker.c         | 2 +-
 include/uapi/linux/btrfs_tree.h | 4 ++--
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 69d56864d4ba..b349f94cf929 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -135,7 +135,7 @@ struct btrfs_block_group {
 	u64 global_root_id;
 	u64 remap_bytes;
 	u32 identity_remap_count;
-	/* The last commited identity_remap_count value of this block group. */
+	/* The last committed identity_remap_count value of this block group. */
 	u32 last_identity_remap_count;
 	/*
 	 * The last committed used bytes of this block group, if the above @used
diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index d6df11f6088c..992b8b42bdb4 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -751,7 +751,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 				btrfs_split_delalloc_extent(tree->inode, state, start);
 
 			/*
-			 * Temporarilly ajdust this state's range to match the
+			 * Temporarily ajdust this state's range to match the
 			 * range for which we are clearing bits.
 			 */
 			state->start = start;
diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
index de160d29dde8..75a1217727a7 100644
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -79,7 +79,7 @@ void btrfs_csum_init(struct btrfs_csum_ctx *ctx, u16 csum_type)
 		blake2b_init(&ctx->blake2b, 32);
 		break;
 	default:
-		/* Checksume type is validated at mount time. */
+		/* Checksum type is validated at mount time. */
 		BUG();
 	}
 }
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a5d0ef09d92a..4f702dbf581b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -953,7 +953,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
 
 	/*
 	 * Clear the data bitmap, as the rbio may be cached for later usage.
-	 * do this before before unlock_stripe() so there will be no new bio
+	 * do this before unlock_stripe() so there will be no new bio
 	 * for this bio.
 	 */
 	bitmap_clear(&rbio->dbitmap, 0, rbio->stripe_nsectors);
@@ -988,7 +988,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
  * as possible, and only use stripe_sectors as fallback.
  *
  * Return NULL if bio_list_only is set but the specified sector has no
- * coresponding bio.
+ * corresponding bio.
  */
 static phys_addr_t *sector_paddrs_in_rbio(struct btrfs_raid_bio *rbio,
 					  int stripe_nr, int sector_nr,
@@ -1451,7 +1451,7 @@ static int rmw_assemble_write_bios(struct btrfs_raid_bio *rbio,
 	ASSERT(bitmap_weight(&rbio->dbitmap, rbio->stripe_nsectors));
 
 	/*
-	 * Reset errors, as we may have errors inherited from from degraded
+	 * Reset errors, as we may have errors inherited from degraded
 	 * write.
 	 */
 	bitmap_clear(rbio->error_bitmap, 0, rbio->nr_sectors);
@@ -2632,7 +2632,7 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 	return 0;
 }
 
-/* Return true if the content of the step matches the caclulated one. */
+/* Return true if the content of the step matches the calculated one. */
 static bool verify_one_parity_step(struct btrfs_raid_bio *rbio,
 				   void *pointers[], unsigned int sector_nr,
 				   unsigned int step_nr)
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5c59b9abedcd..c523bf950c89 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7023,7 +7023,7 @@ static int changed_extent(struct send_ctx *sctx,
 	 * get modified or replaced with a new one). Note that deduplication
 	 * updates the inode item, but it only changes the iversion (sequence
 	 * field in the inode item) of the inode, so if a file is deduplicated
-	 * the same amount of times in both the parent and send snapshots, its
+	 * the same number of times in both the parent and send snapshots, its
 	 * iversion becomes the same in both snapshots, whence the inode item is
 	 * the same on both snapshots.
 	 */
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 3a57f227b5ed..89153cd22596 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -288,7 +288,7 @@ do {										\
  * Call btrfs_abort_transaction() as early as possible when an error condition
  * is detected, that way the exact stack trace is reported for some errors.
  *
- * Error number must be negative as it encodes wheather it's the first abort.
+ * Error number must be negative as it encodes whether it's the first abort.
  */
 #define btrfs_abort_transaction(trans, error)		\
 do {								\
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 401fd40ec7b2..b8ca9980e1dd 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -228,7 +228,7 @@ static bool can_have_extent_data(struct extent_buffer *leaf,
 	}
 
 	/*
-	 * The rest are special files, e.g. block/FIFO files, which cannnot
+	 * The rest are special files, e.g. block/FIFO files, which cannot
 	 * have any file extent.
 	 */
 	return false;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index b6ccaf848e4b..47ee52859b45 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -230,7 +230,7 @@
  *
  * Stored as an inline ref rather to avoid wasting space on a separate item on
  * top of the existing extent item. However, unlike the other inline refs,
- * there is one one owner ref per extent rather than one per extent.
+ * there is one owner ref per extent rather than one per extent.
  *
  * Because of this, it goes at the front of the list of inline refs, and thus
  * must have a lower type value than any other inline ref type (to satisfy the
@@ -243,7 +243,7 @@
 #define BTRFS_EXTENT_DATA_REF_KEY	178
 
 /*
- * Obsolete key. Defintion removed in 6.6, value may be reused in the future.
+ * Obsolete key. Definition removed in 6.6, value may be reused in the future.
  *
  * #define BTRFS_EXTENT_REF_V0_KEY	180
  */
