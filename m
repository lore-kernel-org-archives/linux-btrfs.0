Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505F639E9A0
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 05:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778738110; cv=none; b=Gmrp5SI0TcEj+7I21hunOhgMzSB5WVhaNmy7Idy9SkXpDdcdVtwsqDd3QCsQo1VYzCbNkJ7tZyq7TKUtj1oTSekvSneYxDcixVMbrMCvpc78RQEXqJ123G9GdQ+l3QwzB8BRB3ns6r6VHyDnh64sHlwJfJ4E09/z/uFaNbwq3CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778738110; c=relaxed/simple;
	bh=+PCxf4kcFOyPT5SEAF3avdxrl5uI8e2JgVZGFo6Ra+A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R4AdibNJUzJrWB27pcP6CmTw14eaR7tsCGGbHCuH/zco54gqftQsEPO6Tv0YHIsxCXo3bdcsGuMG/aZ9vmY1KgI4f3B/2UDKeMHnlGk3G2po4YjhghjhiM9mt7uftQHRaKQJ+C08TxWCznpfOk9x0q0ARwPnlMko5eyMppaM93U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jYS4KEBe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jYS4KEBe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jYS4KEBe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jYS4KEBe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 58D885DCE9;
	Thu, 14 May 2026 05:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778738107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QI0l2ZQIa2Ts0KnUMy5nKAiqw0A3KXCyvjVgLPBBdw4=;
	b=jYS4KEBeH4CKatqWe7QLRa3dkMKc3IdjmEBaeUQOvCwe4JgmLwwoyJrZ8lnDBF7BpZkZzw
	rScAKLWzXi5Q52wLHrdKbcdRAQzxxuNTCDjj1gmVEHIKi8UC54jvalXXmNrumySqEywpoY
	GFiWk63IxZ7oiyNBNXpZiInjFAgSRVw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jYS4KEBe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778738107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QI0l2ZQIa2Ts0KnUMy5nKAiqw0A3KXCyvjVgLPBBdw4=;
	b=jYS4KEBeH4CKatqWe7QLRa3dkMKc3IdjmEBaeUQOvCwe4JgmLwwoyJrZ8lnDBF7BpZkZzw
	rScAKLWzXi5Q52wLHrdKbcdRAQzxxuNTCDjj1gmVEHIKi8UC54jvalXXmNrumySqEywpoY
	GFiWk63IxZ7oiyNBNXpZiInjFAgSRVw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2591A593A9;
	Thu, 14 May 2026 05:55:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wpaQNrljBWrRFQAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 14 May 2026 05:55:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Long An <lan@suse.com>
Subject: [PATCH] fstests: btrfs/340: add support for older kernels/progs
Date: Thu, 14 May 2026 15:25:02 +0930
Message-ID: <4fa82130c72f55560967d0deaafb68a69a2e7ccb.1778738100.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 58D885DCE9
X-Spam-Level: 

The test case will fail on older distros like SLE12-SP5, there are two
problems on the test case itself:

- Requires "--sync" option from "btrfs qgroup show" subcommand
  That option was introduecd in v4.9.1, thus there are still some older
  distros using that very old version.

- Not all kernels support quick inherit
  The kernel commit introducing the quick inherit is 6.9, thus some
  supported LTS kernels do not have that commit.

  In that case qgroup will just be marked inconsistent, this will cause
  the later "btrfs qgroup show" command to output a warning due to the
  inconsistent flag.

Fix both problems by:

- Require "--sync" option from "btrfs qgroup show" subcommand
  So older distros will just skip the test.

- Redirect all output from "btrfs qgroup show" to $seqres.full
  So older kernels can still pass the test case by marking qgroup
  inconsitent.

Reported-by: Long An <lan@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/340 | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tests/btrfs/340 b/tests/btrfs/340
index 872f790cb975..fc0b8d48adaa 100755
--- a/tests/btrfs/340
+++ b/tests/btrfs/340
@@ -39,7 +39,14 @@ _btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
 # without marking qgroup inconsistent.
 _btrfs subv snap -i 1/1 $SCRATCH_MNT/subv1 $SCRATCH_MNT/snap1
 echo "After quick inherit:" >> $seqres.full
-_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
+# Sync the fs so that the qgroup numbers are properly updated.
+_btrfs filesystem sync $SCRATCH_MNT
+
+# Redirect all output to seqres.full including stderr.
+# For older kernels without quick inherit support, it will mark
+# qgroup inconsistent, which can pollute the golden output.
+# Here we rely on the final btrfs check to catch any qgroup number errors.
+_btrfs qgroup show -p $SCRATCH_MNT >> $seqres.full
 
 echo "Silence is golden"
 _exit 0
-- 
2.54.0

