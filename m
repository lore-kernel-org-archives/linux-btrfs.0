Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C7C344D88;
	Wed,  2 Sep 2026 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367922; cv=none; b=ExFOGNzW27HWYfDt86ii7YPWkMrRC4KT3kK2sO7e9ecp8W1on/8T1yAMetaoKqR1cauZimFiapwGvRiZJVODWPWJGDKffm29EaJGCbqQ63rt8mzEhwNwDjC/DLOIMkZ8CqlTVUmyxiiL0QThUFwLS4CjFXIRVR4KcMULvUfCvi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367922; c=relaxed/simple;
	bh=UBfFdZPldNc1hUadCt3XscKTg/jSIDuLMuQNl+iv51k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJPK2lShv9vJ8dpxrqvF37g3v2x8wsQvYa2L6lMf21IFFvj7av5zuyC/Ta+JU7nac7S4XX9dy5qHlZbF7OtVN4n6wtDCZ9Whv4jHj+G3PR0L3ti6WTi6c5dPP2qnTgO0oUSxXUJJQsHlvDyceYx11MQMSEEPV7XMO4Gfx1EBzjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HEnbWsEN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HEnbWsEN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 542EB21CB7;
	Wed,  2 Sep 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788367914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gL47BMfxCI2HWSdv8Fz3NX3bLLPdA5kzXwUi+5BePoQ=;
	b=HEnbWsEN2XOs2DtlGmtRh5LuWapjqq319eUKBd0GdByToAZIqt6+YQjCd7l7zCjiJAD+Y+
	uNBnOHoLui5fat9GRDy7/RtexiXfkygTUqkV5EGBjKqhrlpg5yOZE5iLuJLNP8k4QEQUWB
	g/elhQd8Dz3dtavpvMfT+Yy8JG9G/5M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 03F6013738;
	Wed,  2 Sep 2026 16:51:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CK1ZACpUmGqNKAAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 02 Sep 2026 16:51:54 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH 2/2] btrfs: use bio::remaining for async checksumming synchronization
Date: Wed,  2 Sep 2026 18:51:36 +0200
Message-ID: <20260902165137.3781696-3-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902165137.3781696-1-neelx@suse.com>
References: <20260902165137.3781696-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 542EB21CB7
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

We can use bio::remaining counter to sync the offloaded checksuming.
As a result we can slim down the btrfs_bio structure by 24 bytes
and simplify the code a bit.

$ pahole | diff
-	/* size: 328, cachelines: 6, members: 15 */
+	/* size: 304, cachelines: 5, members: 14 */

Moreover this will allow us enabling async checksumming with encryption
where we need to checksum the bounce bio instead of our regular one
embedded in btrfs_bio. And so we need to extend it's lifetime. This is
the preffered way to do so.

Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 fs/btrfs/bio.c       | 4 ----
 fs/btrfs/bio.h       | 4 ----
 fs/btrfs/file-item.c | 6 ++----
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 19b4855969f5..771b7d598aee 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -103,7 +103,6 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 	bbio->can_use_append = orig_bbio->can_use_append;
 	bbio->is_scrub = orig_bbio->is_scrub;
 	bbio->is_remap = orig_bbio->is_remap;
-	bbio->async_csum = orig_bbio->async_csum;
 
 	atomic_inc(&orig_bbio->pending_ios);
 	return bbio;
@@ -114,9 +113,6 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 	/* Make sure we're already in task context. */
 	ASSERT(in_task());
 
-	if (bbio->async_csum)
-		wait_for_completion(&bbio->csum_done);
-
 	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index b7bd377a0162..bbf362b8668b 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -58,7 +58,6 @@ struct btrfs_bio {
 			struct btrfs_ordered_extent *ordered;
 			struct btrfs_ordered_sum *sums;
 			struct work_struct csum_work;
-			struct completion csum_done;
 			struct bvec_iter csum_saved_iter;
 			u64 orig_physical;
 			u64 orig_logical;
@@ -93,9 +92,6 @@ struct btrfs_bio {
 	/* Whether the bio is coming from copy_remapped_data_io(). */
 	bool is_remap:1;
 
-	/* Whether the csum generation for data write is async. */
-	bool async_csum:1;
-
 	/* Whether the bio is written using zone append. */
 	bool can_use_append:1;
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 5a5cffb18922..50dcd448d936 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -817,9 +817,8 @@ static void csum_one_bio_work(struct work_struct *work)
 	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, csum_work);
 
 	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
-	ASSERT(bbio->async_csum == true);
 	csum_one_bio(bbio, &bbio->csum_saved_iter);
-	complete(&bbio->csum_done);
+	bio_endio(&bbio->bio);
 }
 
 /*
@@ -854,8 +853,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 		csum_one_bio(bbio, &iter);
 		return 0;
 	}
-	init_completion(&bbio->csum_done);
-	bbio->async_csum = true;
+	bio_inc_remaining(bio);
 	bbio->csum_saved_iter = bio->bi_iter;
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	schedule_work(&bbio->csum_work);
-- 
2.53.0

