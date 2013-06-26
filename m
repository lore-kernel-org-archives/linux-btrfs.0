Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab3FZTSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 15:18:07 -0400
Date: Wed, 26 Jun 2013 12:18:04 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: check if the scratch dev pool is mounted in
 _require_scratch
Message-ID: <20130626191804.GA20692@lenny.home.zabbo.net>
References: <1372261768-1795-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372261768-1795-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> $SCRATCH_DEV, so anybody who wants to just use the scratch mnt with the scratch
> dev will fail to work because we never unmount the scratch mount.

Yeah, this is annoying.

> Fix this by
> checking to see if the scratch dev pool is mounted at scratch mnt and unmount it
> so we can run our test.  This fixes the issue I was seeing by running

But this fix seems bonkers.  Can we have _scratch_unmount unmount the
mountpoint instead of the device?  That's what Eric suggested when I
whined about this a while ago.

- z

index fe6bbfc..481486a 100644
--- a/common/rc
+++ b/common/rc
@@ -280,7 +280,7 @@ _scratch_mount()
 
 _scratch_unmount()
 {
-    $UMOUNT_PROG $SCRATCH_DEV
+    $UMOUNT_PROG $SCRATCH_MNT
 }
 
 _scratch_remount()
