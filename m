Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444B6C433E6
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Feb 2021 21:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E969A64ED0
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Feb 2021 21:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhBAV3P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 16:29:15 -0500
Received: from smtp-36.italiaonline.it ([213.209.10.36]:34784 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232313AbhBAV3H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Feb 2021 16:29:07 -0500
Received: from venice.bhome ([84.220.24.72])
        by smtp-36.iol.local with ESMTPA
        id 6gkAlJHqMi3tS6gkBlGswz; Mon, 01 Feb 2021 22:28:24 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1612214904; bh=0JP/g66F4gd3rshMtrmg1Fz4b9jvZAJ2enehMQa3ANY=;
        h=From;
        b=G0GaT2idndVwzrcr0DMjWB5KgcWAydsu8HblD//XYYU6up4K3lvJT3jAITHUoZ7wF
         LokynvTTwB8qapsJqKzYr50l2MOMisJfCRCrbGyCB4fdZBtvqZYQTLvAgL1MMfZVrr
         OkiMV6S1yiUqLFZ5sm5hRKyKauJqAaXwjqRulT+zZJQ+wrlJ1wNNjhNYazqTv0tMTr
         bqHVj40mBnNoeXrvIgilp5DAnFZ2TLGnuoFAcQQsAgPloRKOjory9bcPa2CuBF8dZw
         0a4qMGxwknCshyfNGT/jBOki5A2hByALVdPVuXv3R1Ph3dfUKVWTrRuyUbneWXT2y2
         tj0VAkTvONSkA==
X-CNFS-Analysis: v=2.4 cv=FqfAQ0nq c=1 sm=1 tr=0 ts=60187278 cx=a_exe
 a=tAq5w2qrEf5dL+VNPEPBHQ==:117 a=tAq5w2qrEf5dL+VNPEPBHQ==:17
 a=1s11hCFB_oFSRyqhbgYA:9 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     linux-btrfs@vger.kernel.org
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/5] btrfs: export dev_item.type in /sys/fs/btrfs/<uuid>/devinfo/<devid>/type
Date:   Mon,  1 Feb 2021 22:28:18 +0100
Message-Id: <20210201212820.64381-4-kreijack@libero.it>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210201212820.64381-1-kreijack@libero.it>
References: <20210201212820.64381-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfD1wutszHKIlUZTwtbSYl9z/+e0rnW7j20qXXiecWT5AXhz1p+eoq7tfP/qkU18tBxI9hlc8b8fyHHAUb+UiBU9dxOKncAAE1Ax1BwTnR3D1zRLzikXh
 L+S6DNQY6KDcXRnYcJdQI2Bo7+IlDMykKZ6jEhGNNoB4oqwzsv+2kRnyr7C8B9E5yWP+X8UVILmdPSYpPNTAywRp04BU3U6AM2jF6VqBiFkf/cJZKfjVFhWW
 xPf6g9OdpZsmUnI/+mUGmXNUv30pNEKFUw1sSeRxD2gmi2RDNlpfYcVObDHregTq
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 fs/btrfs/sysfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 19b9fffa2c9c..594e8445fe21 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1416,11 +1416,22 @@ static ssize_t btrfs_devinfo_writeable_show(struct kobject *kobj,
 }
 BTRFS_ATTR(devid, writeable, btrfs_devinfo_writeable_show);
 
+static ssize_t btrfs_devinfo_type_show(struct kobject *kobj,
+					    struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_device *device = container_of(kobj, struct btrfs_device,
+						   devid_kobj);
+
+	return scnprintf(buf, PAGE_SIZE, "0x%08llx\n",device->type);
+}
+BTRFS_ATTR(devid, type, btrfs_devinfo_type_show);
+
 static struct attribute *devid_attrs[] = {
 	BTRFS_ATTR_PTR(devid, in_fs_metadata),
 	BTRFS_ATTR_PTR(devid, missing),
 	BTRFS_ATTR_PTR(devid, replace_target),
 	BTRFS_ATTR_PTR(devid, writeable),
+	BTRFS_ATTR_PTR(devid, type),
 	NULL
 };
 ATTRIBUTE_GROUPS(devid);
-- 
2.30.0

