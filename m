Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8853E3BE156
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 22:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784155068; cv=none; b=S8ZIdwqeCZn73QU2ApITqQy6xO+pmD6abhRrfIBjMs9BWfOolq0mzELstOGCTynaY+z8tKgP8H6WjoavUasrrarjg9V5+Qx44QLX39xzPUDgl/8KfJ3oX7pnFc3MZ81QOXBjZguVNRlkx8KpKepMJoQcriWEDpbvanl4yQ2z8ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784155068; c=relaxed/simple;
	bh=QHM/lOWkuX8GJgsKVUcNlUvtp249kxd4fdYE/V98ei0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cmOAt2A0gLJnMP3cA5bQCXccW9MW8N4oEiWihzGd+ry/ivBB05dlcchP2Qjt6ou7XoA1jEVX18APodMHulyy1/+JLGfTgSnM+h15uVbwlZy8YkPkS+E2XIMHbkLUPtJ/Yj7SqAgLE26cqgGsUksa/iOtx89loQ/PmQPPb1T00EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XbOmJU79; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XbOmJU79; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XbOmJU79";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XbOmJU79"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5404F3E32;
	Wed, 15 Jul 2026 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784155064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Wsow2x/PFYLyOT7adFwiW56NTFy4e0sLDcL4EkZ8Peg=;
	b=XbOmJU79etT3HTDhZlGs+S46/WOCP8+HssY73Ztf6FvljmPXm+dS9FccnPib0TX4BegkMB
	t8MmoEF+AfTjQUqNtcMbGQXNjqBAzGWT7IMoVnskGURfXFfaMPdgJ1UfFhAB4DRjw2PRjY
	yXE+JI6lozDdyqsCoF+sCImz+y0C0vU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=XbOmJU79
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784155064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Wsow2x/PFYLyOT7adFwiW56NTFy4e0sLDcL4EkZ8Peg=;
	b=XbOmJU79etT3HTDhZlGs+S46/WOCP8+HssY73Ztf6FvljmPXm+dS9FccnPib0TX4BegkMB
	t8MmoEF+AfTjQUqNtcMbGQXNjqBAzGWT7IMoVnskGURfXFfaMPdgJ1UfFhAB4DRjw2PRjY
	yXE+JI6lozDdyqsCoF+sCImz+y0C0vU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97699779AD;
	Wed, 15 Jul 2026 22:37:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qmxzFrYLWGqQJgAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 15 Jul 2026 22:37:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: bfoster@redhat.com,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic: add a basic cachestat test case
Date: Thu, 16 Jul 2026 08:07:16 +0930
Message-ID: <20260715223716.5965-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5404F3E32
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,suse.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

The test case is inspired by LTP, where there is a regression on 64K
page size systems with btrfs, that after a fsync, cachestat() still
report dirty pages.

The test case itself is pretty simple, fill the file with a buffered write that is
1/2/4/8/16 page sized, call cachestat() to make sure the cached/dirtied
number match the page number.

Then do a fsync(), and make sure the dirty page number reduced to 0
meanwhile cached is still the same.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1270397
Reviewed-by: Anand Jain <asj@kernel.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v3:
- Use golden output to greatly simplify the test case

- Do not mkfs for each size, just remove the original file

v2:
- Reject "sync" and "dax" mount options
  Those mount options write back data synchronously, will screw up the
  buffered write dirtied page reporting.

- Use AWK_PROG everywhere.

- Remove the unnecessary redirection for fsync
---
 tests/generic/798     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/generic/798.out | 16 ++++++++++++++++
 2 files changed, 55 insertions(+)
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out

diff --git a/tests/generic/798 b/tests/generic/798
new file mode 100755
index 00000000..0fe37646
--- /dev/null
+++ b/tests/generic/798
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 798
+#
+# Basic tests for cachestat()
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+_require_xfs_io_command "cachestat"
+_require_scratch
+# Any mount option that writes data back synchronously should be rejected.
+# Or it will screw up the dirtied page reporting for buffered writes.
+_exclude_scratch_mount_option "dax"
+_exclude_scratch_mount_option "sync"
+
+pagesize=$(_get_page_size)
+
+_scratch_mkfs > /dev/null
+_scratch_mount
+
+for num_page in 1 2 4 8 16; do
+	size=$(($pagesize * $num_page))
+
+	echo "=== Test with $num_page pages ==="
+
+	rm -f $SCRATCH_MNT/foobar
+	$XFS_IO_PROG -f -c "pwrite -b $pagesize 0 $size" $SCRATCH_MNT/foobar > /dev/null
+	# Basic cached number reporting
+	$XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar
+
+	# Test dirty page number reporting after a fsync.
+	$XFS_IO_PROG -c "fsync" -c "cachestat 0 $size" $SCRATCH_MNT/foobar
+done
+
+_scratch_unmount
+_exit 0
diff --git a/tests/generic/798.out b/tests/generic/798.out
new file mode 100644
index 00000000..ca6ead3c
--- /dev/null
+++ b/tests/generic/798.out
@@ -0,0 +1,16 @@
+QA output created by 798
+=== Test with 1 pages ===
+Cached: 1, Dirty: 1, Writeback: 0, Evicted: 0, Recently Evicted: 0
+Cached: 1, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
+=== Test with 2 pages ===
+Cached: 2, Dirty: 2, Writeback: 0, Evicted: 0, Recently Evicted: 0
+Cached: 2, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
+=== Test with 4 pages ===
+Cached: 4, Dirty: 4, Writeback: 0, Evicted: 0, Recently Evicted: 0
+Cached: 4, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
+=== Test with 8 pages ===
+Cached: 8, Dirty: 8, Writeback: 0, Evicted: 0, Recently Evicted: 0
+Cached: 8, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
+=== Test with 16 pages ===
+Cached: 16, Dirty: 16, Writeback: 0, Evicted: 0, Recently Evicted: 0
+Cached: 16, Dirty: 0, Writeback: 0, Evicted: 0, Recently Evicted: 0
-- 
2.51.2

