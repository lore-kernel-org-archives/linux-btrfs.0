Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90474C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5870820857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gBHgJQKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfCSKCB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:02:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfCSKCA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:02:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wwII193453
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=6xsjW0a6Mh130bz9FEHliziANLE3HUWx6kVGTVzsq1s=;
 b=gBHgJQKuI3j7+uZDMUdzsCOUmJQ2dYknQ6RoY5533IN4iCZMl2PIiWJC2s5T2BvLTTe3
 1FVmDv3/KHA46liFVhFnJPsKAuFzo1Js4iP2ynqtgkYXZlu1Vke7FINsBM8On2Npoc7j
 CryYj5ucLmmJtA3g7GNAik+0ce/uYx8RT/KU5Wo+pGuQ8eVhDKBDO0FU3tccIg3W0XRr
 Cmx3YeuCCMw665lciklCmNhwLciWVzgLIJA5c0MDuTMqoPWIaaTcXGbNezYbf53ODCoU
 kYM+R2be+xLtovjUNRGHYMK5iDJgH+FgStWvBrPWsrL7l5ofiD+NL1l5omGIhjSeVfm2 Xg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2r8ssrbgk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:01:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA1xqi013510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:01:59 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2JA1wrx019967
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:01:58 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:01:58 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/2] btrfs-progs: add readmirror policy
Date:   Tue, 19 Mar 2019 18:02:12 +0800
Message-Id: <1552989732-30310-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552989732-30310-1-git-send-email-anand.jain@oracle.com>
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
 <1552989732-30310-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190076
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

