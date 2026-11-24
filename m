Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558763;
	b=U/it24QvTqs+wW6tzkbvCYYliQsrraZoKXXD+icBNbEnfLIMh4wYa5GKUTUTUA/PWsSP
	 wjlvTSPYf8feBq8tZCn/TkgvEkusUVT6MfIzEyPI8QprMNO4FHgDWZR2SbNuqWtWU5p0v
	 XsAU/X5Fg9XLsqVFlIJ1PRhDKdrSbFK0CCW95AS6h1BkSEoDx2ez/byvoQlkDrOw/RxH2
	 JXacUS+RJbrDO7tZo5yTTEwJ3CgJBcN5wT1udz2/hChIkPFg4U04d1q/pcqut+EbXffG8
	 K3en4k71eDINV3/5go7cCd7xbH30d8LGxztEXnkdbCSJPcvppurV5M+9M7Aq2a7QtKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558763;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=3dDDnA8mFg86lqbGX6IQOIPVmCH6JFcQNKN9zE5vGAY=;
	b=cnyDaQlRQg9aVnIqpdidCn1lZ1YDrY3JEsh678z4ZG1dvTriOBoLQH17T0LqshvO2uQZ
	 7zUIjuFuHGYRDKMcfuLOWPYpBwgpKUkywBHeJPlzUwb3aBn4gfCUWvIx4dAXJNCNlfb0J
	 YdHjqrsuXmLG9aecDErCgeXkyRv5ERortP1dnfWkxP5jSMkpEmgzR9GOMZQWh7XZ07V2t
	 MNN79W1k2RVMFo2YAuEoGVfRECTTgRRmtjrdAJbkmD7KMedDfU26cKnn2TDXxmLBiqIrD
	 ap6cj1UJ/tWd+wLT2azGyf3LpzV+uapEJjvowiZ5MgEB9g2lbm4A6I5bolpgilfDiQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="pRO7SM/9";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="pRO7SM/9";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D10B606BA0F;
	Tue, 24 Nov 2026 22:19:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D10B606BA0F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pRO7SM/9;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pRO7SM/9
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A2B231F7C8;
	Tue, 24 Nov 2026 22:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795558760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3dDDnA8mFg86lqbGX6IQOIPVmCH6JFcQNKN9zE5vGAY=;
	b=pRO7SM/9D4F1IkcMV8SmDsEsFhT1CWaeNxXbWZE2VRMng3O/VRvwlxCicgRXPwy3J/tDcm
	BDgVJavIP1BfXBs8Vej3j8F42VcM9azZMFwzgXblspdpHIwZJhsjNR0jU76NG46lNXqFo6
	IWQFcR6eWPIJmj+Tb109TU6b3x9G9Q0=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795558760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3dDDnA8mFg86lqbGX6IQOIPVmCH6JFcQNKN9zE5vGAY=;
	b=pRO7SM/9D4F1IkcMV8SmDsEsFhT1CWaeNxXbWZE2VRMng3O/VRvwlxCicgRXPwy3J/tDcm
	BDgVJavIP1BfXBs8Vej3j8F42VcM9azZMFwzgXblspdpHIwZJhsjNR0jU76NG46lNXqFo6
	IWQFcR6eWPIJmj+Tb109TU6b3x9G9Q0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C09D13505;
	Tue, 24 Nov 2026 22:19:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HVehHmYNBmv4DAAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 24 Nov 2026 22:19:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] fstests: add a new test case for FS_IOC_GETFSUUID
Date: Wed, 25 Nov 2026 08:49:00 +1030
Message-ID: <2efc6a36bb0ebe8b88b643fbd5336daff3c084d3.1795558644.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

This is inspired by a recent btrfs patch that adds the support for that
generic ioctl.

The new test case is just a simple one to make sure the ioctl returned
the same value as the one reported by blkid.

