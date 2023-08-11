Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BD1C04A6A
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Aug 2023 10:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbjHKKJw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Aug 2023 06:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbjHKKJg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2023 06:09:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1853AA7;
        Fri, 11 Aug 2023 03:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=J1DfUQkx1NNyyXVn86c6of42JBP1co1gWfvL2lWWijU=; b=yCMFxsqUkS8OiyVwDn9KEmfc7Z
        rFmoMcg8GMQPhofEhx9Enm+G5VFxPlImqTw38zlGAcBUDaOX7du9FynQJKS48kVT+H/4yTI7Fcvpw
        +EOdT0Rg5jhDAmGhxLkZ+Aya7VUX0ZicbvHFVPskzYM/AuWxsQnfkqQ3or878BKOi2vguqi8gGb7F
        rt6WieY+VVtZTtfxA/4t1vyqgnCKVfrPYHz9R6aOcedyEGbVzYLKE5D3+JZwNy0xUiByaW+ayrmb6
        mQ4IeDrjULIinCbVYeRvZw2usWFBmPsNVwDFC/AXNzWjF9TQnR07MCidWipacLPwbEEZgYTHYe60G
        r02dFoGA==;
Received: from [88.128.92.63] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qUP4d-00A5hH-03;
        Fri, 11 Aug 2023 10:08:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Denis Efremov <efremov@linux.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        "Darrick J . Wong" <djwong@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
        nbd@other.debian.org, linux-s390@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/17] nbd: call blk_mark_disk_dead in nbd_clear_sock_ioctl
Date:   Fri, 11 Aug 2023 12:08:18 +0200
Message-Id: <20230811100828.1897174-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230811100828.1897174-1-hch@lst.de>
References: <20230811100828.1897174-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

nbd_clear_sock_ioctl kills the socket and with that the block
device.  Instead of just invalidating file system buffers,
mark the device as dead, which will also invalidate the buffers
as part of the proper shutdown sequence.  This also includes
invalidating partitions if there are any.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 8576d696c7a221..42e0159bb258fa 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1434,12 +1434,10 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd)
 	return ret;
 }
 
-static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
-				 struct block_device *bdev)
+static void nbd_clear_sock_ioctl(struct nbd_device *nbd)
 {
+	blk_mark_disk_dead(nbd->disk);
 	nbd_clear_sock(nbd);
-	__invalidate_device(bdev, true);
-	nbd_bdev_reset(nbd);
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
 			       &nbd->config->runtime_flags))
 		nbd_config_put(nbd);
@@ -1465,7 +1463,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 	case NBD_DISCONNECT:
 		return nbd_disconnect(nbd);
 	case NBD_CLEAR_SOCK:
-		nbd_clear_sock_ioctl(nbd, bdev);
+		nbd_clear_sock_ioctl(nbd);
 		return 0;
 	case NBD_SET_SOCK:
 		return nbd_add_socket(nbd, arg, false);
-- 
2.39.2

