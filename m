Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C31C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D96921470
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BznmhAh1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D96921470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbeJMDIM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:12 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43199 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeJMDIM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id q41-v6so15045068qtq.10
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=OTZOuDgDt/R5spujlNFzi4h/V31eI1viGWGcVEUBX/Y=;
        b=BznmhAh1nQe++duAhbVQugXyBiF/Df+N5Lwb+2mjrpkID+der8ZW9AwHTqikimwwi5
         x43VFVHWS2aSqHwCh6fFEWcfjgARDZHMmQOag2TjGhvDMucQ2nVYWTxR6XXBfpv3jj6z
         F3+xnSdy/tC+k2A/uXZKBaXEjvUTrFthlMfggE0lhUmBNZIZgdVlZoa2PQDdrsPD8SvN
         x3FlmgnNUH0geCTViQQ3IDeiZxGVWpWrSTDVPy6OCkqPlCfvDmk2W9UF0DlDCpaBGuPc
         LM7GiJk9SXDdrJlTu/v0GFQsBwW9XNgOKovt+1ZqHFpQ2vKaXG8nSDFg3M4T691XGxWm
         glxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=OTZOuDgDt/R5spujlNFzi4h/V31eI1viGWGcVEUBX/Y=;
        b=YbGy/GjPmUwEfjHJvDPJBQhSkDGInbYOLXWo03fN+SwhBTrMj/PiHvyf1795AmGBDa
         AHsAae+loHisaaCKrqITE2K4hGIe9V2Vkm3+dVax9Dkm5S3J8xv1v1PG9WCsYlceZFvM
         sQPdgqxIT0DLQY1b0rTAWdD1zPpmrnTbVUMQX5cEqWayYsGXTcX1ndqF+h3gOS9mtYLc
         NKwa7HCTS01ddR4pQiX9uU2NmpGxBMjVKQemws1GmYAiaGG4CKTv9jQwdBejqtffwvLl
         KcsH0UZ2jNYFSm0rHESwubStXVP08jvj+TgZepaKrzrcv7lLPbmPk54IhGkf+m4lVao3
         uHBg==
X-Gm-Message-State: ABuFfoguDO7Qa+KQzmbXsC5ROHQTtpBXL3XkSiqIBv7qu2oz8waBqEF5
        jZLaKhi7LikbwGFK771Fr1DwuUKvP8k=
X-Google-Smtp-Source: ACcGV60nzGyhC1itymQUMd78E589/B2gMwK2XHn7lmlG3RwZeeWQYpILwizuEynfVCUaCTlVMZyjGg==
X-Received: by 2002:ac8:7287:: with SMTP id v7-v6mr7072272qto.126.1539372850771;
        Fri, 12 Oct 2018 12:34:10 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c2-v6sm1139792qkj.79.2018.10.12.12.34.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:09 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 32/42] btrfs: only free reserved extent if we didn't insert it
Date:   Fri, 12 Oct 2018 15:32:46 -0400
Message-Id: <20181012193256.13735-33-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

