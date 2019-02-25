Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE123C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 16:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CE612083D
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 16:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="lGu3WHTh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfBYQOt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 11:14:49 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36175 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbfBYQOt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 11:14:49 -0500
Received: by mail-qk1-f195.google.com with SMTP id c2so4903582qkb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 08:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=3b9KJrOIMlLwY9uYT/4oovJQxbLY2sTHfG5p2JaXMJI=;
        b=lGu3WHThuDnIpBAViq4KbDuJYcFF5b20TTi/SIWAf1FFTVDSCpntvEbbJnTInCvvJ4
         M6m61AMFh7M2MVJHYUqCZ3LCRfjWWyUNB+501c56eQgNeaLvroaEwmCgAmT0z+2JhISJ
         56Pl7Xvu5eGRDztCW0EBTLI/SWkLhpaBDFUDmsKa/XNlQMir2eqiCBYUpbWA05M0XKiY
         nMaQthpC3ufG//J3JoF7vO3hS4RQoTzl5ySru48hTLg/DzkEKnwdIAGaCqiI599uFFIE
         f7+N+6dq1U/E4ACBBIv8fdSWk0h+DW8+nbDM9YomWj1uwduh79DRy26V5JwLeg/HVoeR
         zFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=3b9KJrOIMlLwY9uYT/4oovJQxbLY2sTHfG5p2JaXMJI=;
        b=PTct5H7HapdTEvEi9d2/4QCokBNts/DRDLauk9pSc8fothaqzGzwgzDdfmrt2qm0Lb
         PnEX2o3czQ8QPxo02dSCVffmu+jhHz7k7vQxnBdiIjYj5e2hPDNX4W7lwTgS70pGQkEy
         XE5J45ZYKnifINLOQ+8d56Avu8h9waFwjzC8R2hTNvsKofaYyFfOX1Gbr6qsfcjTBvMM
         1mcmUKyK38bd/h/XZvB6CmH7eBXMWqYIkABElklUIuql2udLYUBhK4FyVApo6anf55e/
         sgLyti15JAvL0ehVtafFG2vE4aivJzFSE7gGo1UMHcthgxzNoIv4zWKyzrYMYkydyKuW
         kbjQ==
X-Gm-Message-State: AHQUAuYYDpkyMtiYZ4S/PT87vPzheBTuuKP0VOuFI+JK2VIa1GZG7b4r
        kByLL1+M5xvbEOC8qya9GV1dSDQGGd4=
X-Google-Smtp-Source: AHgI3IZECDFpqIuWedYMuug5pAETT8MXf2bENzyK9lf2+sSxaZ1NTkV1RnJ8R8d+IzWVn/BMJPvrxQ==
X-Received: by 2002:a37:7d86:: with SMTP id y128mr1028611qkc.36.1551111287252;
        Mon, 25 Feb 2019 08:14:47 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o2sm7148207qtf.46.2019.02.25.08.14.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 08:14:46 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH][RFC] btrfs: fix relocation panic
Date:   Mon, 25 Feb 2019 11:14:45 -0500
Message-Id: <20190225161445.2025-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We've been seeing the following sporadically throughout our fleet

panic: kernel BUG at fs/btrfs/relocation.c:4584!
netversion: 5.0-0
Backtrace:
 #0 [ffffc90003adb880] machine_kexec at ffffffff81041da8
 #1 [ffffc90003adb8c8] __crash_kexec at ffffffff8110396c
 #2 [ffffc90003adb988] crash_kexec at ffffffff811048ad
 #3 [ffffc90003adb9a0] oops_end at ffffffff8101c19a
 #4 [ffffc90003adb9c0] do_trap at ffffffff81019114
 #5 [ffffc90003adba00] do_error_trap at ffffffff810195d0
 #6 [ffffc90003adbab0] invalid_op at ffffffff81a00a9b
    [exception RIP: btrfs_reloc_cow_block+692]
    RIP: ffffffff8143b614  RSP: ffffc90003adbb68  RFLAGS: 00010246
    RAX: fffffffffffffff7  RBX: ffff8806b9c32000  RCX: ffff8806aad00690
    RDX: ffff880850b295e0  RSI: ffff8806b9c32000  RDI: ffff88084f205bd0
    RBP: ffff880849415000   R8: ffffc90003adbbe0   R9: ffff88085ac90000
    R10: ffff8805f7369140  R11: 0000000000000000  R12: ffff880850b295e0
    R13: ffff88084f205bd0  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffc90003adbbb0] __btrfs_cow_block at ffffffff813bf1cd
 #8 [ffffc90003adbc28] btrfs_cow_block at ffffffff813bf4b3
 #9 [ffffc90003adbc78] btrfs_search_slot at ffffffff813c2e6c

The way relocation moves data extents is by creating a reloc inode and
preallocating extents in this inode and then copying the data into these
preallocated extents.  Once we've done this for all of our extents,
we'll write out these dirty pages, which marks the extent written, and
goes into btrfs_reloc_cow_block().  From here we get our current
reloc_control, which _should_ match the reloc_control for the current
block group we're relocating.

However if we get an ENOSPC in this path at some point we'll bail out,
never initiating writeback on this inode.  Not a huge deal, unless we
happen to be doing relocation on a different block group, and this block
group is now rc->stage == UPDATE_DATA_PTRS.  This trips the BUG_ON() in
btrfs_reloc_cow_block(), because we expect to be done modifying the data
inode.  We are in fact done modifying the metadata for the data inode
we're currently using, but not the one from the failed block group, and
thus we BUG_ON().

Fix this by writing out the reloc data inode always, and then breaking
out of the loop after that point to keep from tripping this BUG_ON()
later.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---

This is tricky to reproduce, it only happens on ~50 boxes a day here, and is
completely timing dependant.  I'm heading to Boston for a few days, but this is
kind of important and I need everybody to look at this and tell me if it makes
sense.  I'm trying to force the problem to happen locally, but I'm not going to
be able to put much more time into it until Thursday.

 fs/btrfs/relocation.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ddf028509931..00c3dd92f088 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4330,27 +4330,36 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 		mutex_lock(&fs_info->cleaner_mutex);
 		ret = relocate_block_group(rc);
 		mutex_unlock(&fs_info->cleaner_mutex);
-		if (ret < 0) {
+		if (ret < 0)
 			err = ret;
-			goto out;
-		}
-
-		if (rc->extents_found == 0)
-			break;
-
-		btrfs_info(fs_info, "found %llu extents", rc->extents_found);
 
+		/*
+		 * We may have gotten ENOSPC after we already dirtied some
+		 * extents.  If writeout happens while we're relocating a
+		 * different block group we could end up hitting the
+		 * BUG_ON(rc->stage == UPDATE_DATA_PTRS) in
+		 * btrfs_reloc_cow_block.  Make sure we write everything out
+		 * properly so we don't trip over this problem, and then break
+		 * out of the loop if we hit an error.
+		 */
 		if (rc->stage == MOVE_DATA_EXTENTS && rc->found_file_extent) {
 			ret = btrfs_wait_ordered_range(rc->data_inode, 0,
 						       (u64)-1);
-			if (ret) {
+			if (ret)
 				err = ret;
-				goto out;
-			}
 			invalidate_mapping_pages(rc->data_inode->i_mapping,
 						 0, -1);
 			rc->stage = UPDATE_DATA_PTRS;
 		}
+
+		if (err < 0)
+			goto out;
+
+		if (rc->extents_found == 0)
+			break;
+
+		btrfs_info(fs_info, "found %llu extents", rc->extents_found);
+
 	}
 
 	WARN_ON(rc->block_group->pinned > 0);
-- 
2.14.3

