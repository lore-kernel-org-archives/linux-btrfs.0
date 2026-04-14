Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292563E6DF3
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180673; cv=none; b=UvBdCmjSSQ38D05VZe1z2kK25XccVNwJx+ohR2vq72G/TeRVjbTyCGIs/y7O1hSyFF2ua5za06NaT4oSnmmKmlLhNjeM6CvEd8v+Nc9YtvYyVKSOapL0/H38EIaiIRzIjsypo+sVPSs88GSay1XYsps4oP5mWec70f/X2VaE8PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180673; c=relaxed/simple;
	bh=PjoYtIR186O2dSkSRUZaKGNrRp094UQacmENu7yeShA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZM6QTtKQcM9CEWVypStJh1RMjeO0vlbHho46VcvMW6phgkK9JCAq88ePpqJKKxqQACddhyKdWQ2BnK+J7rp/jU0n8Cw4EWQvuZoGNvWOqKTHJ/hdUrvkUHybqrky3SbNpD79HNndOZHm6RJcMw26IZULq211TMIEqxraq8Z8Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pGGcfBYq; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pGGcfBYq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pGGcfBYq";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pGGcfBYq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 106B66A7C4;
	Tue, 14 Apr 2026 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=avmPQHC8QIrjDKFzXzkA0FP8/HPWKLyr2LgwGX/jFUQ=;
	b=pGGcfBYq738k8afgP4FMdrrQKQ65XpWUgDi19oCaAxunSka4ZDtY+rufwX1zs/O9ys3opA
	6hk3VJivvVd6CkSojTNpsQ6aWTBgBZhz4VdNj5792PecgzBcK6H8XYeoOTVuXbhJm3GW9J
	gAHU8pEUCdHoSvz0044HNipsKCpSxew=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=avmPQHC8QIrjDKFzXzkA0FP8/HPWKLyr2LgwGX/jFUQ=;
	b=pGGcfBYq738k8afgP4FMdrrQKQ65XpWUgDi19oCaAxunSka4ZDtY+rufwX1zs/O9ys3opA
	6hk3VJivvVd6CkSojTNpsQ6aWTBgBZhz4VdNj5792PecgzBcK6H8XYeoOTVuXbhJm3GW9J
	gAHU8pEUCdHoSvz0044HNipsKCpSxew=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08BFE4B4F9;
	Tue, 14 Apr 2026 15:31:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MnUhArpd3mkvPAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Apr 2026 15:31:06 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: convert kmalloc_array to kmalloc_objs in btrfs_calc_avail_data_space()
Date: Tue, 14 Apr 2026 17:30:34 +0200
Message-ID: <7a1451a859fe680ac2e01fd4f896b0bb2306fd49.1776180388.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776180388.git.dsterba@suse.com>
References: <cover.1776180388.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

There's one use of kmalloc_array() that can be transformed to
kmalloc_objs() in the same way as suggested in commit 69050f8d6d075d
("treewide: Replace kmalloc with kmalloc_obj for non-scalar types"),
swap the arguments and drop GFP flags. All the other cases of
kmalloc_array() do not use a simple type so this is the only one.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b26aa9169e8388..f67a268f36a6d6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1633,8 +1633,7 @@ static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	devices_info = kmalloc_array(nr_devices, sizeof(*devices_info),
-			       GFP_KERNEL);
+	devices_info = kmalloc_objs(*devices_info, nr_devices);
 	if (!devices_info)
 		return -ENOMEM;
 
-- 
2.53.0

