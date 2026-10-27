Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793083803;
	b=VPh83+tK4jxalKPNgFYOmds6ifQ2wGv4YdiAVRAM8utxzs7K7S+BXwXKaWLnUGnRgwKY
	 GpZL3NpNXq9MUNB3CPhjBhn1u1ZCDMkqG4M2lLVxuOFtFY97TQElosmJyJOocppymrERb
	 Vm+bBEjRO9Yfj4qgyZtEKEG8ArSQYwMxTeHrYOkVJpVKeWwm5zzk9emcS3qvV8mNDDvwl
	 I41+CYJv7Fi4jlR+1dfgtQLvOQLFGnZGM4aZ0/DRJuk+UWElW2Th32cdaKduQhFrmaY/P
	 oRhvpTNOFE5gdntdOoNwiilwrSd4FzhTxD6IQsO6QFohjOR4iZXfsU87CHYyrFp04lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793083803;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=1HRwFL/X+Yo433nwT87No4TbiieWWRYwZ7jbvTvbfOg=;
	b=z41w5KS5QfBIbnO8oWbz/YNFg9OCz0zAhRNzHFuv1zMgNO521Lu/R3t/3PzJiRLjYs4V
	 JjVHHd+ugxCgZMcJL92aUwp0W63QhA0eBMTUGYcPb3A/QuDxw77keyr73QyPj9MbbwmRD
	 5QXHiWrIrANPGszs0rVd/76Ao374AWI7SzVWWlPanHdEmCSu5a8rZlgcR409VUwCLfnZk
	 fiKa3HyFK+l5zbc1ke+LYuRjfRSBeW3fq9bOFOoIQm1kDcD63rzZ4MwM3Iot0OSeXj0dS
	 fyNkb2nHkRN3B11d8pUg76v3hUTKOLedGCCeuimqLDv+9D5y/67G9t4W8UE6PF4U1cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hUaLliOq;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hUaLliOq;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC42606A31B;
	Tue, 27 Oct 2026 06:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFC42606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hUaLliOq;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hUaLliOq
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A67D1F7C9;
	Tue, 27 Oct 2026 06:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793083795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1HRwFL/X+Yo433nwT87No4TbiieWWRYwZ7jbvTvbfOg=;
	b=hUaLliOqk7Whqztn4yobSj0gYrJpiBI9Nogt2G50HSjXuL6rkWySNleyrzdkMMGSHxAm6t
	S+MeVwUT8Yh1NSBwLfaCTWladsOMJ0weIjkG1c65BNoAXEyRO93BJcPPUug4ksfyQ3S7QO
	Rp3JD03L++DqHaC6I1qhL3XZ/k28NZ8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hUaLliOq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793083795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1HRwFL/X+Yo433nwT87No4TbiieWWRYwZ7jbvTvbfOg=;
	b=hUaLliOqk7Whqztn4yobSj0gYrJpiBI9Nogt2G50HSjXuL6rkWySNleyrzdkMMGSHxAm6t
	S+MeVwUT8Yh1NSBwLfaCTWladsOMJ0weIjkG1c65BNoAXEyRO93BJcPPUug4ksfyQ3S7QO
	Rp3JD03L++DqHaC6I1qhL3XZ/k28NZ8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94C8413319;
	Tue, 27 Oct 2026 06:49:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pcp+OZBJ4GqfKwAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 27 Oct 2026 06:49:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] .gitignore: ignore GNUmakefile
Date: Tue, 27 Oct 2026 17:19:35 +1030
Message-ID: <9024da8d008cebcca6e8bccc0d3cc2d6473e4193.1793083694.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 5A67D1F7C9

I use GNUmakefile to shorten the command of "make".

E.g. for my arm64 worktree, I have a GNUmakefile with:

 export ARCH := arm64
 export LLVM := 1
 export PACMAN_PKGBASE := linux-arm64-custom
 export PACMAN_EXTRAPACKAGES :=
 export PKGEXT := .pkg.tar
 MAKEFLAGS += -j12
 include Makefile

And for my x86_64 worktree, it looks a little simpler:

 export LLVM := 1
 export PACMAN_PKGBASE := linux-custom
 export PACMAN_EXTRAPACKAGES :=
 export PKGEXT := pkg.tar
 MAKEFLAGS += -j12
 include Makefile

So at least in my case, GNUmakefile is really a shortcut to specify
extra environment variables and build flags.
Thus it should be added to gitignore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index 9875120ea7bd..400caf6bce9a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -194,3 +194,6 @@ sphinx_*/
 
 # bc language scripts (not LLVM bitcode)
 !kernel/time/timeconst.bc
+
+# GNUmakefile, mostly to export extra env variables or build flags
+GNUmakefile
-- 
2.56.0

