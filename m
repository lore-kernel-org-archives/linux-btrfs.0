Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28075 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129AbaGQNSO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 09:18:14 -0400
Message-ID: <53C7CD0F.7070603@fb.com>
Date: Thu, 17 Jul 2014 09:18:07 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Cody P Schafer <dev@codyps.com>
CC: Chris Samuel <chris@csamuel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: Blocked tasks on 3.15.1
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>	<pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>	<3081460.dX0cLeJPhK@quad>	<CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com>	<53B1A862.50503@fb.com>	<53B1ACAA.5040505@fb.com>	<CAPoQQ-14VPzzwTDDXmLSmEUs2Rm_HyukoYjeFfOi9LOjqaRCWw@mail.gmail.com>	<53B32275.6010200@fb.com>	<CAPoQQ-3DmAg=s0eBKirGmkfMhaC1bEyJu8fSJc-6fV-EvUbmxQ@mail.gmail.com> <CAPoQQ-1kn+UNfcE4+qeO4yKaX43PenqxBtMXABuP=Ot8=ZB2Gw@mail.gmail.com> <53B40FEC.4030902@fb.com> <53B4140C.8060406@fb.com>
In-Reply-To: <53B4140C.8060406@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


[ deadlocks during rsync in 3.15 with compression enabled ]

Hi everyone,

I still haven't been able to reproduce this one here, but I'm going
through a series of tests with lzo compression foraced and every
operation forced to ordered.  Hopefully it'll kick it out soon.

While I'm hammering away, could you please try this patch.  If this is
the buy you're hitting, the deadlock will go away and you'll see this
printk in the log.

thanks!

-chris

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..8ab56df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8157,6 +8157,13 @@ void btrfs_destroy_inode(struct inode *inode)
 		spin_unlock(&root->fs_info->ordered_root_lock);
 	}
 
+	spin_lock(&root->fs_info->ordered_root_lock);
+	if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
+		list_del_init(&BTRFS_I(inode)->ordered_operations);
+printk(KERN_CRIT "racing inode deletion with ordered operations!!!!!!!!!!!\n");
+	}
+	spin_unlock(&root->fs_info->ordered_root_lock);
+
 	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 		     &BTRFS_I(inode)->runtime_flags)) {
 		btrfs_info(root->fs_info, "inode %llu still on the orphan list",
