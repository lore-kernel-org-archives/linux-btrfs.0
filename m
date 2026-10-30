Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793349249;
	b=o4pZEZ8jsDsMg7/3Bh0eOjsBMYKGYQojaqMwbi+gD2bA3oEBof6ngI/H2a0mHjQXTWp4
	 MKheIqEZiV0zQQwaI1hFOH+99c/ys84bQU3dIeswIK58G+fQdcoLHkR0xmnsgCuXmYtmV
	 Ec1hYDDr+wdpeAMRHtrYUF6UOVki6Vtc7aPEAsSpSBOfBh4Lw87vay3pX4EcmRsgwUvLI
	 1baYbLvGehqSgWFIUX0V7hzquaZDeDpq+Nn+BiM0jpDLLbgxC66dDGBvNvArpyH6UKqnp
	 G33HRuBoBb9IGegDErzJumjRDd736UIPY0rbqQ6bG5qA+PCaK8CyaMN0QuSgLT565Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793349249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZdFlKAdQE4/ZTqkRXdV4kEJA5/zwRfRs5jP160wiz4Q=;
	b=fZWjsokNNSpjmY/+xuPwKIJyOFJyBLiT7kH8zau8VMePDZojE0gHCb2k1iE6XvG1Ns1o
	 xWUTUBguUZixXK/F6aTNtnYMqVsI4WziWQtofJFGEyeWwjB17Sx3hTT+R7+QhjsxIE5YW
	 z8NSR1lw624eo4oMJQAWMZy1R5RSgnq+Cw5xSiPvd/U1IIBpw7wG97lgRYt2WfwHQgr+Q
	 Dxr0Lxh0PJugk4yZgwRRP9jzLyeq9VQCMIqH28/vLBydvi0X5ffeAtutdaYvbb6d661cg
	 F9KITBwn/LIkv0QiHR8cVYdc6n1pglNws6U/W6Vy9rW4QrugT2X1s2pywqBqiXmZEFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ko77PEhy;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA89606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FA89606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ko77PEhy
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3adf5f6833cso284770a91.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 01:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793349247; x=1793954047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZdFlKAdQE4/ZTqkRXdV4kEJA5/zwRfRs5jP160wiz4Q=;
        b=ko77PEhyaeBjXEph+s3SfTjNPDyeiZtyTmCGpwv4s9ZGmkvtmMdrtAJwxibAwKih/7
         kzwO+dgD/XDGMd8TxnbnRWhTxGYwQHCNTfoItE4dxVlz+iV7/DJeZ23oIgmO31GOPyEi
         v1n3rL/n4upVFKsqgtF+lIUwKiJ48R8Y0gG2uY6Wo0PH9ynwQXkjMXtAtbS+n6HmDILp
         8pgHA4CvDvJa31dmIzLHFdVgG9zoSKjfUZUAAAZ7YJIDw3aNT2hkhAe79UqwiqKNC+kt
         oc3O4/DzFaseb6CeSW88qWJTW2JeZJA38+9HkJU8Bpj1/Zld3Ks5BoOK5I2758FM7hGx
         xTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793349247; x=1793954047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZdFlKAdQE4/ZTqkRXdV4kEJA5/zwRfRs5jP160wiz4Q=;
        b=HiX/O5vWSRSjm+e+Coa0vZ4tn2pLAUlFz4UgvrvJEk7niaK1izv7pNVEAZ5myIuKMp
         JHznrNb7mC+3T9tTvX1DWT2C5WVEkLiWdhyatubosyJ/yqylDeQMsjdqywRCNTZIwXlo
         Yak/dBOX1tKtP72wjrU5E7CPd2d9LUj+PmHRv3WYCCpuaCFO14M7+BknO20ZYJJFLU+S
         YmFyR4hccJpiyZ28GUZPv3DJzteg36QJ3r8icbqBZUGo5xrPN2+yE7Fj4P7+ZjNIJCIL
         MXywL2vefs2tBkok4P+6legWuaW/FfBYA9WFSFaVxgo+q6agZ5FOjhyX5E5yUZmBTY+j
         zzvw==
X-Forwarded-Encrypted: i=1; AKwUvBwktAYoSgzDSd8Jwqt1pYrs9SWyCohI7e2pKAUamu/8Mes2/oermdxNQKMP59w0RD59Ip0Z+36/XsvkZw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJlLNe7SoyX7StZCi1JcMi+gQKD9ikWdflZACo66isv92mV2RgX
	O4eTWFUX+RERg4pDRh2KdKLznek3t3Hzy0KoZqV0Y+GIKh4izrAb8PG/
