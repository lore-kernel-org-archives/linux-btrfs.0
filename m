Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF253385D9E
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779444437; cv=none; b=MlnupHnkAXnxhnaGCS90F6LcZnjJddna7CKVBHHopno716wIwvLyYJKeehd3CY2hwwrbxL+bot04eUhm3fpNVMRGTAOrSAeL0C9e7SVdGmx5j2ip+InifYGwiNFJyhlIW71CgxN6Ii4swMwqaQO0adyT6XPXAbuJ5vb66cPh06A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779444437; c=relaxed/simple;
	bh=z69D1H39DDRFbD5oL73oqMlmdpIGXBnsZuyH+j/bRMs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFsHSDJMVXgvue6ZjPcOgIdtI1sXXF3sR3yJMhPqQkoiSlbzfSJPKz620Cf2lzpdsiZpkz+9oTL8gnHZLwplFy4Oixyuw1q2WWlp7FwS1+2DVD/gt42J+6QVuCGcxxdS0xNipqtewhQ4qMrfROHI0aHatSRyMHIybprCJ9cQg4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GnifCPgh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GnifCPgh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GnifCPgh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GnifCPgh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4538F6B0E6
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779444434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5lFB7S8j9OnjnDM16DfH6u1tnU9XWmD2tF6kBu8mTE=;
	b=GnifCPghG0qn6BKCjS6qVDrAArH36HtXhuzdCV0VTMuGjshWQm/NdxXTTVX/ksRIXXB9f7
	E35wURLjz40z3jEPJTMotMm15bsUDuUxndC1wuN1jeoZSwrxS4pLdbvdZNLTEMC/P4P8Ix
	EDRLPEY1wV7vAZm82olGh1vFizZRHjY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779444434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5lFB7S8j9OnjnDM16DfH6u1tnU9XWmD2tF6kBu8mTE=;
	b=GnifCPghG0qn6BKCjS6qVDrAArH36HtXhuzdCV0VTMuGjshWQm/NdxXTTVX/ksRIXXB9f7
	E35wURLjz40z3jEPJTMotMm15bsUDuUxndC1wuN1jeoZSwrxS4pLdbvdZNLTEMC/P4P8Ix
	EDRLPEY1wV7vAZm82olGh1vFizZRHjY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AEB8593A8
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6M4WD9EqEGpnbAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: fsck-tests: add a new test case for the raid56 read fix
Date: Fri, 22 May 2026 19:36:53 +0930
Message-ID: <04de2cfac21f7456f09dc5dc236d9772cf2e779e.1779442619.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779442619.git.wqu@suse.com>
References: <cover.1779442619.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

The new test case is a regression test, which does:

- Create a btrfs with RAID5 data
- Fsstress it with 256 write operations
- Unmount
- Make sure "btrfs check --check-data-csum" reports no error

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile                                 |  2 +-
 tests/fsck-tests/074-raid56-read/test.sh | 27 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)
 create mode 100755 tests/fsck-tests/074-raid56-read/test.sh

diff --git a/Makefile b/Makefile
index 4f471ff4a439..934d6dfb9c37 100644
--- a/Makefile
+++ b/Makefile
@@ -536,7 +536,7 @@ test-convert: btrfs btrfs-convert
 
 test-check: test-fsck
 test-check-lowmem: test-fsck
-test-fsck: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune
+test-fsck: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune fsstress
 ifneq ($(MAKECMDGOALS),test-check-lowmem)
 	@echo "  TEST     fsck-tests.sh"
 	$(Q)bash tests/fsck-tests.sh
diff --git a/tests/fsck-tests/074-raid56-read/test.sh b/tests/fsck-tests/074-raid56-read/test.sh
new file mode 100755
index 000000000000..6caae9837c35
--- /dev/null
+++ b/tests/fsck-tests/074-raid56-read/test.sh
@@ -0,0 +1,27 @@
+#!/bin/bash
+#
+# Make sure "btrfs check" can properly handle RAID5 data reconstruction.
+
+source "$TEST_TOP/common" || exit
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+check_prereq fsstress
+check_global_prereq fallocate
+
+setup_root_helper
+setup_loopdevs 3
+prepare_loopdevs
+dev1=${loopdevs[1]}
+TEST_DEV=$dev1
+fsstress_prog="$INTERNAL_BIN/fsstress"
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -m raid1 -d raid5 "${loopdevs[@]}"
+run_check_mount_test_dev
+run_check $SUDO_HELPER $fsstress_prog -w -n 256 -d "$TEST_MNT"
+run_check_umount_test_dev
+
+# Check data csum should not report false alerts
+run_check $SUDO_HELPER "$TOP/btrfs" check --check-data-csum "$dev1"
+
+cleanup_loopdevs
-- 
2.54.0

