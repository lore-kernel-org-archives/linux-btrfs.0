Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795576536;
	b=MJ1rjDEUQAlEDjqRt7xzMFs2FOHKBV8ol18Xf8eXTH/vaYNbBdCgeUU9lVWlYjBw5SUy
	 5vk9fq4NFrXMa+BNvOxqGkcb02zWi5CkCBgsz1R4gzJnusY6tGf7STuPPMZA+6FWi12im
	 KK/MN+/yXnWIRmlrhizquMP6kc1J/A1HV1F0JCDp6L27C8civ4z7Xfb3myGEdNZ7Dixwd
	 WUkZUJzqqwwf5Sb5rktLProHO2B22E5HOlIzAWV7eKlDhXP0DicVQR802cDhUtWqCfyXS
	 1vbnt1tJ61imFPrqWVuwTFsmJn8hBg3QRNabH8ju1qBgDYiY7PnAnQdcwItKGRuSkiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576536;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=HDDOL1Z2QqKs4dkGmV51dS+p2SnoUrZR5ArEjvoB288=;
	b=ce+euYRHo3TgmkqRTYZTw+s1FBkjnn0rI9djOWWPj7TsiVtiQuCiz7we5p5iSrkHMMZf
	 weL96Q+yRU+uAux8tv0O+bFY+RW+/RT210PFoHEdhhgjmnt6nyiOjeZFcT1+bwz+1Hgj6
	 wGF6Vu1GAJsi8xwEzNYCxbNbgFHsNCVFNB5t5OPraA9ZRa3bS3f4WY2gjiW8A53a3rkMD
	 OLaTf743mciwsm417xUHddkfeRSAAH4bHKoLZJw1pVjXcEqSu/zJoOhPDxcA3G9CnBFjI
	 9AGhdYxTziUNIaB68HbHr3rrCFicFluQlKmZ9U7Lt2NGcWzncchtMflsyGdgHiPd2Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=itlX9Oyh;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=itlX9Oyh;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9F7606A32C
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F9F7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=itlX9Oyh;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=itlX9Oyh
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E2BD1FBB0
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795576534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDDOL1Z2QqKs4dkGmV51dS+p2SnoUrZR5ArEjvoB288=;
	b=itlX9OyhErEyDVR8uThj1DjiVyHodJoPqrrnyhFq8Z6j6zCcxw/emQLIvEXUMlmmnBXj51
	XO+a1p/Dzg9OGe/Lea4VhVCvrdC6DLzwnbj45TlkEJ12JlvlpOBUpUI/B3KLUNOaI8RIJF
	SjivmiHEfdBcLEZRf5y9a65SR49Ygyo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=itlX9Oyh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795576534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDDOL1Z2QqKs4dkGmV51dS+p2SnoUrZR5ArEjvoB288=;
	b=itlX9OyhErEyDVR8uThj1DjiVyHodJoPqrrnyhFq8Z6j6zCcxw/emQLIvEXUMlmmnBXj51
	XO+a1p/Dzg9OGe/Lea4VhVCvrdC6DLzwnbj45TlkEJ12JlvlpOBUpUI/B3KLUNOaI8RIJF
	SjivmiHEfdBcLEZRf5y9a65SR49Ygyo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2585D1339F
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b3N0L9JSBmvBMgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: tree-checker: reject parent backref that goes beyond MAX_LEVEL
Date: Wed, 25 Nov 2026 13:45:11 +1030
Message-ID: <a5657fae3becb14bcece1c86975f15584a048f73.1795576387.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795576387.git.wqu@suse.com>
References: <cover.1795576387.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3E2BD1FBB0
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

Inspired by recent fixes to handle_indirect_tree_backref() and the
original sashiko report, if a tree block is already at the max level
(MAX_LEVEL - 1), it should not have a parent except itself.

The self-parent case is for reloc tree and legacy case where backref_rev
is smaller than BTRFS_MIXED_BACKREF_REV.

So reject them when checking the inlined extent item.
This is a very low priority hardening, as it's very hard to hit such
high level tree block in the real world.

Please note that, this is not going to cover all cases, keyed backref
can still introduce the same problem, but with the default skinny
metadata, we should catch most cases now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..f7bc1ea19a0c 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1537,6 +1537,7 @@ static int check_extent_item(struct extent_buffer *leaf,
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_extent_item *ei;
 	bool is_tree_block = false;
+	u8 level = 0;		/* Tree block level, only for tree blocks */
 	unsigned long ptr;	/* Current pointer inside inline refs */
 	unsigned long end;	/* Extent item end */
 	const u32 item_size = btrfs_item_size(leaf, slot);
@@ -1666,14 +1667,17 @@ static int check_extent_item(struct extent_buffer *leaf,
 		struct btrfs_tree_block_info *info;
 
 		info = (struct btrfs_tree_block_info *)ptr;
-		if (unlikely(btrfs_tree_block_level(leaf, info) >= BTRFS_MAX_LEVEL)) {
+		level = btrfs_tree_block_level(leaf, info);
+		if (unlikely(level >= BTRFS_MAX_LEVEL)) {
 			extent_err(leaf, slot,
 			"invalid tree block info level, have %u expect [0, %u]",
-				   btrfs_tree_block_level(leaf, info),
-				   BTRFS_MAX_LEVEL - 1);
+				   level, BTRFS_MAX_LEVEL - 1);
 			return -EUCLEAN;
 		}
 		ptr = (unsigned long)(struct btrfs_tree_block_info *)(info + 1);
+	} else if (is_tree_block) {
+		/* METADATA_ITEM_KEY, key->offset is already verified. */
+		level = key->offset;
 	}
 
 	/* Check inline refs */
@@ -1719,6 +1723,20 @@ static int check_extent_item(struct extent_buffer *leaf,
 					   inline_offset, fs_info->sectorsize);
 				return -EUCLEAN;
 			}
+			/*
+			 * A tree block at the highest level can not have a
+			 * parent node.
+			 * The exception is the root of a reloc tree, or of a
+			 * legacy tree with backref_rev < BTRFS_MIXED_BACKREF_REV,
+			 * which use the block itself as the parent.
+			 */
+			if (unlikely(level == BTRFS_MAX_LEVEL - 1 &&
+				     inline_offset != key->objectid)) {
+				extent_err(leaf, slot,
+	"invalid inline shared block ref, tree block at level %u can not have parent %llu",
+					   level, inline_offset);
+				return -EUCLEAN;
+			}
 			inline_refs++;
 			break;
 		/*
-- 
2.56.1

