Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC4B3E7BBF
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045413; cv=none; b=K/pzeViTNSS2qjemT1TCcGUByHydhB6VR02Vq/JBQGb+tbOYl4q9iWk1I8qqRLlB96wS/rqs/6aTkBzNStimuCE1svWc9NYdTuA1Sv9QPzrkoFmzxWIPxP7CqtlS2wGXFRbo6mRu7Srseo1g57owcGqeoSFq/tDJ6hM4I5hID5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045413; c=relaxed/simple;
	bh=SM3KjDef+rAu9M3B39qqfo2LDZzCvpScEADzwqU/4iQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewGQDW0BV0K1Qq+tEemfnCJAxRZuG+XyS60Lz0Tjj+DvWfpkakqqOO+l5wSFsloyLblQk+qQ5z02dIbB2MTTF8L3Lkk9sowj4rRE4VQyoJqMIiHp+1+1PIJbxiNJAeklRCNiIUdqj/qLPhCHoe1Pv5Ie9EcdsDX78+xRzCl598s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SoHfl7UN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R0lotbnB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SoHfl7UN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R0lotbnB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 93F9A3EBE
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IlJMxS9eV917Svinke8mII5ZOs5/rtLT97RrPUo+N0Y=;
	b=SoHfl7UNVl018e4bFcSkcx3imAHGl2nTfnt8j7KHAyvC7KoLRWbaD8B0zRKmiVZ/8nYMLJ
	C2627y0EEdbxoBjBNeZB7Q5NsVICXLfPnm4DzG27R4uFwIcwZ7JjulPcS83H/Dz7ufqqnU
	TjwKdldf0aAPA7bmXGm2R8WclS1Q/cM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IlJMxS9eV917Svinke8mII5ZOs5/rtLT97RrPUo+N0Y=;
	b=R0lotbnBotteGqDsCjHiFaMf4UQP/AE50yb5cR+twWulllYWOfvJMO3SfCtheECZy/QJ8L
	4dSrKjb4gp3NeyWCn+VMDMRyWBUSg2NHK1126AukI9ZMXl1JCpXaygf12J8Ypb8bgcaW6A
	HaTnZaH5JBiPdTHIqaTnJwKo7SMO1Jw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79085367A
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sMC5BxgmhGrKWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:00 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs-progs: corrupt-block: allow corrupting dir item flags
Date: Tue, 18 Aug 2026 18:59:33 +0930
Message-ID: <c8166f5de759a95c5426eed13264369bd0617e4b.1787045341.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1787045341.git.wqu@suse.com>
References: <cover.1787045341.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

With this feature and the previous inode corruption, we can change the
type in inode item, dir item, dir index to be consistent with each
other.

Assisted-by: LLM (coding)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-corrupt-block.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 1e49f6ec50db..83910f1394f1 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -343,6 +343,7 @@ enum btrfs_file_extent_field {
 enum btrfs_dir_item_field {
 	BTRFS_DIR_ITEM_NAME,
 	BTRFS_DIR_ITEM_LOCATION_OBJECTID,
+	BTRFS_DIR_ITEM_FLAGS,
 	BTRFS_DIR_ITEM_BAD,
 };
 
@@ -448,6 +449,8 @@ static enum btrfs_dir_item_field convert_dir_item_field(char *field)
 		return BTRFS_DIR_ITEM_NAME;
 	if (strncmp(field, "location_objectid", FIELD_BUF_LEN) == 0)
 		return BTRFS_DIR_ITEM_LOCATION_OBJECTID;
+	if (strncmp(field, "flags", FIELD_BUF_LEN) == 0)
+		return BTRFS_DIR_ITEM_FLAGS;
 	return BTRFS_DIR_ITEM_BAD;
 }
 
@@ -683,6 +686,12 @@ static int corrupt_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 		btrfs_set_dir_item_key(path->nodes[0], di, &disk_key);
 		btrfs_mark_buffer_dirty(path->nodes[0]);
 		goto out;
+	case BTRFS_DIR_ITEM_FLAGS:
+		if (bogus == (u64)-1)
+			bogus = generate_u8(btrfs_dir_flags(path->nodes[0], di));
+		btrfs_set_dir_flags(path->nodes[0], di, bogus);
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		goto out;
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.54.0

