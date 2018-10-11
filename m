Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8012FC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45D9420835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="iZxiPsgP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45D9420835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbeJLDYU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36392 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id u34-v6so11347182qth.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=OTZOuDgDt/R5spujlNFzi4h/V31eI1viGWGcVEUBX/Y=;
        b=iZxiPsgPRItyhWi8ZxSgaHbF0t6l8SViKHUR3QLZOC0R86LrRBtpg1zlLUtpGdyBEL
         nlVNL6az2gBGpDR4EBGRbuWemojo92PrrLdL8dM408UZAbep3gOnGdIYqNMuMS08Emp+
         xYc6Wmp8yM7bya/JRvCyfsQjy2nPMvM/9aUMbTgQJDa771XZXFGLPUCV5r4zWW2U45ET
         sDmBz8H5p0E2LLZnZueKpuSDL50XsM3yhNWYnhwKrkMSWcctv/03Lwje2lVc4zwvBwBy
         aJ7zaiqW5UktLWeLmWocxof6ZnpwQ4MKr6FUxec7QFyJq5kFhgdiNKI9m02UWQqSpMwa
         R7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=OTZOuDgDt/R5spujlNFzi4h/V31eI1viGWGcVEUBX/Y=;
        b=K0c2cxqqU+kiE6tvF+05XwHcoBrumKqmk1UjYX5wOXarMHEqg4SfDwM6jBJiDZsd1F
         Af0rvi17d3xrUmbpYfd5Dno8KPULiOohJQ0Aov5oEnLOSlDt1AbZc3mxFkQMS6EDZ1ha
         jlNYB3Wbj5w4MHrC2SU/+eMpd03NXuaO0N9IncVB2SOxuwZffngoEGap3vsDC5Kmj88E
         EHdntT03fX3AWNszZ4a831kftBKVlahTZoVsSFngwRAeB333PRxzXrHBLH8MxViU/GHU
         jPfNU/YgVsF9sWI7k028/U3pofTklhFP2tPHyIxOHI4/FhvYq/cLYspJJXjBTIP4gl9U
         RTUw==
X-Gm-Message-State: ABuFfojSGW9ZqVjoQpZ6g4pwl5PLZ/Hu+Le3F5N9MbpLZ7BcRUSqMUkC
        aM1MFZ835PCMvdvAJArhamHNjg==
X-Google-Smtp-Source: ACcGV634Co96nEp3xOiNXgHQh3rvqDDZCQxGqN72+ZWE4AMrxd4+0eVbaasg8u5Ug0Ki3tzTbivV4Q==
X-Received: by 2002:ac8:248c:: with SMTP id s12-v6mr2954057qts.116.1539287733810;
        Thu, 11 Oct 2018 12:55:33 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l43-v6sm17610599qtc.80.2018.10.11.12.55.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:32 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 32/42] btrfs: only free reserved extent if we didn't insert it
Date:   Thu, 11 Oct 2018 15:54:21 -0400
Message-Id: <20181011195431.3441-33-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When we insert the file extent once the ordered extent completes we free
the reserved extent reservation as it'll have been migrated to the
bytes_used counter.  However if we error out after this step we'll still
clear the reserved extent reservation, resulting in a negative
accounting of the reserved bytes for the block group and space info.
Fix this by only doing the free if we didn't successfully insert a file
extent for this extent.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5a91055a13b2..2b257d14bd3d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2992,6 +2992,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	bool truncated = false;
 	bool range_locked = false;
 	bool clear_new_delalloc_bytes = false;
+	bool clear_reserved_extent = true;
 
 	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
@@ -3095,10 +3096,12 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						logical_len, logical_len,
 						compress_type, 0, 0,
 						BTRFS_FILE_EXTENT_REG);
-		if (!ret)
+		if (!ret) {
+			clear_reserved_extent = false;
 			btrfs_release_delalloc_bytes(fs_info,
 						     ordered_extent->start,
 						     ordered_extent->disk_len);
+		}
 	}
 	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 			   ordered_extent->file_offset, ordered_extent->len,
@@ -3159,8 +3162,13 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		 * wrong we need to return the space for this ordered extent
 		 * back to the allocator.  We only free the extent in the
 		 * truncated case if we didn't write out the extent at all.
+		 *
+		 * If we made it past insert_reserved_file_extent before we
+		 * errored out then we don't need to do this as the accounting
+		 * has already been done.
 		 */
 		if ((ret || !logical_len) &&
+		    clear_reserved_extent &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
 			btrfs_free_reserved_extent(fs_info,
-- 
2.14.3

