Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770E023EA94
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 00:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780359289; cv=none; b=V5GoPeqAO/bbEmT40uQ1BbI/A/Tk686cNmd5umDB5lwyIEVfLbzgBkhsM6eGrp68DoFUd6K40L+ZwGogn6Sdafua7TuyOBu8iBdHIh767+D1ujshViLF6jeh9KnQvBNz42N3fUb3EPG9GOOraI1C+nTju12dx/Ubk+FLiBB/5pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780359289; c=relaxed/simple;
	bh=lOw6FtVNx68y6w1h7rR90ZE3uCaAAqxSx8c0sIj1G7g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CknMS9R8Y0p2zTXpgiNvGsez88Cq7IHE5AkUFhM5pk6BRau80Sx0r8rZH+OFNALst34t1bzlJJMGdoA9/2FA7v0WZZG3jCi64JgkGkWuu/zlpaW7Z76PkWqGibXSJHszt1rXf3gUTq86RYglCg0VazlsVYXIU+YvDGESfxLy4Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Tco5HUnt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Tco5HUnt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Tco5HUnt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Tco5HUnt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 834DD687DF;
	Tue,  2 Jun 2026 00:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780359281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LSJ0oybHj/dNHV9Gm53ILw2Q0ovTh/5m+kGPNZ+0eHs=;
	b=Tco5HUntgalAEbcSxMiE4VHbXGYn0+c0yeV4oNwggsVQszv6dTIyLzXFPuvAWE31A0jQuQ
	MUbJE37j29D+un1BGxCmOIgTaR/helRCqH2KfjmoYMHnkLpriOGO45t1MMeddaii14lJIq
	FPE6l0ogSqs/pzq8s10RL0A5L+hXFsM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780359281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LSJ0oybHj/dNHV9Gm53ILw2Q0ovTh/5m+kGPNZ+0eHs=;
	b=Tco5HUntgalAEbcSxMiE4VHbXGYn0+c0yeV4oNwggsVQszv6dTIyLzXFPuvAWE31A0jQuQ
	MUbJE37j29D+un1BGxCmOIgTaR/helRCqH2KfjmoYMHnkLpriOGO45t1MMeddaii14lJIq
	FPE6l0ogSqs/pzq8s10RL0A5L+hXFsM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F8D3779A7;
	Tue,  2 Jun 2026 00:14:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cLsQEHAgHmpgOwAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 02 Jun 2026 00:14:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] fstests: use MOUNT_OPTIONS to populate TEST_FS_MOUNT_OPTS if possible
Date: Tue,  2 Jun 2026 09:44:22 +0930
Message-ID: <20260602001422.24364-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

If the test config only specifies "MOUNT_OPTIONS", but not
"TEST_FS_MOUNT_OPTS", the mount for TEST_DIR can have inconsistent flag
after _test_cycle_mount().

Here is an very simple test case to show the problem:

 . ./common/preamble
 _begin_fstest auto
 _require_test

 mount | grep "$TEST_DIR"
 _test_cycle_mount
 mount | grep "$TEST_DIR"
 _exit 0

And with "MOUNT_OPTIONS" set to "-o nodatasum" (one of the btrfs mount
option that affects new inodes), but "TEST_FS_MOUNT_OPTS" not set, then
running the test, the output will be:

 QA output created by 348
 /dev/mapper/test-test on /mnt/test type btrfs (rw,relatime,nodatasum,discard=async,space_cache=v2,subvolid=5,subvol=/)
 /dev/mapper/test-test on /mnt/test type btrfs (rw,relatime,discard=async,space_cache=v2,subvolid=5,subvol=/)

This changed mount option will cause several test cases to fail on btrfs
with MOUNT_OPTIONS="-o nodatasum" set:

- generic/143
- generic/154
- generic/155
- generic/463

All above test case fails because the reflink source is from the initial
test mount, which has "nodatasum" mount option.
But later after _test_cycle_mount(), no more "nodatasum" flags, causing
reflink source and destination have different "nodatasum" flags.
And btrfs will reject such reflink, causing golden output mismatch.

One way to avoid such problem is to set TEST_FS_MOUNT_OPTS to the same
as MOUNT_OPTIONS, but I'm not sure if we really want different options
for test and scratch mounts.

So here as a compromise, set TEST_FS_MOUNT_OPTS to MOUNT_OPTIONS if
the former is not set but the latter is already set by the user.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:

- Still didn't get why the initial test mount respects MOUNT_OPTIONS
  If test mount only respects TEST_FS_MOUNT_OPTS, the first mount should
  not get the MOUNT_OPTIONS.

- Not sure if TEST_FS_MOUNT_OPTS is needed
  If not provided, the default config for TEST_FS_MOUNT_OPTS and
  MOUNT_OPTIONS are the same.

  The introduction of TEST_FS_MOUNT_OPTS is from commit 0e9141e49d4a
  ("common: add cifs support"), with extra handling for
  _test_mount_opts().

  But nowadays the special handling is moved to _common_mount_opts(),
  shared by both scratch and test mounts.
  Not sure if there is any fs that requires split options for test and
  scratch.

- Possible reduced coverage
  Ignoring MOUNT_OPTIONS and requiring extra TEST_FS_MOUNT_OPTS can cause
  reduced coverage, as one may expect MOUNT_OPTIONS to affect both test
  and scratch devices.
---
 common/config | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/common/config b/common/config
index d5299d5b..12e94088 100644
--- a/common/config
+++ b/common/config
@@ -419,8 +419,14 @@ _mount_opts()
 	export MOUNT_OPTIONS=$(_common_mount_opts)
 }
 
+# Must be called before _mount_opts().
 _test_mount_opts()
 {
+	# Use $MOUNT_OPTIONS if provided.
+	if [ ! -z "$MOUNT_OPTIONS" ]; then
+		export TEST_FS_MOUNT_OPTS="$MOUNT_OPTIONS"
+		return
+	fi
 	export TEST_FS_MOUNT_OPTS=$(_common_mount_opts)
 }
 
@@ -823,8 +829,8 @@ get_next_config() {
 
 	parse_config_section $1
 	if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
-		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
 		[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
+		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
 		[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 		[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 
@@ -915,8 +921,8 @@ if [ -z "$CONFIG_INCLUDED" ]; then
 	fi
 	FSTYP=${FSTYP:=xfs}
 	export FSTYP
-	[ -z "$MOUNT_OPTIONS" ] && _mount_opts
 	[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
+	[ -z "$MOUNT_OPTIONS" ] && _mount_opts
 	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 else
-- 
2.51.2

