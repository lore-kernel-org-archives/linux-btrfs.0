Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE44C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 264832087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfBYS4c (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 13:56:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:37026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfBYS4c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 13:56:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 125F6ACBA
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 18:56:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 41311DA83C; Mon, 25 Feb 2019 19:57:48 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: scrub: return EAGAIN when fs is closing
Date:   Mon, 25 Feb 2019 19:57:41 +0100
Message-Id: <20190225185742.14989-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The error code used here is wrong as it's not invalid to try to start
scrub when umount has begun.  Returning EAGAIN is more user friendly as
it's recoverable.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a99588536c79..ed471ffbf115 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3791,7 +3791,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	struct btrfs_workqueue *scrub_parity = NULL;
 
 	if (btrfs_fs_closing(fs_info))
-		return -EINVAL;
+		return -EAGAIN;
 
 	if (fs_info->nodesize > BTRFS_STRIPE_LEN) {
 		/*
-- 
2.20.1

