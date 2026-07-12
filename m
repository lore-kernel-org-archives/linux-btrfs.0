Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85E336B07E
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783850254; cv=none; b=WHtI9Yx+vIvDMlvSh9K3BVWznPU7SZd1TUTgmYrj663fGVkDvZ+SHY1xWafjETjiCX2BU6k/1rVMynNOQDPhJngu6OUAjFjsBkQxGSqIW0uXy6a6N571BKtmCCm8Rq+E6wPGrk56g4deKG/QdcHztP1nhVGWUEfAG2U66/elXIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783850254; c=relaxed/simple;
	bh=aU2eoxhPR3Ev/cevWaV9mqzTovHjauipDfKVhYCVsgI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Tg8oy6bPhW7jOJHlAnrZohHZ8f5zZqtWpa3if14vl5Kf2zmgiKCsYDGQkPxQvFPiFv4C8qF8KLoKCbTuyo8tuhsKIOShi6P84cnPSj+lMlbw4ryAlraZVV/HFT1QhlMUC31xLstwTbsUTwF+M1YSUssVjHCMg1LRP6ldqPYyQPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nBmNKl+/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nBmNKl+/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nBmNKl+/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nBmNKl+/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA4A077245
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783850250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pM0bLkkzM+k2UWVaPtkJtyCQH5zWywBGZWPLZ5PpVfI=;
	b=nBmNKl+/jH9wmthdFU/CWFZKigQQv5eN4P9SEFiHbGsX/Own+nvvcjaGucNxz9HwmhAo+4
	1Q3P5N4vo4P+P1tpLp5dUMULktuKutGcw9mXOw4y4QuYmLGR2li5R4wlJMLGgAXRSbVI0b
	/+pE2gRnGROkJ3HflEZVycwKn4B0vbc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783850250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pM0bLkkzM+k2UWVaPtkJtyCQH5zWywBGZWPLZ5PpVfI=;
	b=nBmNKl+/jH9wmthdFU/CWFZKigQQv5eN4P9SEFiHbGsX/Own+nvvcjaGucNxz9HwmhAo+4
	1Q3P5N4vo4P+P1tpLp5dUMULktuKutGcw9mXOw4y4QuYmLGR2li5R4wlJMLGgAXRSbVI0b
	/+pE2gRnGROkJ3HflEZVycwKn4B0vbc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06375779B5
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:57:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jA9uLQllU2qfPQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 09:57:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs: add a new regression test for RAID56 RWM
Date: Sun, 12 Jul 2026 19:27:08 +0930
Message-ID: <20260712095708.182997-1-wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	TO_DN_NONE(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

There is a regression in btrfs RAID56 RMW, that data checksum
verification can be skipped incorrectly, causing RMW to use the already
corrupted data to generate parity, killing the last chance to recover
the data.

The test case create a special raid5 full stripe layout initially:

            0                      32K                               64K
  Data 1    |    file1, no csum    |   file 2, has csum               |
  Data 2    |                  Unused                                 |
  Parity    |                Parity                                   |

Then corrupt the on-disk data of file 2:

            0                      32K                               64K
  Data 1    |    file1, no csum    |   file 2, corrupted, has csum    |
  Data 2    |                  Unused                                 |
  Parity    |                Parity                                   |

At this stage, if we read out file2, we can still rebuild the data using
Data 2 + Parity.

Instead do a new write to populate the unused data stripe:

            0                      32K                               64K
  Data 1    |    file1, no csum    |   file 2, corrupted, has csum    |
  Data 2    |    file3, new write                                     |
  Parity    |                Parity                                   |

During RMW we should only skip data checksum for range [0, 32K) of data
stripe 1, and still do checksum verification for range [32K, 64K) of
data stripe 1.

But a regression cause the kernel to skip data checksum verification for
the whole range of [0, 64K).
So RMW will use the corrupted data of file 2 to generate parity, and
cause file2 to be permanently corrupted.

For patched kernel or before the regression, RMW will verify the
checksum of range [32K, 64K) of data 1, and rebuild using parity and
data 2 before the new write.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/352     | 103 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/352.out |   4 ++
 2 files changed, 107 insertions(+)
 create mode 100755 tests/btrfs/352
 create mode 100644 tests/btrfs/352.out

diff --git a/tests/btrfs/352 b/tests/btrfs/352
new file mode 100755
index 00000000..435a3ec7
--- /dev/null
+++ b/tests/btrfs/352
@@ -0,0 +1,103 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 352
+#
+# Make sure RAID5 RMW detects corruption correctly.
+#
+. ./common/preamble
+_begin_fstest auto quick volume raid scrub
+
+# For _btrfs_get_first_logical()
+. ./common/filter
+
+# No compression/nodatasum/nodatacow, as we require every
+# data write to be as is on-disk, and we need to control
+# datacsum on a per-file basis, so no global nodatacow/nodatasum
+# mount options allowed
+_require_btrfs_no_compress
+_require_btrfs_no_nodatacow
+_require_btrfs_no_nodatasum
+_require_chattr C
+
+if ! _check_btrfs_raid_type raid5; then
+	_notrun "requires either raid5 or raid6 support"
+fi
+
+# The file layout are all based on 4K block size.
+_require_btrfs_support_sectorsize 4096
+_require_scratch_dev_pool 3
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: raid56: fix an incorrect csum skip during rmw"
+
+_require_non_zoned_device "${SCRATCH_DEV}"
+_require_scratch_dev_pool 3
+_scratch_dev_pool_get 3
+_scratch_pool_mkfs -d raid5 -m raid1  >> $seqres.full 2>&1
+
+# Use v2 cache, as v1 cache will use data space and screw up
+# the data layout inside a full stripe.
+_scratch_mount -o space_cache=v2,datasum
+
+# Balance data so that new data writes can always start at the beginning
+# of the data chunk.
+# The mkfs may put the first data stripe at a location that covers the
+# 2nd super block, that will cause the first data to be at the middle of the chunk
+# making it very hard to force the file layout.
+$BTRFS_UTIL_PROG balance start -d $SCRATCH_MNT >> $seqres.full
+
+chunk_logical=$($BTRFS_UTIL_PROG inspect-internal dump-tree -t chunk $SCRATCH_DEV |\
+	grep -B1 RAID5 | grep -o "[[:digit:]]\+)" | sed 's/)//')
+if [ -z "$chunk_logical" ]; then
+	_scratch_unmount
+	_scratch_dev_pool_put
+	_fail "failed to grab the chunk logical bytenr"
+fi
+
+touch $SCRATCH_MNT/file1
+chattr +C $SCRATCH_MNT/file1
+$XFS_IO_PROG -c "pwrite -S 0xcd 0 32K" -c sync \
+	$SCRATCH_MNT/file1 >> $seqres.full
+logical=$(_btrfs_get_first_logical $SCRATCH_MNT/file1)
+
+if [ "$logical" -ne "$chunk_logical" ]; then
+	_scratch_unmount
+	_scratch_dev_pool_put
+	_notrun "unable to ensure the required file layout"
+fi
+
+# The next 32K data will have data checksum
+$XFS_IO_PROG -f -c "pwrite -S 0xdc 0 32K" -c sync \
+	$SCRATCH_MNT/file2 >> $seqres.full
+
+logical=$(_btrfs_get_first_logical $SCRATCH_MNT/file2)
+
+# Corrupt the data stripe which has checksum
+physical_d=$(_btrfs_get_physical ${logical} 1)
+devpath_d=$(_btrfs_get_device_path ${logical} 1)
+
+_scratch_unmount
+
+echo "Corrupt data stripe at devpath $devpath_d physical $physical_d" \
+	>> $seqres.full
+$XFS_IO_PROG -c "pwrite -S 0x00 $physical_d 64K" -c sync $devpath_d \
+	>> $seqres.full
+
+$BTRFS_UTIL_PROG check --check-data-csum $SCRATCH_DEV >> $seqres.full 2>&1
+_scratch_mount -o space_cache=v2,datasum
+
+# Do a write that updates part of the stripe. This requires RMW, and
+# with unpatched kernel, the csum verification will be skipped and generate
+# parity using the corrupted data.
+$XFS_IO_PROG -f -c "pwrite -S 0x42 0 64K" $SCRATCH_MNT/file3 -c sync \
+	>> $seqres.full
+
+# Now check if we can still read out the data at stripe offset 32K
+_hexdump $SCRATCH_MNT/file2
+
+_scratch_unmount
+_scratch_dev_pool_put
+# success, all done
+_exit 0
diff --git a/tests/btrfs/352.out b/tests/btrfs/352.out
new file mode 100644
index 00000000..972993b6
--- /dev/null
+++ b/tests/btrfs/352.out
@@ -0,0 +1,4 @@
+QA output created by 352
+000000 dc dc dc dc dc dc dc dc dc dc dc dc dc dc dc dc  >................<
+*
+008000
-- 
2.51.2

