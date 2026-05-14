Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EA23DBD5A
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 09:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778749487; cv=none; b=Bfj+af84Pmvi+KYui/7W6A3dHJJ8GfcPqgRnmtZ19mdmMqUcwW5Ila3oNl5Y1+2RGOVtcLLPYMeMYIMt/ISpCoTHpBOKLQLflZxVkEQwoaFf5fcCgAymxJOAGhzzqOmvOkU46m7VsZV1NDGvfNH7PuWrjY43pa9CvaH1NbcFGMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778749487; c=relaxed/simple;
	bh=mWow36PIz1m3IGA9uM5DolkNDfJ8/C0baI89bSk6Qyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KUL4MCW4xNatnkoSTSx2XTfVk82/wX2TJ2zsmtJO7bj5W0lNVLaiysQM4fnfdB/Mi2ajgEJVwR2wyFxn+7KLnWQT720CI0RCxlblqgPGfWYuQfvjdS/hjxWcbNUIep/6OL6MP938k0bV7btAlomdO2Dgkr+SL/r2glHTi94lKDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fjgBurV8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OF+CED2V; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fjgBurV8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OF+CED2V"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D44635E24C;
	Thu, 14 May 2026 09:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778749484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BO8XCB6SkMsptmnY1DdKlwBubsHBKjcC12oXp/O9KEY=;
	b=fjgBurV8AhuvWKtNZtOyYkxi7S7JarVPMPQB96hgZbinyQNvrOa7YllOwTYIlS56OXnY1X
	N6XkQJWFewpZGYoI8esCW6FQYFjBzAHvYhqcMAN4lg6Lygwewpq5rwiOUvX6NLFv0Te+rn
	XCCqb7BXXZ2A6338cwqN4kOHdWY8H5M=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OF+CED2V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778749483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BO8XCB6SkMsptmnY1DdKlwBubsHBKjcC12oXp/O9KEY=;
	b=OF+CED2VVi0xUWSs+vrlISjtBr9dctH5mhQkuckMAlpD2hraOLoBbXVX58fSZDoqwLglEK
	xKjkN+SJ0otpFquvp/qqz+bqX89ExIkl+CJZ8SxtrhibWB8G4LatAfaiFTgoF/zFneCTK/
	PCLEIC3GDdw9UNvJBVGxq8n52BqzeQY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FB18593A9;
	Thu, 14 May 2026 09:04:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Lpm5GCqQBWqWbQAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 14 May 2026 09:04:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Long An <lan@suse.com>
Subject: [PATCH v2] fstests: btrfs/340: add support for older kernels/progs
Date: Thu, 14 May 2026 18:34:39 +0930
Message-ID: <ed76cf7d6a0ad2a98e5730015dd4fc6514fc2343.1778749477.git.wqu@suse.com>
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
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D44635E24C
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
Changelog:
v2:
- Fix the mismatch between the commit message and the test case change
  Forgot to amend the changes before sending.

- Fix a bug in the stderr redirect
  The stdout redirect should be put last.
---
 tests/btrfs/340 | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/btrfs/340 b/tests/btrfs/340
index 872f790cb975..eff76d0b633c 100755
--- a/tests/btrfs/340
+++ b/tests/btrfs/340
@@ -16,6 +16,7 @@ _fixed_by_kernel_commit 68d4b3fa18d7 \
 # For the automatic fsck at unmount.
 _require_scratch
 _require_btrfs_qgroup_report
+_require_btrfs_command qgroup show --sync
 
 # This will imply mkfs and enable regular qgroup.
 _require_scratch_qgroup
@@ -39,7 +40,12 @@ _btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
 # without marking qgroup inconsistent.
 _btrfs subv snap -i 1/1 $SCRATCH_MNT/subv1 $SCRATCH_MNT/snap1
 echo "After quick inherit:" >> $seqres.full
-_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
+# Redirect all output to seqres.full including stderr.
+# For older kernels without quick inherit support, it will mark
+# qgroup inconsistent, which will output a warning about the inconsistent
+# numbers. Here we rely on the final btrfs check to catch any qgroup number
+# errors, thus no need to bother that possible warning.
+_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full 2>&1
 
 echo "Silence is golden"
 _exit 0
-- 
2.54.0

