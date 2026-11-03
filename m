Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701232;
	b=OKs34/zge/JlL+ETYJiaJQUrCFt/BIDaP1SgRFg5F+os8Y00xuTGST3kpeGXf0/LevlM
	 VZQOJf4ykn9eB4H6HJhv8q67933is/K0C+1J6wV9SC0BCp4rqbMIWmHoZ2UsHIHtQDczs
	 uSn7cOEakNeM7ZgsLcHb/0+s48lPx5d3Pu6G377IMywhXqv3GwHRUP3HDVMeUwkcns8GT
	 ScQyDqRb5OqTMUUbk5GTSCfK6uyNL7OU9OmymStrps3OF5SL+nvu0dGDAJxGXeFbxFad7
	 aD8FZrgXEQIJQTkRFR61ks6L9OPYTJU2/U8UsRMDzExToRDyaU5LAl60xVRjtvE8soA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701232;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=EPCv975Dbb620vuUPXrUNfkv2rGeBXAK14pvpAEQsPA=;
	b=dNmCw+fmwz+L3otHzdQE2Rrw7nu9tBaYcJ4arDHI0yryQBFvzA5z2w1ExcC7DvLSrJiV
	 XHl8s9+ztY7FPYARLe2/TzPcwpnoR45K6bBx8urhUFovLbI4F4Zynr3iULmfk2qSp8Ui1
	 RuND+ixCfBXL1qW0nai4PbI74wGUp+BMifIwnB7CaWGiROtmv83d7nPEr4rbxEnR3BUcb
	 EMKmqa+z9rjQO/evuh28w00xjCvnhnXsHxD5v5UrDg7FOBZC1xt2ol1DRxUzM+6LFgJbM
	 VA/KgDnIaKdRvQ9YBo+ZuDqhUsSg5PX5BjoJK3yB7doTs+59vTMa8/mCaVR3Um7MLuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=B6UEGTyH;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=B6UEGTyH;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A44606C54B
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15A44606C54B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=B6UEGTyH;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=B6UEGTyH
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A1E9223A4
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EPCv975Dbb620vuUPXrUNfkv2rGeBXAK14pvpAEQsPA=;
	b=B6UEGTyH8dM4jKcjtdNaBGMwEgKXU3DFRRcOj+E+80zUIe76zrrbvy/cZV80CLrCFakpKQ
	Hm+nTbnhaknxvRyTYJH5aNjoAeknxotARSlWG1HcuITqn8t5aeQNvef+swHD0yOaE9Yhya
	SbtrgtpjDQk6kpwXQdvNlBVtECVgh1E=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EPCv975Dbb620vuUPXrUNfkv2rGeBXAK14pvpAEQsPA=;
	b=B6UEGTyH8dM4jKcjtdNaBGMwEgKXU3DFRRcOj+E+80zUIe76zrrbvy/cZV80CLrCFakpKQ
	Hm+nTbnhaknxvRyTYJH5aNjoAeknxotARSlWG1HcuITqn8t5aeQNvef+swHD0yOaE9Yhya
	SbtrgtpjDQk6kpwXQdvNlBVtECVgh1E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 793471352B
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LthdKme16WpgfAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 10:20:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: fix two sites that may write beyond root item size
Date: Tue,  3 Nov 2026 20:50:05 +1030
Message-ID: <94e2cb63757121d91253ef112a5d5287eceaec23.1793701174.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793701174.git.wqu@suse.com>
References: <cover.1793701174.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

The following two call sites are writing a root item without item size
check:

- btrfs_fsck_clear_root()
- maybe_repair_root_item()

Although the root item size is already checked at read time, at write
time we should clamp the write size between item size and sizeof(ri), to
avoid write into the next item or even beyond the heap memory boundary.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/check/main.c b/check/main.c
index baf4c283527f..d66819048c02 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9532,6 +9532,7 @@ static struct extent_buffer *btrfs_fsck_clear_root(
 	struct btrfs_path *path;
 	struct extent_buffer *c;
 	struct btrfs_disk_key disk_key = {};
+	u32 write_size;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -9579,6 +9580,8 @@ static struct extent_buffer *btrfs_fsck_clear_root(
 		free_extent_buffer(c);
 		return ERR_PTR(ret);
 	}
+	write_size = min_t(u32, sizeof(ri),
+			   btrfs_item_size(path->nodes[0], path->slots[0]));
 	btrfs_set_root_bytenr(&ri, c->start);
 	btrfs_set_root_generation(&ri, trans->transid);
 	btrfs_set_root_refs(&ri, 1);
@@ -9588,7 +9591,7 @@ static struct extent_buffer *btrfs_fsck_clear_root(
 	write_extent_buffer(path->nodes[0], &ri,
 			    btrfs_item_ptr_offset(path->nodes[0],
 						  path->slots[0]),
-			    sizeof(ri));
+			    write_size);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 	return c;
@@ -10476,11 +10479,15 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 		}
 
 		if (!read_only_mode) {
+			const u32 write_size = min_t(u32, sizeof(ri),
+					btrfs_item_size(path->nodes[0],
+							path->slots[0]));
+
 			btrfs_set_root_bytenr(&ri, rii->bytenr);
 			btrfs_set_root_level(&ri, rii->level);
 			btrfs_set_root_generation(&ri, rii->gen);
 			write_extent_buffer(path->nodes[0], &ri,
-					    offset, sizeof(ri));
+					    offset, write_size);
 		}
 
 		return 1;
-- 
2.56.0

