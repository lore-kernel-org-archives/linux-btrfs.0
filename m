Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48812 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab2K0SYW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 13:24:22 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qARIOKwf024872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 18:24:21 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qARIOKaI028546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 18:24:20 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qARIOJ9P031338
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 12:24:19 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs-progs: add feature to label subvol and snapshot
Date: Wed, 28 Nov 2012 02:29:19 +0800
Message-Id: <1354040960-31522-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1354040960-31522-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
 <1354040960-31522-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfslabel.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 btrfslabel.h |    4 +++-
 ctree.h      |    4 +++-
 ioctl.h      |    2 ++
 print-tree.c |    2 ++
 5 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index cb142b0..e161af1 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -126,3 +126,48 @@ int set_label(char *btrfs_dev, char *nLabel)
 	change_label_unmounted(btrfs_dev, nLabel);
 	return 0;
 }
+
+int get_subvol_label(char *subvol, char *labelp)
+{
+	int fd, e=0;
+
+	fd = open_file_or_dir(subvol);
+
+	if(ioctl(fd, BTRFS_IOC_SUBVOL_GETLABEL, labelp) < 0) {
+		e = errno;
+		fprintf(stderr, "ERROR: get subvol label failed, %s\n",
+			strerror(e));
+		close(fd);
+		return -e;
+	}
+	labelp[BTRFS_LABEL_SIZE] = '\0';
+	if (!strlen(labelp))
+		return -1;
+	close(fd);
+	return 0;
+}
+
+int set_subvol_label(char *subvol, char *labelp)
+{
+	int fd, e=0;
+	char label[BTRFS_SUBVOL_LABEL_SIZE+1];
+
+	if (strlen(labelp) > BTRFS_SUBVOL_LABEL_SIZE) {
+		fprintf(stderr, "ERROR: Subvol label is more than max length %d\n",
+			BTRFS_SUBVOL_LABEL_SIZE);
+		return -1;
+	}
+	memset(label, 0, BTRFS_SUBVOL_LABEL_SIZE+1);
+	strcpy(label, labelp);
+	fd = open_file_or_dir(subvol);
+
+	if(ioctl(fd, BTRFS_IOC_SUBVOL_SETLABEL, label) < 0) {
+		e = errno;
+		fprintf(stderr, "ERROR: set subvol label failed, %s\n",
+			strerror(e));
+		close(fd);
+		return -e;
+	}
+	close(fd);
+	return 0;
+}
diff --git a/btrfslabel.h b/btrfslabel.h
index abf43ad..1abc483 100644
--- a/btrfslabel.h
+++ b/btrfslabel.h
@@ -2,4 +2,6 @@
 
 
 int get_label(char *btrfs_dev);
-int set_label(char *btrfs_dev, char *nLabel);
\ No newline at end of file
+int set_label(char *btrfs_dev, char *nLabel);
+int get_subvol_label(char *subvol, char *labelp);
+int set_subvol_label(char *subvol, char *labelp);
diff --git a/ctree.h b/ctree.h
index 293b24f..68bae28 100644
--- a/ctree.h
+++ b/ctree.h
@@ -325,6 +325,7 @@ struct btrfs_header {
  */
 #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
 #define BTRFS_LABEL_SIZE 256
+#define BTRFS_SUBVOL_LABEL_SIZE 32
 
 /*
  * just in case we somehow lose the roots and are not able to mount,
@@ -702,7 +703,8 @@ struct btrfs_root_item {
 	struct btrfs_timespec otime;
 	struct btrfs_timespec stime;
 	struct btrfs_timespec rtime;
-        __le64 reserved[8]; /* for future */
+	char label[BTRFS_SUBVOL_LABEL_SIZE];
+	__le64 reserved[4]; /* for future */
 } __attribute__ ((__packed__));
 
 /*
diff --git a/ioctl.h b/ioctl.h
index 6fda3a1..009fa6e 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -432,4 +432,6 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 					struct btrfs_ioctl_qgroup_limit_args)
+#define BTRFS_IOC_SUBVOL_GETLABEL _IOWR(BTRFS_IOCTL_MAGIC, 55, __u64)
+#define BTRFS_IOC_SUBVOL_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 56, __u64)
 #endif
diff --git a/print-tree.c b/print-tree.c
index 7c615dd..5979109 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -330,6 +330,8 @@ static void print_root(struct extent_buffer *leaf, int slot)
 				btrfs_root_stransid(&root_item),
 				btrfs_root_rtransid(&root_item));
 		}
+		if (strlen(root_item.label))
+			printf("\t\tlabel %s\n", root_item.label);
 	}
 	if (btrfs_root_refs(&root_item) == 0) {
 		struct btrfs_key drop_key;
-- 
1.7.1

