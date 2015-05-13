Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zinan.dashjr.org ([192.3.11.21]:46751 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbbEMRZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 13:25:52 -0400
From: Luke Dashjr <luke@dashjr.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Date: Wed, 13 May 2015 17:15:26 +0000
Cc: stable@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201505131715.27483.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

32-bit ioctl uses these rather than the regular FS_IOC_* versions. They can be 
handled in btrfs using the same code. Without this, 32-bit {ch,ls}attr fail.

Signed-off-by: Luke Dashjr <luke-jr+git@utopios.org>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c65..31af093 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5225,10 +5225,13 @@ long btrfs_ioctl(struct file *file, unsigned int
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
+	case FS_IOC32_GETFLAGS:
 		return btrfs_ioctl_getflags(file, argp);
 	case FS_IOC_SETFLAGS:
+	case FS_IOC32_SETFLAGS:
 		return btrfs_ioctl_setflags(file, argp);
 	case FS_IOC_GETVERSION:
+	case FS_IOC32_GETVERSION:
 		return btrfs_ioctl_getversion(file, argp);
 	case FITRIM:
 		return btrfs_ioctl_fitrim(file, argp);
-- 
2.0.5

