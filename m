Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FC33769EC
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851774; cv=none; b=LABkNStB1MjBp/umRsewzrYq8tkIcjdu51ZNwMMzkjPioTPu4RRRk7FEbQe2AmzVgFVb2Eq3bw8WwwFB7abLPcKksgwu0J6kHS/T6Bh/P0A+MRI/5ri6KulDaqC/W2+8AJBC/6aLxrxhnYyTYu8UYV7o+fIHz1G4i6fFQc9ef1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851774; c=relaxed/simple;
	bh=GLvjcdhFeCQxzCYXe/dhAfYSR0mW8lXfZxS5pp0vNM8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjRsdQtPxuUk2469idqEOS252KF0C2/UtNTsIMITrhUADqVIGlXY8j9qF9ZXuhIwaS90y9cMiWTQ6C9lEUNkNscp3mXxnyDa1VDxebd9hz2D3vnJuOcQEwSno1z2apZskhnNpI2xQZzhuvsfWhbUx9Sa99sgccGL1hBzFMb2QC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=N5vC2FbJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dHDGJgdn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="N5vC2FbJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dHDGJgdn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3D6D211B3
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MwCOZKl63WOR2utH1Q4Jmffb09JPy4XBka/LgM9+ipE=;
	b=N5vC2FbJyEdfh3+VpMsVh5o/lf+QZcFOBSG7SSfIu9O5gZRzH7rFoc19KMsNsYwpqj66JA
	aJfwSKC2VUw8URFU9itZ+rbHxARjNHRKy30V3lVu57KTRLIyUbUvmr6iIo0zVBAx3bC1kl
	AXS2nu47TEtxQZrkIl9bGeJySWnN75M=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MwCOZKl63WOR2utH1Q4Jmffb09JPy4XBka/LgM9+ipE=;
	b=dHDGJgdnR9yjU6FUz73NPqzj315+rHTTnA1ISVNhyveR9SYQK9AjjHu+5WCUNZmX+JS9s1
	SsVgkyrENcYOug4z2lVm3TuLahv/T9xdtY63KWubSy2GG7U/muiB8M+R/Ibw5GUhuYD3vj
	JpwJuK7T9meXdfTDnibOsAsUF1XIPvo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F12E1364A
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uFGmEzG2n2qWVAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 07:16:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: use kvmalloc() for overwrite_item()
Date: Tue,  8 Sep 2026 16:45:39 +0930
Message-ID: <59afd3cef54b5d120384b676af642ed2377079cb.1788851649.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788851649.git.wqu@suse.com>
References: <cover.1788851649.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

The @src_copy buffer utilized inside overwrite_item() can be as large as
the nodesize.

For an existing btrfs with 64KiB nodesize, it means there is a high
chance to fail the kmalloc() call if there is not enough physically
contiguous pages.

Meanwhile there is really no need for such physically contiguous pages,
as we only use that buffer to compare the content of the item.

Use kvmalloc() to replace the kmalloc() call.
For most cases that kvmalloc() call will be easily fulfilled by regular
kmalloc(), but for really large items and large nodes, kvmalloc() will
have a much higher chance to get memory allocated.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cfb0b0e9e124..7fb476b19eb4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -503,7 +503,7 @@ static int overwrite_item(struct walk_control *wc)
 			btrfs_release_path(wc->subvol_path);
 			return 0;
 		}
-		src_copy = kmalloc(item_size, GFP_NOFS);
+		src_copy = kvmalloc(item_size, GFP_NOFS);
 		if (!src_copy) {
 			btrfs_abort_log_replay(wc, -ENOMEM,
 			       "failed to allocate memory for log leaf item");
@@ -514,7 +514,7 @@ static int overwrite_item(struct walk_control *wc)
 		dst_ptr = btrfs_item_ptr_offset(dst_eb, dst_slot);
 		ret = memcmp_extent_buffer(dst_eb, src_copy, dst_ptr, item_size);
 
-		kfree(src_copy);
+		kvfree(src_copy);
 		/*
 		 * they have the same contents, just return, this saves
 		 * us from cowing blocks in the destination tree and doing
-- 
2.55.0

