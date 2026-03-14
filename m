Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C177733EC
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773446468; cv=none; b=rIFiLW6NsmbWt+jvkevtVm/UmAu/BjgiFJ52Tqo1nezWhQP6OBfnNL0LRR0PcRVscZJLJ9x1E4osoCNgkxOziiC5gjoGE+sKVAwuT8xQVfHO8H4RFRTeSF0X4RJPzOL7vYmoTKb0Su3pZngRF/Anm8dsi39OZ2Pqbm3kvqwZ3AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773446468; c=relaxed/simple;
	bh=nWQAX3at5wTDYdXAjG4qSLjyK91ZjPT8g0HpfWl9MJk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np4PGBb0xnhsZ84LG7ci5MrC2wSf/HnZHnBXms1QYOEjFNdfOW1lfH8SbB+SZ0U2SR49fqnB+dthE/hb3Gg55FBj5Ey7UBj2bowSxOpOEat5CM4Swrl5dALs+4xNOdCx9sgwoN4DkQiWh5V3wFEVWmQj77R3nlk8ddmISF9xunE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UNtv0Li3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UNtv0Li3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UNtv0Li3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UNtv0Li3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2895D5BD66
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773446460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCWhqSkZNzcid3cbiKsPRT5qKcfwZWhLXZvXRO7G7Zw=;
	b=UNtv0Li3U2hFeEYpwyPQQZjvXfoNYDHIgA/M4Xwc8nQyzTO/O2qCEIranLdwbS/eFGGfLY
	iGrbHjdrZ3PerBn8ACDEPMh/eDX+hNu9hwTitp1OoR2U1mAYoxokB8OJTaPdBxm5BhCjTb
	x+Ja3MvqD2JHbOHo7vjs+wdPaKok/JM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773446460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCWhqSkZNzcid3cbiKsPRT5qKcfwZWhLXZvXRO7G7Zw=;
	b=UNtv0Li3U2hFeEYpwyPQQZjvXfoNYDHIgA/M4Xwc8nQyzTO/O2qCEIranLdwbS/eFGGfLY
	iGrbHjdrZ3PerBn8ACDEPMh/eDX+hNu9hwTitp1OoR2U1mAYoxokB8OJTaPdBxm5BhCjTb
	x+Ja3MvqD2JHbOHo7vjs+wdPaKok/JM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63071407C3
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WJuFCTultGl9dQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: output more info when duplicated ordered extent is found
Date: Sat, 14 Mar 2026 10:30:39 +1030
Message-ID: <6dc9f2f9702f0ce9e52c0aaff3b702ceedcdadb5.1773446363.git.wqu@suse.com>
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
X-Spam-Score: -2.77
X-Spam-Level: 
X-Spamd-Result: default: False [-2.77 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.17)[-0.857];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

During development of a new feature, I triggered that btrfs_panic()
inside insert_ordered_extent() and spent quite some unnecessary before
noticing I'm passing incorrect flags when creating a new ordered extent.

Unfortunately the existing error message is not providing much help.

Enhance the output to provide file offset, num bytes and flags of both
existing and new ordered extents.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ordered-data.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index de6b60c52292..d39f1c49d1cf 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -253,10 +253,15 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
 	spin_lock(&inode->ordered_tree_lock);
 	node = tree_insert(&inode->ordered_tree, entry->file_offset,
 			   &entry->rb_node);
-	if (unlikely(node))
+	if (unlikely(node)) {
+		struct btrfs_ordered_extent *exist =
+			rb_entry(node, struct btrfs_ordered_extent, rb_node);
+
 		btrfs_panic(fs_info, -EEXIST,
-				"inconsistency in ordered tree at offset %llu",
-				entry->file_offset);
+"overlapping ordered extents, existing oe file_offset %llu num_bytes %llu flags 0x%lx, new oe file_offset %llu num_bytes %llu flags 0x%lx",
+			    exist->file_offset, exist->num_bytes, exist->flags,
+			    entry->file_offset, entry->num_bytes, entry->flags);
+	}
 	spin_unlock(&inode->ordered_tree_lock);
 
 	spin_lock(&root->ordered_extent_lock);
-- 
2.53.0

