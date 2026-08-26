Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA529418361
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 09:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738027; cv=none; b=q8m6gsozsAaNK4r5yML1O7E1LKLykC/c3eALa1cdsI8R3MYNcJKYo/GtKq/3ES/z+j4kRpc2li21ZMhI8Jh3SRauFonizr+UH9lXxF3/ITah4PHAljYLqIeZKOt040NPvCz4vgP51dSvexE5FgBv1cbxWIfNZJWaeJdb6dU7VIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738027; c=relaxed/simple;
	bh=Wt6Kg5PZ7D6r8iR4xs8d+cWl1F6IId7upBEa6ymKpMc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uEuIG4eIU+f7SVJeYhcXaufjkmMs7fV6Ttx03DK927XD1l9zO1E/lD9Ud9gd6cRjxNeNPMGxqoHdaitUQ0JgfLG+Viq7aox5/DLtq0y2+KIL21hApzDxlRz0lABbxXHVHVXgHBeKnn10P/B3Glp2a4cwjqQBXhf5klMxfXf3Nyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XtRid8kT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=h8tMcFwt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XtRid8kT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="h8tMcFwt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9167A8734C
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 09:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787738019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gsD54Lv1AjS9qhaZXLAJoQY6xReL6XkToe9WCoyMHIE=;
	b=XtRid8kTQn6/21oi07FsqfiMECumcIeKPUdV5Do3M19WF6uVtDpa4Lc+4eaGY0Hz33WsY1
	Nmg2V4iQxB6itLhP7umRWP1SJuqs4q6GXIH657R/ARPtYp6UAwY9b1Tpm2GF1GbWdD9Swv
	arsgiDXzSEHQaVM8LxQpXewGMp7a1Xc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787738015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gsD54Lv1AjS9qhaZXLAJoQY6xReL6XkToe9WCoyMHIE=;
	b=h8tMcFwtBPLkvqCpbSI9tQMKjLgWtDk6Nr5l9As+7xwnL3j0rHUDTZUJJ2uJLtgjNIU5tq
	Zvk70XW3t/j2o/DP7fjicbZk9CqD0G1YL5at6+4YJCsZr3VxyM3Col9urRZP4vlkSQ6Kkd
	VKOPM+YSUXuowoXGVgsPP6YIxVDEUQs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8CCAE1361C
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 09:53:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TOaTDp63jmrxCQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2026 09:53:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: tree-checker: add qgroup status item check
Date: Wed, 26 Aug 2026 19:23:15 +0930
Message-ID: <f8f6232eb92cc8789461c2219915845aae1850ac.1787737993.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

This adds the following checks:

- Key check

- Item size check
  Here we do not require completely matching the older or newer qgroup
  status item size, this is to allow future structure expansion.

- Version check
  Again it's not a strict requirement for the version to match the
  support one, but to catch obvious bitflip.

  And the kernel will already reject unknown version by disabling qgroup.

  So we allow any version that is no larger than U8_MAX, which I believe
  we won't reach in the next few decades.

- Flags check
  Mostly to catch any unexpected RUNTIME flags.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Loosen the version check
- Loosen the item size check
  To allow older kernels to mount future newer qgroup expansions,
  other than completely rejecting the qgroup tree and failing the mount.
---
 fs/btrfs/tree-checker.c | 64 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0ce91396b517..ff268ebb22d7 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2313,6 +2313,67 @@ static int check_free_space_bitmap(struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_qgroup_status_item(const struct extent_buffer *leaf,
+				    const struct btrfs_key *key, int slot)
+{
+	struct btrfs_qgroup_status_item *qsi;
+	const u32 item_size = btrfs_item_size(leaf, slot);
+	/*
+	 * Since the introduction of simple mode, the size of qsi has been
+	 * enlarged. We need to handle both the old and new sizes.
+	 */
+	const unsigned int old_qsi_size =
+		offsetof(struct btrfs_qgroup_status_item, enable_gen);
+	u64 flags;
+
+	if (unlikely(key->objectid != 0 || key->offset != 0)) {
+		const struct btrfs_key expected = { .type = BTRFS_QGROUP_STATUS_KEY };
+
+		generic_err(leaf, slot,
+	"invalid qgroup status item key, has " BTRFS_KEY_FMT " expect " BTRFS_KEY_FMT,
+			    BTRFS_KEY_FMT_VALUE(key),
+			    BTRFS_KEY_FMT_VALUE(&expected));
+		return -EUCLEAN;
+	}
+
+	if (unlikely(item_size < old_qsi_size)) {
+		generic_err(leaf, slot,
+			    "invalid qgroup status item size, has %u expect at least %u",
+			    item_size, old_qsi_size);
+		return -EUCLEAN;
+	}
+
+	qsi = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_status_item);
+
+	/*
+	 * The version (1) hasn't changed for a long time, but even if we
+	 * are going to support a newer version, it won't suddenly jump
+	 * over 255 in the foreseeable future.
+	 */
+	if (unlikely(btrfs_qgroup_status_version(leaf, qsi) > U8_MAX)) {
+		generic_err(leaf, slot,
+			    "suspicious qgroup status version, has %llu expect %u",
+			    btrfs_qgroup_status_version(leaf, qsi),
+			    BTRFS_QGROUP_STATUS_VERSION);
+		return -EUCLEAN;
+	}
+	flags = btrfs_qgroup_status_flags(leaf, qsi);
+	if (unlikely(flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK)) {
+		generic_err(leaf, slot,
+			    "unknown qgroup status flags, has 0x%llx unknown flags 0x%llx",
+			    flags, flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK);
+		return -EUCLEAN;
+	}
+	if (unlikely(flags & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE &&
+		     item_size < sizeof(*qsi))) {
+		generic_err(leaf, slot,
+			    "invalid qgroup status item size, has %u expect at least %zu",
+			    item_size, sizeof(*qsi));
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -2394,6 +2455,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_REMAP_BACKREF_KEY:
 		ret = check_remap_key(leaf, key, slot);
 		break;
+	case BTRFS_QGROUP_STATUS_KEY:
+		ret = check_qgroup_status_item(leaf, key, slot);
+		break;
 	}
 
 	if (unlikely(ret))
-- 
2.55.0

