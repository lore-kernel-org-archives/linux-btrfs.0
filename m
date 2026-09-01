Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ECB245012
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 23:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788306780; cv=none; b=XzM6YakPjIPWaI7f6y43RVGfoirKkWkifWsccAU5P2S2AiJy4ZfuMK4IfejkmdoraAx2s5SiRGih4yAU0NoCzI3XkgW6swkEb+ojfpDcAQKQvtR5KlhKkVhYKpA5dq8yKlzcOMOFnqFkFBTr/FP/sISaZJt2K35FcK2DigxxolA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788306780; c=relaxed/simple;
	bh=HualBAcQ8ZW5sDeL1uV9SnaUZp5gYXLQt0Hdya31jlk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hrMi9+GRyQhMdPA/6FmSxqdQemmwLpdkIdgCPr8kU5XlbLe2Ps4f8g/ujbpLr8OtuOXBOd81ZJ7IVQlo+VY6U8/69gL2guQrYxO3lbYHs1YgaX+KkdRodSF/VYNqBTKcKxJ5B/ncaMb1Ly0Ingups2cnYoV0PIV1Kd5+IRUBeNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mnFGPiPP; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TYfC1aS2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mnFGPiPP";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TYfC1aS2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CED27222A5
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 23:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788306773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qjLLXOTh8ZIKYz3QGiRxVGiDFsQoAbBX4VZgZvUJ+0A=;
	b=mnFGPiPPsi5AUOP56ZGLLFZXzBMKuen3xOQk9enl0mwRkzceTLf3dA8oP1/32LiffiJ/Kw
	b6hx1H7HIDt06p2KuOmMMPMLcajCVL8b6GZrLdNG8ONAG/8Mg9ob+Ap/S4qAGzyQaavIeE
	0AYi44S6MPKtiwtwixxLp2M3ApQPCcM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788306768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qjLLXOTh8ZIKYz3QGiRxVGiDFsQoAbBX4VZgZvUJ+0A=;
	b=TYfC1aS2fGBow5k2iYpgw3bzLcjIY+EkrO9LaIBUV3hm7desMpYFb7r0TxK+Rb+1Tt9egr
	APdpxEr21v1HqiMm3iwjS/2p2QtgSCzWDJHr1IcwFlC1QfVAJUFNUMNmckvzMOWPnm6+0D
	t/VAAwrfljGTtzBESJKc969H2FvnUfM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 912A613515
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 23:52:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hmRLD09ll2oREgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2026 23:52:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: scrub: only restore the old scrub limit after scrub is finished
Date: Wed,  2 Sep 2026 09:22:28 +0930
Message-ID: <e62853b27372c6435165507685c65f2a81f33361.1788301098.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
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
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]

[BUG]
There is a bug report that the --limit option of `btrfs scrub start`
doesn't properly apply for all devices.

[CAUSE]
It turns out that the timing we restore the scrub limit is too early:

 scrub_start()
 |- read_scrub_device_limit()
 |- write_scrub_device_limit()
 |  The old limit and new limit are written before we start scrub.
 |
 |- pthread_create()
 |  Now we start threads to do the real scrub ioctl for each device
 |
 |- write_scrub_device_limit()
 |  Now we already restore the old throughput for the first device.
 |
 |- pthread_join()
    We only wait for the scrub to finish after we have restored the old
    limit, which normally is no limit.

[FIX]
Move the old limit restore code after we have waited for all scrub
threads.

Issue: #1165
Fixes: 7c1c88e41668 ("btrfs-progs: scrub: add the new --limit option to set the throughput limit at runtime")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/scrub.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/cmds/scrub.c b/cmds/scrub.c
index 825b91da910f..cb02d9216498 100644
--- a/cmds/scrub.c
+++ b/cmds/scrub.c
@@ -1594,14 +1594,6 @@ static int scrub_start(const struct cmd_struct *cmd, int argc, char **argv,
 
 	err = 0;
 	for (i = 0; i < fi_args.num_devices; ++i) {
-		/* Revert to the older scrub limit. */
-		ret = write_scrub_device_limit(fdmnt, di_args[i].devid, sp[i].old_limit);
-		if (ret < 0) {
-			errno = -ret;
-			warning("failed to reset scrub throughput limit on devid %llu: %m",
-				di_args[i].devid);
-		}
-
 		if (sp[i].skip)
 			continue;
 		devid = di_args[i].devid;
@@ -1645,6 +1637,16 @@ static int scrub_start(const struct cmd_struct *cmd, int argc, char **argv,
 			e_correctable++;
 	}
 
+	/* Revert to the older scrub limits. */
+	for (i = 0; i < fi_args.num_devices; ++i) {
+		ret = write_scrub_device_limit(fdmnt, di_args[i].devid, sp[i].old_limit);
+		if (ret < 0) {
+			errno = -ret;
+			warning("failed to reset scrub throughput limit on devid %llu: %m",
+				di_args[i].devid);
+		}
+	}
+
 	if (do_print) {
 		const char *append = "done";
 		u64 total_bytes_scrubbed = 0;
-- 
2.55.0