X-Gm-Gg: AYBFou1vOa8A7eztS7n756v3ZJolhkZ1UmHhZ6aq0JMvOIkeMscJe7pBTAgGQtNjF9T
	Z622xCHn6bdMpUa+KF4ndvSV9IkUgZ3eruyWj3hGoB23ORX5WUyiKqbgtLHqeEntlw9LCrpcoGP
	htY2LszQ8k5dXGYRLVoM5lzhPuvOOg/P3/tXUVJVkQm/61VtWM39e94YdNVOnYSm68dvJqgpCcV
	l9CSh218Rt4L3ldLcDKL9/CYzOsWuvwhLgBF62+LfqwLVUKxRykF4VlvbpcNIHRk5X+/7b1U4gt
	h1YK5W9mpz6U4k0jC610g6XGMqMvf/zqyjYKRu4LLZhgfLhuOJft2sTcyak5wqZbY8G/kuYfqo4
	0TggoagqTn9IaUj9yRtjzj895jQjLJjvS5DW1+zy93PjZfWmNY7tjIhC9Ckjjy8Rb0skNVaNLmz
	85d3oFR/VHVZdTyhXUUSE/H/1TltbkJ97tgjEPpt0j1/mwFI5miVepDlWhRzxwq716W1/TfQ62r
	mXd9UbuMx80aLQsq7VET0/9Mf5+dTg0YQy/D8mN942AyguKAIorYVoMPJHjM0BihEGcEc7rc+Ps
	P5B2rwoppc2l5LCLtzkjAhAIMbF9xpvkmUabTlJKHtg32OJ+ti1kXnB9OWYvj93PkE/4Kr+aXgM
	IVoM3W8qQCnyxPrHvYwMv0OQY5WFl7eM9eS8/kXp3yHi+x2j3UPdYI39OOyl9pxF6olKEQOA11H
	m4DZlgD85Dpfc8eQ==
X-Received: by 2002:a17:90b:5111:b0:3ab:f38:2b43 with SMTP id 98e67ed59e1d1-3ae89772eaemr1169719a91.34.1793349247420;
        Fri, 30 Oct 2026 01:34:07 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e8fb2fesm7596386a91.4.2026.10.30.01.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:34:07 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	fdmanana@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org,
	amir73il@gmail.com
Subject: [PATCH v3] generic: test FIDEDUPERANGE result reporting with REPORT_PROGRESS
Date: Fri, 30 Oct 2026 16:34:03 +0800
Message-ID: <20261030083403.3041196-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260817095017.948979-1-matthias.goergens@gmail.com>
References: <20260817095017.948979-1-matthias.goergens@gmail.com>
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

Add a raw FIDEDUPERANGE helper that reports each destination's
bytes_deduped and status, and a test for the new
FILE_DEDUPE_RANGE_REPORT_PROGRESS flag: explicit zero-length success, a
request shortened for an interior destination but not for one ending at
EOF, a sub-block request that makes no progress, differing contents
(status DIFFERS, zero bytes), a per-destination error, rejection of an
unknown flag bit, and one unflagged case pinning the legacy reporting of
the requested length.  The test is skipped on kernels that reject the
flag.

xfs_io retries shortened dedupe operations, so its output cannot verify
one raw multi-destination ioctl or distinguish an explicit zero-length
request from a nonzero request shortened to zero; hence the helper.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
Christian Brauner applied the kernel series to vfs-7.5.misc on
21 October.  Reference the flag commit in _wants_kernel_commit:
847f74d6293b (vfs: add FILE_DEDUPE_RANGE_REPORT_PROGRESS flag to
FIDEDUPERANGE).
https://lore.kernel.org/all/20261021-rente-privat-mitfiebern-1b76f4650038@brauner/

v3:
- reference the applied kernel flag commit
- renumber 806 to 810: for-next already uses 806 for an xattr test
- use _get_file_block_size instead of _get_block_size (Zorro, on v1)
- the kernel side (v5) now has Reviewed-by from Amir and Darrick, the
  acks Zorro asked to wait for; it reports bytes_deduped = 0 on DIFFERS
  (the advance hint tested in v2 was dropped), so both DIFFERS cases
  expect zero
- new case: an unknown flag bit is rejected with EINVAL (helper -F)
- new case: two small differing files ending at EOF report 0 bytes,
  status DIFFERS
