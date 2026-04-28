Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B49037E2FA
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777416179; cv=none; b=g75dKHeYoMPqnm+HvHpAV44UJO3E5fGGLQSPao60VIQoCz/pKVkQDbLIC8qOmGdcOtvvMyW4feRwbSuFPlh5G11EMigD5HDgXA0y+TpL/RS1e10GGcWY8hwm0UA9rvnUDtMpUDuQZsR3VhIknmyVEESroKsE+BfiQxJODF+SkFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777416179; c=relaxed/simple;
	bh=X+AyoANL2LSA9jiP3lACIgdmwvf1hk9+eIcPKbp/d4U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RTANgaT2u8HzT7RzY4gY3YNXmR63QK5Vi5v+5wiY90y3pKExkaDVX2ps9shNa8NSVsB5ZvCcHNWwlPixZ6Mm8Q7Ir5aoc99Bq3YCLwMij5mck6+2DBjmZpb/pviX8tFgXJjtzePiWMob5VT1mp04g6TlDkdYeFcKG/K4XzKZOcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dFXZL126; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dFXZL126; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dFXZL126";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dFXZL126"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8BF8C6A880
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777416175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TilO6mG7PY8zMMgKJjOYbBgT+zEwUETqfADoEEQ9LQU=;
	b=dFXZL126XjlnlsCISQX3ex8peaMH3pHHF9D7WQG+qTMhA9A4E4AyR7qstkuFaLsSQljZe9
	TaiopkSlk08vlkgwnhMn8NJAWRorqoL8oyxIOWq8f+9MtP0LStUZ6fABvPJroh5Bf7q6tq
	sHxkW83/vDuUoVum46xb1LuFyttHQyQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=dFXZL126
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777416175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TilO6mG7PY8zMMgKJjOYbBgT+zEwUETqfADoEEQ9LQU=;
	b=dFXZL126XjlnlsCISQX3ex8peaMH3pHHF9D7WQG+qTMhA9A4E4AyR7qstkuFaLsSQljZe9
	TaiopkSlk08vlkgwnhMn8NJAWRorqoL8oyxIOWq8f+9MtP0LStUZ6fABvPJroh5Bf7q6tq
	sHxkW83/vDuUoVum46xb1LuFyttHQyQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82F37593B0
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:42:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ar0kC+438Wl3EQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:42:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: docs: update the operations affected by swapfiles
Date: Wed, 29 Apr 2026 08:12:31 +0930
Message-ID: <cc6e6714a155270c1f84c0ed6f61405ad80a5ecc.1777416149.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8BF8C6A880

Scrub and dev-replace shares the same routine, thus they are both
affected by swapfiles.

If there is any extent of an active swapfile inside a block group, that
block group will be skipped by scrub/dev-replace.

Furthermore such skipped block groups will only be reported through
dmesg, which can cause confusion to end users.

Enhance the doc to be more explicit about the behavior.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/ch-swapfile.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/ch-swapfile.rst b/Documentation/ch-swapfile.rst
index 2c20104b8402..7cf65a81a260 100644
--- a/Documentation/ch-swapfile.rst
+++ b/Documentation/ch-swapfile.rst
@@ -23,10 +23,11 @@ are on one device but this cannot be affected by user and depends on free space
 fragmentation and available unused space for new chunks.
 
 With active swapfiles, the following whole-filesystem operations will skip
-swapfile extents or may fail:
+some block groups or may fail:
 
 * balance - block groups with extents of any active swapfiles are skipped and
-  reported, the rest will be processed normally
+  reported through dmesg, the rest will be processed normally
+* scrub - ditto
 * resize grow - unaffected
 * resize shrink - works as long as the extents of any active swapfiles are
   outside of the shrunk range
-- 
2.53.0

