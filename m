Return-Path: <SRS0=/Od+=EE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A02C55178
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 12:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93FC520796
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 12:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lLc4bOXa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgJ2MDK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 08:03:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:32966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgJ2MDJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Oct 2020 08:03:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603972988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ra+v+uvHvnFKDJE+A8V6vBAGmqIy4MJoM3of6uZE1c8=;
        b=lLc4bOXawgP22Kozik3O+XGooa5hUyisj9sFnKHdQHSSfg4+9axZwYBPa99WcwJsZtPVoV
        dTRoSnr/2PNLPBTj4MHpt4wTS6lGkqb3OnR3bZctU4fzTN7mw9ClpPUOoe1b3jN4bnSsmD
        sYNne9TZqRSOnyNbODi7MGYlS+wMmIw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73CFAAF16;
        Thu, 29 Oct 2020 12:03:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 760E7DA7D9; Thu, 29 Oct 2020 13:01:28 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 4/8] btrfs: check-integrity: use proper helper to access btrfs_header
Date:   Thu, 29 Oct 2020 13:01:28 +0100
Message-Id: <281e0cf80515224fa488f4e6562b482d3d55d1aa.1603972767.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1603972767.git.dsterba@suse.com>
References: <cover.1603972767.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There's one raw use of le->cpu conversion but we have a helper to do
that for us, so use it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 81a8c87a5afb..106874c959a0 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -954,7 +954,7 @@ static noinline_for_stack int btrfsic_process_metablock(
 	sf->prev = NULL;
 
 continue_with_new_stack_frame:
-	sf->block->generation = le64_to_cpu(sf->hdr->generation);
+	sf->block->generation = btrfs_stack_header_generation(sf->hdr);
 	if (0 == sf->hdr->level) {
 		struct btrfs_leaf *const leafhdr =
 		    (struct btrfs_leaf *)sf->hdr;
-- 
2.25.0

