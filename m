Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1494D1F30BB
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 10:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781777145; cv=none; b=r+vSIhI8gQ7xaW3u2zvUaPt42WB6p5ZB+llHOTL+b+1Cj7TraCYncLx/LyWljsw1Lu6Z5C7sRIfOcGKq8Z1xu4dfFAD2bcLNJkujDzP1IFxJXHG05lVaH+KJD05OJ0EIDKAZVmPvugZKNlpH72LnTr9tf0sKgzw3ud7QscDqW4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781777145; c=relaxed/simple;
	bh=n4jpWT+of/FKbklG3temyOdlIWm9QuId6SZyG0ZTE0Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ENUKJn6b66A/A+O2j+BNpTdKrP59v9Tt8GI4L3L/BDeBwGq5LmNogjnBzFLNwcpNxcJYfRWbiRlEIHbyqx2vgsmXkMkcibaW+4JWBVUoQA6X2vRWmf3XrTuGZUg1APHL0O/TRGarlz8F2V+IO5NTr0LlS0GNcWj+j1b4zVQuWKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UJxaT2z0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PCbx0YSz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UJxaT2z0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PCbx0YSz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 15E2B6D1BD;
	Thu, 18 Jun 2026 10:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781777142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LDPRqDyM2I6KpN/mvxylTJDHGGe0TGRrm2+VX34NqJg=;
	b=UJxaT2z0K5UBjzOjIEV3t5osSviPqkHOTPsdcsY4ZCbiHD4goUb+7bB8HYuifFhlrXA5+R
	cMBJyIUTAGwgIC/wEDh+3IbaRj8AQP/9JEzl8ZXc0iP00IMm9Am87ONOw8769eImJ4b6L0
	Qb07GMQieKB8oZQNLRLTvCI2WHvnEzo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PCbx0YSz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781777141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LDPRqDyM2I6KpN/mvxylTJDHGGe0TGRrm2+VX34NqJg=;
	b=PCbx0YSzfd1X0JGcpesvMidi/Y6AbMv9WURoFD8K83WdjD2tKsNDxHdb0SR3T5jwJ5Bb/V
	9NsP/sNlMSelK7phOfUW5Ma8NKw610uNtEGZ32VcfHdP3kNMFsrVQKguIf4Ef46xRmCgOz
	5eZ3dVvXIJsa29gS4tG+yBgrztt1P4E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5508779A8;
	Thu, 18 Jun 2026 10:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1OGIGPPCM2orEgAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 18 Jun 2026 10:05:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: add a test case for btrfs get_subvol_info ioctl
Date: Thu, 18 Jun 2026 19:35:21 +0930
Message-ID: <20260618100521.91162-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 15E2B6D1BD
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

There is a regression caused by upstream kernel commit 538e5bdbc899
("btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO"), where
the unprivileged get_subvol_info ioctl is returning incorrect results.

Unfortunately that bug is not covered by fstests, and only exposed by
btrfs-progs libbtrfsutil python tests, which is not a short run.

So add a new test case for such btrfs ioctl:

- Introduce a helper program, btrfs_ioctl
  Which will call the dedicated ioctl, print all of its structure
  members.

  For now only get_subvol_info is supported, but it can be easily
  appended for new ones.

- Mkfs and create a subvolume on btrfs

- Use "_btrfs_get_subvolid()" to grab the subvolid
  That function is utilizing "btrfs subvolume list" to grab the info,
  which is not utilizing the unprivileged ioctl.

- Use "btrfs_ioctl get_subvol_info" to grab the subvolid

- Compare the two subvolids

This should be enough to detect the regression.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore          |   1 +
 src/Makefile        |   2 +-
 src/btrfs_ioctl.c   | 103 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/351     |  47 ++++++++++++++++++++
 tests/btrfs/351.out |   2 +
 5 files changed, 154 insertions(+), 1 deletion(-)
 create mode 100644 src/btrfs_ioctl.c
 create mode 100755 tests/btrfs/351
 create mode 100644 tests/btrfs/351.out

diff --git a/.gitignore b/.gitignore
index dd77ee30..0b6b9452 100644
--- a/.gitignore
+++ b/.gitignore
@@ -215,6 +215,7 @@ tags
 /src/file_attr
 /src/truncate
 /src/t_btrfs_received_uuid_ioctl
+/src/btrfs_ioctl
 
 # Symlinked files
 /tests/generic/035.out
