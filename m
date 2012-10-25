Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:50437 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992692Ab2JYUwE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:52:04 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Thu, 25 Oct 2012 14:52:04 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id AB998C40011
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 14:52:00 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q9PKq1jo238860
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 14:52:01 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q9PKq1dP018670
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 14:52:01 -0600
Message-ID: <5089A670.7080108@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2012 13:52:00 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs seems to do COW while inode has NODATACOW set
References: <CAOcd+r0pJB2FqxWkkoy72TsUALEKeocV6pB1-RV_je93Kv2YWA@mail.gmail.com> <50898BE1.4070706@linux.vnet.ibm.com> <CAOcd+r2U9XjvjS6bZPNXkQh1JGJxohmHyAb5CAQNySwCyV1TzA@mail.gmail.com>
In-Reply-To: <CAOcd+r2U9XjvjS6bZPNXkQh1JGJxohmHyAb5CAQNySwCyV1TzA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2012 12:09 PM, Alex Lyakas wrote:

> Wade, thanks.
>
> Yes, with the preallocated extent I saw the behavior you describe, and
> it makes perfect sense to alloc a new EXTENT_DATA in this case.
> In my case, I did another simple test:
>
> Before:
> 	item 4 key (257 INODE_ITEM 0) itemoff 3593 itemsize 160
> 		inode generation 5 transid 5 size 5368709120 nbytes 5368709120
> owner[0:0] mode 100644
> 		inode blockgroup 0 nlink 1 flags 0x3 seq 0
> 	item 5 key (257 INODE_REF 256) itemoff 3578 itemsize 15
> 		inode ref index 2 namelen 5 name: vol-1
> 	item 6 key (257 EXTENT_DATA 0) itemoff 3525 itemsize 53
> 		extent data disk byte 5368709120 nr 131072
> 		extent data offset 0 nr 131072 ram 131072
> 		extent compression 0
> 	item 7 key (257 EXTENT_DATA 131072) itemoff 3472 itemsize 53
> 		extent data disk byte 5905842176 nr 33423360
> 		extent data offset 0 nr 33423360 ram 33423360
> 		extent compression 0
>                  ...
>
> I am going to do a single write of a 4Kib block into (257 EXTENT_DATA
> 131072) extent:
>
> dd if=/dev/urandom of=/mnt/src/subvol-1/vol-1 bs=4096 seek=32 count=1
> conv=notrunc
>
> After:
> 	item 4 key (257 INODE_ITEM 0) itemoff 3593 itemsize 160
> 		inode generation 5 transid 21 size 5368709120 nbytes 5368709120
> owner[0:0] mode 100644
> 		inode blockgroup 0 nlink 1 flags 0x3 seq 1
> 	item 5 key (257 INODE_REF 256) itemoff 3578 itemsize 15
> 		inode ref index 2 namelen 5 name: vol-1
> 	item 6 key (257 EXTENT_DATA 0) itemoff 3525 itemsize 53
> 		extent data disk byte 5368709120 nr 131072
> 		extent data offset 0 nr 131072 ram 131072
> 		extent compression 0
> 	item 7 key (257 EXTENT_DATA 131072) itemoff 3472 itemsize 53
> 		extent data disk byte 5368840192 nr 4096
> 		extent data offset 0 nr 4096 ram 4096
> 		extent compression 0
> 	item 8 key (257 EXTENT_DATA 135168) itemoff 3419 itemsize 53
> 		extent data disk byte 5905842176 nr 33423360
> 		extent data offset 4096 nr 33419264 ram 33423360
> 		extent compression 0
>
> We clearly see that a new extent has been allocated for some reason
> (bytenr=5368840192), and previous extent (bytenr=5905842176) is still
> there, but used at offset of 4096. This is exactly cow, I believe.
Hmm, I'm pretty sure that using 'dd' in this fashion skips the first 32 4096-sized
blocks and thus writes -past- the length of this extent (eg: writes from 131073 to
135168). This causes a new extent to be allocated after the previous extent.

But even if using 'dd' with a 'skip' value of '31' created a new EXTENT_DATA, it
would not necessarily be data CoW, since data CoW refers only to the location of
the -data- (i.e., not metadata and thus not EXTENT_DATA) on disk. The key thing
is to look at where the EXTENT_DATAs are pointing to, not how many EXTENT_DATAs
there are.

> However, your hint about not being able to read into memory may be
> useful; it would be good if we can find the place in the code that
> does that decision to cow.
Try looking at the callers of btrfs_cow_block(), but you'll be own your own from
there :)

> I guess I am looking for a way to never ever allocate new EXTENT_DATAs
> on a fully-mapped file. Is there one?
Hmm, I don't think that this exists right now. You could try a '-o autodefrag' to
minimize the number of EXTENT_DATAs, though.

Regards,
Wade

>
> Thanks!
> Alex.

