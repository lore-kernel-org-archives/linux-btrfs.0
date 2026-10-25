Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917748;
	b=l0rU6kzuZCifw4+ReTTMZJyskWFY7YNrkTEp0kjBY1oGxfX/TGznHez1/WRxaogTJC77
	 310p0qglJGA3pKLOcP/I2B+SXB50DW4q9b36XObUE2V/070tOQZCRl18gaqtGR0AFjhKQ
	 RzIJpX9bsUkYgy9zGIJP/p0zIhv7N3xfz3X6M4wE9FgH+lR0rcrHCcyosdgIynvgoC16w
	 N7iroQuaDrqMjPgaPMDBBzKjT8/erq00wPQYeaejDMw3f0nj/t9yQxGh0A8SXS/WyveaJ
	 gLBj3TQVyQpRUFaJip/Hq+BiJJvKfo1YetDa2YHDuPdTT2Kd4HRC6Gp1EVttlEGYQ5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917748;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=wvxMnyWV1cYT75q/PiNIsmFVUOHb6eu1X70p6J+zpiw=;
	b=xQyZjndBcMQ1FE+ZYfSx5BsHWY+3WG+l2s/vunXwL0VOpD12gJxnaLCBU1cCV+T0t2PU
	 EFSyPhipbn12jbt26qyqfb8ux2K2Pp03ddUSpVGuq35hu5uMbkRroMXlx1f3Vknx9UfOq
	 jfhfDR80Ll4Jdc7dZR5Txiqh7i+c+OcHOjnZZAWv+duAVpNUCF4t2vx1J/nkJ1j+Yf4wd
	 IjAfGMHJDuDY6j/G5VVCgiIS8qrCoCH7ClwB/2q0pdpK1gaLDXo0iqsTaNn/SKJKkO0ve
	 el12+buEbMl0exHGYvQuRiVX4FTUlZKatMs837ZlNa5n+1GjsBwY2ljFt9kGHXOtKHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GFXSj1bL;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GFXSj1bL;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88389606A31D
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88389606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GFXSj1bL;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GFXSj1bL
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E60F922252
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wvxMnyWV1cYT75q/PiNIsmFVUOHb6eu1X70p6J+zpiw=;
	b=GFXSj1bLHSYCxmLvqEDMs9rNVr13KmkkWQyn7McL/NoXiXVzwKQHAhrdX1Nl/YW+9pkqZe
	8E8udYEjrsIq18KOipkaKRhNwv1yPwONUW+feHVnNvVokGt4kIUPpwoftKPo54SRkX61fT
	TLz5Wi2Zl2l4J2iuRtaig5Ih/Uh4GVY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wvxMnyWV1cYT75q/PiNIsmFVUOHb6eu1X70p6J+zpiw=;
	b=GFXSj1bLHSYCxmLvqEDMs9rNVr13KmkkWQyn7McL/NoXiXVzwKQHAhrdX1Nl/YW+9pkqZe
	8E8udYEjrsIq18KOipkaKRhNwv1yPwONUW+feHVnNvVokGt4kIUPpwoftKPo54SRkX61fT
	TLz5Wi2Zl2l4J2iuRtaig5Ih/Uh4GVY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C58E013314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T13
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/12] btrfs-progs: image: properly error out when fseek() failed
Date: Sun, 25 Oct 2026 19:11:46 +1030
Message-ID: <b446c272935840521a5fd01d96b75f0e0b813b9a.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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
X-Spam-Level: 
X-Spam-Flag: NO

When fseek() inside restore_metadump() failed, @ret is still 0, and no
error is returned.

Fix it by using the errno on the error path.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/image/image-restore.c b/image/image-restore.c
index 7f3c9fdb6536..3d76440599ec 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -1889,6 +1889,7 @@ int restore_metadump(const char *input, FILE *out, int old_restore,
 	}
 
 	if (in != stdin && fseek(in, 0, SEEK_SET)) {
+		ret = -errno;
 		error("seek failed: %m");
 		goto out;
 	}
-- 
2.56.0

