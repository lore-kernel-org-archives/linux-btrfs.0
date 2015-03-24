Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbbCXWCF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 18:02:05 -0400
Message-ID: <5511DEDB.9040804@redhat.com>
Date: Tue, 24 Mar 2015 17:02:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: fstests@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] fstests: fix _filter_transcation_commit_default
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs has started emitting new information from
cmd_subvol_delete(), so filter that out or it breaks btrfs/001:

    -Delete subvolume 'SCRATCH_MNT/snap'
    +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'

(Spell "transaction" correctly while we're at it.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/filter.btrfs b/common/filter.btrfs
index ea047c5..9bb6479 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -57,13 +57,14 @@ _filter_btrfs_device_stats()
 	sed -e "s/ *$NUMDEVS /<NUMDEVS> /g"
 }
 
-_filter_transcation_commit_default() {
-	sed -e "/Transaction commit: none (default)/d"
+_filter_transaction_commit() {
+	sed -e "/Transaction commit: none (default)/d" | \
+	sed -e "s/Delete subvolume (.*commit):/Delete subvolume/g"
 }
 
 _filter_btrfs_subvol_delete()
 {
-	_filter_scratch | _filter_transcation_commit_default
+	_filter_scratch | _filter_transaction_commit
 
 }
 

