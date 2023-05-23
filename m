Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445C5C7EE29
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 May 2023 08:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbjEWIl4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 May 2023 04:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbjEWIlZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2023 04:41:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7836BE4F
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 01:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=C0lfNshUPGXqHaUMiEW5g00Pi9Fwa/T9RYSgmZdTpBQ=; b=Cg+3VWgvbKcayuKl+dCah4lvZQ
        gbGHPCkSKr2qo8iZu6VTj/+icNeqUZgNj5dIFQM8kt18KUFH8e7vcBsWsi1A17yppkQfqSw9xzjPj
        ZS4CvGnF/DpNtexPECxnEgBDBPcnMTn2bv3Ss8XVveQp8xj62WE92pofFBo0qVh/qctkURENO+N/t
        AOzMBb3CVroztI8lgY2hLi+aTrLAVBAee3lu1AVWb3+7SrENCoDEiRFQVuFVT4x4JdWDPJRWXpS8D
        TESLRG/a5QEsufQ46FYaW08JiPRLy+NGjTlNR31w0SezZYm+LPm+9Wc3f0HWDrGgYFZcXaIKgLJtC
        xPF5q5CQ==;
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q1NZE-009TZQ-06;
        Tue, 23 May 2023 08:40:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: remove a pointless NULL check in btrfs_lookup_fs_root
Date:   Tue, 23 May 2023 10:40:20 +0200
Message-Id: <20230523084020.336697-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523084020.336697-1-hch@lst.de>
References: <20230523084020.336697-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_grab_root already checks for a NULL root itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/disk-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1edd6685df5760..c70d9defb90fa5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1332,8 +1332,7 @@ static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
 				 (unsigned long)root_id);
-	if (root)
-		root = btrfs_grab_root(root);
+	root = btrfs_grab_root(root);
 	spin_unlock(&fs_info->fs_roots_radix_lock);
 	return root;
 }
-- 
2.39.2

