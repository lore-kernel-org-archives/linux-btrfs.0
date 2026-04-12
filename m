Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E21A6814
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 04:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775966674; cv=none; b=f2RmBOzPFXTOFbnBLsXkeccmIgalqNhbleq/Hsk7EAIW03wKqxXiUYzrdNxXQWlo/olUaIQpB9ditM/ZXNjbMwkQgNzVrrNJtWSSS6Lj4RttX+vBDtHhAsJURzenxSAHMmK87LN2UAdre4LuzMdn8Dr1mL4buHMXzy5L5OlBRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775966674; c=relaxed/simple;
	bh=bB94bcJZQwuGgpc7hTHHJU0qfmBtPULFbwoiEfpF6Lg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ng6dQ1PVpBJGAT5gbzqTwYahUExhL0b5RGK7U6yCYn0lj6UJRJknusJVyiirnDwygCU3i3A7uSFH/WsrOD4UZsJm9Fp3iW0u/DDVPdkubTHiuzGyTjst1XVyNW9r/mgiWM5topYfy4wWb8IZ+p/W8iAHHusPX1bjyG4AQL9PP4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=S4qn5JC0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=STCCAO7h; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="S4qn5JC0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="STCCAO7h"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E49D95BCDD
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 04:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775966664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pWCyQY4v3OdocDu2nCtGWvQ+ht/6wMZ3MLt1vA/CeBQ=;
	b=S4qn5JC08Xb4lxObeCdK1bauT7XgNROQdUqGhOzyuE4X9k/1jmcYh3hk/7AzY0VdXmQks6
	uEU0td9gWYUc76TuLWROsGKR0QdSNcd9Qzm5pt/V34p6UBeJEMDb2l/GZN+K4/6S6jlUSx
	OLGH/JtS+x315imKiwY23XF+3FFX0Vo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=STCCAO7h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775966663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pWCyQY4v3OdocDu2nCtGWvQ+ht/6wMZ3MLt1vA/CeBQ=;
	b=STCCAO7hqa8EtSevW4tYorvE64lrD0VaQ/9LRm0zp+z3l0emtJExD9/uDFBDpHolhwEAd/
	U5+Q2AuFij7bOOTgiYhLp4lBigYmJiPaOxBsjhS3Iouhuf+lpEpRmViSi+0hU7SU4/i6qM
	+vjt440M0eFTbgV5SfIBzvJ+sG0zy9Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEB0A4A715
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 04:04:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D6t/IsYZ22mbRgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Apr 2026 04:04:22 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck-tests: add the missing binary image for fsck/071
Date: Sun, 12 Apr 2026 13:34:04 +0930
Message-ID: <6a494c4c928cf8d711aec68e4339911a6122ec64.1775966626.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vudl_pq:email,p:email,2j:email,tk9r:email,z:email,hy:email,n:email,x8q:email,a_aplxvj:email,kmvv:email,sw:email,wrp2:email,ee:email,mssk:email,ukts:email,0.0.0.3:email]
X-Rspamd-Queue-Id: E49D95BCDD
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Surprisingly the test case fsck/071 contains no image file.

It looks like a merge error, as the patch I sent to the mailing list
correctly shows the binary file:

 https://lore.kernel.org/linux-btrfs/dd3a868f33762d907a1c8bfc99c14b47c917ba7b.1770335913.git.wqu@suse.com/

Anyway, add back the missing binary file, which is created by v6.16
btrfs-progs, which has the orphan fst entries.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../orphan_fst_entries.img.xz                    | Bin 0 -> 1864 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/071-orphan-fst-entry/orphan_fst_entries.img.xz

diff --git a/tests/fsck-tests/071-orphan-fst-entry/orphan_fst_entries.img.xz b/tests/fsck-tests/071-orphan-fst-entry/orphan_fst_entries.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..272412ebf847077c2be6afe69e6686cb904d6b27
GIT binary patch
literal 1864
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

literal 0
HcmV?d00001

-- 
2.53.0

