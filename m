Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093716;
	b=07WbP9+JJ31kpUxz4J9vTcyBxt1kokh3DFW0TaRjaAPWoKRH4wLciZJMXT2mKdKtxH7w
	 2lpbqTzrsYEsJ8LOpGD9EHztMmSxS+wRRDGif7J+FjZlKLdeeBcvVMQEJMp3pK5ft08Lh
	 iHvoTP+fsDh9KmyetgD5mWhttBH5RFxgjYe4yBdkS4oCIOFRIV/EpYEQsfVCmmVapZRxD
	 OSLLT3BLZxI8nniP9cnbIJ46R65/c54hfppLYIpsIhYTGgvNtwuiG1yK7XK0OwcYr5cAf
	 K1TuNgcF7jkP30ak+FKBmKhs5soxe1ka4Odh2F2uMyGyTkB/48SEQChMTeRo3y6JXkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093716;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=KHgr6ssZOYEkWXUOYJVTcmh64zDDrC+49e09oDqm5vc=;
	b=ZTMztoDMkIEq7sqSFZvTpbD3Pbu97xwP+o3nnaITsEzN/AHtKsPEMwK7pKRAvVB5kDji
	 oyfatmtJaDFtZSFlo7737BZlB8NI1KRH3gYrTVxZBf243smihAPygUVfaaAq8x+qvcg2k
	 IBzR/mFv+p1UHgg0hNaexq0HwcBjaKbtIPh5RFFrEa/5NySThfw6HL1gO49iMLVsJaAjt
	 zPxRQmUwEvSeccHLIhVUCC3C3/AmnbbLTsC/HD5JAmsbyaYUALNwOWReJ6Igdl0mk/Txb
	 ffoRF1K5Up2MuhBL8dsUb7If6NhAcCwx49rGsDYaU5nIA4xXsHZHIxyKEAKEnZ36Rpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E4Q2A6ow;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E4Q2A6ow;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C52606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C52606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E4Q2A6ow;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=E4Q2A6ow
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9BA8B1F7EB
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793093714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KHgr6ssZOYEkWXUOYJVTcmh64zDDrC+49e09oDqm5vc=;
	b=E4Q2A6ow5cTX+zbpAKgxGeW/a32eDzW0XOWFDVvJTDRXUQp3wWv5cke30M7HZWQUgZ/qPV
	YC1WrJ0XJoUnX/aZq5JP6sdQJzdct1vJgSxI1TyvChbDVzMrqn4+GCaFzYfVOOiRE1vkOP
	+1AwWhmLGHzpydi7TQrECcHzHlJmVUw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793093714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KHgr6ssZOYEkWXUOYJVTcmh64zDDrC+49e09oDqm5vc=;
	b=E4Q2A6ow5cTX+zbpAKgxGeW/a32eDzW0XOWFDVvJTDRXUQp3wWv5cke30M7HZWQUgZ/qPV
	YC1WrJ0XJoUnX/aZq5JP6sdQJzdct1vJgSxI1TyvChbDVzMrqn4+GCaFzYfVOOiRE1vkOP
	+1AwWhmLGHzpydi7TQrECcHzHlJmVUw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8155B13319
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RUo5FE1w4Gr8VgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs-progs: gitignore: add GNUmakefile
Date: Tue, 27 Oct 2026 20:04:51 +1030
Message-ID: <97f1a76d342b63ab692fd513c3574618ffcb5b44.1793093611.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793093611.git.wqu@suse.com>
References: <cover.1793093611.git.wqu@suse.com>
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

I use GNUmakefile to add extra compiling flags without modifying the
existing Makefile:

 MAKEFLAGS += -j12
 include Makefile

So the GNUmakefile is more or less reflecting personal tastes, better to
add it to gitignore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 7cbd83f79676..78333d679a7d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -71,6 +71,7 @@
 /cscope.in.out
 /cscope.po.out
 /compile_commands.json
+/GNUmakefile
 .*
 !.editorconfig
 !.github
-- 
2.56.0

