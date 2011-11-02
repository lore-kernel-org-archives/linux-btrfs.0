From: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3] btrfs: do not allow mounting non-subvolumes via subvol option
Date: Wed,  2 Nov 2011 17:41:25 +0100
Message-ID: <1320252085-22859-1-git-send-email-dsterba@suse.cz>
References: <1317296669-27570-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317296669-27570-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

There's a missing test whether the path passed to subvol=path option
during mount is a real subvolume, allowing any directory located in
default subovlume to be passed and accepted for mount.

(current btrfs progs prevent this early)
$ btrfs subvol snapshot . p1-snap
ERROR: '.' is not a subvolume

(with "is subvolume?" test bypassed)
$ btrfs subvol snapshot . p1-snap
Create a snapshot of '.' in './p1-snap'

$ btrfs subvol list -p .
ID 258 parent 5 top level 5 path subvol
ID 259 parent 5 top level 5 path subvol1
ID 260 parent 5 top level 5 path default-subvol1
ID 262 parent 5 top level 5 path p1/p1-snapshot
ID 263 parent 259 top level 5 path subvol1/subvol1-snap

The problem I see is that this makes a false impression of snapshotting the
given subvolume but in fact snapshots the default one: a user expects outcome
like ID 263 but in fact gets ID 262 .

This patch makes mount fail with EINVAL with a message in syslog.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
v2->v3: dropped unused setting of error variable

branch with v3: hotfixes-20111102/josef/for-chris in my repo

 fs/btrfs/super.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 29eecbb..e149d8b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -741,6 +741,16 @@ static int btrfs_set_super(struct super_block *s, void *data)
 }
 
 /*
+ * subvolumes are identified by ino 256
+ */
+static inline int is_subvolume_inode(struct inode *inode)
+{
+	if (inode && inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+		return 1;
+	return 0;
+}
+
+/*
  * This will strip out the subvol=%s argument for an argument string and add
  * subvolid=0 to make sure we get the actual tree root for path walking to the
  * subvol we want.
@@ -843,6 +853,14 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 	if (error)
 		return ERR_PTR(error);
 
+	if (!is_subvolume_inode(path.dentry->d_inode)) {
+		path_put(&path);
+		mntput(mnt);
+		printk(KERN_ERR "btrfs: '%s' is not a valid subvolume\n",
+				subvol_name);
+		return ERR_PTR(-EINVAL);
+	}
+
 	/* Get a ref to the sb and the dentry we found and return it */
 	s = path.mnt->mnt_sb;
 	atomic_inc(&s->s_active);
-- 
1.7.6

