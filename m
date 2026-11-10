Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350031;
	b=2wrMBg3o2e+3KfSHbKBTgFEay2WlT2jmSYkXJvpZvNn8HvImyoSFEagBF0WI3aGutUdP
	 ng0ePVomeniONP5yR03FQoDSACG/ZurZ9UaPrljYFA5CcxqM9TxnMmT94HjAM9xPYvDBq
	 n3X53HjFRcgRjkh3HQb7YwlEEH02/uev+VfvbNEPI+DYViJo1ltAdsDeOnYGz/zijax0v
	 ZbhyAinydkclBVsGxzwU70KibLhosIG9yo1uDCSsJalmjrfnjbCX1CTB8EYaAT9w30c/U
	 hmefTxZ8I/A1oRxyDqUGNPA0hZFmLmqKiSUEFcdLqbq0ksjcvxs2zfbNipkpiWgw/wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350031;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=5YF9cR/Sj24XBOZgVl/31zuzT8Nsmh/4VSonCxpA9R8=;
	b=PJ7HS80ges+z/9MLl405hxLKMrw/GtKuzUljjbl1+qqJ81G8/zQUYcfgpwu4XEDdp5sZ
	 t7ZS6A6Uo4G0G7uVD/T7a6OqzLX1V4mb25y33fNIIsVrU2vtBblLqq3fxMFxdk/+5vvSg
	 6k6pLUzX9mw8B6ykpiFqb8Psf9J6pFl8g4qiS1M0Phvt+cXMDJS3ainj9zRE6ZtihHir+
	 5ICMp9ytsh7ClK95PxFCS3CQcd81jvoYkG7kk/zQ7EAdRsQ/wSF5/P44rBprZ/ptAYZN7
	 CyQLnqdOjxx/Togvv64wJhSxKB7IexmuWnyJmFv8bNOFhiHN0Ty7E6JITk4ckTze9yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JzU2Aqvc;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pgy6vTLP;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B30606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71B30606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JzU2Aqvc;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pgy6vTLP
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E4E9A1FAB4
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794350029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YF9cR/Sj24XBOZgVl/31zuzT8Nsmh/4VSonCxpA9R8=;
	b=JzU2AqvcydIEqvrzgfzhaFDfOlefsZK5DlOMccyMv5m7Gzi0CTevrUbM9ufy40aMBerNDb
	ieUBt+8xyu6ldJu9/uD0FMtGRPW5wwJouy6QC8X+m3wv3T6QLnYxh40SeupAB/+ZhvW83W
	5BuJB5wks/y9o6OBpYQbxvR9eof0lMI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=pgy6vTLP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794350028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YF9cR/Sj24XBOZgVl/31zuzT8Nsmh/4VSonCxpA9R8=;
	b=pgy6vTLPn72bqAEzDVAR3Wif3p67GZv11S/BcufII4XO8EBvCrcMPQkHOVFqkR6APn0jJP
	RbucwMZVt2CJe1aQSD3vvUq13gvoDzHus1PH83OGD64ZbQGgEEYBdx3MGRa8uctT9kZXfu
	ugeyF/ntQnUWm/ReuFUTnMbq97Vhgf8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C630413693
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bA6vKceb82r5DgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:33:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: tests: add test for zeroed QGROUP_LIMIT item from mkfs
Date: Wed, 11 Nov 2026 09:03:25 +1030
Message-ID: <a4ceff99941890db7bace4e1608ad2ac2acd83ad.1794349527.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794349527.git.wqu@suse.com>
References: <cover.1794349527.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: E4E9A1FAB4
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

Add a mkfs test that creates a filesystem with '-O quota' and verifies
all members of the QGROUP_LIMIT items are zero.

This covers the garbage fix in the previous commit.

Assisted-by: LLM (generate the test case)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../046-qgroup-limit-zeroed/test.sh           | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100755 tests/mkfs-tests/046-qgroup-limit-zeroed/test.sh

diff --git a/tests/mkfs-tests/046-qgroup-limit-zeroed/test.sh b/tests/mkfs-tests/046-qgroup-limit-zeroed/test.sh
new file mode 100755
index 000000000000..54b66927a842
--- /dev/null
+++ b/tests/mkfs-tests/046-qgroup-limit-zeroed/test.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+# Verify that mkfs -O quota zeroes all members of the QGROUP_LIMIT items.
+
+source "$TEST_TOP/common" || exit
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -O quota "$TEST_DEV"
+
+# A good limit item should looks like:
+#
+# item 2 key (0 QGROUP_LIMIT 0/5) itemoff 16027 itemsize 40
+#         flags 0
+#         max_referenced 0 max_exclusive 0
+#         rsv_referenced 0 rsv_exclusive 0
+output=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-tree -t quota "$TEST_DEV" | \
+	grep -A 3 "QGROUP_LIMIT")
+
+if [ -z "$output" ]; then
+	_fail "no QGROUP_LIMIT item found"
+fi
+
+for member in flags max_referenced max_exclusive rsv_referenced rsv_exclusive; do
+	echo "$output" | grep -q -w "$member 0" ||
+		_fail "QGROUP_LIMIT member $member is not zero"
+done
-- 
2.56.0

