Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24EE3BBA0B;
	Thu,  9 Apr 2026 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748152; cv=none; b=Fz5GGXFfzzP5ASID4+7ZLzbn9QMyA76RrNKh4f92wbxzw/ZX0OS10BZXaiLTwkn9qTx8c0YzqFDLVG2oPkgXRYTRrOwc2KKziqvq+QnBgN6ynVJT6VVopqKkDpfTXtqPo11qJ4p+t072fLyBrorj/u20cHdA51r0rvqhQswe+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748152; c=relaxed/simple;
	bh=SyiaN0YLHlxXE3bUnbmU2fjMi5bq8t8nXSue0JRv7cE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YUr7Zichi4bix4TlX6QwHqPnifg+eBTvYeqr/sis9Y/98mShaY65kd2y0ffXou1W0gfdD142IFBEz2lYjBE8MI60vUqEVJIySFYKw4qWrC/6dStKk9SFLob+tYmEwsNyBW3jDngvWY71Fqb8p9u4g6u4MhaJigT+ABN1zJKdbvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdLnsrfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdLnsrfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79363C4CEF7;
	Thu,  9 Apr 2026 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775748152;
	bh=SyiaN0YLHlxXE3bUnbmU2fjMi5bq8t8nXSue0JRv7cE=;
	h=From:To:Cc:Subject:Date:From;
	b=fdLnsrfPWIPY7Ih/iu7QCeuTkynxUNx7ofS9aSxihAeivfLHcxHrxMcMkRVVops6z
	 /ArCd5BItDYL0xxcHlyGRtNEi6s/FlmPjgHDZBM/pFxkYXROrOFALf5zgcFv87BWiG
	 NwfD2DSAF2g+eJmQRrnzlUSDIYgfX7Z6nLufjXEN5VMB+fx90fjJlDRKy434OcD7Pm
	 cEIOogdMkWDTi7aYOarD3364dbnxYb2KH9dfhUhLqdpkVjqyltzdFqtQSMvVDIlC95
	 6hsr3IYn6MnboYJxHJmShzs+ankmKbk0itq5KJiwp+lFhAJ9dT0aEKZB5jzlCPV/3E
	 GQFrCBOUAEi1Q==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: test fsync against a removed directory
Date: Thu,  9 Apr 2026 16:22:27 +0100
Message-ID: <d4b466fd960d1dd8e25f7db75fd323f48053cef1.1775747936.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Test that if we fsync a directory that became empty after removing it
and we have a power failure, we are able to mount the filesystem and the
directory does not exists anymore.

This exercises a bug found in btrfs which is fixed by the following patch:

  btrfs: fix missing last_unlink_trans update when removing a directory

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 src/unlink-fsync.c    | 39 ++++++++++++++++++------
 tests/generic/792     | 69 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/792.out | 10 +++++++
 3 files changed, 109 insertions(+), 9 deletions(-)
 create mode 100755 tests/generic/792
 create mode 100644 tests/generic/792.out

diff --git a/src/unlink-fsync.c b/src/unlink-fsync.c
index ce008c6b..364f9226 100644
--- a/src/unlink-fsync.c
+++ b/src/unlink-fsync.c
@@ -4,10 +4,12 @@
  */
 
 /*
- * Utility to open an existing file, unlink it while holding an open fd on it
- * and then fsync the file before closing the fd.
+ * Utility to open an existing file or directory, unlink or rmdir it while
+ * holding an open fd on it and then fsync it before closing the fd.
  */
 
