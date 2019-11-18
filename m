Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9D0C432C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 22:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07AB722309
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 22:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKRWgS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 17:36:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:44794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfKRWgR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Nov 2019 17:36:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5BB3DACE3;
        Mon, 18 Nov 2019 22:36:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B94C6DAB3A; Mon, 18 Nov 2019 23:36:17 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: get bdev directly from fs_devices in submit_extent_page
Date:   Mon, 18 Nov 2019 23:36:15 +0100
Message-Id: <20191118223615.12236-1-dsterba@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is preparatory patch to remove @bdev parameter from
submit_extent_page. It can't be removed completely, because the cgroups
need it for wbc when initializing the bio

wbc_init_bio
  bio_associate_blkg_from_css
    dereference bdev->bi_disk->queue

The bdev pointer is the same as latest_bdev, thus no functional change.
We can retrieve it from fs_devices that's reachable through several
dereferences. The local variable shadows the parameter, but that's only
temporary.

Signed-off-by: David Sterba <dsterba@suse.com>
---

This is a prerequisite for patchset to avoid crash when cgroups are
enabled

https://lore.kernel.org/linux-btrfs/cover.1570474492.git.dsterba@suse.com/

 fs/btrfs/extent_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ceb3c028894e..9a2339a54a9d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2987,13 +2987,16 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 	}
 
 	bio = btrfs_bio_alloc(offset);
-	bio_set_dev(bio, bdev);
 	bio_add_page(bio, page, page_size, pg_offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
 	bio->bi_write_hint = page->mapping->host->i_write_hint;
 	bio->bi_opf = opf;
 	if (wbc) {
+		struct block_device *bdev;
+
+		bdev = BTRFS_I(page->mapping->host)->root->fs_info->fs_devices->latest_bdev;
+		bio_set_dev(bio, bdev);
 		wbc_init_bio(wbc, bio);
 		wbc_account_cgroup_owner(wbc, page, page_size);
 	}
-- 
2.24.0

