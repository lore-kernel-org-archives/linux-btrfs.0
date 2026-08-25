Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F0649364D
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 01:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787620766; cv=none; b=AwfIEBn/yVa4zg+ZOBSxfscUQcFLzVMoAHtGH1uvKsEZ4VkDyJHlm6qJ9yA3J6Lvv02cA1Da/HuaMfpcFPgz3Q3bS2puKGdJhSibkjbYRyjfpRY6vqjeAAwFB/OoZUMAR0l324TejP7lGT8AUn4YYhfOAri34v6+okQ7fb5EPKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787620766; c=relaxed/simple;
	bh=ifkG4AyzOcO2P+D8e9a4lYte5jlOKbVmZ17JwoxdKPg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UTwB3OiFjcIQtrUYUQVw89gvgyXdkMI2+THQlSjGcRGmU1cjMzgG8o9iBL1sqdPPJ4CEfPd7inm98Lb4uSQ8I2WiD8TJTCQHEjrmwt3irQGGSXVPPeu+ZX7TxuYGV+j9S50+Bk5XiZ05MTOPvysM7IjOAqBeUCanqm3TV8SAMfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CjjSf28o; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MJIYg8/L; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CjjSf28o";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MJIYg8/L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E43286BF2
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 01:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787620758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D8kv/H61/ElnAK15KcQrP7ISakaDeubJi2nuY2ua+bo=;
	b=CjjSf28oUOw4NjJNBF83WOOqxStqKKuCzaLxwi4kfI152fI2EuyWvOPq1yambXyubVXplB
	cWVRLduP1ha/FrUEwArxCxqT6MqkYrg2e6NcfV7+nX7xW1VBHz9twJ6fgxnOKzbHStaxtE
	ekHwGTYwsR51jNNdHV0NAj//hakmQ3M=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787620754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D8kv/H61/ElnAK15KcQrP7ISakaDeubJi2nuY2ua+bo=;
	b=MJIYg8/LJeVYX0FY9W+BSi4rXGVMxS10WAGEV6Gx+mwyCBHDytPzfhOgFz1or0+AERCKaU
	IeCPdCCtnVKJ5DFhc3KH8JapVSAiGZLRWRLZ6QUbKWyzvSDeU/VCtbohL2Nib6U0T9JTXV
	xbk578dvIa8BcNx+Nxq2Ssd/cb3Qd4I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80EDA13331
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 01:19:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qWraCpHtjGoPegAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 01:19:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: add qgroup status item check
Date: Tue, 25 Aug 2026 10:48:46 +0930
Message-ID: <abf2a17bcdd62cedc285867435cdb852a383bf51.1787620696.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.26 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_SPAM_SHORT(2.86)[0.952];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
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
X-Spam-Score: 0.26
X-Spam-Level: 

This adds the following checks:

- Key check

- Item size check
  Include the old size (before simple mode) and the new size (with
  simple mode's enable_gen).

  This means we will reject any newer status item size expansion.

- Version check

- Flags check
  Mostly to catch any unexpected RUNTIME flags.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 59 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0ce91396b517..a99fa7729c0b 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2313,6 +2313,62 @@ static int check_free_space_bitmap(struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_qgroup_status_item(const struct extent_buffer *leaf,
+				    const struct btrfs_key *key, int slot)
+{
+	struct btrfs_qgroup_status_item *qsi;
+	const u32 item_size = btrfs_item_size(leaf, slot);
+	/*
+	 * Since the introduction of simple mode, the size of qsi is enlarged.
+	 * We need to handle both the old and new size.
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
+	if (unlikely(item_size != sizeof(*qsi) && item_size != old_qsi_size)) {
+		generic_err(leaf, slot,
+			    "invalid qgroup status item size, has %u expect %zu or %u",
+			    item_size, sizeof(*qsi), old_qsi_size);
+		return -EUCLEAN;
+	}
+
+	qsi = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_status_item);
+	if (unlikely(btrfs_qgroup_status_version(leaf, qsi) !=
+		     BTRFS_QGROUP_STATUS_VERSION)) {
+		generic_err(leaf, slot,
+			    "invalid qgroup status version, has %llu expect %u",
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
+		     item_size != sizeof(*qsi))) {
+		generic_err(leaf, slot,
+			    "invalid qgroup status item size, has %u expect %zu",
+			    item_size, sizeof(*qsi));
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -2394,6 +2450,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
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

