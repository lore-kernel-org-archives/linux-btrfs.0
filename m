Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92766C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB1122419
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CB1122419
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbeKNXis (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:38:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:52914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728116AbeKNXis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:38:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7DC35B0E2
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:35:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 6/6] btrfs: unconditionally provide function prototypes from free-space-tree.h
Date:   Wed, 14 Nov 2018 14:35:20 +0100
Message-Id: <20181114133520.16069-7-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181114133520.16069-1-jthumshirn@suse.de>
References: <20181114133520.16069-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently the function prototypes of:
* search_free_space_info()
* convert_free_space_to_bitmaps()
* convert_free_space_to_extents()
* free_space_test_bit()
* __remove_from_free_space_tree()
* __add_to_free_space_tree()
are hidden behind CONFIG_BTRFS_FS_RUN_SANITY_TESTS.

If CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set, these functions are only
used within free-space-tree.c so technically there would be no need to provide
the function prototypes. But when CONFIG_BTRFS_FS_RUN_SANITY_TESTS they are
also used from tests/free-space-tree-tests.c which explains the need for
the function prototypes and the non-static declaration of the functions.

When compiling with -Wmissing-prototypes and
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=n gcc emits a warning for each of these
functions, so remove the ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS guard to
make the compiler happy when running 'make W=1'.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/free-space-tree.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 3133651d7d70..0f4db2ad68c8 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -27,7 +27,6 @@ int add_to_free_space_tree(struct btrfs_trans_handle *trans,
 int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 				u64 start, u64 size);
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct btrfs_free_space_info *
 search_free_space_info(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
@@ -47,6 +46,5 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 				  struct btrfs_path *path);
 int free_space_test_bit(struct btrfs_block_group_cache *block_group,
 			struct btrfs_path *path, u64 offset);
-#endif
 
 #endif
-- 
2.16.4

