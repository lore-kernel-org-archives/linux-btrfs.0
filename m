Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793169072;
	b=eYjTuoFvhevGy27yt7q1zjI/bUJYocKMkLIJmqZfH8gcSe+7f3IizAvbcyD0IMnRRvPP
	 RcG2UQrGH4KmzT8Uwu9Lq9MugE8YteForrzH3+W1WvWrfuL42oMvZZBnDPN2qe6l5nZxV
	 zOGsj7zK0bJNbPNmMuwLnrFlN+KDKYuVC2W/AUasltuorJL0agIow4AFb+sIDwnxqIJeE
	 OnU5yhlpAISWWVYFBTwtSu7hG7lIJz1XNicbJkN9IwRKv7yidV2Ec1uFew2M46iedIwtp
	 c6VL+SbE0P8mdvmBJ9CC8H1LgCLXKN5qr94fwSimsiJVoCUISDA3ws+l4WLQN4H4usA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793169072;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=CvC1k2vBQgM1YPDsYenRjXdw+UFI+YbR2Z6n+TVJN08=;
	b=Oe9kSK8E0Wzcp/sOK1xbgEOKVUqX8/MaybTDCO0vs6G7Tk2hk1D27PcWRsA3ppJysmy0
	 K+UWVx9JFN2+Q8V8xkKaM7yCC07Dt4mu84sDw7FsdBvtHTXQD4emrrXB4omciblDcb/01
	 cuNaWkF6IQTtagJ2wzbkXlQHrYAUa7mYkqOF8K7NlHIoJkkN9LTIE4yhKhH0PnfT7fqbp
	 LKyd7eKDOQohM9Vl7xiehTpksm8OHsppRN+Bt5qoH/T0JxSc0jKED/6RdTkH+M2TMJpEv
	 1jfnBStCSKEHoBRQmpBrOD5KBvvxbLlwKJqjLggPr+JqP8i0MB62/2uZoXsyS9NxDPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OskNa3RF;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OskNa3RF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFB6606A326
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CFB6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OskNa3RF;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OskNa3RF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 96DBE220FE
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793169070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CvC1k2vBQgM1YPDsYenRjXdw+UFI+YbR2Z6n+TVJN08=;
	b=OskNa3RF+UxZU4cW1z7xQiTBMrz6sL1s0DHBEgbNtEwIDXKXqqu3sIzJnwOat9XiCbWwbW
	AolUIF9fjke4fy4vz1xrUDk77+HkLUNu0+urvMHn/jFTgrBa0bHQcctFZ/ujSNxnCsSTpI
	/Ppayl/vVtG2QJ/ljiZA9H2nL2R7N5Q=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OskNa3RF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793169070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CvC1k2vBQgM1YPDsYenRjXdw+UFI+YbR2Z6n+TVJN08=;
	b=OskNa3RF+UxZU4cW1z7xQiTBMrz6sL1s0DHBEgbNtEwIDXKXqqu3sIzJnwOat9XiCbWwbW
	AolUIF9fjke4fy4vz1xrUDk77+HkLUNu0+urvMHn/jFTgrBa0bHQcctFZ/ujSNxnCsSTpI
	/Ppayl/vVtG2QJ/ljiZA9H2nL2R7N5Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D31D13419
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NOeGHKmW4WoiBwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: don't cache rbio if an error is hit
Date: Wed, 28 Oct 2026 17:00:47 +1030
Message-ID: <b0d3adf5f3cc527b2ffd89c7ed93c99a0cbbdc76.1793168898.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793168898.git.wqu@suse.com>
References: <cover.1793168898.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 96DBE220FE
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

If rmw_rbio() hit an error after cache_rbio_pages() call, the rbio still
have RBIO_CACHE_READY_BIT set, thus can be utilized for future page
stealing.

But that rbio didn't really reach the disk, thus using the pages for
future steal can cause data inconsistency between in-memory cache and
on-disk data.

Fix the problem by clearing the RBIO_CACHE_READY_BIT on the error path
of rmw_rbio().

Fixes: 5eb30ee26fa4 ("btrfs: raid56: introduce the main entrance for RMW path")
Assisted-by: LLM (find the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index b24ec362909b..a8a8004bb14c 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2471,6 +2471,9 @@ static void rmw_rbio(struct btrfs_raid_bio *rbio)
 		spin_lock(&rbio->bio_list_lock);
 		set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
 		spin_unlock(&rbio->bio_list_lock);
+
+		/* Failed write, don't cache for page stealing. */
+		clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
 	}
 	rbio_orig_end_io(rbio, errno_to_blk_status(ret));
 }
-- 
2.56.0

