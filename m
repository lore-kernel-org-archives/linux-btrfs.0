Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42734 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3CRHXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 03:23:22 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2I7NK2I022629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 07:23:21 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2I7NKj2020607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 07:23:20 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2I7NJot017532
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 02:23:19 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: return zero for success
Date: Mon, 18 Mar 2013 15:24:01 +0800
Message-Id: <1363591441-6335-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Makefile          |  6 +++++-
 check-mounted.c   | 31 +++++++++++++++++++++++++++++++
 cmds-filesystem.c |  2 +-
 3 files changed, 37 insertions(+), 2 deletions(-)
 create mode 100644 check-mounted.c

diff --git a/Makefile b/Makefile
index d102dee..c97e6b7 100644
--- a/Makefile
+++ b/Makefile
@@ -159,6 +159,10 @@ btrfs-select-super: $(objects) $(libs) btrfs-select-super.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
 
+check-mounted: $(objects) $(libs) check-mounted.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o check-mounted $(objects) check-mounted.o $(LDFLAGS) $(LIBS)
+
 btrfstune: $(objects) $(libs) btrfstune.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
@@ -205,7 +209,7 @@ clean :
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfs.static btrfsck \
-	      version.h \
+	      version.h check-mounted\
 	      $(libs) $(lib_links)
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
diff --git a/check-mounted.c b/check-mounted.c
new file mode 100644
index 0000000..781edec
--- /dev/null
+++ b/check-mounted.c
@@ -0,0 +1,31 @@
+
+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE 1
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "print-tree.h"
+#include "transaction.h"
+#include "list.h"
+#include "version.h"
+#include "utils.h"
+
+int main(int ac, char **av)
+{
+	int ret;
+
+	if((ret = check_mounted(av[optind])) < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
+		return ret;
+	} else if(ret) {
+		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
+		return -EBUSY;
+	}
+	printf("Not mounted\n");
+	return 0;
+}
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2210020..f3d3130 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -446,7 +446,7 @@ static int cmd_defrag(int argc, char **argv)
 		exit(1);
 	}
 
-	return errors + 20;
+	return errors;
 }
 
 static const char * const cmd_resize_usage[] = {
-- 
1.8.1.227.g44fe835

