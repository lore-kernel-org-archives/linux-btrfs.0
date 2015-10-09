Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:61395 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbbJIAht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 20:37:49 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id t990blKM022751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 09:37:47 +0900 (JST)
From: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: fix waitqueue_active without memory barrier in btrfs
Date: Fri, 9 Oct 2015 00:35:48 +0000
Message-ID: <17EC94B0A072C34B8DCF0D30AD16044A02874794@BPXM09GP.gisp.nec.co.jp>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_bio_counter_sub() seems to be missing a memory barrier which might
cause the waker to not notice the waiter and miss sending a wake_up as
in the following figure.

	btrfs_bio_counter_sub			btrfs_rm_dev_replace_blocked
------------------------------------------------------------------------
if (waitqueue_active(&fs_info->replace_wait))
/* The CPU might reorder the test for
   the waitqueue up here, before
   prior writes complete */
					/* wait_event */
					 /* __wait_event */
					  /* ___wait_event */
					  long __int = prepare_to_wait_event(&wq,
					    &__wait, state);
					  if (!percpu_counter_sum(&fs_info->bio_counter))
percpu_counter_sub(&fs_info->bio_counter,
  amount);
					  schedule()
------------------------------------------------------------------------

This patch removes the call to waitqueue_active() leaving just wake_up()
behind.  This fixes the problem because the call to spin_lock_irqsave()
in wake_up() will be an ACQUIRE operation.

I found this issue when I was looking through the linux source code
for places calling waitqueue_active() before wake_up*(), but without
preceding memory barriers, after sending a patch to fix a similar
issue in drivers/tty/n_tty.c  (Details about the original issue can be
found here: https://lkml.org/lkml/2015/9/28/849).

Signed-off-by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
---
 fs/btrfs/dev-replace.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e54dd59..ecb3e71 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -918,9 +918,7 @@ void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
 void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
 {
 	percpu_counter_sub(&fs_info->bio_counter, amount);
-
-	if (waitqueue_active(&fs_info->replace_wait))
-		wake_up(&fs_info->replace_wait);
+	wake_up(&fs_info->replace_wait);
 }
 
 void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
-- 
1.7.1
