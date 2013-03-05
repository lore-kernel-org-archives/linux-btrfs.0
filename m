Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52743 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3CEQkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2013 11:40:21 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 313C19A067A
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 09:40:21 -0700 (MST)
Date: Tue, 5 Mar 2013 11:40:18 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Chris Mason <clmason@fusionio.com>
CC: Stefan Behrens <sbehrens@giantdisaster.de>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>
Subject: Re: [BUG] during balance operation, WARNING: at
 fs/btrfs/relocation.c:1624 replace_file_extents+0x74b/0x7e0 [btrfs]()
Message-ID: <20130305164018.GH30680@shiny.masoncoding.com>
References: <5134D8D7.9000501@giantdisaster.de>
 <20130304193137.GA30680@shiny.masoncoding.com>
 <5135DE09.4080605@giantdisaster.de>
 <20130305151121.GE30680@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130305151121.GE30680@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 05, 2013 at 08:11:21AM -0700, Chris Mason wrote:
> inux 3.9 RC1.
> > >>
> > >> #!/bin/sh
> > >> mkfs.btrfs -f /dev/sdl /dev/sdk -m raid1 -d raid1 -l 16384
> > >> mount /dev/sdl /mnt
> > >> dd if=/dev/urandom of=/mnt/urandom.1GB bsM count0 &
> > >> dd if=/dev/zero of=/mnt/zero.4GB bsM count@0 &
> > >> (cd ~/kernel-src; tar cf - fs) | (cd /mnt && tar xf -)
> > >> wait
> > >>
> > >> ((cd ~/kernel-src; tar cf - drivers) | (cd /mnt && tar xf -)) &
> > >> sleep 5
> > >> btrfs fi balance start /mnt
> > >
> > > This doesn't look new, are you able to trigger it with an older kernel?
> > >
> >
> > git bisect identifies the following post v3.8 commit to be the one:
> 
> Is your dd running fallocate?  Trying to figure out how this is related.

So the preallocation came from balance, which is preallocating because
it requires us to make an extent exactly the same size as the one we are
replacing.

Zach's commit broke that rule, which means I finally get to send him a
tshirt to celebrate his first btrfs bug.

Looking through all other callers, min_bytes is always either the sector
size or the total allocation requested, so I've done this and pushed it
to for-linus.

Stefan, many thanks for bisecting and testing the patch.

commit 154ea2893002618bc3f9a1e2d8186c65490968b1
Author: Chris Mason <chris.mason@fusionio.com>
Date:   Tue Mar 5 11:11:26 2013 -0500

    Btrfs: enforce min_bytes parameter during extent allocation
    
    Commit 24542bf7ea5e4fdfdb5157ff544c093fa4dcb536 changed preallocation of
    extents to cap the max size we try to allocate.  It's a valid change,
    but the extent reservation code is also used by balance, and that
    can't tolerate a smaller extent being allocated.
    
    __btrfs_prealloc_file_range already has a min_size parameter, which is
    used by relocation to request a specific extent size.  This commit
    adds an extra check to enforce that minimum extent size.
    
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>
    Reported-by: Stefan Behrens <sbehrens@giantdisaster.de>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ecd9c4c..13ab4de 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8502,6 +8502,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	struct btrfs_key ins;
 	u64 cur_offset = start;
 	u64 i_size;
+	u64 cur_bytes;
 	int ret = 0;
 	bool own_trans = true;
 
@@ -8516,8 +8517,9 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			}
 		}
 
-		ret = btrfs_reserve_extent(trans, root,
-					   min(num_bytes, 256ULL * 1024 * 1024),
+		cur_bytes = min(num_bytes, 256ULL * 1024 * 1024);
+		cur_bytes = max(cur_bytes, min_size);
+		ret = btrfs_reserve_extent(trans, root, cur_bytes,
 					   min_size, 0, *alloc_hint, &ins, 1);
 		if (ret) {
 			if (own_trans)
