Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69863C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A7F82084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A7F82084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbeLEM27 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:28:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:48460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727679AbeLEM26 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:28:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D79E2AE61
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:28:56 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 03/10] btrfs: dax: read zeros from holes
Date:   Wed,  5 Dec 2018 06:28:28 -0600
Message-Id: <20181205122835.19290-4-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/dax.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index d614bf73bf8e..5a297674adec 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -54,7 +54,12 @@ ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
 
                 BUG_ON(em->flags & EXTENT_FLAG_FS_MAPPING);
 
-                ret = em_dax_rw(inode, em, pos, len, to);
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			u64 zero_len = min(em->len - (em->start - pos), len);
+			ret = iov_iter_zero(zero_len, to);
+		} else {
+			ret = em_dax_rw(inode, em, pos, len, to);
+		}
                 if (ret < 0)
                         goto out;
                 pos += ret;
-- 
2.16.4

