Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1210C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90C43205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90C43205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbeJZUUK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:20:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:33534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727491AbeJZUUK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:20:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 79B67AE15
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 11:43:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/5] btrfs: Ensure at least 1g is free for balance
Date:   Fri, 26 Oct 2018 14:43:17 +0300
Message-Id: <1540554201-11305-2-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540554201-11305-1-git-send-email-nborisov@suse.com>
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The first part of balance operation is to shrink every constituting
device to ensure there is free space for chunk allocation. However, the code
has been buggy ever since its introduction since calculating the space to shrink
the device by was bounded by 1 mb. Most likely the original intention was to
have an upper bound of 1g and not 1m, since the largest chunk size is 1g. This 
means the first stage in __btrfs_balance so far has been a null op since it
effectively freed just a single megabyte.

Fix this by setting an upper bound of size_to_free of 1g. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f435d397019e..8b0fd7bf3447 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3467,7 +3467,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	list_for_each_entry(device, devices, dev_list) {
 		old_size = btrfs_device_get_total_bytes(device);
 		size_to_free = div_factor(old_size, 1);
-		size_to_free = min_t(u64, size_to_free, SZ_1M);
+		size_to_free = min_t(u64, size_to_free, SZ_1G);
 		if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) ||
 		    btrfs_device_get_total_bytes(device) -
 		    btrfs_device_get_bytes_used(device) > size_to_free ||
-- 
2.7.4

