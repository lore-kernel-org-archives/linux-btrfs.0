Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E446C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 05:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE84921773
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 05:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J2VpzPC4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfC2FuB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 01:50:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57658 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfC2FuB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 01:50:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2T5mpCK177751
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=6oLALUsJDVOwU4QgUPZHd38mz7H+dkjPzRwKBWtDBTQ=;
 b=J2VpzPC4K8K2QA94LWjcDsPmSUgtA/sz455ykYkcSjG+vpJBXaxxq4AixnSYSnFY7+zc
 LpgiXEGpzJN9rlrkeULoElz9cNY8WCOB7+LbJalFsrxfJdCGRhAYBiTukrEJdB7PF3vT
 CqGQh9yJdHmPcWm4khgMTat5IXkiLFHN5K0/TSsvQ8oTeZ6HwnF/Sr/Z4gMgvK78tu/v
 XWT4kBmTJeJhqGdjG7OxJbgUYcsESlhAY3OKf4bE8Bk5u4xPFJdv1JcRgQngKbaQ437k
 +KLvvE9eG24sVeemHKYk8lzGN7pBMc40snoiZPz/2AoLCaRV44ap6rW36nBFA9zXpriv kQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2re6g1adgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:49:59 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2T5nwuD010395
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:49:58 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2T5nvN9029352
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:49:58 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 22:49:57 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: scan: cleanup, return errno when we have one
Date:   Fri, 29 Mar 2019 13:49:53 +0800
Message-Id: <1553838594-26013-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9210 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903290043
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Functions called in cmd_device_scan() and its return codes as below:

btrfs_forget_devices() returns -errno pass down from ioctl or -errno of
open().
btrfs_register_one_device() returns -errno pass down from the kernel
ioctl or -errno from open().
btrfs_scan_devices() (after the patch) returns error code from libblk who's
return error code matches to -errno or 0.
btrfs_register_all_devices() returns number of devices that failed to
regester (as of now) which no one uses. However if
btrfs_register_all_devices() returns error, we error_on() and return 0.

So we can safely return the error code instead of return !!ret;

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index e3e30b6d5ded..bb3dc78149f8 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -359,13 +359,13 @@ static int cmd_device_scan(int argc, char **argv)
 
 		if (is_block_device(argv[i]) != 1) {
 			error("not a block device: %s", argv[i]);
-			ret = 1;
+			ret = EINVAL;
 			goto out;
 		}
 		path = canonicalize_path(argv[i]);
 		if (!path) {
 			error("could not canonicalize path '%s': %m", argv[i]);
-			ret = 1;
+			ret = EINVAL;
 			goto out;
 		}
 		if (forget) {
@@ -376,8 +376,8 @@ static int cmd_device_scan(int argc, char **argv)
 			}
 		} else {
 			printf("Scanning for btrfs filesystems on '%s'\n", path);
-			if (btrfs_register_one_device(path) != 0) {
-				ret = 1;
+			ret = btrfs_register_one_device(path);
+			if (ret < 0) {
 				free(path);
 				goto out;
 			}
@@ -386,7 +386,9 @@ static int cmd_device_scan(int argc, char **argv)
 	}
 
 out:
-	return !!ret;
+	if (ret < 0)
+		return -ret;
+	return ret;
 }
 
 static const char * const cmd_device_ready_usage[] = {
-- 
1.8.3.1

