From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Mon, 18 Aug 2008 12:51:04 +0100
Message-ID: <1219060264.3184.366.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <1218974002.3184.278.camel@pmac.infradead.org>
	 <200808171821.43874.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200808171821.43874.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2008-08-17 at 18:21 +0530, Balaji Rao wrote:
> > Note that the first problem you'll hit is the lack of stable fsid --
> > because btrfs uses an anonymous superblock, it might cause stale file
> > handles after a reboot, unless your test setup mounts exactly the same
> > anonymous file systems each time. That bit me when I context switched
> > from something else and had debugfs mounted before btrfs, then rebooted
> > and didn't mount debugfs first. I'll deal with the fsid problem
> > separately; just be aware of it and avoid it for now.
> >
> Hmmm.. how do we deal with that ?

First we teach nfs-utils to derive a UUID from the 'f_fsid' field it's
already being given by the kernel when it calls statfs():
git.infradead.org/users/dwmw2/nfs-utils.git

Then we make btrfs put something suitable into the f_fsid field in
btrfs_statfs(). The patch below works OK, but doesn't yet handle
subvolumes -- it gives the same fsid for all subvolumes.

But then, since we're also returning the same {dev,ino#} for all
subvolumes, nfs exporting isn't the _only_ thing that's going to get
confused...

From: David Woodhouse <David.Woodhouse@intel.com>
Date: Mon, 18 Aug 2008 12:01:52 +0100
Subject: [PATCH] Fill f_fsid field in btrfs_statfs()

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/super.c b/super.c
index e830e0e..6446ab7 100644
--- a/super.c
+++ b/super.c
@@ -489,6 +489,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct btrfs_root *root = btrfs_sb(dentry->d_sb);
 	struct btrfs_super_block *disk_super = &root->fs_info->super_copy;
 	int bits = dentry->d_sb->s_blocksize_bits;
+	__be32 *fsid = (__be32 *)root->fs_info->fsid;
 
 	buf->f_namelen = BTRFS_NAME_LEN;
 	buf->f_blocks = btrfs_super_total_bytes(disk_super) >> bits;
@@ -497,6 +498,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = buf->f_bfree;
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	buf->f_type = BTRFS_SUPER_MAGIC;
+	/* We treat it as constant endianness (it doesn't matter _which_)
+	   because we want the fsid to come out the same whether mounted 
+	   on a big-endian or little-endian host */
+	buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
+	buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
 	return 0;
 }
 
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



