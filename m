Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2730DC10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E54262084B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aB7PuI8i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfDYMBE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 08:01:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53940 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfDYMBD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 08:01:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBxE1o062788
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=6xsjW0a6Mh130bz9FEHliziANLE3HUWx6kVGTVzsq1s=;
 b=aB7PuI8ixPlEy/5VK3WyFdIeEaRHmODbDG9WfLCjZvd827EaPQca6fH4TMpZMQws6b2n
 E5+mdHYjDRn7Lch8F8QCStsPF/iLVepANjyjLWXva9t5USYEdnc8Lv762eAq5MRQ+dRs
 UAaGJJZFICBYsisLjB9mjWcLRUaJ5vRmOOsApVI2brGjcpAYg6xjPX7uUeo93Ip8uADW
 UD7fPoEgoME7mOVzJewT1Rij77WRCGbfs1y8frZXPWwFVWs2ooPRKSQQ6y/qRaoSVOxM
 tqGvrFSt8NsAghEgQ6iDe/cEfLNTQnTQSbnTzc3IAmjAVmoR2jmvE3/zE4xwubFZsPiK sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rytut7vbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PC0mUT149004
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2s0dwfc0p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3PC11Lw022558
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:01 GMT
Received: from localhost.localdomain (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 05:01:00 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: add readmirror policy
Date:   Thu, 25 Apr 2019 20:00:55 +0800
Message-Id: <20190425120055.2604-2-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190425120055.2604-1-anand.jain@oracle.com>
References: <20190425115946.2550-1-anand.jain@oracle.com>
 <20190425120055.2604-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904250077
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904250077
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This sets the readmirror=<parm> as a btrfs.<attr> extentded attribute.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 props.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/props.c b/props.c
index 3a498bd9e904..1d1a2c7f9d14 100644
--- a/props.c
+++ b/props.c
@@ -178,6 +178,53 @@ out:
 	return ret;
 }
 
+static int prop_readmirror(enum prop_object_type type, const char *object,
+			   const char *name, const char *value)
+{
+	int fd;
+	int ret;
+	char buf[256] = {0};
+	char *xattr_name;
+	DIR *dirstream = NULL;
+
+	fd = open_file_or_dir3(object, &dirstream, value ? O_RDWR : O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		error("failed to open %s: %m", object);
+		return ret;
+	}
+
+	xattr_name = alloc_xattr_name(name);
+	if (IS_ERR(xattr_name)) {
+		error("failed to alloc xattr_name %s: %m", object);
+		return PTR_ERR(xattr_name);
+	}
+
+	ret = 0;
+	if (value) {
+		if (fsetxattr(fd, xattr_name, value, strlen(value), 0) < 0) {
+			ret = -errno;
+			error("failed to set readmirror for %s: %m", object);
+		}
+	} else {
+		if (fgetxattr(fd, xattr_name, buf, 256) < 0) {
+			if (errno != ENOATTR) {
+				ret = -errno;
+				error("failed to get readmirror for %s: %m",
+				      object);
+			}
+		} else {
+			fprintf(stdout, "readmirror=%.*s\n", (int) strlen(buf),
+				buf);
+		}
+	}
+
+	free(xattr_name);
+	close_file_or_dir(fd, dirstream);
+
+	return ret;
+}
+
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
@@ -185,5 +232,7 @@ const struct prop_handler prop_handlers[] = {
 	 prop_object_dev | prop_object_root, prop_label},
 	{"compression", "Set/get compression for a file or directory", 0,
 	 prop_object_inode, prop_compression},
+	{"readmirror", "set/get readmirror policy for filesystem", 0,
+	 prop_object_root, prop_readmirror},
 	{NULL, NULL, 0, 0, NULL}
 };
-- 
1.8.3.1

