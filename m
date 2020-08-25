Return-Path: <SRS0=8sAC=CD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C1BC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F59C2075F
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHYPEH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 11:04:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:52824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgHYPD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 11:03:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E086EADDB;
        Tue, 25 Aug 2020 15:04:25 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 2/4] btrfs-progs: add sysfs file reading functions
Date:   Tue, 25 Aug 2020 10:03:36 -0500
Message-Id: <20200825150338.32610-2-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825150338.32610-1-rgoldwyn@suse.de>
References: <20200825150233.30294-1-rgoldwyn@suse.de>
 <20200825150338.32610-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Functions to read and and open sysfs files.
Given a fd, find the fsid associated with the mount and convert into
the sysfs directory to look. Read the exclusive_operation file to find
the current exclusive operation running.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 Makefile       |  4 ++--
 common/sysfs.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 common/utils.h |  3 +++
 3 files changed, 57 insertions(+), 2 deletions(-)
 create mode 100644 common/sysfs.c

diff --git a/Makefile b/Makefile
index ee57d9f8..8a267c45 100644
--- a/Makefile
+++ b/Makefile
@@ -168,8 +168,8 @@ libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   kernel-shared/free-space-tree.o repair.o kernel-shared/inode-item.o \
 		   kernel-shared/file-item.o \
 		   kernel-lib/raid56.o kernel-lib/tables.o \
-		   common/device-scan.o common/path-utils.o \
-		   common/utils.o libbtrfsutil/subvolume.o libbtrfsutil/stubs.o \
+		   common/device-scan.o common/path-utils.o common/utils.o \
+		   common/sysfs.o libbtrfsutil/subvolume.o libbtrfsutil/stubs.o \
 		   crypto/hash.o crypto/xxhash.o $(CRYPTO_OBJECTS)
 libbtrfs_headers = send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-list.h \
 	       crypto/crc32c.h kernel-lib/list.h kerncompat.h \
diff --git a/common/sysfs.c b/common/sysfs.c
new file mode 100644
index 00000000..b2c95cfb
--- /dev/null
+++ b/common/sysfs.c
@@ -0,0 +1,52 @@
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <unistd.h>
+#include <sys/select.h>
+#include <uuid/uuid.h>
+
+#include "common/utils.h"
+
+static char fsid_str[BTRFS_UUID_UNPARSED_SIZE] = {'\0'};
+
+int sysfs_open(int fd, const char *filename)
+{
+	u8 fsid[BTRFS_UUID_SIZE];
+	int ret;
+	char sysfs_file[128];
+
+	if (fsid_str[0] == '\0') {
+		ret = get_fsid_fd(fd, fsid);
+		if (ret < 0)
+			return ret;
+		uuid_unparse(fsid, fsid_str);
+	}
+
+	snprintf(sysfs_file, 128, "/sys/fs/btrfs/%s/%s", fsid_str, filename);
+	return open(sysfs_file, O_RDONLY);
+}
+
+int sysfs_get_str_fd(int fd, char *val, int size)
+{
+	lseek(fd, 0, SEEK_SET);
+	memset(val, '\0', size);
+	return read(fd, val, size);
+}
+
+int get_exclusive_operation(int mp_fd, char *val)
+{
+	int fd;
+	int n;
+
+	fd = sysfs_open(mp_fd, "exclusive_operation");
+	if (fd < 0)
+		return fd;
+
+	n = sysfs_get_str_fd(fd, val, BTRFS_SYSFS_EXOP_SIZE);
+	close(fd);
+
+	val[n - 1] = '\0';
+	return n;
+}
diff --git a/common/utils.h b/common/utils.h
index e34bb5a4..be8aab58 100644
--- a/common/utils.h
+++ b/common/utils.h
@@ -153,4 +153,7 @@ void init_rand_seed(u64 seed);
 char *btrfs_test_for_multiple_profiles(int fd);
 int btrfs_warn_multiple_profiles(int fd);
 
+#define BTRFS_SYSFS_EXOP_SIZE		16
+int get_exclusive_operation(int fd, char *val);
+
 #endif
-- 
2.26.2