Older kernels or unsupported fs will still be skipped.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .gitignore            |  1 +
 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 m4/package_libcdev.m4 | 14 +++++++
 src/Makefile          |  4 ++
 src/t_getfsuuid.c     | 89 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/816     | 42 ++++++++++++++++++++
 tests/generic/816.out |  2 +
 8 files changed, 154 insertions(+)
 create mode 100644 src/t_getfsuuid.c
 create mode 100755 tests/generic/816
 create mode 100644 tests/generic/816.out

diff --git a/.gitignore b/.gitignore
index cdcfa06e1119..66bea02fe236 100644
--- a/.gitignore
+++ b/.gitignore
@@ -213,6 +213,7 @@ tags
 /src/perf/*.pyc
 /src/fiemap-fault
 /src/min_dio_alignment
+/src/t_getfsuuid
 /src/dio-writeback-race
 /src/unlink-fsync
 /src/file_attr
diff --git a/configure.ac b/configure.ac
index 6d7ff3ba35fa..7b4a6052fd4b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -75,6 +75,7 @@ AC_HAVE_FICLONE
 AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 AC_HAVE_FILE_GETATTR
 AC_HAVE_FANOTIFY_FID
+AC_HAVE_FS_IOC_GETFSUUID
 
 AC_CHECK_FUNCS([renameat2])
 AC_CHECK_FUNCS([reallocarray])
diff --git a/include/builddefs.in b/include/builddefs.in
index 8e9e2e3b4113..fe9817948673 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -76,6 +76,7 @@ NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE = @need_internal_xfs_ioc_exchange_range@
 HAVE_FICLONE = @have_ficlone@
 HAVE_FILE_GETATTR = @have_file_getattr@
 HAVE_FANOTIFY_FID = @have_fanotify_fid@
+HAVE_FS_IOC_GETFSUUID = @have_fs_ioc_getfsuuid@
 
 GCCFLAGS = -std=gnu11 -funsigned-char -fno-strict-aliasing -Wall
 SANITIZER_CFLAGS += @autovar_init_cflags@
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 340cdad3faf9..7182d9f4f129 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -116,3 +116,17 @@ AC_DEFUN([AC_HAVE_FANOTIFY_FID],
        AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
     AC_SUBST(have_fanotify_fid)
   ])
+
+# Check if we have FS_IOC_GETFSUUID
+AC_DEFUN([AC_HAVE_FS_IOC_GETFSUUID],
+  [ AC_MSG_CHECKING([for FS_IOC_GETFSUUID])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+    ]], [[
+	 struct fsuuid2 u;
+	 ioctl(-1, FS_IOC_GETFSUUID, &u);
+    ]])],[have_fs_ioc_getfsuuid=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_fs_ioc_getfsuuid)
+  ])
diff --git a/src/Makefile b/src/Makefile
index a1fc38d88b8a..cc19abf2517a 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -106,6 +106,10 @@ ifeq ($(HAVE_FICLONE),yes)
      LINUX_TARGETS += t_reflink_read_race
 endif
 
+ifeq ($(HAVE_FS_IOC_GETFSUUID),yes)
+     LINUX_TARGETS += t_getfsuuid
+endif
+
 ifeq ($(HAVE_FANOTIFY_FID),yes)
      LINUX_TARGETS += fs-monitor
 endif
diff --git a/src/t_getfsuuid.c b/src/t_getfsuuid.c
new file mode 100644
index 000000000000..e775abf4a99a
--- /dev/null
+++ b/src/t_getfsuuid.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+ *
+ * Call the generic FS_IOC_GETFSUUID ioctl on the given path and print the
+ * returned ID, in lower case and in the same format as blkid.
+ *
+ * SYNOPSIS:
+ *   t_getfsuuid PATH
+ *
+ * Exit code is 0 on success, 2 if the ioctl is not supported (ENOTTY) and 1
+ * for any other error.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <stdint.h>
+#include <endian.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <uuid/uuid.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+
+int main(int argc, char **argv)
+{
+	struct fsuuid2 fsuuid = { };
+	uuid_t uuid;
+	char uuid_str[37];
+	uint32_t id32;
+	uint64_t id64;
+	int fd;
+	int err;
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s PATH\n", argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror(argv[1]);
+		return 1;
+	}
+
+	if (ioctl(fd, FS_IOC_GETFSUUID, &fsuuid) < 0) {
+		err = errno;
+		fprintf(stderr, "FS_IOC_GETFSUUID: %s\n", strerror(err));
+		close(fd);
+		return err == ENOTTY ? 2 : 1;
+	}
+	close(fd);
+
+	if (fsuuid.len == 0 || fsuuid.len > sizeof(uuid_t)) {
+		fprintf(stderr, "invalid UUID length %u\n", fsuuid.len);
+		return 1;
+	}
+
+	if (fsuuid.len == sizeof(uuid_t)) {
+		memcpy(uuid, fsuuid.uuid, sizeof(uuid));
+		uuid_unparse_lower(uuid, uuid_str);
+		printf("%s\n", uuid_str);
+		return 0;
+	}
+
+	/*
+	 * Some filesystems (e.g. FAT, NTFS) report an ID shorter than 16 bytes.
+	 * That is the raw on-disk volume serial number, a little endian integer.
+	 * Format them manually as blkid does, using the integer value.
+	 */
+	switch (fsuuid.len) {
+	case 4:
+		memcpy(&id32, fsuuid.uuid, sizeof(id32));
+		id32 = le32toh(id32);
+		printf("%04x-%04x\n", id32 >> 16, id32 & 0xffff);
+		break;
+	case 8:
+		memcpy(&id64, fsuuid.uuid, sizeof(id64));
+		id64 = le64toh(id64);
+		printf("%016llx\n", (unsigned long long)id64);
+		break;
+	default:
+		fprintf(stderr, "unsupported short UUID length %u\n",
+			fsuuid.len);
+		return 1;
+	}
+	return 0;
+}
diff --git a/tests/generic/816 b/tests/generic/816
new file mode 100755
index 000000000000..4b6fb77dad19
--- /dev/null
+++ b/tests/generic/816
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 816
+#
+# Test that the generic FS_IOC_GETFSUUID ioctl works and returns the same
+# UUID as what blkid reports for the filesystem.
+#
+. ./common/preamble
+_begin_fstest auto quick ioctl
+
+_require_scratch
+_require_test_program t_getfsuuid
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+ioctl_uuid=$($here/src/t_getfsuuid $SCRATCH_MNT 2>&1)
+ret=$?
+echo "ioctl returned $ret: $ioctl_uuid" >> $seqres.full
+
+# Make sure both the kernel and the filesystem support the ioctl first.
+if [ $ret -eq 2 ]; then
+	_scratch_unmount
+	_notrun "FS_IOC_GETFSUUID is not supported by the kernel or $FSTYP"
+fi
+[ $ret -eq 0 ] || _fail "FS_IOC_GETFSUUID failed: $ioctl_uuid"
+
+_scratch_unmount
+
+# t_getfsuuid always prints in lower case, convert blkid UUID to lower case.
+blkid_uuid=$(blkid -s UUID -o value $SCRATCH_DEV | tr 'A-F' 'a-f')
+echo "blkid UUID: $blkid_uuid" >> $seqres.full
+
+if [ "$ioctl_uuid" != "$blkid_uuid" ]; then
+	echo "UUID mismatch: ioctl=$ioctl_uuid blkid=$blkid_uuid"
+fi
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/816.out b/tests/generic/816.out
new file mode 100644
index 000000000000..a9d8f943c88c
--- /dev/null
+++ b/tests/generic/816.out
@@ -0,0 +1,2 @@
+QA output created by 816
+Silence is golden
-- 
2.56.1

