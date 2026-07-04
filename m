Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3589271456
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jul 2026 09:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783155957; cv=none; b=J7ivwxPeVx2uz3Ydqz7g0QmjQsTeYSnbHCly0H1f71MgozMYpw2zmiFbl+gq1wbkjEgOpekH/0iqcrFw2ivcBFIF9Jb0YDGtLavFozqPZAdCucMKqpcrrbKWSZBDpw1Tc9NbSj/XiA2vUeTPlUJx3X832onDkUXdvJeJ5O6TCkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783155957; c=relaxed/simple;
	bh=C2SV43j/nbRjLK+XY18Ni82mG7mcVomqvQQPYKNLq6Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lIZQJlSA92V1F1xFVphAGXvMTDOz2pLptCeyhYoudWjKLk77Ej1nZGj/mjQNeYMDxIkB4JeyHt17H2qJYTddvUDkPPBGVY/MpBUIf1k1IAnAwjiK3TtSCgijBUfg/P2yEZ1wPJBc+hxGtAe8cnqMrJYim5FYBnZtN0pS4Gc0RdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qdKOkGLQ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qdKOkGLQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qdKOkGLQ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qdKOkGLQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C5F375C4D
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jul 2026 09:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783155954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QLZ8vvpeLKdKbRX7qSlhdJniM/igXUK6jEhjd20Etfk=;
	b=qdKOkGLQTJrHP6arVCgXICnaE4sLUxMPag0RzOeOGMQ32rtvDp9zCZYeA4B3ekGAynB+67
	pq9YmicFrAV9Tw+FNOxT8tL9UNM/UeugeuUXzksjswYnvoIkkPLDnWkOWz0rhMLaKnBOtw
	1VhPfe2/ybSzCmZ5ESPWcdma6FMYhAI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783155954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QLZ8vvpeLKdKbRX7qSlhdJniM/igXUK6jEhjd20Etfk=;
	b=qdKOkGLQTJrHP6arVCgXICnaE4sLUxMPag0RzOeOGMQ32rtvDp9zCZYeA4B3ekGAynB+67
	pq9YmicFrAV9Tw+FNOxT8tL9UNM/UeugeuUXzksjswYnvoIkkPLDnWkOWz0rhMLaKnBOtw
	1VhPfe2/ybSzCmZ5ESPWcdma6FMYhAI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C8A7779AA
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jul 2026 09:05:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MLfsLvDMSGoJIQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 04 Jul 2026 09:05:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: docs: mark "usebackuproot" mount option as removed
Date: Sat,  4 Jul 2026 18:35:30 +0930
Message-ID: <cbb4fd969d5f07477adc09449c609084cbd14c33.1783155928.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Since the kernel patch is going to land in v7.3, update the man page to
reflect that change.

Also, just in case end users are using the latest progs but on a much
older kernel, keep the "usebackuproot" mount option entry, but
explicitly mark it as "removed", along with the history of deprecation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/ch-mount-options.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/ch-mount-options.rst b/Documentation/ch-mount-options.rst
index 8f65b8311e7e..8dac29d8aa52 100644
--- a/Documentation/ch-mount-options.rst
+++ b/Documentation/ch-mount-options.rst
@@ -462,14 +462,15 @@ treelog, notreelog
         a mounted filesystem if the log is not replayed.
 
 usebackuproot
-        (since: 4.6, default: off)
+        (since: 4.6, removed since: 7.3, default: off)
 
         Enable autorecovery attempts if a bad tree root is found at mount time.
         Currently this scans a backup list of several previous tree roots and tries to
         use the first readable. This can be used with read-only mounts as well.
 
         .. note::
-                This option has replaced *recovery* which has been deprecated.
+		This option has replaced *recovery* which has been deprecated in v5.9.
+		This option is fully removed since v7.3.
 
 user_subvol_rm_allowed
         (default: off)
-- 
2.54.0

