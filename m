Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA88C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 16:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A12FC205C9
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 16:01:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="UI8zmaDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404665AbfAPQBB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:01:01 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34211 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfAPQBB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 11:01:01 -0500
Received: by mail-qt1-f194.google.com with SMTP id r14so7741337qtp.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 08:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=EPbZ8/cENnl4w46HD8KaDVKzMV4CWLMPEgTA2PYUj4I=;
        b=UI8zmaDPUx5iSoPJTzosjYuSaJqkEq/f33FafbE+34QWRE2c33yNC2JVqmKidIcpLT
         yHO+pnWOi5zpNGj6KXOYqyC3QF7wxfQdPba3SyZvkvohaZIfKPdrFx/7FkMqT0Qm6XGs
         ANyGcjq+yazcpE48cHR0XIxIN+xPS2Fwl1ymygP7ZiRuA/XyXiU9dTEmfbakRF9TVmHx
         Xl/+ImfnE9fF6pcKTiZPTFl0hLG+as0lJ47BYVtzjq4PMmYzztBy4Pbh10PXUOGffLnU
         JgzzVRxH7CuyrxtZg1l6XCsmc8GZw/4EjOcvWWfoDxQxaHO/QRlvHEMfn6/mRjYFSG+x
         YhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=EPbZ8/cENnl4w46HD8KaDVKzMV4CWLMPEgTA2PYUj4I=;
        b=f8XXi6ElaEUtAGFbaTbBDv13EPknKm0vOO+EM2D2j8hDZhDkkRk1kn4L0DV+rXI/DT
         6E5+Urvo1Wm2UD1+N8LHWXsHhKRXvW3yFvwh/kG6CDn19woYjPM35+4w8O7pOenFoeEC
         XBOZ5EPt27Jo+SHDMBTVF0r1oz4taXTN/2DwqrNUSzYLRryPnHFhxEdQWujm3fThjHg4
         vKbBXQmZ/mAqOWv0E2b9sosuiPyDSy1cFRphr6DcOGOUatKShEjHKbQrOeWHu4SYjyDV
         xsa8SVA0ki9avTdSrHz8Pne1aixkKDpSIDMcO9qqgrJ3G66WpDnPgQFb3b92jYFvkXI2
         9duw==
X-Gm-Message-State: AJcUukeArj35rsY+Iv+X+IosxKm45TkTkCl+6d42yqVN1fwHkGEaLekw
        qmgIWRSIeUwf/mY6e926pq4aV45wyyY=
X-Google-Smtp-Source: ALg8bN7hIdgIcD/o5DXDRtWpsLc5bz2JAgxQVT39nlYCuQ7NhHUsvL/0zsY/uWqNWAyUn20w04G0ow==
X-Received: by 2002:aed:22ba:: with SMTP id p55mr7423787qtc.137.1547654459786;
        Wed, 16 Jan 2019 08:00:59 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k132sm43191054qke.36.2019.01.16.08.00.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 08:00:58 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH] btrfs: honor path->skip_locking in backref code
Date:   Wed, 16 Jan 2019 11:00:57 -0500
Message-Id: <20190116160057.22040-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

qgroups will do the old roots lookup at delayed ref time, which could be
while walking down the extent root while running a delayed ref.  This
should be fine, except we specifically lock eb's in the backref walking
code irrespective of path->skip_locking, which deadlocks the system.
Fix up the backref code to honor path->skip_locking, nobody will be
modifying the commit_root when we're searching so it's completely safe
to do.  Thanks,

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/backref.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 78556447e1d5..973e8251b1bf 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -712,7 +712,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
  * read tree blocks and add keys where required.
  */
 static int add_missing_keys(struct btrfs_fs_info *fs_info,
-			    struct preftrees *preftrees)
+			    struct preftrees *preftrees, bool lock)
 {
 	struct prelim_ref *ref;
 	struct extent_buffer *eb;
@@ -737,12 +737,14 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 			free_extent_buffer(eb);
 			return -EIO;
 		}
-		btrfs_tree_read_lock(eb);
+		if (lock)
+			btrfs_tree_read_lock(eb);
 		if (btrfs_header_level(eb) == 0)
 			btrfs_item_key_to_cpu(eb, &ref->key_for_search, 0);
 		else
 			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
-		btrfs_tree_read_unlock(eb);
+		if (lock)
+			btrfs_tree_read_unlock(eb);
 		free_extent_buffer(eb);
 		prelim_ref_insert(fs_info, &preftrees->indirect, ref, NULL);
 		cond_resched();
@@ -1227,7 +1229,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
-	ret = add_missing_keys(fs_info, &preftrees);
+	ret = add_missing_keys(fs_info, &preftrees, path->skip_locking == 0);
 	if (ret)
 		goto out;
 
@@ -1288,11 +1290,13 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 					ret = -EIO;
 					goto out;
 				}
-				btrfs_tree_read_lock(eb);
+				if (!path->skip_locking)
+					btrfs_tree_read_lock(eb);
 				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie, ignore_offset);
-				btrfs_tree_read_unlock_blocking(eb);
+				if (!path->skip_locking)
+					btrfs_tree_read_unlock_blocking(eb);
 				free_extent_buffer(eb);
 				if (ret < 0)
 					goto out;
-- 
2.14.3

