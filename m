Return-Path: <SRS0=qcWT=ZF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2D4C43331
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Nov 2019 06:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A6EB222CD
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Nov 2019 06:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfKMG5X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:57:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:47758 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726186AbfKMG5X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Nov 2019 01:57:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B0AEAFA1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2019 06:57:21 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: common: Keep $seqres.dmesg in $RESULT_DIR
Date:   Wed, 13 Nov 2019 14:57:16 +0800
Message-Id: <20191113065716.33948-1-wqu@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently fstests will remove $seqres.dmesg if nothing wrong happened.
It saves some space, but sometimes it may not provide good enough
history for developers to check.
E.g. some unexpected dmesg from fs, but not serious enough to be caught
by current filter.

So instead of deleting the ordinary $seqres.dmesg, just keep them, so
we can archive them for later review.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/rc | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index b988e912..59a339a6 100644
--- a/common/rc
+++ b/common/rc
@@ -3625,10 +3625,8 @@ _check_dmesg()
 	if [ $? -eq 0 ]; then
 		_dump_err "_check_dmesg: something found in dmesg (see $seqres.dmesg)"
 		return 1
-	else
-		rm -f $seqres.dmesg
-		return 0
 	fi
+	return 0
 }
 
 # capture the kmemleak report
-- 
2.23.0

