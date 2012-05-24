Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2EXRMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 13:12:12 -0400
Received: by pbbrp8 with SMTP id rp8so521015pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2012 10:12:12 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 24 May 2012 19:12:11 +0200
Message-ID: <CAB9VWqAcuCSE8=Kr6+P6vUPjY4TXNmz7ExHhQYSge=jcCoC+8A@mail.gmail.com>
Subject: [BUG] atime on ro snapshots is updated when it should not
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

if a snapshot was created with -r and thus is read only, accessing
files in it will update the atime. I would expect that atime is not
updated on ro snapshots.

I tried to find out where the ro check is missing. The problem seems
to be that the vfs is only checking the mount, super block and
i_flags.
As it has no clue about subvolumes, it never checks them. My temporary
solution for me to continue working is atm the patch at the end of
this mail.
Is anyone with more vfs experience able to fix this in a better way?

Thanks,
Alex.

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3524978..6f126e0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -115,6 +115,10 @@ void btrfs_update_iflags(struct inode *inode)
                inode->i_flags |= S_NOATIME;
        if (ip->flags & BTRFS_INODE_DIRSYNC)
                inode->i_flags |= S_DIRSYNC;
+
+       if (btrfs_root_readonly(ip->root)) {
+               inode->i_flags |= S_NOATIME;
+       }
 }
