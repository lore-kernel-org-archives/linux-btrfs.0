Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A1A3ACA48;
	Fri, 20 Mar 2026 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774011150; cv=none; b=EmvR/KD+yXoU+XKplozSWnyQ77v2PTbEYsjl4Y90H8GZ+hsRCSGZfHAkMwaxgz2kB90NwObmYJF0W7FLV2DMLDqn0I6ZSbv5uiWk4A5/tTQtV1pSNIMs3SHYcLnaiyb/if9stKJJnv+RTmDLWYrJBUbME5QLvigugQblUKDuNag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774011150; c=relaxed/simple;
	bh=/MtjJOPJ9vy4+8qDzT0OqCnLHtcw5P+UHbcQKexDnm4=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=Wj8PcqXNUkFSBvMSX1arDuOPzeVc2aRv5fOG+ZZICUXMdfLNnYZOtkIg3zKUBVLFLzk1YXYnBVs/M17RFN5NK+EApENwRQLkrEvZQxsK4kDnIaPz9zeMlM6THHBZJ31wuEvTCMxFeLIbF14Y7u8Q4+Mj2CCXWXLa1VUq13X7hzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=gYRIWb4w; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="gYRIWb4w"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id A282E3125F3;
	Fri, 20 Mar 2026 12:52:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774011145;
	bh=eucBlLAg2AqPxkjLC4ZMuRVrwDQfv4D9xOXt95z7Wpo=;
	h=From:To:Cc:Subject:Date;
	b=gYRIWb4wX9jQUzzkZBUFutwGVzyhhSpdlAhRZi9yRNaoC2Fs1HgPCbv1roR5fRomf
	 +J/ZuLUbxqgj4Rv1hdm4+iA0mEUBn+sS3JVBEXsYlMMQzXLHRuU7I8RYz/amfjjXpY
	 NuDjY5V9z1IRw/Ueq0LQO808iW/7KWH/IOQzAseU=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: add test for BTRFS_IOC_GET_CSUMS ioctl
Date: Fri, 20 Mar 2026 12:52:18 +0000
Message-ID: <20260320125223.90171-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

Test the new BTRFS_IOC_GET_CSUMS ioctl which retrieves file checksums
from the kernel's csum tree. The test covers:

1. Regular data extents returning HAS_CSUMS with checksum data
2. Holes returning SPARSE entries
3. Preallocated extents returning SPARSE entries
4. Buffer continuation (small buffer forcing multiple calls)
5. Checksum consistency (identical data produces identical csums)
6. Querying past file data returning SPARSE
7. Precomputed values

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 src/Makefile          |   2 +-
 src/btrfs_get_csums.c | 198 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/343       | 196 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/343.out   |  33 +++++++
 4 files changed, 428 insertions(+), 1 deletion(-)
 create mode 100644 src/btrfs_get_csums.c
 create mode 100755 tests/btrfs/343
 create mode 100644 tests/btrfs/343.out

