Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab2IGL47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Sep 2012 07:56:59 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 894ACA0FED
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2012 13:56:57 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [RFC inside][PATCH] btrfs: allow setting NOCOW for a zero sized file via ioctl
Date: Fri,  7 Sep 2012 13:56:55 +0200
Message-Id: <1347019015-3215-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the patch si simple, but it has user visible impact and I'm not quite sure how
to resolve it.

In short, $subj says it, chattr -C supports it and we want to use it.

The conditions that acutally allow to change the NOCOW flag are clear. What if
I try to set the flag on a file that is not empty? Options:

1) whole ioctl will fail, EINVAL
2.1) ioctl will succeed, the NOCOW flag will be silently removed, but the file
     will stay COW-ed and checksummed
2.2) ioctl will succeed, flag will not be removed and a syslog message will
     warn that the COW flag has not been changed
2.2.1) dtto, no syslog message

Man page of chattr states that

 "If it is set on a file which already has data blocks, it is undefined when
 the blocks assigned to the file will be fully stable."

Yes, it's undefined and with current implementation it'll never happen. So from
this end, the user cannot expect anything. I'm trying to find a reasonable
behaviour, so that a command like 'chattr -R -aijS +C' to tweak a broad set of
flags in a deep directory does not fail unnecessarily and does not pollute the
log.

My personal preference is 2.2.1, but my dev's oppinion is skewed, not counting
the fact that I know the code and otherwise would look there before consulting
the documentation.

The patch implements 2.2.1.


david

-------------8<-------------------
From: David Sterba <dsterba@suse.cz>

It's safe to turn off checksums for a zero sized file.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/18030

"We cannot switch on NODATASUM for a file that already has extents that
are checksummed. The invariant here is that either all the extents or
none are checksummed.

Theoretically it's possible to add/remove all checksums from a given
file, but it's a potentially longtime operation, the file has to be in
some intermediate state where the checksums partially exist but have to
be ignored (for the csum->nocsum) until the file is fully converted,
this brings more special cases to extent handling, it has to survive
power failure and remain consistent, and probably needs to be restarted
after next mount."

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 00ff333..a6005d5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -182,6 +182,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	int ret;
 	u64 ip_oldflags;
 	unsigned int i_oldflags;
+	umode_t mode;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
@@ -204,6 +205,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	ip_oldflags = ip->flags;
 	i_oldflags = inode->i_flags;
+	mode = inode->i_mode;
 
 	flags = btrfs_mask_flags(inode->i_mode, flags);
 	oldflags = btrfs_flags_to_ioctl(ip->flags);
@@ -238,10 +240,31 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ip->flags |= BTRFS_INODE_DIRSYNC;
 	else
 		ip->flags &= ~BTRFS_INODE_DIRSYNC;
-	if (flags & FS_NOCOW_FL)
-		ip->flags |= BTRFS_INODE_NODATACOW;
-	else
-		ip->flags &= ~BTRFS_INODE_NODATACOW;
+	if (flags & FS_NOCOW_FL) {
+		if (S_ISREG(mode)) {
+			/*
+			 * It's safe to turn csums off here, no extents exist.
+			 * Otherwise we want the flag to reflect the real COW
+			 * status of the file and will not set it.
+			 */
+			if (inode->i_size == 0)
+				ip->flags |= BTRFS_INODE_NODATACOW
+					   | BTRFS_INODE_NODATASUM;
+		} else {
+			ip->flags |= BTRFS_INODE_NODATACOW;
+		}
+	} else {
+		/*
+		 * Revert back under same assuptions as above
+		 */
+		if (S_ISREG(mode)) {
+			if (inode->i_size == 0)
+				ip->flags &= ~(BTRFS_INODE_NODATACOW
+				             | BTRFS_INODE_NODATASUM);
+		} else {
+			ip->flags &= ~BTRFS_INODE_NODATACOW;
+		}
+	}
 
 	/*
 	 * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
-- 
1.7.9

