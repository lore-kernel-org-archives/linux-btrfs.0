Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC033EC
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773446462; cv=none; b=WawbBt8vgiqmJ+/VedJPOy9PiGOy+ksWf0aazDm/sttzqB5YgVCtRc5VJU4dSCApv1tti9nQ7ttMcv9jKS/h4xEKKmqZR2fZ3kGsFcmTUXpFlFSUfDWs2AsU6M5lkHIUj5euGdBpPO1ebXJWVA457C7Q2kMI6yjYmuBB1cwbMl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773446462; c=relaxed/simple;
	bh=bJORFpYn7ZwsZZg3NNvtqegHY0rjtafyWvSClLxqYU8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+ctTwztkLnMO0XdILN/ArtX1m+OW+gzE2sY5wiXks9xbRPdFhLn+a8mnBDjuUh8Ip9AWSMalyp/PPAQAhtPiDnvXWwaKoE070ZALLsYS3VuxdLeefB4vxuav39EO+G6rbGzEb7h2J0y4kax23EZKk745ELjQT9XvtdchHweRXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IP1mHy4Z; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IP1mHy4Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IP1mHy4Z";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IP1mHy4Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E2D2B5BD34
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773446458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SscBWblceWeQ/HSKRPs+jjMkahSGOCXxsLXBAGGOY5I=;
	b=IP1mHy4ZZYyDTpT8MXnMy1l9M3DvOqu1dHoXrGFJUe0+7B/aAGEZhWPoZnJdNDG+kMrysi
	AY+8bBOcCtxT/Ldv46+1I0QdKmIRFX2z2qlBOyukpF1rUQpDtwpl3SIpyNVFQYsdVKx8O4
	lmL0cmqFevgAtCFQSDlvbMNQronaP5k=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773446458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SscBWblceWeQ/HSKRPs+jjMkahSGOCXxsLXBAGGOY5I=;
	b=IP1mHy4ZZYyDTpT8MXnMy1l9M3DvOqu1dHoXrGFJUe0+7B/aAGEZhWPoZnJdNDG+kMrysi
	AY+8bBOcCtxT/Ldv46+1I0QdKmIRFX2z2qlBOyukpF1rUQpDtwpl3SIpyNVFQYsdVKx8O4
	lmL0cmqFevgAtCFQSDlvbMNQronaP5k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2A719407C3
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qEFcNzmltGl9dQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: check type flags in alloc_ordered_extent()
Date: Sat, 14 Mar 2026 10:30:38 +1030
Message-ID: <0723b078ac15ef9407837247a8f7076cbae005c1.1773446363.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773446363.git.wqu@suse.com>
References: <cover.1773446363.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.78 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.18)[-0.895];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.78
X-Spam-Level: 

Unlike other flags used in btrfs, BTRFS_ORDERED_* macros are different as
they can not be directly used as flags.

They are defined as bit numbers, thus they should be utilized with
bit operations, not directly with logical operations.

Unfortunately sometimes I forgot this and can pass the incorrect flags
to alloc_ordered_extent() and hit weird bugs.

Enhance the type checks in alloc_ordered_extent() by:

- Make sure there is one and only one bit set for exclusive type flags
  There are four exclusive type flags, REGULAR, NOCOW, PREALLOC and
  COMPRESSED.
  So introduce a new macro, BTRFS_ORDERED_EXCLUSIVE_FLAGS, to cover
  above flags.

  And add an ASSERT() to check one and only one of those exclusive flags
  can be set for alloc_ordered_extent().

- Re-order the type bit numbers to the end of the enum
  This is make it much harder to get a valid false negative.

  E.g, with the old BTRFS_ORDERED_REGULAR starts at zero, we can have
  the following flags passing the weight check:

  * BTRFS_ORDERED_NOCOW
    Be treated as BTRFS_ORDERED_REGULAR (1 == 1UL << 0).

  * BTRFS_ORDERED_PREALLOC
    Be treated as BTRFS_ORDERED_NOCOW (2 == 1UL << 1).

  * BTRFS_ORDERED_DIRECT
    Be treated as BTRFS_ORDERED_PREALLOC (4 == 1UL << 2).

  Now all those types starts at 8, passing any of those bit numbers as
  flags directly will not pass the ASSERT().

