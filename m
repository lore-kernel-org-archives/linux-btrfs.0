Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090161;
	b=oY5upUKiW55FH3bNVph1stQkl0M455h/cSjrvCiKA6zdxLnD7/vfL5DcYPJkw2FKMJK5
	 taWWg9GWlAf/TwPSzc684m0PqbaQ0mfkT4XFahhpXmLJVQirLmSWBiuc7kQQyo81SQZ0v
	 lCFUWTdYrMNpRF91nIqrcqLCNCL9QZ+OLiavcOKxRkf4BGLH9ONZVozoMutQmQZ0l7D09
	 nr73jgvGPCOMaW2EyqGMfdqB33DIx9m0R3QVDpYS314ctPLiOwyqlIJMjBKL9FRgjs9U6
	 wchjsWL4Ec4jB20NLP4jofrsFn1ScFu/mFbU+FbpGfZ3IUu6HI4d73AdWz9ybmytheg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090161;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=A3mVveeTeiLtXd+U4TA1YcpFricH9t45FBl92p7jvQE=;
	b=O5tCHvf1LZU7xTDNymC6b6oA+2CWjxgSJPb8v9Lcw/0bx9geznlWpHSGBqkFdhZQzbRH
	 wvc4aoyG4UrwQpX9Lo1iWJ8kfzimHi0nDvPtGfz2BVfghTrF4BudrK46zviW62I6OQuCZ
	 +8Pt9NZHMr1G6+pzOE+xmIUw55hpArzXRN9hNopuHlbG+gfXPlocGtM0MYPLl5/iXzCe6
	 80Jjlopa9HaPCkGlfe4x9m1/qg7kalzuUAS0BFRvEvkxCZ7DhA4zWfYkMXRK0Zt9oQYU3
	 Ext2buTc3+DBzWmvODuJN6gWwenvTjFezNk249f/MyGk0/nfa3PU4y63cwLmNxgfJTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=L9HvZhG4;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=L9HvZhG4;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B5F606A326
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09B5F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=L9HvZhG4;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=L9HvZhG4
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5F170228CC
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793090159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A3mVveeTeiLtXd+U4TA1YcpFricH9t45FBl92p7jvQE=;
	b=L9HvZhG4oOyxUyZYSh985QbdWRivlo+fnZwt2sOlRqz0z/l40ADHzgskeaNgI7bHGQ67y5
	iBfhn/aKhQUswrxtEdOKZYXNyWDF44fvFHKGpyLko1kzCMPxNo1BkgdkkISJFbxO9Bdaxe
	RCWH/iR0uPf79NOjrxlM5vvo4BNUHHo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793090159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A3mVveeTeiLtXd+U4TA1YcpFricH9t45FBl92p7jvQE=;
	b=L9HvZhG4oOyxUyZYSh985QbdWRivlo+fnZwt2sOlRqz0z/l40ADHzgskeaNgI7bHGQ67y5
	iBfhn/aKhQUswrxtEdOKZYXNyWDF44fvFHKGpyLko1kzCMPxNo1BkgdkkISJFbxO9Bdaxe
	RCWH/iR0uPf79NOjrxlM5vvo4BNUHHo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B3BC1321C
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bsDdEGpi4GqbGgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: gitignore: add GNUmakefile
Date: Tue, 27 Oct 2026 19:05:32 +1030
Message-ID: <06c3ff42ede1381ad1fa5168b22dc1995abc78f6.1793090084.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793090084.git.wqu@suse.com>
References: <cover.1793090084.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

I use GNUmakefile to add extra compiling flags without modifying the
existing Makefile:

 MAKEFLAGS += -j12
 include Makefile

So the GNUmakefile is more or less reflecting personal tastes, better to
add it to gitignore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 GNUmakefile | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 GNUmakefile

diff --git a/GNUmakefile b/GNUmakefile
new file mode 100644
index 000000000000..e0eaca65651c
--- /dev/null
+++ b/GNUmakefile
@@ -0,0 +1,2 @@
+MAKEFLAGS += -j12
+include Makefile
-- 
2.56.0

