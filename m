Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793525836;
	b=rE13TU5TwIu13sy5xcm7GgLiCjogTn8p9xb8A/8jA75oRRSWSSb5swO1R0URpBLvbphG
	 V1/7RTnfMMOm8ZzkkwkQ9RRachUpQFBEL3ni7KzJScGGQoyfrO8CAJy0CBL2J155rylBZ
	 5P0WSyCQ1gWqzg9Lty++UgPTLVS1EbEav4ZFNQRQLnUaG8ktvLJLl5pfTr3l46HS4uKQu
	 zTx+5JDioFVLmAu94/zqoxrG+RgrWIzRyX8HojTLsqRa/6TYwykEBd+EWwGAlHjKeOlL3
	 xQ/Ctk8YoNc9XU9yrcH17VHflsjKWY4ttvdC3i3kaw0xORyS220jGiGSA667Zr+2H2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793525836;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=u8Fk5A4/Oqx28fT4Qhb8POIbT+eqAc8V4Jvz0wkDr+M=;
	b=I5QwzMs20K8zSxI8THWI21t91nrNoFqSJ+QMUCSqxPdIZ6p8O9p2ou403h3mnkIVJq1n
	 E6lKC18y7QJj51Eyy0q2F4n8l8HKekuzYnW5rvEpW5S7oM/luGAua8e1ezJNEvb9LvcTh
	 UhLz2/3KX5itdoiL7+jhH2PTRkqJ5HcKdSC+JAQFwnfZGNB2dKH+jOTxjWE/Mq6El6NYe
	 grhbEbxjGOU/ffXvUStKfokX32+SrQI6fweINWGdzn6CChQY+r6dTxzHTKVTsonU9oZf0
	 NJ1uSNtX841FfRo4jDRGNRnBZZPs/3s1Te45E3v3l04GnJbg8JaniN2Mi4TvM5k/mqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=a9XnwlbE;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=a9XnwlbE;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7308606A32C
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7308606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=a9XnwlbE;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=a9XnwlbE
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 16D581F78B
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793525834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8Fk5A4/Oqx28fT4Qhb8POIbT+eqAc8V4Jvz0wkDr+M=;
	b=a9XnwlbEr3mIWm/+CQeg0ovAUvQ4Fz6JZu11xUgPTCvPyOGMcjxEKDoYVpsNFxZ1X5a9w6
	k8e6m1W+XLJb7Pb11qGeGhNqujWU6KrIAFjG/g7Y46nmLxywlHHMX6DK54krC4uX61eCWa
	Lh988sZkDoc7/dpTPsbDx37hKkRqWlM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793525834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8Fk5A4/Oqx28fT4Qhb8POIbT+eqAc8V4Jvz0wkDr+M=;
	b=a9XnwlbEr3mIWm/+CQeg0ovAUvQ4Fz6JZu11xUgPTCvPyOGMcjxEKDoYVpsNFxZ1X5a9w6
	k8e6m1W+XLJb7Pb11qGeGhNqujWU6KrIAFjG/g7Y46nmLxywlHHMX6DK54krC4uX61eCWa
	Lh988sZkDoc7/dpTPsbDx37hKkRqWlM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1E6913314
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id odilLEYI52qESgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 09:37:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: subvolume: fix an uninitialized access
Date: Sun,  1 Nov 2026 20:06:51 +1030
Message-ID: <a2de9026dff326c28f0e1b5609905ec9a5cace72.1793525519.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793525519.git.wqu@suse.com>
References: <cover.1793525519.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

If the fstatvfs() call failed inside wait_for_subvolume_cleaning(), for
the first failure it output a message, and set @statvfs_warned to true.

Then if fstatvfs() failed again by some reason, since @statvfs_warned is
true, the same old warning won't be triggered, so
"(st.f_flag & ST_RDONLY)" is checked instead.

But since the fstatvfs() failed already, the @st is uninitialized, which
can trigger an incorrect warning and return before waiting for
subvolumes.

This is really a minor problem, exposed by LLM during review of patches
touching the same wait_for_subvolume_cleaning() function.

Fix it by only checking @st.f_flag if the fstatvfs() succeeded.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/subvolume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds/subvolume.c b/cmds/subvolume.c
index f0da28582931..1c53686596df 100644
--- a/cmds/subvolume.c
+++ b/cmds/subvolume.c
@@ -112,7 +112,7 @@ static int wait_for_subvolume_cleaning(int fd, size_t count, uint64_t *ids,
 		if (ret < 0 && !statvfs_warned) {
 			statvfs_warned = true;
 			warning("cannot check read-only status of the filesystem: %m");
-		} else if (st.f_flag & ST_RDONLY) {
+		} else if (ret == 0 && st.f_flag & ST_RDONLY) {
 			warning("filesystem is now read-only");
 			return 1;
 		}
-- 
2.56.0

