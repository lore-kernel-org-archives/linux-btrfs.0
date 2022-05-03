Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C54AC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 May 2022 15:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbiECPnL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 May 2022 11:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiECPnK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2022 11:43:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0781430F6B
        for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2022 08:39:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3F7E3210E3
        for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2022 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651592375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+MHcmlbTzW7qY0e33oOVzNRyRuY7TsASYQCjv0B0FMY=;
        b=mc1oyVy6L5gXu84AM2Y8Gf6sZnx2qy+BFBygNmYpnogt/jsNKmAuhk0k5z2j0BhPs2h2mb
        uMpSq96lYDrZ/K0fLKl8+5jHfcuZQuwbA9TSh9scLKAd0STvyzAvOELIVqzcIcLDk5IKUY
        vYk19VChrEGZyLSGM94cSCGei2SE8J4=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 38B912C141
        for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2022 15:39:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 80B61DA7F7; Tue,  3 May 2022 17:35:25 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: sysfs: export the balance paused state of exclusive operation
Date:   Tue,  3 May 2022 17:35:25 +0200
Message-Id: <20220503153525.22045-1-dsterba@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The new state allowing device addition with paused balance is not
exported to user space so it can't recognize it and actually start the
operation.

Fixes: efc0e69c2fea ("btrfs: introduce exclusive operation BALANCE_PAUSED state")
CC: stable@vger.kernel.org # 5.17
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 366424222b4f..92a1fa8e3da6 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -957,6 +957,9 @@ static ssize_t btrfs_exclusive_operation_show(struct kobject *kobj,
 		case BTRFS_EXCLOP_BALANCE:
 			str = "balance\n";
 			break;
+		case BTRFS_EXCLOP_BALANCE_PAUSED:
+			str = "balance paused\n";
+			break;
 		case BTRFS_EXCLOP_DEV_ADD:
 			str = "device add\n";
 			break;
-- 
2.34.1

