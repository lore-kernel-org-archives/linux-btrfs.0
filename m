From: Josef Bacik <josef@redhat.com>
Subject: Re: [2.6.35-rc6 patch] direct I/O submission fixes
Date: Sun, 25 Jul 2010 10:42:24 -0400
Message-ID: <20100725144224.GA21910@dhcp231-156.rdu.redhat.com>
References: <AANLkTinGy=mJjXJZ1YmmpHKsvL0E6O0kn2pSPBcQ5mcP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinGy=mJjXJZ1YmmpHKsvL0E6O0kn2pSPBcQ5mcP@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 24, 2010 at 12:01:59AM +0100, Daniel J Blueman wrote:
> Hi Chris,
> 
> This fixes some issues relating to direct I/O submission, however a
> further patch will be needed to handle the case where allocation of
> 'dip' fails, which is always dereferenced when finding the ordered
> extent.
>

Hi,

There's an easier way to do this.  This patch should fix the problem,

Signed-off-by: Josef Bacik <josef@redhat.com>
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3232945..7259ef9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5815,7 +5815,7 @@ free_ordered:
 	if (write) {
 		struct btrfs_ordered_extent *ordered;
 		ordered = btrfs_lookup_ordered_extent(inode,
-						      dip->logical_offset);
+						      file_offset);
 		if (!test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags) &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
 			btrfs_free_reserved_extent(root, ordered->start,
