From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] Deny sys_link across subvolumes.
Date: Thu, 12 Nov 2009 16:14:26 +0900
Message-ID: <4AFBB5D2.3060405@jp.fujitsu.com>
References: <4AEA7A07.4020006@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AEA7A07.4020006@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


From: Christian Parpart <trapni@gentoo.org>

I rebased Christian Parpart's patch to deny hard link across
subvolumes. Original patch modifies also btrfs_rename, but
I excluded it because we can move across subvolumes now and
it make no problem.
-----------------

Hard link across subvolumes should not allowed in Btrfs.
btrfs_link checks root of 'to' directory is same as root
of 'from' file. If not same, btrfs_link returns -EPERM.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 fs/btrfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78139ef..c7f66e4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4284,6 +4284,10 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink == 0)
 		return -ENOENT;

+	/* do not allow sys_link's with other subvols of the same device */
+	if (root->objectid != BTRFS_I(inode)->root->objectid)
+		return -EPERM;
+
 	/*
 	 * 1 item for inode ref
 	 * 2 items for dir items
-- 1.6.5 --
taruisi

