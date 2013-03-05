Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:33298 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3CEL7I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2013 06:59:08 -0500
Message-ID: <5135DE09.4080605@giantdisaster.de>
Date: Tue, 05 Mar 2013 12:59:05 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>, zab@redhat.com
Subject: Re: [BUG] during balance operation, WARNING: at fs/btrfs/relocation.c:1624
 replace_file_extents+0x74b/0x7e0 [btrfs]()
References: <5134D8D7.9000501@giantdisaster.de> <20130304193137.GA30680@shiny.masoncoding.com>
In-Reply-To: <20130304193137.GA30680@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 4 Mar 2013 14:31:37 -0500, Chris Mason wrote:
> On Mon, Mar 04, 2013 at 10:24:39AM -0700, Stefan Behrens wrote:
>> Just ran the following command sequence and got lots of WARNINGs.
>> The issue is reproducible.
>> The box was running the cmason/for-linus that made it into Linux 3.9 RC1.
>>
>> #!/bin/sh
>> mkfs.btrfs -f /dev/sdl /dev/sdk -m raid1 -d raid1 -l 16384
>> mount /dev/sdl /mnt
>> dd if=/dev/urandom of=/mnt/urandom.1GB bs=10M count=100 &
>> dd if=/dev/zero of=/mnt/zero.4GB bs=10M count=400 &
>> (cd ~/kernel-src; tar cf - fs) | (cd /mnt && tar xf -)
>> wait
>>
>> ((cd ~/kernel-src; tar cf - drivers) | (cd /mnt && tar xf -)) &
>> sleep 5
>> btrfs fi balance start /mnt
> 
> This doesn't look new, are you able to trigger it with an older kernel?
> 

git bisect identifies the following post v3.8 commit to be the one:

commit 24542bf7ea5e4fdfdb5157ff544c093fa4dcb536
Author: Zach Brown <zab@redhat.com>
Date:   Fri Nov 16 00:04:43 2012 +0000

    btrfs: limit fallocate extent reservation to 256MB

    Very large fallocate requests are cpu bound and result in extents with a
    repeating pattern of ever decreasing size:
    
    $ time fallocate -l 1T file
    real	0m13.039s
    
    ( an excerpt of the extents from btrfs-debug-tree: )
      prealloc data disk byte 1536292564992 nr 397312
      prealloc data disk byte 1536292962304 nr 196608
      prealloc data disk byte 1536293158912 nr 98304
      prealloc data disk byte 1536293257216 nr 49152
      prealloc data disk byte 1536293306368 nr 24576
      prealloc data disk byte 1536293330944 nr 12288
      prealloc data disk byte 1536293343232 nr 8192
      prealloc data disk byte 1536293351424 nr 4096
      prealloc data disk byte 1536293355520 nr 4096
      prealloc data disk byte 1536293359616 nr 4096
    
    The excessive cpu use comes from __btrfs_prealloc_file_range() trying to
    allocate the entire remaining size after each extent is allocated.
    btrfs_reserve_extent() repeatedly cuts this requested size in half until
    it gets down to the size that the allocators can return.  We limit the
    problem for now by capping each reservation at 256 meg.
    
    The small extents come from a masking bug when decreasing the requested
    reservation size.  The high 32bits are cleared and the remaining low
    bits might happen to reserve a small size.   Fix this by using
    round_down() which properly casts the mask.
    
    After these fixes huge fallocate requests are fast and result in nice
    large extents:
    
    $ time fallocate -l 1T file
    real	0m0.082s
    
      prealloc data disk byte 1112425889792 nr 268435456
      prealloc data disk byte 1112694325248 nr 268435456
      prealloc data disk byte 1112962760704 nr 268435456
    
    Reported-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Zach Brown <zab@redhat.com>
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b3ecca4..d2b3a5e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6143,7 +6143,7 @@ again:
 	if (ret == -ENOSPC) {
 		if (!final_tried) {
 			num_bytes = num_bytes >> 1;
-			num_bytes = num_bytes & ~(root->sectorsize - 1);
+			num_bytes = round_down(num_bytes, root->sectorsize);
 			num_bytes = max(num_bytes, min_alloc_size);
 			if (num_bytes == min_alloc_size)
 				final_tried = true;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4e6a11c..3bc62b1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7894,8 +7894,9 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			}
 		}
 
-		ret = btrfs_reserve_extent(trans, root, num_bytes, min_size,
-					   0, *alloc_hint, &ins, 1);
+		ret = btrfs_reserve_extent(trans, root,
+					   min(num_bytes, 256ULL * 1024 * 1024),
+					   min_size, 0, *alloc_hint, &ins, 1);
 		if (ret) {
 			if (own_trans)
 				btrfs_end_transaction(trans, root);


