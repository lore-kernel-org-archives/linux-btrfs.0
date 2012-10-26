Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from col0-omc4-s13.col0.hotmail.com ([65.55.34.215]:14403 "EHLO
	col0-omc4-s13.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123Ab2JZNd1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 09:33:27 -0400
Message-ID: <COL002-W65AE07781DBE4AF850FF9FB07E0@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: Wade Cline <clinew@linux.vnet.ibm.com>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs seems to do COW while inode has NODATACOW set
Date: Fri, 26 Oct 2012 08:33:26 -0500
In-Reply-To: <5089A670.7080108@linux.vnet.ibm.com>
References: <CAOcd+r0pJB2FqxWkkoy72TsUALEKeocV6pB1-RV_je93Kv2YWA@mail.gmail.com>
 <50898BE1.4070706@linux.vnet.ibm.com>
 <CAOcd+r2U9XjvjS6bZPNXkQh1JGJxohmHyAb5CAQNySwCyV1TzA@mail.gmail.com>,<5089A670.7080108@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Wade, thanks.
> >
> > Yes, with the preallocated extent I saw the behavior you describe, and
> > it makes perfect sense to alloc a new EXTENT_DATA in this case.
> > In my case, I did another simple test:
> >
> > Before:
> > item 4 key (257 INODE_ITEM 0) itemoff 3593 itemsize 160
> > inode generation 5 transid 5 size 5368709120 nbytes 5368709120
> > owner[0:0] mode 100644
> > inode blockgroup 0 nlink 1 flags 0x3 seq 0
> > item 5 key (257 INODE_REF 256) itemoff 3578 itemsize 15
> > inode ref index 2 namelen 5 name: vol-1
> > item 6 key (257 EXTENT_DATA 0) itemoff 3525 itemsize 53
> > extent data disk byte 5368709120 nr 131072
> > extent data offset 0 nr 131072 ram 131072
> > extent compression 0
> > item 7 key (257 EXTENT_DATA 131072) itemoff 3472 itemsize 53
> > extent data disk byte 5905842176 nr 33423360
> > extent data offset 0 nr 33423360 ram 33423360
> > extent compression 0
> > ...
> >
> > I am going to do a single write of a 4Kib block into (257 EXTENT_DATA
> > 131072) extent:
> >
> > dd if=/dev/urandom of=/mnt/src/subvol-1/vol-1 bs=4096 seek=32 count=1
> > conv=notrunc
> >
> > After:
> > item 4 key (257 INODE_ITEM 0) itemoff 3593 itemsize 160
> > inode generation 5 transid 21 size 5368709120 nbytes 5368709120
> > owner[0:0] mode 100644
> > inode blockgroup 0 nlink 1 flags 0x3 seq 1
> > item 5 key (257 INODE_REF 256) itemoff 3578 itemsize 15
> > inode ref index 2 namelen 5 name: vol-1
> > item 6 key (257 EXTENT_DATA 0) itemoff 3525 itemsize 53
> > extent data disk byte 5368709120 nr 131072
> > extent data offset 0 nr 131072 ram 131072
> > extent compression 0
> > item 7 key (257 EXTENT_DATA 131072) itemoff 3472 itemsize 53
> > extent data disk byte 5368840192 nr 4096
> > extent data offset 0 nr 4096 ram 4096
> > extent compression 0
> > item 8 key (257 EXTENT_DATA 135168) itemoff 3419 itemsize 53
> > extent data disk byte 5905842176 nr 33423360
> > extent data offset 4096 nr 33419264 ram 33423360
> > extent compression 0
> >
> > We clearly see that a new extent has been allocated for some reason
> > (bytenr=5368840192), and previous extent (bytenr=5905842176) is still
> > there, but used at offset of 4096. This is exactly cow, I believe.
> Hmm, I'm pretty sure that using 'dd' in this fashion skips the first 32 4096-sized
> blocks and thus writes -past- the length of this extent (eg: writes from 131073 to
> 135168). This causes a new extent to be allocated after the previous extent.
>
> But even if using 'dd' with a 'skip' value of '31' created a new EXTENT_DATA, it
> would not necessarily be data CoW, since data CoW refers only to the location of
> the -data- (i.e., not metadata and thus not EXTENT_DATA) on disk. The key thing
> is to look at where the EXTENT_DATAs are pointing to, not how many EXTENT_DATAs
> there are.
>
> > However, your hint about not being able to read into memory may be
> > useful; it would be good if we can find the place in the code that
> > does that decision to cow.
> Try looking at the callers of btrfs_cow_block(), but you'll be own your own from
> there :)
>
> > I guess I am looking for a way to never ever allocate new EXTENT_DATAs
> > on a fully-mapped file. Is there one?
> Hmm, I don't think that this exists right now. You could try a '-o autodefrag' to
> minimize the number of EXTENT_DATAs, though.

This seems to be a start at what you're looking for:
Commit: 7e97b8daf63487c20f78487bd4045f39b0d97cf4
btrfs: allow setting NOCOW for a zero sized file via ioctl

In short, the nodatacow option won't be honored if any checksums have been assigned to any extents of a file.

>
> Regards,
> Wade
>
> >
> > Thanks!
> > Alex. 		 	   		  