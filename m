Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2473C4167B
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Oct 2021 06:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF1BD61260
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Oct 2021 06:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhJSG2T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 02:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbhJSG2P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Oct 2021 02:28:15 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A579C061769;
        Mon, 18 Oct 2021 23:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6G6Emq5ChhmlcaDtzCXji8dJmryMmwXGPmCdOZlKPPY=; b=j4UB2nSod+LlsBHiimZOBDpcAy
        u6tB26X30Q2k2GBEgBacqFxiVQDVPzkRZiYu4lqEfkXIB3yzaQiuGy9S4c0VDN7/AnGFYxJmJk7eA
        /moXk9K3qVOhJ5TVQ8R8dQu/tf697hXRZazlcb0VCPamOZuuxa9DhrhL284ceHMsP1Z3Ko+i221Iq
        m40wQohw06W10smZ91d0PtMkNL5lSN2RvzsOAjlkQ7FNgMfQdw7x1VOvA5v6yJIB6JC8yZsBjuna8
        Cra8m+LDTCQRLNkntWeqLfMSwGVOwGTGNFezv1/lSkmVmL/tiGmekXUOrAS52cWwWAxcLeFw/i7C/
        JzdPpvUw==;
Received: from 089144192247.atnat0001.highway.a1.net ([89.144.192.247] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mciZL-000Haq-Cr; Tue, 19 Oct 2021 06:25:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ntfs3@lists.linux.dev
Subject: [PATCH 5/7] fat: use sync_blockdev_nowait
Date:   Tue, 19 Oct 2021 08:25:28 +0200
Message-Id: <20211019062530.2174626-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211019062530.2174626-1-hch@lst.de>
References: <20211019062530.2174626-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use sync_blockdev_nowait instead of opencoding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fat/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index de0c9b013a851..2fd5bfddb6958 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1943,10 +1943,8 @@ int fat_flush_inodes(struct super_block *sb, struct inode *i1, struct inode *i2)
 		ret = writeback_inode(i1);
 	if (!ret && i2)
 		ret = writeback_inode(i2);
-	if (!ret) {
-		struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
-		ret = filemap_flush(mapping);
-	}
+	if (!ret)
+		ret = sync_blockdev_nowait(sb->s_bdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(fat_flush_inodes);
-- 
2.30.2

