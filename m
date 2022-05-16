Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45891C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 May 2022 06:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbiEPG1g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 May 2022 02:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbiEPG1Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 May 2022 02:27:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BED826AC2
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2022 23:27:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BFF1321F32
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2022 06:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652682431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=N4Iasz4hO+yRkT1m55q1HxK/kW0wsSODC8d+PqA/Tgc=;
        b=jMajts69kr0a2E19vEE5cdW6ftmSr4I8aX6lsaUAMeBotm07vfUHprLzevRW4LyAajWSS5
        YnhSHFHEmrhYaPZHHjbfCZi1eIYQw7vFOl76tDnB2ClL3O2EsFjznW4asPdSlv0qwMv9cX
        SDRAWQP76UdOvVkNEftvd2FbaMaSn58=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2D8A313ADC
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2022 06:27:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PoUUO77ugWKxNAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2022 06:27:10 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: prevent remounting to v1 space cache for subpage mount
Date:   Mon, 16 May 2022 14:26:53 +0800
Message-Id: <1e09cf20ca9309f2b9daf57136c3e2c1b22f94f6.1652682383.git.wqu@suse.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Upstream commit 9f73f1aef98b ("btrfs: force v2 space cache usage for
subpage mount") forces subpage mount to use v2 cache, to avoid
deprecated v1 cache which doesn't support subpage properly.

But there is a loophole that user can still remount to v1 cache.

The existing check will only give users a warning, but not really
prevents the users to do the remount.

Although remounting to v1 will not cause any problems since the v1 cache
will always be marked invalid when mounted with a different page size,
it's still better to prevent v1 cache at all for subpage mounts.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b1fdc6a26c76..1617528a3367 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1985,6 +1985,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if (ret)
 		goto restore;
 
+	/* V1 cache is not supported for subpage mount. */
+	if (fs_info->sectorsize < PAGE_SIZE &&
+	    btrfs_test_opt(fs_info, SPACE_CACHE)) {
+		btrfs_warn(fs_info,
+	"v1 space cache is not supported for page size %lu with sectorsize %u",
+			   PAGE_SIZE, fs_info->sectorsize);
+		goto restore;
+	}
 	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
-- 
2.36.1

