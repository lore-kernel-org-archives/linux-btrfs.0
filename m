Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23F5C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B62182086A
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B62182086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbeKNR1I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:27:08 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58919 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727375AbeKNR1I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:27:08 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="48077927"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 14 Nov 2018 15:25:06 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C8B034B714D6
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 15:25:02 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 14 Nov
 2018 15:25:08 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Fix suspicious RCU usage warning in device_list_add
Date:   Wed, 14 Nov 2018 15:24:56 +0800
Message-ID: <20181114072456.4746-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: C8B034B714D6.A6B54
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

=============================
WARNING: suspicious RCU usage
4.20.0-rc2+ #23 Tainted: G           O
-----------------------------
fs/btrfs/volumes.c:886 suspicious rcu_dereference_check() usage!

Use btrfs_info_in_rcu instead of pr_info for the required lock/unlock of
RCU string.

Fixes: 1f265fc6f58b ("btrfs: harden agaist duplicate fsid on scanned devices")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2186300bab91..6039ae5c549e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -873,15 +873,15 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 			if (device->bdev != path_bdev) {
 				bdput(path_bdev);
 				mutex_unlock(&fs_devices->device_list_mutex);
-				pr_warn(
-		"BTRFS: duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",
+				btrfs_warn_in_rcu(device->fs_info,
+			"duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",
 					disk_super->fsid, devid,
 					rcu_str_deref(device->name), path);
 				return ERR_PTR(-EEXIST);
 			}
 			bdput(path_bdev);
-			pr_info(
-			"BTRFS: device fsid %pU devid %llu moved old:%s new:%s\n",
+			btrfs_info_in_rcu(device->fs_info,
+			"device fsid %pU devid %llu moved old:%s new:%s\n",
 				disk_super->fsid, devid,
 				rcu_str_deref(device->name), path);
 		}
-- 
2.19.1



