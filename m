Return-Path: <SRS0=/Od+=EE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA9FC2D0A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 14:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02EFB2151B
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 14:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PeMRGz/1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgJ2O3W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 10:29:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:47370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbgJ2O3V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Oct 2020 10:29:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603981760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0l3eftyGdqbWyjNE5Mdwd/vdKUtgWr/xu8ha1Jf5uX8=;
        b=PeMRGz/199O1EpJ6G1UG4ere2jWKSk9RUyrkQWwVZG6i2CicYyEi5XtWhH3M8F4h3Gu0uC
        GPbJ3aCGWMm/e/xIrIkfFqpIE5smOfSMk5ofr1rOv7+oHB8If9qZv8fTEkvNGAlYhc0Sl/
        x6ViCOuTu1Mffd2nFMkzPiYJkJQtAdo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4ACEB031;
        Thu, 29 Oct 2020 14:29:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DEB0BDA7CE; Thu, 29 Oct 2020 15:27:44 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 04/10] btrfs: store precalculated csum_size in fs_info
Date:   Thu, 29 Oct 2020 15:27:44 +0100
Message-Id: <652ccbcbeb0af86caab62515908b2b6b66e88cb8.1603981453.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1603981452.git.dsterba@suse.com>
References: <cover.1603981452.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In many places we need the checksum size and it is inefficient to read
it from the raw superblock. Store the value into fs_info, actual use
will be in followup patches.  The size is u32 as it allows to generate
better assembly than with u16.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 1 +
 fs/btrfs/disk-io.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a1a0b99c3530..1f2162fc1daa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -932,6 +932,7 @@ struct btrfs_fs_info {
 	u32 nodesize;
 	u32 sectorsize;
 	u32 sectorsize_bits;
+	u32 csum_size;
 	u32 stripesize;
 
 	/* Block groups and devices containing active swapfiles. */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4e67c122389c..25dbdfa8bc4b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3078,6 +3078,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->nodesize = nodesize;
 	fs_info->sectorsize = sectorsize;
 	fs_info->sectorsize_bits = ilog2(sectorsize);
+	fs_info->csum_size = btrfs_super_csum_size(disk_super);
 	fs_info->stripesize = stripesize;
 
 	/*
-- 
2.25.0

