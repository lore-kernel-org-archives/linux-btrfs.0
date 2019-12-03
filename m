Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3428BC432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 01:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BD34206F0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 01:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ryBR2y29"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfLCBel (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 20:34:41 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37433 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfLCBel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2019 20:34:41 -0500
Received: by mail-pl1-f193.google.com with SMTP id bb5so930235plb.4
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Dec 2019 17:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cz4IiSRm1bjZ0sMYi8R6ullo2ASea8qE8Hw8baCLXRQ=;
        b=ryBR2y29HxZfeUmfm+spjLu0Ikc98Vl5EqGQkUggRHeA+Ev03E0YPKdhufnWRX7T/m
         5kINWovwkNWh7Wg85p/oUSN4kNkGBhP8LAWvKFK+8fEARAIX2MwaxtkMbOnzSmwDSuuY
         BI8z+8I/nvVz0C05WToUBWhl36xTqSEr6pfe1cKZEoy9c3qUYPmbkQX4dLMeU1mnKyXA
         h3y7BKl+h3XlrnwXIBxxgF1D1NsOJsPlsfFkLLrMHpRFoV7UOoZY73PGCyc1J8DClHlr
         sKOQUx1uZqwzszVzQbHDu1mcVKRbBu2xNE7vCQTRGzCLYdSIZLdIAez/mMvwvPnF5pP3
         6gpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cz4IiSRm1bjZ0sMYi8R6ullo2ASea8qE8Hw8baCLXRQ=;
        b=uKXibQn3sbWc6ARxCcSnIjBfMG/sPdNLYHA8MehAx+XUaj01ZlVWcbUbXmTT2LE2ED
         HvoX/a7OBUMZGGWx6csxkl351a4ll5X2HZ+E62efzCDbruJhhlvGWOkfIJpdaQ8wmbFS
         836yE/mkvDAnvINGHMnw8Rl9voW2gWC6ktT+MXOQUQveN7DaDLWDb2fN2zaBYqwnvOqO
         sDS/VEcbcwJoSgSTg3rz2/H41q7R00nQaOt74QfeNCRu7fA1wYomtwBAPMnwhHjkkUTt
         Smx1YV1q5gLYZDaEaceavmGVY/MP1sqUTcBvQBLZHsc8ACVROfb7bvawFEusnszqFzWu
         TuTg==
X-Gm-Message-State: APjAAAVNRs1cHjmWFo/bF1etPnnqU5RyeIhximPF8HGmL+U+qp2w/u6G
        iq6QgK2TDElf/b+4pu5Uy+6bVhaW2kP8Vw==
X-Google-Smtp-Source: APXvYqxwwT4+YzDck/W6uNKdo0AM5Bvv48gdBB0CfhZ38sK3/R1sGqoasN5VlEDKEF31zy3QQxAV8A==
X-Received: by 2002:a17:902:7784:: with SMTP id o4mr2407192pll.176.1575336879631;
        Mon, 02 Dec 2019 17:34:39 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::6ddc])
        by smtp.gmail.com with ESMTPSA id u65sm800242pfb.35.2019.12.02.17.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 17:34:39 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 6/9] btrfs: remove redundant i_size check in __extent_writepage_io()
Date:   Mon,  2 Dec 2019 17:34:22 -0800
Message-Id: <365cd6fdadd6a91c22ccf61fcb1deb688763a176.1575336816.git.osandov@fb.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1575336815.git.osandov@fb.com>
References: <cover.1575336815.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

In __extent_writepage_io(), we check whether
i_size <= page_offset(page).

Note that if i_size < page_offset(page), then
i_size >> PAGE_SHIFT < page->index. If i_size == page_offset(page), then
i_size >> PAGE_SHIFT == page->index && offset_in_page(i_size) == 0.

__extent_writepage() already has a check for these cases that
returns without calling __extent_writepage_io():

  end_index = i_size >> PAGE_SHIFT
  pg_offset = offset_in_page(i_size);
  if (page->index > end_index ||
     (page->index == end_index && !pg_offset)) {
          page->mapping->a_ops->invalidatepage(page, 0, PAGE_SIZE);
          unlock_page(page);
          return 0;
  }

Get rid of the one in __extent_writepage_io(), which was obsoleted in
211c17f51f46 ("Fix corners in writepage and btrfs_truncate_page").

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent_io.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8622282db31e..635f5d2954a4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3455,11 +3455,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	update_nr_written(wbc, nr_written + 1);
 
 	end = page_end;
-	if (i_size <= start) {
-		btrfs_writepage_endio_finish_ordered(page, start, page_end, 1);
-		goto done;
-	}
-
 	blocksize = inode->i_sb->s_blocksize;
 
 	while (cur <= end) {
@@ -3540,7 +3535,6 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		pg_offset += iosize;
 		nr++;
 	}
-done:
 	*nr_ret = nr;
 	return ret;
 }
-- 
2.24.0

