From: Jim Ursetto <jim@3e8.org>
Subject: Re: dkms build error
Date: Sat, 12 Jun 2010 22:51:47 -0500
Message-ID: <20100613035147.GC16863@3e8.org>
Reply-To: Jim Ursetto <jim@3e8.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline

On Mon, 31 May 2010 09:20:22 +0200 Andreas Philipp wrote:

> I did not succeed to compile a btrfs module via dkms from btrfs-unstable...
> For the exact error message, please see the make.log...

> /var/lib/dkms/btrfs/git/build/extent-tree.c:1699: error: 
>   ‘DISCARD_FL_BARRIER’ undeclared (first use in this function)

The problem is the blkdev flag name change that occurred in this commit from
Linus' tree around 2.6.35:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fbd9b09a177a481eda256447c881f014f29034fe

which is not in btrfs-unstable.  That patch doesn't apply cleanly to the
btrfs-unstable tree so attached is one that just modifies extent-tree.c.

Jim


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrfs-extent-tree.diff.txt"

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b34d32f..c6a4f45 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1589,7 +1589,7 @@ static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			     DISCARD_FL_BARRIER);
+			BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,


--AqsLC8rIMeq19msA--
