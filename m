Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794697432;
	b=rxI+48BOwVAlXXKew5/o0YyDtJ+mQpUi+Wf/JDB4KiGaHLRDu0hVXp+RgzKGPAD4vZ3P
	 3goBXcRhH7mWCOm5zgW50LwvNZKNloen+s6ZCqvYOBVzlpvo3kEWY7U/SE9AgkiWKiP0i
	 V9JwNQMAzK9u90WYPPYC9hweoa+XEw8u/bxkuFhO35brPJs6UTxmFEW6tzM6Bys6bhUOi
	 VGoFEpVR8k30iMyrtp8lJsIKgH//NjwMiZlkBtszGSXCE379e2lNbrPm/5AbiiuPtSq47
	 gV+kcizRCFPrP47xguTridzvpeTsk53GKlUOqE/rXg6AOYTu5PnbGm67RVPO8DaiUtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794697432;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=2KMAF1f9SoKI+GlPgoQgdnoLD+XqoV2wbXAF58l/q5k=;
	b=reEzxoQlytsyASMo9CqWkRtULxbQEINpdSjCTgmmVdAnl0DcLuqqySfAIAGzfRX9Bzzm
	 oW5+qt1X93yCiEDuirxDruvp+wVSsOUy61N8C6Tn7xjouy1ZAA3tWK37BbNBepTQ1kaGV
	 DV4Qpf6rLsgF7nRrtLpEvYzJwEBI4W+YxgtMgEIUtdz0eC02DBp6MNhgIX1mX0EP+qCJq
	 tXiYXdHm00nCV+cd2FHABwpp3xuFAIYqq7FKhSX6eCHi/R64WQPdlQcXFC/1rdYpNJ3ub
	 dkjYqk2LjNK/7JAC3NaGhOhGgKX3m+yJ4ZiiDe881W8N2YSRYy1mLKfOGpe61RwdYyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ISI4oDS6;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ISI4oDS6;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C658606A337
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C658606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ISI4oDS6;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ISI4oDS6
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71DDA1F745
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794697424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KMAF1f9SoKI+GlPgoQgdnoLD+XqoV2wbXAF58l/q5k=;
	b=ISI4oDS6L05PQUsqPELCiq1C4jLRK0u1/fWuFb73DSpINIKWIGmp1hh14sTzNBq5wiB1wU
	6mUXiP4QYPkyrHIn0Js18RFegMSYSFWPOyZjwID/qKxVG9jyNwbEIY9nPXIJksjw/jlX4f
	qmVswC8QyRYJUuGTcruz7KYQmG8cRnA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794697424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KMAF1f9SoKI+GlPgoQgdnoLD+XqoV2wbXAF58l/q5k=;
	b=ISI4oDS6L05PQUsqPELCiq1C4jLRK0u1/fWuFb73DSpINIKWIGmp1hh14sTzNBq5wiB1wU
	6mUXiP4QYPkyrHIn0Js18RFegMSYSFWPOyZjwID/qKxVG9jyNwbEIY9nPXIJksjw/jlX4f
	qmVswC8QyRYJUuGTcruz7KYQmG8cRnA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52E8513408
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sn6dDcvo+Go0GAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: tests: fix github CI failure on mkfs/037
Date: Sun, 15 Nov 2026 09:33:21 +1030
Message-ID: <d6e25547f5c310a861969339e64ae213751d9257.1794697359.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794697359.git.wqu@suse.com>
References: <cover.1794697359.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[100.00%];
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

The github CI fails with the mkfs/037 due to changed `/usr/lib` layout:

 failed: cp -axf --update --no-preserve=ownership,context /usr/lib*/lib[abcdef]* /tmp/btrfs-progs-mkfs-rootdir.Ivn4QL

We should never rely on the host to populate the rootdir at all.
So use generated data instead, which also improves the coverage, as now
we have both compressible, incompressible and partial compressible
files.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../mkfs-tests/037-basic-compression/test.sh  | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/tests/mkfs-tests/037-basic-compression/test.sh b/tests/mkfs-tests/037-basic-compression/test.sh
index bb1653cf3074..6c2cf9023e5d 100755
--- a/tests/mkfs-tests/037-basic-compression/test.sh
+++ b/tests/mkfs-tests/037-basic-compression/test.sh
@@ -12,23 +12,22 @@ setup_root_helper
 prepare_test_dev
 
 tmp=$(_mktemp_dir mkfs-rootdir)
-limit=$((128*1024*1024))
 
-# Create dataset of approximate size 256M so the repeated compression does not take that long
-for file in /usr/bin/[gx]*; do
-	run_check cp -axf --update --no-preserve=ownership,context "$file" "$tmp"
-	size=$(du -sb "$tmp" | awk '{print $1}')
-	if [ "$size" -gt "$limit" ]; then
-		break
-	fi
-done
-
-for file in /usr/lib*/lib[abcdef]*; do
-	run_check cp -axf --update --no-preserve=ownership,context "$file" "$tmp"
-	size=$(du -sb "$tmp" | awk '{print $1}')
-	if [ "$size" -gt "$limit" ]; then
-		break
-	fi
+# Create dataset of approximate size 256M so the repeated compression does not
+# take that long.
+# Mix compressible, incompressible and partially compressible files.
+for i in $(seq 1 25); do
+	# Compressible: zeros
+	run_check dd if=/dev/zero of="$tmp/zero_$i" bs=1M count=4 status=none
+	# Incompressible: random data
+	run_check dd if=/dev/urandom of="$tmp/random_$i" bs=1M count=4 status=none
+	# Partially compressible: 64K of random data alternating with 64K of
+	# zeros, so a compressed extent (max 128K) contains both
+	run_check dd if=/dev/zero of="$tmp/mixed_$i" bs=1M count=2 status=none
+	for j in $(seq 0 15); do
+		run_check dd if=/dev/urandom of="$tmp/mixed_$i" bs=64K count=1 \
+			seek=$((j * 2)) conv=notrunc status=none
+	done
 done
 
 run_check du -sh "$tmp"
-- 
2.56.0