diff --git a/src/Makefile b/src/Makefile
index 31ac43b2..76cf50c3 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint fs-monitor
+	rw_hint fs-monitor btrfs_ioctl
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/btrfs_ioctl.c b/src/btrfs_ioctl.c
new file mode 100644
index 00000000..4114fa88
--- /dev/null
+++ b/src/btrfs_ioctl.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) SUSE S.A.
+
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <uuid/uuid.h>
+#include <linux/btrfs.h>
+
+#define subvol_info_printf_u64(info, name)	\
+	printf(#name ": %llu\n", (info).name)
+
+#define subvol_info_printf_timestamp(info, name)	\
+	printf(#name ": %llu.%09u\n", (info).name.sec, (info.name.nsec))
+
+#define subvol_info_printf_uuid(info, name)	\
+{						\
+	char uuidbuf[UUID_STR_LEN];		\
+						\
+	uuid_unparse((info).name, uuidbuf);	\
+	printf(#name ": %s\n", (info).name);	\
+}
+
+void get_subvol_info(int fd)
+{
+	struct btrfs_ioctl_get_subvol_info_args info = { 0 };
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_INFO, &info);
+	if (ret < 0) {
+		fprintf(stderr, "ioctl failed: %m\n");
+		return;
+	}
+
+	subvol_info_printf_u64(info, treeid);
+	printf("name: %.*s\n", BTRFS_VOL_NAME_MAX, info.name);
+	subvol_info_printf_u64(info, parent_id);
+	subvol_info_printf_u64(info, dirid);
+	subvol_info_printf_u64(info, generation);
+	printf("flags: 0x%llx\n", info.flags);
+	subvol_info_printf_uuid(info, uuid);
+	subvol_info_printf_uuid(info, parent_uuid);
+	subvol_info_printf_uuid(info, received_uuid);
+	subvol_info_printf_u64(info, ctransid);
+	subvol_info_printf_u64(info, otransid);
+	subvol_info_printf_u64(info, stransid);
+	subvol_info_printf_u64(info, rtransid);
+	subvol_info_printf_timestamp(info, ctime);
+	subvol_info_printf_timestamp(info, otime);
+	subvol_info_printf_timestamp(info, stime);
+	subvol_info_printf_timestamp(info, rtime);
+}
+
+const struct ioctl {
+	const char *name;
+	void (*func)(int fd);
+} supported_ioctls[] = {
+	{
+		.name = "get_subvol_info",
+		.func = get_subvol_info,
+	},
+};
+
+static void usage()
+{
+	fprintf(stderr, "Usage: btrfs_ioctl <ioctl_name> <path>\n");
+}
+int main(int argc, char **argv)
+{
+	const char *ioctl_name;
+	int done = 0;
+	int fd;
+	int ret = 0;
+
+	if (argc != 3) {
+		usage();
+		return ret;
+	}
+	fd = open(argv[2], O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "failed to open %s: %m", argv[2]);
+		return 1;
+	}
+	ioctl_name = argv[1];
+
+	for (int i = 0; i < sizeof(supported_ioctls) / sizeof(supported_ioctls[0]); i++) {
+		const struct ioctl *ioctl = &supported_ioctls[i];
+
+		if (!strncasecmp(ioctl->name, ioctl_name, strlen(ioctl->name))) {
+			ioctl->func(fd);
+			done = 1;
+			break;
+		}
+	}
+	if (!done) {
+		fprintf(stderr, "ioctl \"%s\" is not recognized\n", ioctl_name);
+		ret = 1;
+	}
+	close(fd);
+	return ret;
+}
diff --git a/tests/btrfs/351 b/tests/btrfs/351
new file mode 100755
index 00000000..e92ddf1b
--- /dev/null
+++ b/tests/btrfs/351
@@ -0,0 +1,47 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 351
+#
+# Make sure the unprivileged get_subvol_info ioctl is providing the correct
+# result.
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"Revert \"btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO\""
+
+_require_test_program btrfs_ioctl
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_btrfs subvolume create $SCRATCH_MNT/subv1
+
+# The id is get through "btrfs subvolume list" command, which doesn't utilize the
+# unprivileged version.
+subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
+echo "subvolid=$subvolid" >> $seqres.full
+
+# Do a basic check in case "btrfs subvolume list" doesn't get a correct subvolid
+if [ -z "$subvolid" -o "$subvolid" -lt 256 ]; then
+	_fail "\"btrfs subvolume list\" returned an invalid subvolid"
+fi
+
+# Get the id again through the unprivileged get_subvol_info ioctl
+$here/src/btrfs_ioctl get_subvol_info $SCRATCH_MNT/subv1 >> $tmp.output
+cat $tmp.output >> $seqres.full
+ioctl_subvolid=$(grep treeid: $tmp.output | cut -f 2 -d\ )
+
+if [ "$ioctl_subvolid" -ne "$subvolid" ]; then
+	_fail "get_subvol_info ioctl returned an incorrect treeid"
+fi
+
+_scratch_unmount
+
+echo "Silence is golden"
+# success, all done
+_exit 0
diff --git a/tests/btrfs/351.out b/tests/btrfs/351.out
new file mode 100644
index 00000000..49b14639
--- /dev/null
+++ b/tests/btrfs/351.out
@@ -0,0 +1,2 @@
+QA output created by 351
+Silence is golden
-- 
2.51.2

