Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9E8ECAAA1
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Oct 2022 19:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiJaTeG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 15:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiJaTeA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2022 15:34:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E7F13E1D
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Oct 2022 12:33:59 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A7F212238D;
        Mon, 31 Oct 2022 19:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667244838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VmVixvHV89ijFONnWA7FMA46gFj0Yue9HqucX+Q2FSE=;
        b=e7+pT66KwGnaOT6Iz4eCT1UuCmn7E3Xb50r27T9GA1l4UMNDTmq+9kyZXp/ckSt/1VZpyQ
        sz1NyK1WzfVbWRxi6J4hmYD02fq6zDEoefXnYqWGukJN8lAwwGAsV0qiSpMxlyglgXEiez
        /ytqxE+4trDNvuNZuWFFyzPVQWLl3i8=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 9E0672C141;
        Mon, 31 Oct 2022 19:33:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 89B6BDA79D; Mon, 31 Oct 2022 20:33:42 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: zoned: use helper to check a power of two zone size
Date:   Mon, 31 Oct 2022 20:33:42 +0100
Message-Id: <1e9e2015a56fb48dba859dff85f3eee1f69f74fc.1667244568.git.dsterba@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667244567.git.dsterba@suse.com>
References: <cover.1667244567.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have a 64bit compatible helper to check if a value is a power of two,
use it instead of open coding it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9d12a23e1a59..32a5aac1cccb 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -393,8 +393,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		zone_sectors = bdev_zone_sectors(bdev);
 	}
 
-	/* Check if it's power of 2 (see is_power_of_2) */
-	ASSERT(zone_sectors != 0 && (zone_sectors & (zone_sectors - 1)) == 0);
+	ASSERT(is_power_of_two_u64(zone_sectors));
 	zone_info->zone_size = zone_sectors << SECTOR_SHIFT;
 
 	/* We reject devices with a zone size larger than 8GB */
-- 
2.37.3

