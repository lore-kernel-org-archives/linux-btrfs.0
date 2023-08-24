Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D323C27C40
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Aug 2023 06:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbjHXGt0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 02:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbjHXGsg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2023 02:48:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD35F1711;
        Wed, 23 Aug 2023 23:48:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7E8FC22C58;
        Thu, 24 Aug 2023 06:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692859705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=IMsgRNm7jdTWW/81d1EFUh6LIet3hQ/6DjIxr6NdGUs=;
        b=NSkJVrucbksvkcpXdiTrVZJMVluQudfaIvmzpItGfKb1+JKPQz/f+GQBRxzKBHVm9nNDSJ
        u7yRMqGQh1HrKrZQjyYzLSP8pjXW9UzH0d91+SUPFeS84IT9HjZkCLO1UEC8Z8Rhr/Rvc6
        5EVydfKWflOBKck3d5Uy43JefPVpFV8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F2E4138FB;
        Thu, 24 Aug 2023 06:48:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LkooEDj95mTeEQAAMHmgww
        (envelope-from <wqu@suse.com>); Thu, 24 Aug 2023 06:48:24 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs/213: fix the _not_run spell
Date:   Thu, 24 Aug 2023 14:48:20 +0800
Message-ID: <20230824064820.72147-1-wqu@suse.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The proper function is _notrun, not _not_run.

This can cause false alerts if the write speed is too fast or has some
cache causing the balance to finish eariler than expectation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/213 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/213 b/tests/btrfs/213
index 5666d9b9..6def4f6e 100755
--- a/tests/btrfs/213
+++ b/tests/btrfs/213
@@ -55,7 +55,7 @@ sleep $(($runtime / 4))
 # any error about no balance currently running.
 $BTRFS_UTIL_PROG balance cancel "$SCRATCH_MNT" 2>&1 | grep -iq 'not in progress'
 if [ $? -eq 0 ]; then
-	_not_run "balance finished before we could cancel it"
+	_notrun "balance finished before we could cancel it"
 fi
 
 # Now check if we can finish relocating metadata, which should finish very
-- 
2.41.0

