Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31505C43332
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Jan 2021 12:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016FA206FA
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Jan 2021 12:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbhATMQ4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:16:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:37884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbhATK10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jan 2021 05:27:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611138329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGhIIvy8Fec9DdtXcF0QwTe1muoBAP8kCTn5E9+c9F4=;
        b=LFYVOLz/9+MMdoVj/2luGh/Imz3mnwzTmVOF3hv55Pmfn3dPVqV3KFhTGPqHtypPfUHMcD
        ziUJIF7bTBNplkn+fWLUVnyV8atldcIRDyb/TT7Ubav0ktAyt192lkf0wtTa629JMxtRWs
        AJWnfkc2NsQh88J0iSwS2DOOjLBIqTo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8F14AAFF1;
        Wed, 20 Jan 2021 10:25:29 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 07/14] btrfs: Document fs_info in btrfs_rmap_block
Date:   Wed, 20 Jan 2021 12:25:19 +0200
Message-Id: <20210120102526.310486-8-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120102526.310486-1-nborisov@suse.com>
References: <20210120102526.310486-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fixes fs/btrfs/block-group.c:1570: warning: Function parameter or member 'fs_info' not described in 'btrfs_rmap_block'

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/block-group.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 0886e81e5540..89a8d7de9cf5 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1554,6 +1554,7 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 
 /**
  * btrfs_rmap_block - Map a physical disk address to a list of logical addresses
+ * @fs_info:       the filesystem
  * @chunk_start:   logical address of block group
  * @physical:	   physical address to map to logical addresses
  * @logical:	   return array of logical addresses which map to @physical
-- 
2.25.1