+#include <sys/types.h>
+#include <sys/stat.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -15,24 +17,43 @@
 
 int main(int argc, char *argv[])
 {
+	struct stat path_stat;
 	int fd;
 	int ret;
 
 	if (argc != 2) {
-		fprintf(stderr, "Use: %s <file path>\n", argv[0]);
+		fprintf(stderr, "Use: %s <file or dir path>\n", argv[0]);
 		return 1;
 	}
 
-	fd = open(argv[1], O_WRONLY, 0666);
+	ret = stat(argv[1], &path_stat);
+	if (ret == -1) {
+		perror("stat failed");
+		exit(1);
+	}
+
+	if (S_ISDIR(path_stat.st_mode))
+		fd = open(argv[1], O_RDONLY | O_DIRECTORY);
+	else
+		fd = open(argv[1], O_WRONLY, 0666);
+
 	if (fd == -1) {
-		perror("failed to open file");
+		perror("failed to open file/dir");
 		exit(1);
 	}
 
-	ret = unlink(argv[1]);
-	if (ret == -1) {
-		perror("unlink failed");
-		exit(2);
+	if (S_ISDIR(path_stat.st_mode)) {
+		ret = rmdir(argv[1]);
+		if (ret == -1) {
+			perror("rmdir failed");
+			exit(2);
+		}
+	} else {
+		ret = unlink(argv[1]);
+		if (ret == -1) {
+			perror("unlink failed");
+			exit(2);
+		}
 	}
 
 	ret = fsync(fd);
diff --git a/tests/generic/792 b/tests/generic/792
new file mode 100755
index 00000000..892ca2d8
--- /dev/null
+++ b/tests/generic/792
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 792
+#
+# Test that if we fsync a directory that became empty after removing it and we
+# have a power failure, we are able to mount the filesystem and the directory
+# does not exists anymore.
+#
+. ./common/preamble
+_begin_fstest auto quick log
+
+_cleanup()
+{
+	_cleanup_flakey
+	cd /
+	rm -r -f $tmp.*
+}
+
+. ./common/filter
+. ./common/dmflakey
+
+_require_scratch
+_require_test_program unlink-fsync
+_require_dm_target flakey
+
+_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+	"btrfs: fix missing last_unlink_trans update when removing a directory"
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_require_metadata_journaling $SCRATCH_DEV
+_init_flakey
+_scratch_mount
+
+# Create our first directory and define its permissions (we will later change
+# them).
+mkdir $SCRATCH_MNT/dir1
+chmod a+rwx $SCRATCH_MNT/dir1
+
+# Created another directory inside that first directoy and then another one at
+# the top level.
+mkdir $SCRATCH_MNT/dir1/dir2
+mkdir $SCRATCH_MNT/dir3
+
+# Persist everything done so far.
+_scratch_sync
+
+# Do some change to the first directory, like change its permissions, fsync it.
+chmod o-rwx $SCRATCH_MNT/dir1
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/dir1
+
+# Now move the second directory from dir1 to dir3, so that dir1 becomes empty.
+mv $SCRATCH_MNT/dir1/dir2 $SCRATCH_MNT/dir3/
+
+# Now open an fd for dir1, rmdir it and fsync it before closing the fd.
+$here/src/unlink-fsync $SCRATCH_MNT/dir1
+
+# Simulate a power failure and replay the log/journal.
+# The mount should succeed, dir1 must not exist anymore and dir2 must now be
+# inside dir3.
+_flakey_drop_and_remount
+
+echo -e "Filesystem content after power failure:\n"
+# Exclude 'lost+found' dir from ext4 and last line if it's blank (due to removal
+# of 'lost+found').
+ls -R $SCRATCH_MNT/ | grep -v 'lost+found' | sed -e '${/^$/d;}' | _filter_scratch
+
+_exit 0
diff --git a/tests/generic/792.out b/tests/generic/792.out
new file mode 100644
index 00000000..f806258c
--- /dev/null
+++ b/tests/generic/792.out
@@ -0,0 +1,10 @@
+QA output created by 792
+Filesystem content after power failure:
+
+SCRATCH_MNT/:
+dir3
+
+SCRATCH_MNT/dir3:
+dir2
+
+SCRATCH_MNT/dir3/dir2:
-- 
2.47.2

