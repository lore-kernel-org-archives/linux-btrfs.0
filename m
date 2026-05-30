Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED351ABED9
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 01:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780103532; cv=none; b=NmVZ5R7n/2sY+2+cQX4aLv6Kq5VejlAxmR6i/p4GxmZxy306KYF6cfyGrM0N4gMFe78ijrOd4a94Z44o0IyUTSDg/QJTPJTCPNt9Q9NV9cibdfx8jVMI2OEEUTEAhHBVD4HJoOXFzGncj1YCVtJun2zn2nLSCYQ5PKQpXl+Ze7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780103532; c=relaxed/simple;
	bh=9TlrZIrj0mwIWy+VrRAWvuWki6qUfhzXQzkQ0TQr/9Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WQpt8D0L+yGk7P6TEIv2AOcX7yvANnf3HMTaucxSHDAydRtbXu4ifQbh4FDKkx7G00NPzQhi1RLQFPscDsp1rdrH4Qu55FHZJOo72yE99PbN/+zFs3eG0svLzHgBoDUtwm5/XJQHnW133KhBp6PbCmi7jAxx5f75sfGi9HSCw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NpPoMGJD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NpPoMGJD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NpPoMGJD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NpPoMGJD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 362D367001
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 01:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780103529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1PFFAodbDRKyQqHx39J4MQ4NYly/XHzcQPKd0Rpa/T4=;
	b=NpPoMGJDMPrFMORzLganctWLWECliDmiN3WwRb1NzrEZ381cZKaqEYMHvKMzMzTzVMxCil
	BiNLZmLgLIm1eoih1Olkdz7ps3YQjTICAvQowg/sqylzbDKfBgt4AgzbuglasrCvJv1gCE
	uvlC+h6ak13LUq4FjHIfoz3TLcyG5d0=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780103529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1PFFAodbDRKyQqHx39J4MQ4NYly/XHzcQPKd0Rpa/T4=;
	b=NpPoMGJDMPrFMORzLganctWLWECliDmiN3WwRb1NzrEZ381cZKaqEYMHvKMzMzTzVMxCil
	BiNLZmLgLIm1eoih1Olkdz7ps3YQjTICAvQowg/sqylzbDKfBgt4AgzbuglasrCvJv1gCE
	uvlC+h6ak13LUq4FjHIfoz3TLcyG5d0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71B40779A7
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 01:12:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z6FGDWg5Gmq7awAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 01:12:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: scrub: update the error message to reduce confusion
Date: Sat, 30 May 2026 10:41:46 +0930
Message-ID: <6d3508bdab79b1ac5b1999f2b1bfcc195d81e3b2.1780103458.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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

[BUG]
There is a bug report that scrub is reporting confusing and conflicting
messages:

 $ sudo btrfs scrub start -B /mnt
 Starting scrub on devid 1
 scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
 Scrub started:    Fri May 29 23:54:53 2026
 Status:           finished
 Duration:         0:10:23
 Total to scrub:   911.45GiB
 Rate:             1.46GiB/s
 Error summary:    csum=18
   Corrected:      0
   Uncorrectable:  18
   Unverified:     0
 ERROR: there are 1 uncorrectable errors

There are 18 uncorrectable errors, but the final line only shows one.

[CAUSE]
The "1" is for the number of devices with uncorrectable errors, not the
total errors found in the device.

[FIX]
Change the error message to "there are 1 device(s) with uncorrectable
errors" instead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds/scrub.c b/cmds/scrub.c
index 74fd0fec1b79..88883498eb48 100644
--- a/cmds/scrub.c
+++ b/cmds/scrub.c
@@ -1727,7 +1727,7 @@ out:
 	if (nothing_to_resume)
 		return 2;
 	if (e_uncorrectable) {
-		error("there are %d uncorrectable errors", e_uncorrectable);
+		error("there are %d device(s) with uncorrectable errors", e_uncorrectable);
 		return 3;
 	}
 	if (e_correctable)
-- 
2.54.0

