Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662B9237713
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774396102; cv=none; b=QXfcKxTIfAor1ADd22+QCiuZ1s/v6jJW+QW4Qq18og91lArLxrrUOOdlTe2oQkIpKwyIx9sKRtGvCsJF7uhI01T9xYbuxZ4/f65hQ3BMLN/3aQV+jAqEPWrw+gbuowu/7AqtWdAxEMPdTbAGr1mlPNBh/mtZZSMwHCiGsFqe9d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774396102; c=relaxed/simple;
	bh=y4amXLOH93YJGvWpeXrb1trPSIZKnJTl0/R8wC0l+zg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G85i0VXZnWtNPvvkviUWeOaw+rj4m4m5igGQ+BDG7fh9C90y+Y3fRKFhkrwpExv5fmEQ4Ki/BCyReGqVHCGjIajkoXf/wpVGYZhtBypqADaJC0PSqR5otMX/T88m0jHV0ahI90lX5EOh6Ti5U/TEtEUsGIuWQG/8QH7Lkow3EFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O5cK9rDZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O5cK9rDZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O5cK9rDZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O5cK9rDZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45D394D229
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774396094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjhK0BgtgZqnyChr0GxZ99thPBh50XfII0jhNnVDSQo=;
	b=O5cK9rDZZPBnf8AVXMy89WanwcZp3iYEmlXlcBO0pqLCSoKWKcdeTreaury6mGJOIhvPRQ
	bVLggsh5jxStvNd/jRZQ1SZYJaXqfyl/xSm986nAMIUTar0UoSzHAjeGHA/7/zAQfQqGtc
	WqNvRBsKEM2QqqaJjIq5NIy/y4kv6Ss=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774396094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjhK0BgtgZqnyChr0GxZ99thPBh50XfII0jhNnVDSQo=;
	b=O5cK9rDZZPBnf8AVXMy89WanwcZp3iYEmlXlcBO0pqLCSoKWKcdeTreaury6mGJOIhvPRQ
	bVLggsh5jxStvNd/jRZQ1SZYJaXqfyl/xSm986nAMIUTar0UoSzHAjeGHA/7/zAQfQqGtc
	WqNvRBsKEM2QqqaJjIq5NIy/y4kv6Ss=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80A2D440D9
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UIvTD70iw2nlIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: fsck-tests: add a test case for verity items
Date: Wed, 25 Mar 2026 10:17:53 +1030
Message-ID: <74bfea6fd8704d8669c476408d729eb9cc8f15ab.1774395991.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774395991.git.wqu@suse.com>
References: <cover.1774395991.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
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
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[n6:email,nhk:email,imap1.dmz-prg2.suse.org:helo,qg:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Leo recently fixed a false alerts in btrfs-check where verity items are
reported as unknown items.

Add a test case for such case, the image is generated by enabling
fsverity on a small file, which will have VERITY_DESC_ITEM and
VERITY_MERKLE_ITEM items to trigger the previous false alerts.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../fsck-tests/072-verity-items/fsverity.img.xz  | Bin 0 -> 2364 bytes
 tests/fsck-tests/072-verity-items/test.sh        |  15 +++++++++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 tests/fsck-tests/072-verity-items/fsverity.img.xz
 create mode 100755 tests/fsck-tests/072-verity-items/test.sh

diff --git a/tests/fsck-tests/072-verity-items/fsverity.img.xz b/tests/fsck-tests/072-verity-items/fsverity.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..eba1bbb4192e28820d86f4bf2fe13ba1a2ee3edd
GIT binary patch
literal 2364
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/072-verity-items/test.sh b/tests/fsck-tests/072-verity-items/test.sh
new file mode 100755
index 000000000000..d5dc08a09afa
--- /dev/null
+++ b/tests/fsck-tests/072-verity-items/test.sh
@@ -0,0 +1,15 @@
+#!/bin/bash
+#
+# Verify that check can handle btrfs with fsverity features properly
+
+source "$TEST_TOP/common" || exit
+
+check_prereq btrfs
+
+check_image() {
+	# The image contains verity data in the fs tree.
+	# The check should not report verity items as errors.
+	run_check "$TOP/btrfs" check "$1"
+}
+
+check_all_images
-- 
2.53.0

