Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD31DC43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 17:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ED4820717
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 17:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CL31fDSa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfDYRIS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 13:08:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDYRIS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 13:08:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PH48ul137243;
        Thu, 25 Apr 2019 17:08:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=o06jrEIqltrJhyPiqem2DTUU1+Oq3xmbOkOAIMRhbks=;
 b=CL31fDSa5kxWGrW4zya+y4KwM7M6TlU3AyFAe355zD4SpG0GQgFgOz/XmYtbdEva7gID
 4A5eJv5ybAN06SjykV1XCqdt8u96SxEqa+3wfi4gE0vsbViu5XuqGxK8vYHfvL2EyOzd
 cyIL0roLizvBO2sCrSe5lZXmp5bKAP8cr8JMJLR/Wm97Qkxd5hYR4n7DjvVJ5rnyl+Fn
 DlAPlvWVA/3oAdrsPcCZQzJVNwesDR5RW5G+OlKzfvDPq4BlU5LPB9J4mTzuQlsRHKpi
 uEBuiD4nVgtR5qlQ0mlXStzsjG+N1NsdVhzbII5C6MxwZQ5CbQFhipfnifrClvp2VEHx gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rytut9pty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Apr 2019 17:08:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PH7NAS077853;
        Thu, 25 Apr 2019 17:08:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ryrhtbcsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Apr 2019 17:08:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3PH8D6t029590;
        Thu, 25 Apr 2019 17:08:13 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 10:08:12 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.com
Subject: [PATCH] btrfs: fix null pointer dereference in write_pinned_extent_entries
Date:   Fri, 26 Apr 2019 01:08:06 +0800
Message-Id: <20190425170806.1213-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9238 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904250104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9238 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904250104
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs/049 fails with null pointer dereference

 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
::
 kernel: RIP: 0010:write_pinned_extent_entries+0x27/0x100 [btrfs]
::
 kernel: Call Trace:
 kernel:  __btrfs_write_out_cache+0x273/0x450 [btrfs]
 kernel:  btrfs_write_out_ino_cache+0x84/0xd0 [btrfs]
 kernel:  btrfs_save_ino_cache+0x414/0x500 [btrfs]
 kernel:  commit_fs_roots+0xc6/0x190 [btrfs]
 kernel:  btrfs_commit_transaction+0x4de/0xac0 [btrfs]
 kernel:  btrfs_sync_file+0x35b/0x3d0 [btrfs]
 kernel:  do_fsync+0x38/0x60
 kernel:  __x64_sys_fsync+0x10/0x20

 %block_group::fs_info should be accessed only when block_group is not null.

(Fixes: de965ddc6f29 btrfs: get fs_info from block group in
 write_pinned_extent_entries)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/free-space-cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ea7fecf63fbb..a065041e7c80 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1044,7 +1044,7 @@ static noinline_for_stack int write_pinned_extent_entries(
 			    struct btrfs_io_ctl *io_ctl,
 			    int *entries)
 {
-	struct btrfs_fs_info *fs_info = block_group->fs_info;
+	struct btrfs_fs_info *fs_info;
 	u64 start, extent_start, extent_end, len;
 	struct extent_io_tree *unpin = NULL;
 	int ret;
@@ -1052,6 +1052,7 @@ static noinline_for_stack int write_pinned_extent_entries(
 	if (!block_group)
 		return 0;
 
+	fs_info = block_group->fs_info;
 	/*
 	 * We want to add any pinned extents to our free space cache
 	 * so we don't leak the space
-- 
2.20.1 (Apple Git-117)

