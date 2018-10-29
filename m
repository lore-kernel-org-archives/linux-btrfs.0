Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B236AC46475
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 09:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A2A2084A
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 09:42:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTxmiPiL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76A2A2084A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbeJ2SaE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 14:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbeJ2SaE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 14:30:04 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 057DA2084A
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2018 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540806130;
        bh=R3wyu7BWnqMVeN3rV6uRj7F2Pn0zDQvvk56Qm0GPPdY=;
        h=From:To:Subject:Date:From;
        b=bTxmiPiLh78KHdBekXRnOYtatjVNMhgcm0BQDOFgdtyDzOqERkbDIkNP5BVVcyr5I
         1v3YSJUp7dr5pSFZkoyX/mgdTHhzxjoB5RIYQwDxAts7Nqco38wOuBrHo8LXJ/cDlc
         TlKBWLDs3tFD4BO+Q822V558WOscK5fV9roBL0e8=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix missing data checksums after a ranged fsync (msync)
Date:   Mon, 29 Oct 2018 09:42:06 +0000
Message-Id: <20181029094206.18079-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Recently we got a massive simplification for fsync, where for the fast
path we no longer log new extents while their respective ordered extents
are still running.

However that simplification introduced a subtle regression for the case
where we use a ranged fsync (msync). Consider the following example:

               CPU 0                                    CPU 1

                                            mmap write to range [2Mb, 4Mb[
  mmap write to range [512Kb, 1Mb[
  msync range [512K, 1Mb[
    --> triggers fast fsync
        (BTRFS_INODE_NEEDS_FULL_SYNC
         not set)
    --> creates extent map A for this
        range and adds it to list of
        modified extents
    --> starts ordered extent A for
        this range
    --> waits for it to complete

                                            writeback triggered for range
                                            [2Mb, 4Mb[
                                              --> create extent map B and
                                                  adds it to the list of
                                                  modified extents
                                              --> creates ordered extent B

    --> start looking for and logging
        modified extents
    --> logs extent maps A and B
    --> finds checksums for extent A
        in the csum tree, but not for
        extent B
  fsync (msync) finishes

                                              --> ordered extent B
                                                  finishes and its
                                                  checksums are added
                                                  to the csum tree

                                <power cut>

After replaying the log, we have the extent covering the range [2Mb, 4Mb[
but do not have the data checksum items covering that file range.

This happens because at the very beginning of an fsync (btrfs_sync_file())
we start and wait for IO in the given range [512Kb, 1Mb[ and therefore
wait for any ordered extents in that range to complete before we start
logging the extents. However if right before we start logging the extent
in our range [512Kb, 1Mb[, writeback is started for any other dirty range,
such as the range [2Mb, 4Mb[ due to memory pressure or a concurrent fsync
or msync (btrfs_sync_file() starts writeback before acquiring the inode's
lock), an ordered extent is created for that other range and a new extent
map is created to represent that range and added to the inode's list of
modified extents.

That means that we will see that other extent in that list when collecting
extents for logging (done at btrfs_log_changed_extents()) and log the
extent before the respective ordered extent finishes - namely before the
checksum items are added to the checksums tree, which is where
log_extent_csums() looks for the checksums, therefore making us log an
extent without logging its checksums. Before that massive simplification
of fsync, this wasn't a problem because besides looking for checkums in
the checksums tree, we also looked for them in any ordered extent still
running.

The consequence of data checksums missing for a file range is that users
attempting to read the affected file range will get -EIO errors and dmesg
reports the following:

 [10188.358136] BTRFS info (device sdc): no csum found for inode 297 start 57344
 [10188.359278] BTRFS warning (device sdc): csum failed root 5 ino 297 off 57344 csum 0x98f94189 expected csum 0x00000000 mirror 1

So fix this by skipping an extents outside of our logging range at
btrfs_log_changed_extents() and leaving them on the list of modified
extents so that any subsequent ranged fsync may collect them if needed.
Also, if we find a hole extent outside of the range still log it, just
to prevent having gaps between extent items after replaying the log,
otherwise fsck will complain when we are not using the NO_HOLES feature
(fstest btrfs/056 triggers such case).

Fixes: e7175a692765 ("btrfs: remove the wait ordered logic in the log_one_extent path")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86c5dd100b2..d49edd25f2e5 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4394,6 +4394,23 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	test_gen = root->fs_info->last_trans_committed;
 
 	list_for_each_entry_safe(em, n, &tree->modified_extents, list) {
+		/*
+		 * Skip extents outside our logging range. It's important to do
+		 * it for correctness because if we don't ignore them, we may
+		 * log them before their ordered extent completes, and therefore
+		 * we could log them without logging their respective checksums
+		 * (the checksum items are added to the csum tree at the very
+		 * end of btrfs_finish_ordered_io()). Also leave such extents
+		 * outside of our range in the list, since we may have another
+		 * ranged fsync in the near future that needs them. If an extent
+		 * outside our range corresponds to a hole, log it to avoid
+		 * leaving gaps between extents (fsck will complain when we are
+		 * not using the NO_HOLES feature).
+		 */
+		if ((em->start > end || em->start + em->len <= start) &&
+		    em->block_start != EXTENT_MAP_HOLE)
+			continue;
+
 		list_del_init(&em->list);
 		/*
 		 * Just an arbitrary number, this can be really CPU intensive
-- 
2.11.0

