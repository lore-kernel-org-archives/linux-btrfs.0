Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F5DC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D34215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="g3f0vPm8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48D34215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbeI1Rmn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:43 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:46492 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbeI1Rmm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:42 -0400
Received: by mail-qt1-f178.google.com with SMTP id h22-v6so6090642qtr.13
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=OTZOuDgDt/R5spujlNFzi4h/V31eI1viGWGcVEUBX/Y=;
        b=g3f0vPm8untRqZQJPQGfmRU69iIfSg4kuTVdkqXkFjSzxYwprjdBpQnzbaQjCkpJkm
         0JY3g6kS82hHFkxMNu1BBwzXIOnWAwEyz7tyBoR3YvkF7Pg7rk1+Rk3H2KaSGuJg8dro
         /T3zGvZEfkSQ5RflpqKNa/HG9ymE4s5t+iRV6w3EpYqf1pPUrGSq1HxT+AjXv+eo8Fc1
         u8ammbLSJded8uNmFgFAu5ztwAXXmPo4SSPaKWQLPqil1cBNCS3FX4z7rAKroyPu6fxM
         nK2TMj44uj2AxmT9M7IyS5xkkzd7wR+tmZpkKasb4JOdUcBZEOTIgxUycibA4RMbBjrA
         wEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=OTZOuDgDt/R5spujlNFzi4h/V31eI1viGWGcVEUBX/Y=;
        b=I4VVY5oryz1d9AVAVhyrOg1loWCjRCxx3bT64s/ctDU1rVzB9KCjoHAElBXIc5Xu3A
         77q/RtuBbwExpCb9jBUwa6IDjIjlB1Pmku6tviwCr02qHzmJADuISOZSYGNNmvirhN6j
         IHgf3os50ih8iy0X8UxJtGkGUDAusrB1Fq0LC8gdT1Doi6Fab5Gnrc+9lxgB/oJ+F/Mz
         1BfCkzi3lZSuslaTMhJEiwE7NWnNgkP1QZv4snD6RNtCZNMw7ic6N3T8l1ka9EC9F01f
         6jauOIJ5vI6MChaHXLEE5pptTq+b1tbEFwwj8fihnV6XrSng4GcvIyYVjEoJfHBWIGhg
         J0zw==
X-Gm-Message-State: ABuFfogV8P3pefvhijLy7SoLUUS9V6mik8BdeS1SOIFVjxsRCJq4lUEG
        KgpMgAxEI3EyM2DqGjbr1LZIGA==
X-Google-Smtp-Source: ACcGV62a9eD2fSQ/FPceO9RauWOLul1Pa/QA2GzXuoRHx5gq/+HvUnDS0tQshEDel+iP01Gjriw5HA==
X-Received: by 2002:ac8:37f2:: with SMTP id e47-v6mr11579448qtc.32.1538133564532;
        Fri, 28 Sep 2018 04:19:24 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u184-v6sm2611219qkc.87.2018.09.28.04.19.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:23 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 32/42] btrfs: only free reserved extent if we didn't insert it
Date:   Fri, 28 Sep 2018 07:18:11 -0400
Message-Id: <20180928111821.24376-33-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