- _notrun on kernels that reject the flag, rather than failing
- .gitignore entry moved into alphabetical order

Previously tested on 2 October as generic/806 under QEMU on v7.3-rc4
with and without the v5 series, on btrfs, XFS (4k and 1k blocks) and
ext4.  With the series generic/517 and
generic/806 pass on btrfs and both XFS configurations; without it 806 is
not run ("kernel does not support FILE_DEDUPE_RANGE_REPORT_PROGRESS")
and 517 passes.  On ext4 both are not run (no dedupe).

Validation refreshed on 30 October against fstests for-next d07dca72:
helper builds with -Wall -Wextra -Werror -O2; bash -n passes.  The
filesystem tests have not been rerun on that base.

 .gitignore            |   1 +
 src/Makefile          |   2 +-
 src/fideduperange.c   | 172 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/810     | 144 +++++++++++++++++++++++++++++++++++
 tests/generic/810.out |   9 +++
 5 files changed, 327 insertions(+), 1 deletion(-)
 create mode 100644 src/fideduperange.c
 create mode 100755 tests/generic/810
 create mode 100644 tests/generic/810.out

diff --git a/.gitignore b/.gitignore
index cdcfa06..418ef7c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -86,6 +86,7 @@ tags
 /src/fake-dump-rootino
 /src/fault
 /src/feature
+/src/fideduperange
 /src/fiemap-tester
 /src/fill
 /src/fill2
