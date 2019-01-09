Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B72C43444
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6293E20821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFECkZe8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbfAIB1w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46019 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbfAIB1t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:49 -0500
Received: by mail-wr1-f65.google.com with SMTP id t6so5962694wrr.12;
        Tue, 08 Jan 2019 17:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X1CzxfoRB3z94dMUde/0tctDv45BKK0+G6IeHmGf5XI=;
        b=DFECkZe8Gec9k9yYAxPYdPPCZLJfkfpP4jkAl6DYiZN+0Kd/zPJsZ0AIU2fGbDDqLJ
         2qhsHRt2KcJ4NvPTl6atiiTsBh0ZPIIbC+lruS3YlVikHmFfxeQqk2kKctYHf3FecIei
         rPskZ0PWyf3xX95UKIOXu8OTrLOdJEWHkkBCGV+85bxKo7mJn2in2iGbRBYrhTAtja6J
         KQ7aQJCdKc7gyLaElV0nDzSnlSNnMCb0RW5j9l2/SjVlpjqarqXFlBUeDpovd2sOqADa
         mcj8Lnl6ytxsdNQNdF44F3KieEBzkkJv7ZXk5pwTD1QLiVvtSpreJKnDKSri47e6EfpC
         R9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=X1CzxfoRB3z94dMUde/0tctDv45BKK0+G6IeHmGf5XI=;
        b=VcYMQjs9rCivMcZRXhvpEMwtwrPB2sRqZHb1sZLPsWK5ktfxhbpkuYH/52uYER2AUn
         aOwozRCcahKHlYEp6XtBsOKiX4NCMmb3rWp2vF6pT34c/14nFIe7yYrHkuqLrtQuOmGQ
         wkA10wJVKv2j7D3+uuAvSRFJUzhcdpvsYBO8MS9xrOKSSxqptTXmdUd5AXRHfIyelNqc
         ZVEz5rEadxLCGLxraifnlb3Iz0dKrutmb8cNSIVlpiYWTMSISF509UaWUkHhoOshyE5O
         ba7OmVcwlbiUamBwjTknITnj1L/cmexu9ikj3qIAuVe/LA21lUraSN6Cp1yyUdW20ByD
         3SrQ==
X-Gm-Message-State: AJcUukeBZ883jZLho6HuFjS4PuRonZ++EPh9VPBTezODCMJDfbfT8YzS
        sq2iAVlgzBWxePYHeD1F9IY=
X-Google-Smtp-Source: ALg8bN4/RNeQ/Amh1uaqj1zlXKVOAI0OT2AM2dyxHYVHi90OOkml98ILpuVpPuM2pJTgmmkvASsJgw==
X-Received: by 2002:adf:8342:: with SMTP id 60mr2932552wrd.212.1546997267737;
        Tue, 08 Jan 2019 17:27:47 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:47 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 17/19] btrfs: don't allow direct IO of encrypted extents
Date:   Wed,  9 Jan 2019 01:26:59 +0000
Message-Id: <20190109012701.26441-17-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f8bc7174f7e3..8f58f492abc8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7945,6 +7945,17 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		goto unlock_err;
 	}
 
+	/*
+	 * Fallback to buffered IO if we have an encrypted inode,
+	 * as we would need to change what's in memory.
+	 */
+	if ((create && inode_need_encrypt(inode)) ||
+		test_bit(EXTENT_FLAG_ENCRYPTED, &em->flags)) {
+		free_extent_map(em);
+		ret = -ENOTBLK;
+		goto unlock_err;
+	}
+
 	if (create) {
 		ret = btrfs_get_blocks_direct_write(&em, bh_result, inode,
 						    dio_data, start, len);
-- 
2.19.2

