Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F1E425862
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190906; cv=none; b=j8kUZ8gRIii+Sw9lLyiAhI8KByIumfmUHpuz7LQ6GPD4qwFt+JlxNYDS2bFDKGJd1W/yQFCvBfKKPwVx4xNMB5MKruZ3OkZOhH039BF5r2MXwpHKWtAMMYszDwUTwNuRHmx/6e5drQGLrTbEJqaAaHRd5XdGyont1YZ6tro2I/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190906; c=relaxed/simple;
	bh=Aa9h8oY2GwFM6QkPo3RrwHTdzdsGEI+wibdtOhdDUHE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPjPUrrcaLrgvj9pXR2YI7esTYEhsuCVYN3IZjsgSUA9Ovs2SYWTOBZKl6avnTA83Dq6UmKBw+r6JLJZzo4LgXZyhQgrSF15L+QkCwfm8HBDhtdvsXCVKx9zGQNXBqTZ9LBPlGwpmFCAmcX1hB142hMTkjyZGTv/2zoygAQY4ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cPc1SLiZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FbpSIltc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cPc1SLiZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FbpSIltc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FB6A1F789
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q6o7SxyPrS0icj0htulXrkwM2EHDAD9+xBdC+RhVQNM=;
	b=cPc1SLiZH3oxtOpM7QFNiYvWaTG1GgjDbCwyqURhyKmgJAioVjeBKiGsGO0E9yHrpq+CLl
	UWMyE0sqjfJfe2ODVsCyGFXS0hCm5HjIbuN/BM7PkdSZMvgNIH0+XClADhr8u2FjnwavRS
	+hGE5Cs6sIW87e9F/pDH/oSeNcfvvYE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=FbpSIltc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q6o7SxyPrS0icj0htulXrkwM2EHDAD9+xBdC+RhVQNM=;
	b=FbpSIltcsDvnhj/3L/fyzPQSMMAwO5aDKQcp2dKMfyl8tfTWE6B80AXl09dKmmg4qIo6hH
	+lY6nHphzK+ktHDP2rX+IHRmABCAstNZipJVOwYudphMYD5DSUkoh0aW/YYbTaT4qLDpM1
	vDYIBfJNMA5NA+PMYulCUE6e5WXFAAI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E57113A1B
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngyMK2tnw2qpRwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 09:01:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: check: fix the inverted condition to load qgroups
Date: Mon,  5 Oct 2026 19:31:10 +1030
Message-ID: <0843c2a34743a4d61942149f5a26b8519aab87b6.1791190852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791190852.git.wqu@suse.com>
References: <cover.1791190852.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2FB6A1F789
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[BUG]
When a qgroup tree is higher than level 0 and has a qgroup relation
between the first subvolume and a higher level qgroup, the btrfs check
can failed to load qgroup tree.

A minimal reproducer looks like the following:

  mkfs.btrfs -f -K -n 4k $dev > /dev/null
  mount $dev $mnt
  btrfs quota enable "$mnt"
  btrfs quota rescan -w $mnt
  for i in $(seq 1 32); do
          btrfs subvolume create "$mnt/s$i" >/dev/null
  done
  id=$(btrfs subvolume list "$mnt" | awk 'NR==1 {print $2}')
  btrfs qgroup create 1/1 "$mnt"
  btrfs qgroup assign "0/$id" 1/1 "$mnt"
  umount $mnt
  btrfs check -Q $dev

The failure looks like:

 Opening filesystem to check...
 Checking filesystem on /dev/test/scratch1
 UUID: fbe3bc62-168a-4fec-8ef5-ba5f92d8c22c
 Print quota groups report for /dev/test/scratch1
 UUID: fbe3bc62-168a-4fec-8ef5-ba5f92d8c22c
 ERROR: failed to add qgroup relation, member=256 parent=281474976710657: No such file or directory
 ERROR: loading qgroups from disk: -2
 extent buffer leak: start 30789632 len 4096
 extent buffer leak: start 30793728 len 4096

[CAUSE]
With extra debug output, the following one line shows the problem pretty
well:

 load_quota_info: search_relations=0 search_key=(246 0 0)

That's for the first loop of load_quota_info(), which should start from
the first leaf and load all qgroups into memory.

However the search key is not (0 0 0), it's the inverted condition
initializing the search key cause btrfs-check to grab the leaf with
qgroup relation items, not the first leaf.

Thus btrfs-check failed to load the qgroups in earlier leaves, causing
the above failure.

[FIX]
The code is not that well written, but as a hot fix just revert the
condition to fix the bug.

Issues: #1180
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/qgroup-verify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/qgroup-verify.c b/check/qgroup-verify.c
index 68002ec2e2ae..7993cd22a213 100644
--- a/check/qgroup-verify.c
+++ b/check/qgroup-verify.c
@@ -953,7 +953,7 @@ loop:
 	 * items. The 2nd pass picks up relation items and glues them to their
 	 * respective count structures.
 	 */
-	key.objectid = search_relations ? 0 : BTRFS_QGROUP_RELATION_KEY;
+	key.objectid = search_relations ? BTRFS_QGROUP_RELATION_KEY : 0;
 	key.type = 0;
 	key.offset = 0;
 
-- 
2.55.0