diff --git a/src/Makefile b/src/Makefile
index eaf0621..774447e 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -25,7 +25,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
-	locktest unwritten_mmap bulkstat_unlink_test deduperace \
+	locktest unwritten_mmap bulkstat_unlink_test deduperace fideduperange \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
diff --git a/src/fideduperange.c b/src/fideduperange.c
new file mode 100644
index 0000000..d8aef98
--- /dev/null
+++ b/src/fideduperange.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Issue a raw FIDEDUPERANGE ioctl and report each destination's result.
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <inttypes.h>
+#include <linux/fs.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+/*
+ * Local copies of the UAPI types: the system linux/fs.h may predate the
+ * FILE_DEDUPE_RANGE_REPORT_PROGRESS flag.  The layout matches the kernel
+ * UAPI.
+ */
+#ifndef FILE_DEDUPE_RANGE_REPORT_PROGRESS
+#define FILE_DEDUPE_RANGE_REPORT_PROGRESS (1U << 0)
+#endif
+#define FILE_DEDUPE_RANGE_SAME		0
+#define FILE_DEDUPE_RANGE_DIFFERS	1
+
+struct file_dedupe_range_info_local {
+	__s64 dest_fd;
+	__u64 dest_offset;
+	__u64 bytes_deduped;
+	__s32 status;
+	__u32 reserved;
+};
+
+struct file_dedupe_range_local {
+	__u64 src_offset;
+	__u64 src_length;
+	__u16 dest_count;
+	__u16 reserved1;
+	__u32 flags;
+	struct file_dedupe_range_info_local info[0];
+};
+
+#ifndef FIDEDUPERANGE
+#define FIDEDUPERANGE _IOWR(0x94, 54, struct file_dedupe_range_local)
+#endif
+
+static __u32 range_flags;
+
+static void
+usage(const char *progname)
+{
+	fprintf(stderr,
+		"Usage: %s [-f] [-F flags] src src_offset length dest dest_offset "
+		"[dest dest_offset ...]\n"
+		"  -f: set FILE_DEDUPE_RANGE_REPORT_PROGRESS\n"
+		"  -F: set the raw flags value (e.g. 0x2 for an unknown bit)\n",
+		progname);
+	exit(EXIT_FAILURE);
+}
+
+static uint64_t
+parse_u64(const char *arg, const char *name)
+{
+	char *end;
+	unsigned long long value;
+
+	errno = 0;
+	value = strtoull(arg, &end, 0);
+	if (errno || end == arg || *end != '\0') {
+		fprintf(stderr, "Invalid %s: %s\n", name, arg);
+		exit(EXIT_FAILURE);
+	}
+
+	return value;
+}
+
+int
+main(int argc, char **argv)
+{
+	struct file_dedupe_range_local *range;
+	size_t range_size;
+	unsigned int dest_count;
+	unsigned int i;
+	int src_fd;
+	int ret;
+	int c;
+
+	const char *progname = argv[0];
+
+	while ((c = getopt(argc, argv, "fF:")) != -1) {
+		switch (c) {
+		case 'f':
+			range_flags |= FILE_DEDUPE_RANGE_REPORT_PROGRESS;
+			break;
+		case 'F':
+			range_flags |= (__u32)parse_u64(optarg, "flags");
+			break;
+		default:
+			usage(progname);
+		}
+	}
+	argc -= optind;
+	argv += optind;
+
+	if (argc < 5 || (argc - 3) % 2 != 0)
+		usage(progname);
+
+	dest_count = (argc - 3) / 2;
+	if (dest_count > UINT16_MAX) {
+		fprintf(stderr, "Too many destinations: %u\n", dest_count);
+		return EXIT_FAILURE;
+	}
+
+	range_size = sizeof(*range) +
+		dest_count * sizeof(struct file_dedupe_range_info_local);
+	range = calloc(1, range_size);
+	if (!range) {
+		perror("calloc");
+		return EXIT_FAILURE;
+	}
+
+	src_fd = open(argv[0], O_RDONLY);
+	if (src_fd < 0) {
+		perror(argv[0]);
+		free(range);
+		return EXIT_FAILURE;
+	}
+
+	range->src_offset = parse_u64(argv[1], "source offset");
+	range->src_length = parse_u64(argv[2], "length");
+	range->dest_count = dest_count;
+	range->flags = range_flags;
+
+	for (i = 0; i < dest_count; i++) {
+		const char *dest_path = argv[3 + i * 2];
+
+		range->info[i].dest_fd = open(dest_path, O_RDWR);
+		if (range->info[i].dest_fd < 0) {
+			perror(dest_path);
+			ret = EXIT_FAILURE;
+			goto close_destinations;
+		}
+		range->info[i].dest_offset =
+			parse_u64(argv[4 + i * 2], "destination offset");
+		/* Sentinels: the kernel must overwrite both output fields. */
+		range->info[i].bytes_deduped = ~0ULL;
+		range->info[i].status = INT32_MIN;
+	}
+
+	if (ioctl(src_fd, FIDEDUPERANGE, range) < 0) {
+		perror("FIDEDUPERANGE");
+		ret = EXIT_FAILURE;
+		goto close_destinations;
+	}
+
+	for (i = 0; i < dest_count; i++)
+		printf("destination %u: bytes=%" PRIu64 " status=%d\n", i,
+		       (uint64_t)range->info[i].bytes_deduped,
+		       range->info[i].status);
+	ret = EXIT_SUCCESS;
+
+close_destinations:
+	while (i > 0) {
+		i--;
+		close(range->info[i].dest_fd);
+	}
+	close(src_fd);
+	free(range);
+	return ret;
+}
diff --git a/tests/generic/810 b/tests/generic/810
new file mode 100755
index 0000000..2c09315
--- /dev/null
+++ b/tests/generic/810
@@ -0,0 +1,144 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Matthias Goergens. All Rights Reserved.
+#
+# FS QA Test No. 810
+#
+# Check FIDEDUPERANGE result reporting with FILE_DEDUPE_RANGE_REPORT_PROGRESS:
+# bytes_deduped is the length actually deduplicated for zero-length,
+# shortened and zero-progress requests, and zero for differing requests and
+# errors; unknown flag bits are rejected; one unflagged case pins the legacy
+# reporting.
+#
+. ./common/preamble
+_begin_fstest auto quick dedupe clone
+
+. ./common/reflink
+
+_require_scratch_dedupe
+_require_test_program "fideduperange"
+
+_wants_kernel_commit 847f74d6293b \
+	"vfs: add FILE_DEDUPE_RANGE_REPORT_PROGRESS flag to FIDEDUPERANGE"
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+block_size=$(_get_file_block_size "$SCRATCH_MNT")
+short_length=$((2 * block_size))
+full_length=$((short_length + 100))
+
+src=$SCRATCH_MNT/src
+src_short=$SCRATCH_MNT/src-short
+src_diff=$SCRATCH_MNT/src-diff
+dest_interior=$SCRATCH_MNT/dest-interior
+dest_eof=$SCRATCH_MNT/dest-eof
+dest_short_eof=$SCRATCH_MNT/dest-short-eof
+dest_diff=$SCRATCH_MNT/dest-diff
+
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $full_length" "$src" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 100" "$src_short" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $((full_length + block_size))" \
+	"$dest_interior" >>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $full_length" "$dest_eof" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 100" "$dest_short_eof" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $full_length" "$src_diff" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $full_length" "$dest_diff" \
+	>>$seqres.full 2>&1
+
+# Kernels without the flag reject it with EINVAL before looking at any
+# destination.
+result=$($here/src/fideduperange -f "$src" 0 0 "$dest_interior" 0 2>&1)
+echo "flag probe: $result" >>$seqres.full
+if echo "$result" | grep -q "Invalid argument"; then
+	_notrun "kernel does not support FILE_DEDUPE_RANGE_REPORT_PROGRESS"
+fi
+
+check_results()
+{
+	local description="$1"
+	local expected="$2"
+	shift 2
+	local result
+	local ret
+
+	result=$($here/src/fideduperange "$@" 2>&1)
+	ret=$?
+	{
+		echo "$description"
+		echo "$result"
+	} >>$seqres.full
+
+	if [ $ret -ne 0 ]; then
+		_fail "$description: ioctl helper failed"
+	fi
+	if [ "$result" != "$expected" ]; then
+		_fail "$description: unexpected ioctl result"
+	fi
+
+	echo "$description"
+}
+
+# With the flag, bytes_deduped is the length the filesystem reports as
+# deduplicated on SAME, and zero on DIFFERS or an error.
+
+expected="destination 0: bytes=0 status=0"
+check_results "zero length: 0 bytes, SAME" "$expected" \
+	-f "$src" 0 0 "$dest_interior" 0
+
+expected="destination 0: bytes=$short_length status=0
+destination 1: bytes=$full_length status=0"
+check_results "mixed partial request: shortened, full" "$expected" \
+	-f "$src" 0 "$full_length" "$dest_interior" 0 "$dest_eof" 0
+
+expected="destination 0: bytes=0 status=0
+destination 1: bytes=100 status=0"
+check_results "sub-block request: zero progress, full" "$expected" \
+	-f "$src_short" 0 100 "$dest_interior" 0 "$dest_short_eof" 0
+
+expected="destination 0: bytes=0 status=1"
+check_results "differing contents: DIFFERS, zero bytes" "$expected" \
+	-f "$src_diff" 0 "$full_length" "$dest_diff" 0
+
+# Small differing files ending at EOF: still zero, not the request length.
+
+$XFS_IO_PROG -f -c "pwrite -S 0x41 0 512" "$SCRATCH_MNT/tiny-src" >>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x42 0 512" "$SCRATCH_MNT/tiny-dst" >>$seqres.full 2>&1
+
+expected="destination 0: bytes=0 status=1"
+check_results "small-file DIFFERS: zero bytes" "$expected" \
+	-f "$SCRATCH_MNT/tiny-src" 0 512 "$SCRATCH_MNT/tiny-dst" 0
+
+# On a per-destination error, status carries the errno and bytes_deduped
+# is zero (the huge offset fails VFS validation with EINVAL).
+
+expected="destination 0: bytes=0 status=-22"
+check_results "error: bytes zero on EINVAL" "$expected" \
+	-f "$src" 0 "$full_length" "$dest_interior" 9223372036854775807
+
+# An unknown flag bit is rejected before any destination is processed.
+
+result=$($here/src/fideduperange -F 0x2 "$src" 0 "$full_length" "$dest_interior" 0 2>&1)
+echo "unknown flag bit: $result" >>$seqres.full
+if echo "$result" | grep -q "Invalid argument"; then
+	echo "unknown flag bit: EINVAL"
+else
+	_fail "unknown flag bit: expected EINVAL, got: $result"
+fi
+
+# Without the flag, the legacy reporting is unchanged: the requested
+# length is reported even when the VFS shortens the range.
+
+expected="destination 0: bytes=$full_length status=0
+destination 1: bytes=$full_length status=0"
+check_results "unflagged legacy reporting: full length" "$expected" \
+	"$src" 0 "$full_length" "$dest_interior" 0 "$dest_eof" 0
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/810.out b/tests/generic/810.out
new file mode 100644
index 0000000..f88ac62
--- /dev/null
+++ b/tests/generic/810.out
@@ -0,0 +1,9 @@
+QA output created by 810
+zero length: 0 bytes, SAME
+mixed partial request: shortened, full
+sub-block request: zero progress, full
+differing contents: DIFFERS, zero bytes
+small-file DIFFERS: zero bytes
+error: bytes zero on EINVAL
+unknown flag bit: EINVAL
+unflagged legacy reporting: full length

base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
-- 
2.56.0