diff --git a/src/Makefile b/src/Makefile
index d0a4106e..49649537 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint
+	rw_hint btrfs_get_csums
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/btrfs_get_csums.c b/src/btrfs_get_csums.c
new file mode 100644
index 00000000..0a75959a
--- /dev/null
+++ b/src/btrfs_get_csums.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Meta Platforms, Inc.  All Rights Reserved.
+ *
+ * Test helper for BTRFS_IOC_GET_CSUMS.
+ *
+ * Usage: btrfs_get_csums <file> <offset> <length> [bufsize]
+ *
+ * Prints one line per entry returned by the ioctl:
+ *   HAS_CSUMS <offset> <length> <hex csums>
+ *   SPARSE <offset> <length>
+ *   NO_CSUMS <offset> <length>
+ *
+ * On completion prints:
+ *   remaining <offset> <length>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <sys/ioctl.h>
+#include <linux/btrfs.h>
+
+#ifndef BTRFS_IOC_GET_CSUMS
+
+#define BTRFS_GET_CSUMS_HAS_CSUMS	0
+#define BTRFS_GET_CSUMS_SPARSE		1
+#define BTRFS_GET_CSUMS_NO_CSUMS	2
+
+struct btrfs_ioctl_get_csums_entry {
+	__u64 offset;
+	__u64 length;
+	__u32 type;
+	__u32 reserved;
+};
+
+struct btrfs_ioctl_get_csums_args {
+	__u64 offset;
+	__u64 length;
+	__u64 buf_size;
+	__u8 buf[];
+};
+
+#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
+				  struct btrfs_ioctl_get_csums_args)
+#endif
+
+/* Get csum_size from FS_INFO ioctl. */
+static int get_csum_size(int fd, uint16_t *csum_size_ret)
+{
+	struct btrfs_ioctl_fs_info_args fi;
+
+	memset(&fi, 0, sizeof(fi));
+	fi.flags = BTRFS_FS_INFO_FLAG_CSUM_INFO;
+
+	if (ioctl(fd, BTRFS_IOC_FS_INFO, &fi) < 0) {
+		perror("BTRFS_IOC_FS_INFO");
+		return -1;
+	}
+
+	*csum_size_ret = fi.csum_size;
+	return 0;
+}
+
+static const char *type_str(uint32_t type)
+{
+	switch (type) {
+	case BTRFS_GET_CSUMS_HAS_CSUMS:
+		return "HAS_CSUMS";
+	case BTRFS_GET_CSUMS_SPARSE:
+		return "SPARSE";
+	case BTRFS_GET_CSUMS_NO_CSUMS:
+		return "NO_CSUMS";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int fd;
+	uint64_t offset, length;
+	uint64_t buf_size = 64 * 1024;
+	uint16_t csum_size;
+	uint32_t sectorsize;
+	struct btrfs_ioctl_get_csums_args *args;
+	uint64_t pos;
+	int ret = 0;
+
+	if (argc < 4 || argc > 5) {
+		fprintf(stderr,
+			"Usage: %s <file> <offset> <length> [bufsize]\n",
+			argv[0]);
+		return 1;
+	}
+
+	offset = strtoull(argv[2], NULL, 0);
+	length = strtoull(argv[3], NULL, 0);
+	if (argc == 5)
+		buf_size = strtoull(argv[4], NULL, 0);
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror(argv[1]);
+		return 1;
+	}
+
+	if (get_csum_size(fd, &csum_size) < 0) {
+		ret = 1;
+		goto out;
+	}
+
+	/* Use FIGETBSZ to get the sector size. */
+	if (ioctl(fd, FIGETBSZ, &sectorsize) < 0) {
+		perror("FIGETBSZ");
+		ret = 1;
+		goto out;
+	}
+
+	args = calloc(1, sizeof(*args) + buf_size);
+	if (!args) {
+		perror("calloc");
+		ret = 1;
+		goto out;
+	}
+
+	args->offset = offset;
+	args->length = length;
+	args->buf_size = buf_size;
+
+	if (ioctl(fd, BTRFS_IOC_GET_CSUMS, args) < 0) {
+		fprintf(stderr, "BTRFS_IOC_GET_CSUMS: %s\n", strerror(errno));
+		ret = 1;
+		free(args);
+		goto out;
+	}
+
+	/* Walk the returned entries. */
+	pos = 0;
+
+	while (pos < args->buf_size) {
+		struct btrfs_ioctl_get_csums_entry *entry;
+
+		if (pos + sizeof(*entry) > args->buf_size)
+			break;
+
+		entry = (void *)(args->buf + pos);
+		pos += sizeof(*entry);
+
+		printf("%s %llu %llu",
+		       type_str(entry->type),
+		       (unsigned long long)entry->offset,
+		       (unsigned long long)entry->length);
+
+		if (entry->type == BTRFS_GET_CSUMS_HAS_CSUMS) {
+			uint64_t num_sectors;
+			uint64_t csums_len;
+
+			num_sectors = entry->length / sectorsize;
+			csums_len = num_sectors * csum_size;
+
+			if (pos + csums_len > args->buf_size) {
+				printf(" TRUNCATED\n");
+				break;
+			}
+
+			for (uint64_t s = 0; s < num_sectors; s++) {
+				uint64_t off = pos + s * csum_size;
+
+				printf(" ");
+				if (csum_size <= 8) {
+					for (int16_t b = csum_size - 1; b >= 0; b--)
+						printf("%02x", args->buf[off + b]);
+				} else {
+					for (uint16_t b = 0; b < csum_size; b++)
+						printf("%02x", args->buf[off + b]);
+				}
+			}
+
+			pos += csums_len;
+		}
+
+		printf("\n");
+	}
+
+	printf("remaining %llu %llu\n",
+	       (unsigned long long)args->offset,
+	       (unsigned long long)args->length);
+
+	free(args);
+out:
+	close(fd);
+	return ret;
+}
diff --git a/tests/btrfs/343 b/tests/btrfs/343
new file mode 100755
index 00000000..065dba64
--- /dev/null
+++ b/tests/btrfs/343
@@ -0,0 +1,196 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Meta Platforms, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 343
+#
+# Test the BTRFS_IOC_GET_CSUMS ioctl which retrieves file checksums.
+#
+# Verifies:
+# 1) Regular data extents return HAS_CSUMS with checksum data
+# 2) Holes return SPARSE
+# 3) Preallocated extents return SPARSE
+# 4) Continuation works when buffer is too small for all entries
+# 5) Identical data produces identical checksums
+# 6) Query range past file data returns SPARSE
+# 7) Checksum values match precomputed values for all algorithms (4k sectorsize)
+#
+. ./common/preamble
+_begin_fstest auto quick ioctl
+
+_require_scratch
+_require_test_program "btrfs_get_csums"
+_require_xfs_io_command "falloc"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+GET_CSUMS=$here/src/btrfs_get_csums
+blksz=$(_get_block_size $SCRATCH_MNT)
+
+# Check that the kernel supports the ioctl.
+$XFS_IO_PROG -f -c "pwrite -S 0x00 0 ${blksz}" $SCRATCH_MNT/probe >> $seqres.full
+sync
+$GET_CSUMS $SCRATCH_MNT/probe 0 $blksz > /dev/null 2>&1 || \
+	_notrun "kernel does not support BTRFS_IOC_GET_CSUMS"
+rm -f $SCRATCH_MNT/probe
+
+# Helper: print just the entry types from GET_CSUMS output (excluding remaining)
+print_types() {
+	grep -v "^remaining" | awk '{print $1}'
+}
+
+# Helper: check if ioctl completed (remaining length is 0)
+check_complete() {
+	local remaining_len
+	remaining_len=$(grep "^remaining" | awk '{print $3}')
+	[ "$remaining_len" -eq 0 ] && echo "complete" || echo "incomplete"
+}
+
+# Test 1: Regular file with one block of data
+echo "=== Test 1: regular data ==="
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 ${blksz}" $SCRATCH_MNT/file1 >> $seqres.full
+sync
+output=$($GET_CSUMS $SCRATCH_MNT/file1 0 $blksz)
+echo "$output" >> $seqres.full
+echo "$output" | print_types
+ncsums=$(echo "$output" | head -1 | awk '{print NF - 3}')
+[ "$ncsums" -gt 0 ] && echo "has csums" || echo "no csums"
+echo "$output" | check_complete
+
+# Test 2: File with a hole in the middle
+echo "=== Test 2: hole ==="
+$XFS_IO_PROG -f \
+	-c "pwrite -S 0xbb 0 ${blksz}" \
+	-c "pwrite -S 0xcc $((blksz * 4)) ${blksz}" \
+	$SCRATCH_MNT/file2 >> $seqres.full
+sync
+output=$($GET_CSUMS $SCRATCH_MNT/file2 0 $((blksz * 5)))
+echo "$output" >> $seqres.full
+echo "$output" | print_types
+echo "$output" | check_complete
+
+# Test 3: Preallocated extent
+echo "=== Test 3: prealloc ==="
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * 2))" $SCRATCH_MNT/file3 >> $seqres.full
+sync
+output=$($GET_CSUMS $SCRATCH_MNT/file3 0 $((blksz * 2)))
+echo "$output" >> $seqres.full
+echo "$output" | print_types
+echo "$output" | check_complete
+
+# Test 4: Continuation with small buffer
+# Create a file with a hole [0, 2*blksz) then data [2*blksz, 4*blksz).
+# Query with a 24-byte buffer (fits exactly one entry header, no csum data).
+# The SPARSE entry for the hole needs only 24 bytes, so it fits.
+# Then the following HAS_CSUMS entry won't fit, so the ioctl returns
+# with remaining offset/length pointing past the hole.
+echo "=== Test 4: continuation ==="
+$XFS_IO_PROG -f \
+	-c "pwrite -S 0xee $((blksz * 2)) $((blksz * 2))" \
+	$SCRATCH_MNT/file4 >> $seqres.full
+sync
+output=$($GET_CSUMS $SCRATCH_MNT/file4 0 $((blksz * 4)) 24)
+echo "$output" >> $seqres.full
+echo "$output" | print_types
+echo "$output" | check_complete
+
+# Now call again with a large buffer starting from the remaining offset
+remaining_off=$(echo "$output" | grep "^remaining" | awk '{print $2}')
+remaining_len=$(echo "$output" | grep "^remaining" | awk '{print $3}')
+output2=$($GET_CSUMS $SCRATCH_MNT/file4 $remaining_off $remaining_len)
+echo "$output2" >> $seqres.full
+echo "$output2" | print_types
+echo "$output2" | check_complete
+
+# Test 5: Identical data blocks produce identical checksums
+echo "=== Test 5: csum consistency ==="
+$XFS_IO_PROG -f -c "pwrite -S 0xff 0 ${blksz}" $SCRATCH_MNT/file5a >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0xff 0 ${blksz}" $SCRATCH_MNT/file5b >> $seqres.full
+sync
+csum_a=$($GET_CSUMS $SCRATCH_MNT/file5a 0 $blksz | head -1 | \
+	awk '{for(i=4;i<=NF;i++) printf $i}')
+csum_b=$($GET_CSUMS $SCRATCH_MNT/file5b 0 $blksz | head -1 | \
+	awk '{for(i=4;i<=NF;i++) printf $i}')
+[ "$csum_a" = "$csum_b" ] && echo "csums match" || echo "csums differ"
+
+# Test 6: Query range past file data returns SPARSE
+echo "=== Test 6: past data ==="
+$XFS_IO_PROG -f -c "pwrite -S 0x11 0 ${blksz}" $SCRATCH_MNT/file6 >> $seqres.full
+sync
+output=$($GET_CSUMS $SCRATCH_MNT/file6 $((blksz * 10)) $blksz)
+echo "$output" >> $seqres.full
+echo "$output" | print_types
+echo "$output" | check_complete
+
+# Test 7: Verify checksum values against precomputed values for all algorithms.
+# Uses explicit -s 4096 as the expected values are precomputed for 4096-byte
+# sectors. Write three sectors: all 0x00, all 0xff, all 0xaa.
+echo "=== Test 7: precomputed csums ==="
+_scratch_unmount
+for csum_algo in crc32c xxhash sha256 blake2; do
+	echo "--- $csum_algo ---"
+
+	_scratch_mkfs -s 4096 --csum $csum_algo >> $seqres.full 2>&1
+	_scratch_mount
+
+	case "$csum_algo" in
+	crc32c)
+		expect_00="98f94189"
+		expect_ff="25c1fe13"
+		expect_aa="4ed66b65"
+		;;
+	xxhash)
+		expect_00="ac869b6f32d8bbdb"
+		expect_ff="10af2cb94282321f"
+		expect_aa="e35ac2d66625ceaa"
+		;;
+	sha256)
+		expect_00="ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b48892ca7"
+		expect_ff="f47a8ec3e9aff2318d896942282ad4fe37d6391c82914f54a5da8a37de1300c6"
+		expect_aa="c622005493c4cb75f3e08eda4cc0bfe172e2c5eeca661ec4908c5490fc3d6994"
+		;;
+	blake2)
+		expect_00="686ede9288c391e7e05026e56f2f91bfd879987a040ea98445dabc76f55b8e5f"
+		expect_ff="1e23d2944a4523734ef9c8b536eed668fa8a99b272bfc10988864e1ef135197d"
+		expect_aa="8337334ce71745681a24e9aa409fdf85fe4081242c39815ccf266df6d33355a2"
+		;;
+	esac
+
+	$XFS_IO_PROG -f \
+		-c "pwrite -S 0x00 0 4096" \
+		-c "pwrite -S 0xff 4096 4096" \
+		-c "pwrite -S 0xaa 8192 4096" \
+		$SCRATCH_MNT/file7 >> $seqres.full
+	sync
+
+	output=$($GET_CSUMS $SCRATCH_MNT/file7 0 12288)
+	echo "$output" >> $seqres.full
+
+	got_csums=$(echo "$output" | grep "^HAS_CSUMS" | \
+		awk '{for(i=4;i<=NF;i++) printf $i " "; print ""}')
+	got_00=$(echo $got_csums | awk '{print $1}')
+	got_ff=$(echo $got_csums | awk '{print $2}')
+	got_aa=$(echo $got_csums | awk '{print $3}')
+
+	pass=true
+	if [ "$got_00" != "$expect_00" ]; then
+		echo "FAIL: 0x00 sector csum $got_00 != $expect_00"
+		pass=false
+	fi
+	if [ "$got_ff" != "$expect_ff" ]; then
+		echo "FAIL: 0xff sector csum $got_ff != $expect_ff"
+		pass=false
+	fi
+	if [ "$got_aa" != "$expect_aa" ]; then
+		echo "FAIL: 0xaa sector csum $got_aa != $expect_aa"
+		pass=false
+	fi
+	$pass && echo "csums verified"
+
+	_scratch_unmount
+done
+
+echo "=== done ==="
+status=0
+exit
diff --git a/tests/btrfs/343.out b/tests/btrfs/343.out
new file mode 100644
index 00000000..85582c24
--- /dev/null
+++ b/tests/btrfs/343.out
@@ -0,0 +1,33 @@
+QA output created by 343
+=== Test 1: regular data ===
+HAS_CSUMS
+has csums
+complete
+=== Test 2: hole ===
+HAS_CSUMS
+SPARSE
+HAS_CSUMS
+complete
+=== Test 3: prealloc ===
+SPARSE
+complete
+=== Test 4: continuation ===
+SPARSE
+incomplete
+HAS_CSUMS
+complete
+=== Test 5: csum consistency ===
+csums match
+=== Test 6: past data ===
+SPARSE
+complete
+=== Test 7: precomputed csums ===
+--- crc32c ---
+csums verified
+--- xxhash ---
+csums verified
+--- sha256 ---
+csums verified
+--- blake2 ---
+csums verified
+=== done ===
-- 
2.52.0