- Add a static assert to avoid overflow
  To make sure all BTRFS_ORDERED_* flags can fit into an unsigned long.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ordered-data.c | 13 ++++++++++
 fs/btrfs/ordered-data.h | 55 +++++++++++++++++++++++------------------
 2 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8405d07b49cd..de6b60c52292 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -156,6 +156,19 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	const bool is_nocow = (flags &
 	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
 
+	/* Only one type flag can be set. */
+	ASSERT(has_single_bit_set(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS));
+
+	/* DIRECT cannot be set with COMPRESSED nor ENCODED. */
+	if (test_bit(BTRFS_ORDERED_DIRECT, &flags)) {
+		ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &flags));
+		ASSERT(!test_bit(BTRFS_ORDERED_ENCODED, &flags));
+	}
+
+	/* ENCODED must be set with COMPRESSED. */
+	if (test_bit(BTRFS_ORDERED_ENCODED, &flags))
+		ASSERT(test_bit(BTRFS_ORDERED_COMPRESSED, &flags));
+
 	/*
 	 * For a NOCOW write we can free the qgroup reserve right now. For a COW
 	 * one we transfer the reserved space from the inode's iotree into the
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index cd74c5ecfd67..ccae3d7c0c05 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -47,8 +47,25 @@ struct btrfs_ordered_sum {
  * IO is done and any metadata is inserted into the tree.
  */
 enum {
+	/* Extra status bits for ordered extents */
+
+	/* Set when all the pages are written */
+	BTRFS_ORDERED_IO_DONE,
+	/* Set when removed from the tree */
+	BTRFS_ORDERED_COMPLETE,
+	/* We had an io error when writing this out */
+	BTRFS_ORDERED_IOERR,
+	/* Set when we have to truncate an extent */
+	BTRFS_ORDERED_TRUNCATED,
+	/* Used during fsync to track already logged extents */
+	BTRFS_ORDERED_LOGGED,
+	/* We have already logged all the csums of the ordered extent */
+	BTRFS_ORDERED_LOGGED_CSUM,
+	/* We wait for this extent to complete in the current transaction */
+	BTRFS_ORDERED_PENDING,
+
 	/*
-	 * Different types for ordered extents, one and only one of the 4 types
+	 * Different types for ordered extents, one and only one of those types
 	 * need to be set when creating ordered extent.
 	 *
 	 * REGULAR:	For regular non-compressed COW write
@@ -61,37 +78,27 @@ enum {
 	BTRFS_ORDERED_PREALLOC,
 	BTRFS_ORDERED_COMPRESSED,
 
+	/* Extra bit for encoded write, must be set with COMPRESSED. */
+	BTRFS_ORDERED_ENCODED,
+
 	/*
 	 * Extra bit for direct io, can only be set for
-	 * REGULAR/NOCOW/PREALLOC. No direct io for compressed extent.
+	 * REGULAR/NOCOW/PREALLOC. Must not be set for COMPRESSED nor ENCODED.
 	 */
 	BTRFS_ORDERED_DIRECT,
 
-	/* Extra status bits for ordered extents */
-
-	/* set when all the pages are written */
-	BTRFS_ORDERED_IO_DONE,
-	/* set when removed from the tree */
-	BTRFS_ORDERED_COMPLETE,
-	/* We had an io error when writing this out */
-	BTRFS_ORDERED_IOERR,
-	/* Set when we have to truncate an extent */
-	BTRFS_ORDERED_TRUNCATED,
-	/* Used during fsync to track already logged extents */
-	BTRFS_ORDERED_LOGGED,
-	/* We have already logged all the csums of the ordered extent */
-	BTRFS_ORDERED_LOGGED_CSUM,
-	/* We wait for this extent to complete in the current transaction */
-	BTRFS_ORDERED_PENDING,
-	/* BTRFS_IOC_ENCODED_WRITE */
-	BTRFS_ORDERED_ENCODED,
+	BTRFS_ORDERED_NR_FLAGS,
 };
+static_assert(BTRFS_ORDERED_NR_FLAGS <= BITS_PER_LONG);
+
+/* One and only one flag can be set. */
+#define BTRFS_ORDERED_EXCLUSIVE_FLAGS ((1UL << BTRFS_ORDERED_REGULAR) |	\
+				       (1UL << BTRFS_ORDERED_NOCOW) |	\
+				       (1UL << BTRFS_ORDERED_PREALLOC) |\
+				       (1UL << BTRFS_ORDERED_COMPRESSED))
 
 /* BTRFS_ORDERED_* flags that specify the type of the extent. */
-#define BTRFS_ORDERED_TYPE_FLAGS ((1UL << BTRFS_ORDERED_REGULAR) |	\
-				  (1UL << BTRFS_ORDERED_NOCOW) |	\
-				  (1UL << BTRFS_ORDERED_PREALLOC) |	\
-				  (1UL << BTRFS_ORDERED_COMPRESSED) |	\
+#define BTRFS_ORDERED_TYPE_FLAGS (BTRFS_ORDERED_EXCLUSIVE_FLAGS |	\
 				  (1UL << BTRFS_ORDERED_DIRECT) |	\
 				  (1UL << BTRFS_ORDERED_ENCODED))
 
-- 
2.53.0

