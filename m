Return-Path: <SRS0=qcWT=ZF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968E2C17442
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Nov 2019 10:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79221222C1
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Nov 2019 10:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfKMK1j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 05:27:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:48198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726597AbfKMK1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Nov 2019 05:27:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10753B5FB;
        Wed, 13 Nov 2019 10:27:37 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Qu Wenru <wqu@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 5/7] btrfs: remove final BUG_ON() in close_fs_devices()
Date:   Wed, 13 Nov 2019 11:27:26 +0100
Message-Id: <20191113102728.8835-6-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191113102728.8835-1-jthumshirn@suse.de>
References: <20191113102728.8835-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now that the preparation work is done, remove the temporary BUG_ON() in
close_fs_devices() and return an error instead.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes to v1:
- btrfs_fs_devices::seeding is a 'boolean' flags and no counter, don't
  decrement it (Qu)
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index be1fd935edf7..25e4608e20f1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1128,7 +1128,11 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
 		ret = btrfs_close_one_device(device);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			mutex_unlock(&fs_devices->device_list_mutex);
+			return ret;
+		}
+		fs_devices->opened--;
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-- 
2.16.4

