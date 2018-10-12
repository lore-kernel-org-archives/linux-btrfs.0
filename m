Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBFCC67869
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 04:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62C102087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 04:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="43xI8JV3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62C102087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbeJLLhM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 07:37:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37374 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbeJLLhL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 07:37:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9C449Cx081771
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=hcC7UnJ+vktybRGKszi1En4Huvr6uIhHTouvCazU92o=;
 b=43xI8JV3ufh3N9+p6+fm7j3LQUhUgbeIGBePmN7eVnUh1km7GyzeLy8O7tg5q3GwHJUu
 C0+3qL4FpihuzzI6PZqHVowelJLUdzIeK5RyMDxuzyFyVBWzGUm8IiMZD9mq6jAPN7lR
 KUbp0EnJfi/Pxs1crb5e6+NbgWL3UGGAmuLPx82k199A8mMeWXRCu4jHSL1+0QeQRPFZ
 WpkTYHzvEZ3J9IYshCbmrInP2Bnv4o2nfCjyCqjF2n49KDeIUHenX+AMFWzuzpW7JakF
 5CHo4EGj3fCNycK/JY8FWHwo+qR23SDi0Vq2jCRvpJAQhKrfvc8cZ+3zabesCyt3R6L3 kw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mxmfu86pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:44 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9C46hlS019034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:43 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9C46hGJ018260
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:43 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Oct 2018 04:06:42 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add cli to forget one or all scanned devices
Date:   Fri, 12 Oct 2018 12:06:30 +0800
Message-Id: <1539317191-9265-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
References: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9043 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810120040
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
---
 cmds-device.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 ioctl.h       |  2 ++
 2 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 2a05f70a76a9..ecc391ea01d8 100644
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
+	"btrfs device scan [(-d|--all-devices)|-u|--forget|<device> "\
+							"[<device>...]]",
+	"Scan or forget (deregister) devices for a btrfs filesystem",
 	" -d|--all-devices (deprecated)",
+	" -u|--forget [<device> ..]",
 	NULL
 };
 
@@ -267,32 +289,40 @@ static int cmd_device_scan(int argc, char **argv)
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
 
-	if (all || argc - optind == 0) {
+	if (!forget && (all || argc - optind == 0)) {
 		printf("Scanning for Btrfs filesystems\n");
 		ret = btrfs_scan_devices();
 		error_on(ret, "error %d while scanning", ret);
@@ -301,6 +331,13 @@ static int cmd_device_scan(int argc, char **argv)
 		goto out;
 	}
 
+	if (forget && (all || argc - optind == 0)) {
+		ret = btrfs_forget_devices(NULL);
+		if (ret)
+			error("Can't forget: %s", strerror(-ret));
+		goto out;
+	}
+
 	for( i = devstart ; i < argc ; i++ ){
 		char *path;
 
@@ -315,11 +352,19 @@ static int cmd_device_scan(int argc, char **argv)
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

