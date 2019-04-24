Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FA5C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 08:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A04D218D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 08:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfDXIq6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 04:46:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:38404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727441AbfDXIq6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 04:46:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E13D4AEC6
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 08:46:56 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     dsterba@suse.cz
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Fix off-by-one error btrfs_trim_free_extents
Date:   Wed, 24 Apr 2019 11:46:55 +0300
Message-Id: <20190424084655.31615-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_trim_free_extents always caps the range it's going to trim based
on the size of the device. This happens if find_first_clear_extent_bit
detects that untrimmed range is past the last allocated range. Since it
doesn't have knowledge of the size of the device it just returns (u64)-1
for end. Then btrfs_trim_free_extents caps this to device->total_bytes.
However, btrfs_trim_free_extent calculates 'len' based off of the
actual usable end byte - in this case total_bytes - 1.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Fixes: 4d877687cbbc ("btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit")
---

David you might want to squash that in the 'Fixes' commit. With this I see 
generic/500 passing and also full xfstest didn't uncover any new regressions. 
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d9e2e35700fd..5a4b81259413 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11175,7 +11175,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		 * end of the device it will set end to -1, in this case it's up
 		 * to the caller to trim the value to the size of the device.
 		 */
-		end = min(end, device->total_bytes);
+		end = min(end, device->total_bytes - 1);
 		len = end - start + 1;
 
 		/* We didn't find any extents */
-- 
2.17.1

