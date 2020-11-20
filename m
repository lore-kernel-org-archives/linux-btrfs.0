Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B9EC63777
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Nov 2020 15:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32CAF22201
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Nov 2020 15:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dk6jO/M4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgKTP5s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Nov 2020 10:57:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:51674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbgKTP5s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Nov 2020 10:57:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605887866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=UQkCnZRDJS+wptwiGgPtbCdODgKK2DnkK+A8cqjhXNo=;
        b=dk6jO/M4v3mpibvw1wP9fuGEd4phn0zpOaJwfyFmw32YhDBpk4JC6PT/DtrOT2hyfwQFhg
        VcwiFFb9/dKmQ9oPr7Y2oJXywmC7/EZYTnZQgX8x59t8CHYWIKBlfGcFs0M4e/ydqS43aZ
        BPbkl6dhEUYdu9EsYmn7CS0U3v3yV7k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A96C1AB3D;
        Fri, 20 Nov 2020 15:57:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EA136DA6E1; Fri, 20 Nov 2020 16:55:59 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: add missing returns after data_ref alignment checks
Date:   Fri, 20 Nov 2020 16:55:58 +0100
Message-Id: <20201120155558.29684-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are sectorsize alignment checks that are reported but then
check_extent_data_ref continues. This was not intended, wrong alignment
is not a minor problem and we should return with error.

CC: stable@vger.kernel.org # 5.4+
Fixes: 0785a9aacf9d ("btrfs: tree-checker: Add EXTENT_DATA_REF check")
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-checker.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 1b27242a9c0b..f3f666b343ef 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1424,6 +1424,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 	"invalid item size, have %u expect aligned to %zu for key type %u",
 			    btrfs_item_size_nr(leaf, slot),
 			    sizeof(*dref), key->type);
+		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(key->objectid, leaf->fs_info->sectorsize)) {
 		generic_err(leaf, slot,
@@ -1452,6 +1453,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 			extent_err(leaf, slot,
 	"invalid extent data backref offset, have %llu expect aligned to %u",
 				   offset, leaf->fs_info->sectorsize);
+			return -EUCLEAN;
 		}
 	}
 	return 0;
-- 
2.25.0

