Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C349C07E85
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 09:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 258BA22360
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 09:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o55yo4vn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 258BA22360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbeKNTPN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 14:15:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbeKNTPM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 14:15:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAE98u6n103653
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 09:12:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=41qjOl89+ktlr+kWb8H7x5AdkpIoXL2susruu2+KPuk=;
 b=o55yo4vn+Yy0zy5EeRDC1qGp7OpNuf9Esv/ycgvnJDEY+7Z1BmoBGQ99X7hmSVurbrOK
 gwQJSq8jIYEmavMBZSXdHOLtIUTUtXHv/AxHUxNJcgkuepL4AyaQFbhgLz/jJHuNDNCh
 8beN8Kcno19kvVwy3+9A4uHtgfS2OA67OJQQZA3shnRYWEGwNHyeNIkn4QpaRx6uQWRH
 5fqr7bq6CEznURCgZyIouORGfvUxzHAjoLOcvbONcaQSdKMDkKOA5LpQDJu6BBLufMqZ
 xoJodPgRo3pBC5nuW0yaPo9Hw2rSoIloG2TYCE9vp9+aN87Qi+GXvk0/XBK65MRkY/Wx vg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2nr7cs22a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 09:12:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAE9CnlO021300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 09:12:49 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAE9CnUF019307
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 09:12:49 GMT
Received: from tpasj.oracle.com (/192.188.170.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 01:12:48 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add cli to forget one or all scanned devices
Date:   Wed, 14 Nov 2018 17:12:48 +0800
Message-Id: <1542186768-22956-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1542186768-22956-1-git-send-email-anand.jain@oracle.com>
References: <1542186768-22956-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140084
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch adds cli
  btrfs device forget [dev]
to remove the given device structure in the kernel if the device
is unmounted. If no argument is given it shall remove all stale
(device which are not mounted) from the kernel.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 cmds-device.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 ioctl.h       |  2 ++
 2 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 2a05f70a76a9..280d6f555377 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -254,10 +254,32 @@ static int cmd_device_delete(int argc, char **argv)
 	return _cmd_device_remove(argc, argv, cmd_device_delete_usage);
 }
 
+static int btrfs_forget_devices(char *path)
+{
+	struct btrfs_ioctl_vol_args args;
+	int ret;
+	int fd;
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	memset(&args, 0, sizeof(args));
+	if (path)
+		strncpy_null(args.name, path);
+	ret = ioctl(fd, BTRFS_IOC_FORGET_DEV, &args);
+	if (ret)
+		ret = -errno;
+	close(fd);
+	return ret;
+}
+
 static const char * const cmd_device_scan_usage[] = {
-	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
-	"Scan devices for a btrfs filesystem",
+	"btrfs device scan [(-d|--all-devices)|(-u|--forget)|<device> "\
+							"[<device>...]]",
+	"Scan or forget (deregister) devices for a btrfs filesystem",
 	" -d|--all-devices (deprecated)",
+	" -u|--forget [<device> ..]",
 	NULL
 };
 
@@ -267,37 +289,53 @@ static int cmd_device_scan(int argc, char **argv)
 	int devstart;
 	int all = 0;
 	int ret = 0;
+	int forget = 0;
 
 	optind = 0;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
 			{ "all-devices", no_argument, NULL, 'd'},
+			{ "forget", no_argument, NULL, 'u'},
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "d", long_options, NULL);
+		c = getopt_long(argc, argv, "du", long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
 		case 'd':
 			all = 1;
 			break;
+		case 'u':
+			forget = 1;
+			break;
 		default:
 			usage(cmd_device_scan_usage);
 		}
 	}
 	devstart = optind;
 
+	if (all && forget)
+		usage(cmd_device_scan_usage);
+
 	if (all && check_argc_max(argc - optind, 1))
 		usage(cmd_device_scan_usage);
 
 	if (all || argc - optind == 0) {
-		printf("Scanning for Btrfs filesystems\n");
-		ret = btrfs_scan_devices();
-		error_on(ret, "error %d while scanning", ret);
-		ret = btrfs_register_all_devices();
-		error_on(ret, "there are %d errors while registering devices", ret);
+		if (forget) {
+			ret = btrfs_forget_devices(NULL);
+			error_on(ret, "'%s', forget failed",
+				 strerror(-ret));
+		} else {
+			printf("Scanning for Btrfs filesystems\n");
+			ret = btrfs_scan_devices();
+			error_on(ret, "error %d while scanning", ret);
+			ret = btrfs_register_all_devices();
+			error_on(ret,
+				"there are %d errors while registering devices",
+				ret);
+		}
 		goto out;
 	}
 
@@ -315,11 +353,19 @@ static int cmd_device_scan(int argc, char **argv)
 			ret = 1;
 			goto out;
 		}
-		printf("Scanning for Btrfs filesystems in '%s'\n", path);
-		if (btrfs_register_one_device(path) != 0) {
-			ret = 1;
-			free(path);
-			goto out;
+		if (forget) {
+			ret = btrfs_forget_devices(path);
+			if (ret)
+				error("Can't forget '%s': %s",
+							path, strerror(-ret));
+		} else {
+			printf("Scanning for Btrfs filesystems in '%s'\n",
+									path);
+			if (btrfs_register_one_device(path) != 0) {
+				ret = 1;
+				free(path);
+				goto out;
+			}
 		}
 		free(path);
 	}
diff --git a/ioctl.h b/ioctl.h
index 709e996f401c..e27d80e09392 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -721,6 +721,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
1.8.3.1

