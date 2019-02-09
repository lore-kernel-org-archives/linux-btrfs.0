Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3032CC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 09:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E086820818
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 09:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bg7HyUMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfBIJDM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 04:03:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39904 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfBIJDM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 04:03:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x198wuKf141946;
        Sat, 9 Feb 2019 09:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=pGzFb2T9oc8FjADOewKOYMJZA5aptGaxlIz/RMw+NQs=;
 b=Bg7HyUMK2edEYDFG0DXqgovdrivnBq3FQxAZj39Go8iRJbJJX7U7xWW4u5KNan+X/xx2
 YtL8BmOv/G3Vp5YkFAR/1AyDTEARfXZgG5TaHWMNQnM+rgssWRBj2RZ1rwelWBKx5Iwb
 iywN7+T2XhnEKOZSZfLOXG8MVtcA747zub4aNTxj1t5vebIfvGcJJY37/yWV08Lho2Vp
 gShxNxtStlx7VudHA377yMcl63R2wmLtVdcSavHlbFoxyLMuw4I/oiC1GbisIYsYavUn
 qukxnxFPFSQLduYOwhpafN84U7TA6Pi9SsygLm7Go6e7PoKdiiIyRk2pevk8RXFbNeUH Rg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qhre507ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Feb 2019 09:03:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x19933GM002712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 9 Feb 2019 09:03:04 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x19933Wh032742;
        Sat, 9 Feb 2019 09:03:03 GMT
Received: from kadam (/197.157.0.32)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Feb 2019 01:03:02 -0800
Date:   Sat, 9 Feb 2019 12:02:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Chris Mason <clm@fb.com>, Jeff Mahoney <jeffm@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] btrfs: Silence a static checker locking warning
Message-ID: <20190209090254.GC4865@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9161 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902090067
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Back in the day, before commit 0b246afa62b0 ("btrfs: root->fs_info
cleanup, add fs_info convenience variables") then we used to take
different locks.  But now it's just one lock and the static checkers
think we can call down_read(&fs_info->subvol_sem); twice in a row which
would lead to a deadlock.

That code is several years old now so presumably both (old_ino ==
BTRFS_FIRST_FREE_OBJECTID) and (new_ino == BTRFS_FIRST_FREE_OBJECTID)
conditions can't be true at the same time or the bug would have showed
up in testing.  I have re-written the code though to make it cleaner and
to silence the static checkers.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/btrfs/inode.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9b0e3e2d589c..039a12f51cd7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9423,9 +9423,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	btrfs_init_log_ctx(&ctx_dest, new_inode);
 
 	/* close the race window with snapshot create/destroy ioctl */
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
-		down_read(&fs_info->subvol_sem);
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&fs_info->subvol_sem);
 
 	/*
@@ -9644,9 +9643,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		ret = ret ? ret : ret2;
 	}
 out_notrans:
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
-		up_read(&fs_info->subvol_sem);
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (new_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
 	return ret;
-- 
2.17.1

