Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917738;
	b=RnW3Wks+qVQiBD6PwSmK4HPjBloLqsD/9b0N9+NfjigV5SO2S5H64Hg3mDy7M5Hp1wQW
	 RrtEzNUTQTsSflIaRSl/4qmcXIJIfQB0gytAQ17pbLbLY/m+BCVT54h6hTRSaovWkzp94
	 9XABe/OzcHab1KhHz6BWRwgIciyc+O4XMuSjekn/RB6Rnhi/fOyQty5D33xmsC1Gy0kR9
	 FOETmIhPydKwqGS4dQngIgfcOJqSOEwZzm0yJSJbttXlRMp9WhzEV9lft9JeEb/E1FFxY
	 wGW0PtYLzfIYGuyG5ChAEMI/5B8OAwMcKMna97v+b2eteAve5O5po2Tx+LgEogfqrsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917738;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=XgbDgbH3maFlgBcQwOdzATJr5dtLCni9gIPy4P2P7TQ=;
	b=NXRgmHlg0jkhvbpICp0Qtaj5R7+3OG9ql/YihJyUk+d5GiI5+t+qtuuKFIE+ixy5ohW0
	 FpE/fY5hjOtgEjly+08rNv3yMGEeoGcy1IVq9JqfyjrHYxwRNxGDljuiGfB628DG+9BtW
	 iq0Q//NO+EBH16reFxqXOKvs2X8LgXhdH/EMRhLyIZg7+DH7WKUeFubiApxAHaAtXkAiO
	 R5CYYcOuTnpt5LTa4Po1yX+/Yqb2jYTbt0t756I5b3XmgPVOEKUGHYt3LVBJcKIHU2caV
	 o3N22uNx1eekgZ0dSE9COn8yrzTBjES8DC/5xUnNlGgo6b0gwi3K6HKKVSqKqCds3oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vO4OGKz3;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vO4OGKz3;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C41606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8C41606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vO4OGKz3;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vO4OGKz3
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 187421F38A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgbDgbH3maFlgBcQwOdzATJr5dtLCni9gIPy4P2P7TQ=;
	b=vO4OGKz3x2paPHnYg0apob7u6L5loH5oVXmbLamBR4o9r+pahm73S3uisdcJZDYN+Wxqq6
	mJ1QK29uBaAZmZaCUOlzVnoQeGbZmnkzzzRgsp7WpizJfSTQblrsdhZs7M8SXhN+1jy0Az
	Jmofj3nTVm9xyzUzzgorxPp4Ad/7Rus=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=vO4OGKz3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgbDgbH3maFlgBcQwOdzATJr5dtLCni9gIPy4P2P7TQ=;
	b=vO4OGKz3x2paPHnYg0apob7u6L5loH5oVXmbLamBR4o9r+pahm73S3uisdcJZDYN+Wxqq6
	mJ1QK29uBaAZmZaCUOlzVnoQeGbZmnkzzzRgsp7WpizJfSTQblrsdhZs7M8SXhN+1jy0Az
	Jmofj3nTVm9xyzUzzgorxPp4Ad/7Rus=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 01A7A13314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T7
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/12] btrfs-progs: image: avoid NULL-ptr-deref in build_chunk_tree()
Date: Sun, 25 Oct 2026 19:11:40 +1030
Message-ID: <88a7fa21d1e8ab593349719ce0bb33bab0fbbffd.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 187421F38A
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

Although very unlikely, if there is a header that has no item in it,
build_chunk_tree() left @item as NULL, then later during the error
message we still call "get_unaligned_le64(&item->bytenr)", which is
going to trigger a NULL-pointer dereference.

Fix it by removing the get_unaligned_le64() call.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/image/image-restore.c b/image/image-restore.c
index b1de96c51efa..89ce2f3e79ed 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -1140,7 +1140,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 	}
 
 	if (!item || get_unaligned_le64(&item->bytenr) != BTRFS_SUPER_INFO_OFFSET) {
-		error("did not find superblock at %llu", get_unaligned_le64(&item->bytenr));
+		error("did not find superblock");
 		return -EINVAL;
 	}
 
-- 
2.56.0

