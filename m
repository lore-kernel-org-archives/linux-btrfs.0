From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Mon, 18 Aug 2008 13:10:14 +0100
Message-ID: <1219061414.3184.368.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <1218974002.3184.278.camel@pmac.infradead.org>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1219060264.3184.366.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219060264.3184.366.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 12:51 +0100, David Woodhouse wrote:
> The patch below works OK, but doesn't yet handle
> subvolumes -- it gives the same fsid for all subvolumes.

Is this the correct fix?

diff --git a/super.c b/super.c
index 6446ab7..55f4d00 100644
--- a/super.c
+++ b/super.c
@@ -503,6 +503,10 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	   on a big-endian or little-endian host */
 	buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
 	buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
+	/* Mask in the root object ID too, to disambiguate subvols */
+	buf->f_fsid.val[0] ^= BTRFS_I(dentry->d_inode)->root->objectid >> 32;
+	buf->f_fsid.val[1] ^= BTRFS_I(dentry->d_inode)->root->objectid;
+
 	return 0;
 }
 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



