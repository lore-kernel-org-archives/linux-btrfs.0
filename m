From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 00/21] Btrfs: restriper
Date: Tue, 10 Jan 2012 20:31:06 +0200
Message-ID: <20120110183106.GA13519@zambezi.lan>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
 <CAAdM645+sZ-z1T5==M9S_GBJ1R2h=8fwtx57uvXxWkFR=VtReg@mail.gmail.com>
 <20120109134418.GA10425@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120109134418.GA10425@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 09, 2012 at 03:44:18PM +0200, Ilya Dryomov wrote:
> On Mon, Jan 09, 2012 at 01:50:34AM -0500, Marios Titas wrote:
> > I tried this for many different scenarios and it seems to work pretty
> > well. I only ran into one problematic case: If you remove a device
> > from a multidevice filesystem it crashes. Here's how to reproduce it:
> > 
> > truncate -s1g /tmp/test1
> > truncate -s1g /tmp/test2
> > losetup /dev/loop1 /tmp/test1
> > losetup /dev/loop2 /tmp/test2
> > mkdir /tmp/test
> > ./mkfs.btrfs -L test -d single -m single /dev/loop1 /dev/loop2
> > mount -o noatime /dev/loop1 /tmp/test
> > ./btrfs dev del /dev/loop1 /tmp/test
> > ./btrfs fi bal start /tmp/test
> > 
> > There is no actual restriping involved but the above example does work
> > corretly under 3.1+for-linus whereas it fails with your patches.
> 
> Thanks for your testing.  The good news is that I put that BUG() there
> simply for debugging so it's nothing major:
> 
> 2520                    if (ret)
> 2521                            BUG(); /* FIXME break ? */
> 
> It used to be just a break out of the loop there, so that's the reason
> it doesn't panic with 3.1+for-linus.  I'll investigate further and fix
> this.

I force-rebased my tree, removed two other BUG_ONs along with this one.

Thanks,

		Ilya



diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d7c5c7d..9b3d03d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2312,7 +2312,8 @@ static int chunk_drange_filter(struct extent_buffer *leaf,
 	int factor;
 	int i;
 
-	BUG_ON(!(bargs->flags & BTRFS_BALANCE_ARGS_DEVID));
+	if (!(bargs->flags & BTRFS_BALANCE_ARGS_DEVID))
+		return 0;
 
 	if (btrfs_chunk_type(leaf, chunk) & (BTRFS_BLOCK_GROUP_DUP |
 	     BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10))
@@ -2355,7 +2356,8 @@ static int chunk_vrange_filter(struct extent_buffer *leaf,
 static int chunk_soft_convert_filter(u64 chunk_profile,
 				     struct btrfs_balance_args *bargs)
 {
-	BUG_ON(!(bargs->flags & BTRFS_BALANCE_ARGS_CONVERT));
+	if (!(bargs->flags & BTRFS_BALANCE_ARGS_CONVERT))
+		return 0;
 
 	chunk_profile &= BTRFS_BLOCK_GROUP_PROFILE_MASK;
 
@@ -2518,7 +2520,7 @@ again:
 		ret = btrfs_previous_item(chunk_root, path, 0,
 					  BTRFS_CHUNK_ITEM_KEY);
 		if (ret)
-			BUG(); /* FIXME break ? */
+			break;
 
 		leaf = path->nodes[0];
 		slot = path->slots[0];

