Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5002C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Jul 2022 06:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiGOG6O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Jul 2022 02:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGOG6K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jul 2022 02:58:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CE85007B
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2022 23:58:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7C85E1FACC
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2022 06:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657868288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ul4lPHV7sY5IsEg9O145ydrdrhnD0dMziX8upH+VNSU=;
        b=oXKr7lCHt2wVInjyGO0qxDQqY3mNwRnF5eRbmJNjo8nvbSc4L2LrlO29T/L38MdLyIyGQS
        FRmra22RyYkcksxrIzkJnSBIAKsIVgSB9l5vXt41wZrmWI+x3G8pP48RIuslimwNiBG5A7
        u6GFmnLu5h5TWinQ3j9Ubz2f7NHZJ8o=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C4FF913754
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2022 06:58:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ABtoIv8P0WKtfQAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2022 06:58:07 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: make __btrfs_dump_space_info() output better formatted
Date:   Fri, 15 Jul 2022 14:57:45 +0800
Message-Id: <b49e400a0ea64debeace5b667ef5d87fc0ea5409.1657867842.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657867842.git.wqu@suse.com>
References: <cover.1657867842.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The format change includes:

- Output each bytes_* in a separate line

- All bytes_* output starts at the same vertical position
  Do human a favor reading the numbers

- Skip zone specific numbers if zone is not enabled

Now one example of __btrfs_dump_space_info() looks like this for its
bytes_* members.

 BTRFS info (device dm-1: state A): space_info META has 251494400 free, is not full
 BTRFS info (device dm-1: state A):   total:         268435456
 BTRFS info (device dm-1: state A):   used:          376832
 BTRFS info (device dm-1: state A):   pinned:        229376
 BTRFS info (device dm-1: state A):   reserved:      0
 BTRFS info (device dm-1: state A):   may_use:       16269312
 BTRFS info (device dm-1: state A):   read_only:     65536

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/space-info.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 36b466525318..623fa0488545 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -475,11 +475,15 @@ static void __btrfs_dump_space_info(struct btrfs_fs_info *fs_info,
 		   flag_str,
 		   (s64)(info->total_bytes - btrfs_space_info_used(info, true)),
 		   info->full ? "" : "not ");
-	btrfs_info(fs_info,
-		"space_info total=%llu, used=%llu, pinned=%llu, reserved=%llu, may_use=%llu, readonly=%llu zone_unusable=%llu",
-		info->total_bytes, info->bytes_used, info->bytes_pinned,
-		info->bytes_reserved, info->bytes_may_use,
-		info->bytes_readonly, info->bytes_zone_unusable);
+	btrfs_info(fs_info, "  total:         %llu", info->total_bytes);
+	btrfs_info(fs_info, "  used:          %llu", info->bytes_used);
+	btrfs_info(fs_info, "  pinned:        %llu", info->bytes_pinned);
+	btrfs_info(fs_info, "  reserved:      %llu", info->bytes_reserved);
+	btrfs_info(fs_info, "  may_use:       %llu", info->bytes_may_use);
+	btrfs_info(fs_info, "  read_only:     %llu", info->bytes_readonly);
+	if (btrfs_is_zoned(fs_info))
+		btrfs_info(fs_info,
+			    "  zone_unusable: %llu", info->bytes_zone_unusable);
 
 	DUMP_BLOCK_RSV(fs_info, global_block_rsv);
 	DUMP_BLOCK_RSV(fs_info, trans_block_rsv);
-- 
2.37.0

