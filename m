Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2191926299
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111727; cv=none; b=uVaUNlJvQToU8LBaZ78vIYLWCakLcbqD1x3A2sDq6CFqtuCUo3bOUa6SLixydXijpxGrY1G+hLhyR1nE1W25s8uO/Fw9ss3lVHUDk/ClwVGXwf9kcTffbwjJnb5EQu1vXE39md2MFBYWF8LvFoNBj6LlVGSmOYURIwBtXmGBxjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111727; c=relaxed/simple;
	bh=H5iGh4FQVML59ZYXzxnsLgebTvhZfE2mIPLd3UnhjaU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T21MURmnXsqvhYrP/FMXldemRrN9ucystwbluvUmFpwiq/gOjqU8f241AhyToxp4iwyYNJz7oW8/i9bOFSibjB3hY1H/C5Bftf/U1SABHWkNoVZGs/E+9nKMkDnzDl3ACvHRGTnozTErS08AUAR3aud5OIdUaI5JGbh9kyxgQ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RSN8rDjO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RSN8rDjO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RSN8rDjO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RSN8rDjO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A0AB1FD74
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aBpfNBr09x47VsRMnIBHm5wkgg1OigCBJiBrq8aWyAA=;
	b=RSN8rDjO8PZNMwBvALu6A8FwXE8ig+AURwbYyY5eV9tqkD4pxhFlUcY0+2huXlkhD4oWV1
	rsUhcYi1/HEMdgWWVcUsKbrok4nnxujfq40UxHu92nSumMYz1Ts0iPJJeb4OKL9sYqgtO+
	TPdygPJ7kmlKb31nyz5tRbvjT0QKxGw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aBpfNBr09x47VsRMnIBHm5wkgg1OigCBJiBrq8aWyAA=;
	b=RSN8rDjO8PZNMwBvALu6A8FwXE8ig+AURwbYyY5eV9tqkD4pxhFlUcY0+2huXlkhD4oWV1
	rsUhcYi1/HEMdgWWVcUsKbrok4nnxujfq40UxHu92nSumMYz1Ts0iPJJeb4OKL9sYqgtO+
	TPdygPJ7kmlKb31nyz5tRbvjT0QKxGw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38B4B1339F
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id inJNK2V00WojCAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: reject existing chunks that don't match
Date: Fri, 16 Oct 2026 11:18:19 +1030
Message-ID: <f4a07685c20d72e23b893f957ba477ff5d3c335e.1792111604.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792111604.git.wqu@suse.com>
References: <cover.1792111604.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

During read_one_chunk() we can hit an existing chunk map.

There are several situations that this can happen:

- System chunk maps
  This is the most common case, where the system chunks are added from
  super block during bootstrap.

  But in that case, the system chunks in the super block should match
  the one in the chunk tree, if not there is definitely something wrong.

- Overlapping chunk maps
  This is rare, but potentially malicious.

  Crafted images or even some bitflips in the chunk tree can lead to
  this.
  In that case we should reject such cases.

To detect and reject those cases:

- Introduce a new helper, is_same_chunk_map()
  This checks most important members, so we can detect such problem
  without fully checking the stripes.

  If the helper returns false, then we output an error message and
  reject the mount.

- Use the full chunk map range for btrfs_find_chunk_map()
  The current search range is [@logical, @logical], which is only one
  bytenr in length.

  If we have the following case, btrfs_find_chunk_map() returns NULL but
  we still have an overlapping chunk map:

                   Logical
                   |<--- New chunk map --->|
                            |<--- Existing chunk map --->|

  Using the full range to do the search would return the existing chunk
  map and get the new one rejected.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e3886c9035de..6574939e1295 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7718,6 +7718,15 @@ static struct btrfs_device *handle_missing_device(struct btrfs_fs_info *fs_info,
 	return dev;
 }
 
+static bool is_same_chunk_map(const struct btrfs_chunk_map *map, u64 logical,
+			      u64 length, u64 type, u16 num_stripes)
+{
+	if (map->start != logical || map->chunk_len != length ||
+	    map->on_disk_type != type || map->num_stripes != num_stripes)
+		return false;
+	return true;
+}
+
 static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
 {
@@ -7747,14 +7756,21 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 	warn_32bit_meta_chunk(fs_info, logical, length, type);
 #endif
 
-	map = btrfs_find_chunk_map(fs_info, logical, 1);
+	map = btrfs_find_chunk_map(fs_info, logical, length);
 
-	/* already mapped? */
-	if (map && map->start <= logical && map->start + map->chunk_len > logical) {
-		btrfs_free_chunk_map(map);
-		return 0;
-	} else if (map) {
+	/* Already mapped? Check if the existing one matches. */
+	if (map) {
+		if (unlikely(!is_same_chunk_map(map, logical, length,
+						type, num_stripes))) {
+			btrfs_err(fs_info,
+		"existing chunk %llu doesn't match the new one at %llu",
+				  map->start, logical);
+			ret = -EUCLEAN;
+		} else {
+			ret = 0;
+		}
 		btrfs_free_chunk_map(map);
+		return ret;
 	}
 
 	map = btrfs_alloc_chunk_map(num_stripes, GFP_NOFS);
-- 
2.56.0

