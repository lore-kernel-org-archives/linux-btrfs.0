Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:47045 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbeGaI7z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 04:59:55 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 538EEAC01A1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 16:20:50 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 88D623286E7
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 16:20:49 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: replace: Reset on-disk dev stats value after replace
References: <cover.1533020736.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <e913d7ad-24b0-d361-9841-e15882b521fc@jp.fujitsu.com>
Date: Tue, 31 Jul 2018 16:20:21 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1533020736.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

on-disk devs stats value is updated in btrfs_run_dev_stats(),
which is called during commit transaction, if device->dev_stats_ccnt
is not zero.

Since current replace operation does not touch dev_stats_ccnt,
on-disk dev stats value is not updated. Therefore "btrfs device stats"
may return old device's value after umount/mount
(Example: See "btrfs ins dump-t -t DEV $DEV" after btrfs/100 finish).

Fix this by just increment dev_stats_ccnt in
btrfs_dev_replace_finishing() when replace is succeeded.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e2ba0419297a..d20b244623f2 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -676,6 +676,12 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	btrfs_rm_dev_replace_unblocked(fs_info);
 
+	/*
+	 * Increment dev_stats_ccnt so that btrfs_run_dev_stats() will
+	 * update on-disk dev stats value during commit transaction
+	 */
+	atomic_inc(&tgt_device->dev_stats_ccnt);
+
 	/*
 	 * this is again a consistent state where no dev_replace procedure
 	 * is running, the target device is part of the filesystem, the
-- 
2.14.4


