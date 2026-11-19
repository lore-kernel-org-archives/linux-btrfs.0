Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058440;
	b=egsOL3UYeWo2PbiSu499ELaUm5qF3qpJnRqgHttQ1rEkdjDxonQAc0xQwV+xqfcE4Y9j
	 noah6aBzg/jdypooBvkHbBgkwWlVUnkkXv5Ykga40hDcSX3CNf9mqGYhlyb2jIhwFVOLb
	 CbAe/veUca+ncvsBPQSDUt4r1dWkfEcm9y3J6ekTxnJPTydc9EXwoRDomk7uO2EFDw9YG
	 +2Pa0VEi/qZEGBmZTXIw/LFArDC01lw7j9J1SlZBw38o1r89m4PlQs04KS8QJh7d8I1Q4
	 i040eIcwqdVV8ZuqaexPbI8rxdUMfGeqCeZINY8SWjPne48wkYyPyEZ19dzOAOP4EJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058440;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=VpNFfKzHNhCYovbFj9x7bd+USPCuslFZOV8dJ+P6Wmo=;
	b=3GKDo5GorszgaU+SFLa8G4z+pMIBW6hyQxczwUHkZZg9PqrjN2PGw+LQsT1WLxcSICTG
	 CthA/R14Hx9+C4Vph0j/r7fvL6A1YfidumJV1OPQe5SLaEV/4iZ/hsw4UFSs6BTNveJOw
	 0d7RHBezjSDDk+y2dMzJaHg97Zdy8VaoGaC/zf3yiveDkXHvHDiOlvbM4RktMTzBVfuWa
	 KNgK0YnBEarXoNjzy6QCau8uWie8npN7mG5tdQ2VCmEHmgR5v1zGtGkQDTjHFBb1rHdN/
	 S8Pfb7qvz2Pd+ABXYPy809+RQ58DsGHnZDvW11xpWvQ9P1kBmbhlxLdGkrBNZrCo/Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fKwCg53K;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fKwCg53K;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C072D606A339
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C072D606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fKwCg53K;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fKwCg53K
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B4C4C1F799
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795058437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VpNFfKzHNhCYovbFj9x7bd+USPCuslFZOV8dJ+P6Wmo=;
	b=fKwCg53K0aTxj6milFgJbPqZCJifI1bNMLM4p1bP2cQ5wF1DzhSQaCXaXqJrxcrYft3/d/
	2r3YJ1HlWCO9KaFzq07EMjqlgXXBgRSXLAkMOFSsd4cD27wWHio+I4dN2OPPNDZ4RXwKMC
	Twlxgq3UoYQPeHghXX6u1NlKrtZoD20=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=fKwCg53K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795058437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VpNFfKzHNhCYovbFj9x7bd+USPCuslFZOV8dJ+P6Wmo=;
	b=fKwCg53K0aTxj6milFgJbPqZCJifI1bNMLM4p1bP2cQ5wF1DzhSQaCXaXqJrxcrYft3/d/
	2r3YJ1HlWCO9KaFzq07EMjqlgXXBgRSXLAkMOFSsd4cD27wWHio+I4dN2OPPNDZ4RXwKMC
	Twlxgq3UoYQPeHghXX6u1NlKrtZoD20=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 918FB1334C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sSvrFwBr/mq7WQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: warn about multiple profiles after dev-replace
Date: Thu, 19 Nov 2026 13:50:14 +1030
Message-ID: <67c14c754958159d20a7152932adce7f77b2a0e1.1795057869.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795057869.git.wqu@suse.com>
References: <cover.1795057869.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: B4C4C1F799
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

There is a private user report that, after replacing a missing device
from a degraded RAID1 raid, the fs is unable to tolerant a missing
device anymore.

It turns out that a new SINGLE system chunk is created during that
dev-replace, which will reject mounts if that device is missing.

We have several sub-commands that will warn about such situation, e.g.
"btrfs filesystem" and "btrfs balance".

Add "btrfs replace start" to also do the warning before exiting.

This warning will be output even if we failed to start replace, this is
not the worst thing, as the end user have more chance to note the
unexpected profiles.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/replace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/cmds/replace.c b/cmds/replace.c
index bd17ea94842b..bb89fcc0d4f3 100644
--- a/cmds/replace.c
+++ b/cmds/replace.c
@@ -355,13 +355,16 @@ static int cmd_replace_start(const struct cmd_struct *cmd,
 			goto leave_with_error;
 		}
 	}
+	btrfs_warn_multiple_profiles(fdmnt);
 	close(fdmnt);
 	return 0;
 
 leave_with_error:
 	free(dstdev);
-	if (fdmnt != -1)
+	if (fdmnt != -1) {
+		btrfs_warn_multiple_profiles(fdmnt);
 		close(fdmnt);
+	}
 	if (fddstdev != -1)
 		close(fddstdev);
 	return 1;
-- 
2.56.0

