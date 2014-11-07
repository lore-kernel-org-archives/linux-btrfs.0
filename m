Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKGRGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 12:06:21 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 632C7AC89
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 17:06:20 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/5] btrfs-progs: build, add basic build test for library
Date: Fri,  7 Nov 2014 18:06:19 +0100
Message-Id: <effebebb42bb4263d8633b4252ce2ac573f1a7f8.1415379676.git.dsterba@suse.cz>
In-Reply-To: <cover.1415379676.git.dsterba@suse.cz>
References: <cover.1415379676.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Basic test based on snapper code that uses the send stream API.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile       |  8 +++++++
 library-test.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 library-test.c

diff --git a/Makefile b/Makefile
index 203597c3e23e..99b03658a406 100644
--- a/Makefile
+++ b/Makefile
@@ -240,6 +240,14 @@ send-test: $(objects) $(libs) send-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
 
+library-test: $(libs_shared) library-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o library-test library-test.o $(LDFLAGS) -lbtrfs
+
+library-test.static: $(libs_static) library-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o library-test-static library-test.o $(LDFLAGS) $(libs_static)
+
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
 
diff --git a/library-test.c b/library-test.c
new file mode 100644
index 000000000000..142188a73b45
--- /dev/null
+++ b/library-test.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2014 SUSE.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "kerncompat.h"
+#include "version.h"
+#include "send-stream.h"
+
+/*
+ * Reduced code snippet from snapper.git/snapper/Btrfs.cc
+ */
+struct btrfs_send_ops send_ops = {
+	.subvol = NULL,
+	.snapshot = NULL,
+	.mkfile = NULL,
+	.mkdir = NULL,
+	.mknod = NULL,
+	.mkfifo = NULL,
+	.mksock = NULL,
+	.symlink = NULL,
+	.rename = NULL,
+	.link = NULL,
+	.unlink = NULL,
+	.rmdir = NULL,
+	.write = NULL,
+	.clone = NULL,
+	.set_xattr = NULL,
+	.remove_xattr = NULL,
+	.truncate = NULL,
+	.chmod = NULL,
+	.chown = NULL,
+	.utimes = NULL,
+	.update_extent = NULL,
+};
+
+/*
+ * Link test only, not intended to be executed.
+ */
+static int test_send_stream_api() {
+	int ret;
+	int fd = -1;
+
+#if BTRFS_LIB_VERSION < 101
+	ret = btrfs_read_and_process_send_stream(fd, &send_ops, NULL, 0);
+#else
+	ret = btrfs_read_and_process_send_stream(fd, &send_ops, NULL, 0, 1);
+#endif
+	return ret;
+}
+
+int main() {
+	test_send_stream_api();
+
+	return 0;
+}
-- 
1.8.4.5

