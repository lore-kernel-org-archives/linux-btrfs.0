Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA7336494F
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775970550; cv=none; b=nQp8y0QtW0SX4nFayiNtL7SYOsLZBINzdXVomg2GRcdT02oVGCtSAidpRfVFMMGQzfHtZMK4cS0UFPA3Lg7giCbYHoH6OWClKV1kVYrA/1zeNlKrvkhJNHiRYPEmiqfQfknl4CA8RqRdAE6LBqN1ZhL2MJ3vB5l9uuTTivwXOZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775970550; c=relaxed/simple;
	bh=aS1E2JDPOnavhG+9+w82bPsAmdAAQkW69nwdOVVTnZU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbHpv4jWf6lb7/ChJruUCKqk1ZdynDt+HCC7jlPPVuymo5BL+c3xQelvO21ZEpwojoPZc3NxuloMU6bSk/Taj70rLeNnInHnbYvQISrY6iL47RuJOrrJ174vRAuWgD7mZxrId8hnF+h4Rx/cMjx+r3X7UlgkMkxF6JVGoBDIMVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PdWyhAZ8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PdWyhAZ8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PdWyhAZ8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PdWyhAZ8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03F426A83E
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EHBsUMzH2IxyZhamOccnWPVlIB0ghjO1BG39eJpcH6Y=;
	b=PdWyhAZ8ey2jkefKffk1pEnxUi8k1pqKj4CcZnlqHAK36GG/iKcBF+9HWpFFmkODHcwDUG
	I/4WmJRfzS/7OikE2SXLGRNsAzO/kfDXy3IG5gOxSM8qMtuR5/LLPhYRk0HsdxZMpToR2U
	bKULT0GOyQsjIGDTx+675bmCdJl1mPE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775970547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EHBsUMzH2IxyZhamOccnWPVlIB0ghjO1BG39eJpcH6Y=;
	b=PdWyhAZ8ey2jkefKffk1pEnxUi8k1pqKj4CcZnlqHAK36GG/iKcBF+9HWpFFmkODHcwDUG
	I/4WmJRfzS/7OikE2SXLGRNsAzO/kfDXy3IG5gOxSM8qMtuR5/LLPhYRk0HsdxZMpToR2U
	bKULT0GOyQsjIGDTx+675bmCdJl1mPE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F10904A756
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mNjMJvEo22k7AwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 05:09:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: print-tree: fix the format string for EXTENT_OWNER_REF_KEY
Date: Sun, 12 Apr 2026 14:38:43 +0930
Message-ID: <c2c8d98d47188e395c1afa4aa755cac6ac5a41a6.1775970499.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775970499.git.wqu@suse.com>
References: <cover.1775970499.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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

There is missing tab for EXTENT_OWNER_REF_KEY, which results output not
following the same indent:

	item 13 key (84082688 EXTENT_ITEM 1048576) itemoff 15763 itemsize 62
		refs 1 gen 14 flags DATA
	(172 0x100) textent owner root 256 <<<
		(178 0xdea30debbf5f519) extent data backref root 256 objectid 258 offset 0 count 1

And it's caused by a misplaced 't':

			printf("\t\(%u 0x%llx) textent owner root %llu\n",

There is no special escape sequence "\(", nor the word "textent", it
looks like the 't' is incorrectly placed by commit ad8a831a742c
("btrfs-progs: dump-tree: output the sequence number for inline
references").

Fix it so that the output is correct now:

	item 13 key (84082688 EXTENT_ITEM 1048576) itemoff 15763 itemsize 62
		refs 1 gen 14 flags DATA
		(172 0x100) textent owner root 256
		(178 0xdea30debbf5f519) extent data backref root 256 objectid 258 offset 0 count 1

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/print-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index 28d6f4ded3f4..0afa36963b6a 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -579,7 +579,7 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 			       type, seq, offset, btrfs_shared_data_ref_count(eb, sref));
 			break;
 		case BTRFS_EXTENT_OWNER_REF_KEY:
-			printf("\t\(%u 0x%llx) textent owner root %llu\n",
+			printf("\t\t(%u 0x%llx) extent owner root %llu\n",
 			       type, seq, offset);
 			break;
 		default:
-- 
2.53.0

