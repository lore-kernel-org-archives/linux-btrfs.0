Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1DD1EB5B
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772065260; cv=none; b=MfJuYnCnMkVK00uCgf6gucSDWLPqYu7d5D7DMzMryZT58KE+ET9zGSZkrKgYO7IGzVGx3FLcz+bKv1VQsMHDZOgBPBIJgKDepDrSQN/8S9ZeiNr8z4F7OeiCnJ7CTlb4drleLhZ9iuuc4+enJBFtld0rGzRPT/lSL5X9pbLTluI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772065260; c=relaxed/simple;
	bh=VUN/oumpf+J72euCWHmcnNBKqu6rmcQjzkZStZ2P36s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OGlWOExn2fjjV5pxr9B5b6/u7NqFmSIpuOLlLyNNfClqOq+viTgYVUOMh2gOd35b9yuRcruLZh3Bb2uKTZk+ZCbpBQ315OiNUzyr8tpvgJ5jnDckP5RBNz5dvXdxpZlEobCV+gHn+sHQ4C5DOEgmhQqFzY4YuZlfnhI5CZYCObk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sErX0vyM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TniVva6a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sErX0vyM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TniVva6a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DAFA85BD4B
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 00:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772065257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fHAOju6y95UG6AsDlQVKRHOyUue6jqy18bjl2BSrUNU=;
	b=sErX0vyMX3d/tZeYrZSnG36mTJVdZDZaOTacXkGdySILvguzodJ8bBQgoH/B+8r0ieFk8R
	TjPnxl7cLhf7XsXTiu8+goIyNwq/ZLNQRX4EfFPO9N4xOKMs/9T+Nt8At9+Ompi9c/kyU5
	hc8xD7YmK0dsgNNr+VV2cF4vE4VNt8U=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772065256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fHAOju6y95UG6AsDlQVKRHOyUue6jqy18bjl2BSrUNU=;
	b=TniVva6aRCuaMVYqg/hfxpe5rPk8XoDVofW76pnbVWOZvjWw/fMXeWLR0MErDEBvViolW/
	E4MKJ6kkCQvvQT65JOYtzfcqGsgOkQUzn12iBeCkHwEhcd0XRMUUNZEmGWQbYj7ZU7HyNg
	FKkaUybN+ld5rNIkSE4s0k5Vl/m6mhM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 183AF3EA62
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 00:20:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XSfmMueRn2mJOAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 00:20:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove the folio ref count ASSERT() from btrfs_free_comp_folio()
Date: Thu, 26 Feb 2026 10:50:38 +1030
Message-ID: <30541df912ac4a2dd502796a823558fe1d88baa0.1772065237.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Inside btrfs_free_compr_folio() we have an ASSERT() to make sure when we
free the folio it should only have one reference (by btrfs).

However there is never any guarantee that btrfs is the only holder of
the folio. Memory management may have acquired that folio for whatever
reasons.

I do not think we should poke into the very low-level implementation
of memory management code, and I didn't find any fs code really using
folio_ref_count() other than during debugging output.

Just remove the ASSERT() to avoid false triggering.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e897342bece1..192f133d9eb5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -224,7 +224,6 @@ void btrfs_free_compr_folio(struct folio *folio)
 		return;
 
 free:
-	ASSERT(folio_ref_count(folio) == 1);
 	folio_put(folio);
 }
 
-- 
2.53.0

