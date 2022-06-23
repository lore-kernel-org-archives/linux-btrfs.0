Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01532C43334
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Jun 2022 07:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiFWH6P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 03:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiFWH6L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Jun 2022 03:58:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0829C47
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2022 00:57:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 20FB921D23;
        Thu, 23 Jun 2022 07:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655971074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=av96+huStRr1JVti9SRUCuOc2UPumqeAtskjD/Y0AUA=;
        b=DWFt8jCr68kVEXcHO5TsK02R8VzWmtRlw+Rq3vig8zOyATNtvRSIDF8358SXHlsPpoVZip
        8FuwlVuz6P4yjUK+C3FFFlYOKXCnhXKJ+suPcyUdmYtHvn33RzBsOR2gsr1H4YcPCp2Ijq
        aYGgE3ej/KTbURZuFdaDMgXaT3q5DKs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E36A7133A6;
        Thu, 23 Jun 2022 07:57:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nQXLNAEdtGJ3cwAAMHmgww
        (envelope-from <nborisov@suse.com>); Thu, 23 Jun 2022 07:57:53 +0000
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: remove overly verbose messages
Date:   Thu, 23 Jun 2022 10:57:52 +0300
Message-Id: <20220623075752.1430598-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The message "flagging fs with big metadata" doesn't really convey any
useful information to users. Simply remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c3d92aadc820..8c34d08e3c64 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3508,12 +3508,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 * Flag our filesystem as having big metadata blocks if they are bigger
 	 * than the page size.
 	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			btrfs_info(fs_info,
-				"flagging fs with big metadata feature");
+	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE)
 		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
 
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
-- 
2.25.1

