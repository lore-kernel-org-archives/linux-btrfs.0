Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41393 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965239Ab2JYS6s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 14:58:48 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Thu, 25 Oct 2012 14:58:47 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 816766E8036
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 14:58:43 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q9PIwg5349414254
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 14:58:42 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q9PIwgPI015532
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 14:58:42 -0400
Message-ID: <50898BE1.4070706@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2012 11:58:41 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs seems to do COW while inode has NODATACOW set
References: <CAOcd+r0pJB2FqxWkkoy72TsUALEKeocV6pB1-RV_je93Kv2YWA@mail.gmail.com>
In-Reply-To: <CAOcd+r0pJB2FqxWkkoy72TsUALEKeocV6pB1-RV_je93Kv2YWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

Someone correct me if I am wrong, but I'm pretty sure that the purpose of
'nodatacow' is to prevent the location of extents on the disk itself from
moving, however, it may be necessary to allocate more extents in the metadata
(which I presume are represented by EXTENT_DATA) in order to do this.

For example, say you preallocated space for a 1GB file using fallocate. Then
you'd have one EXTENT_DATA to represent the entire 1GB range, say:

         item 7 key (257 EXTENT_DATA 131072) itemoff 3469 itemsize 53

Then, if you performed a single write to the middle of the 1GB file, that one,
preallocated extent would need to be broken up into three extents; one for the
preallocated area before the write, one for the written area, and the last one
for the preallocated area after the write, say:

         item 7 key (257 EXTENT_DATA 131072) itemoff 3469 itemsize 53
         item 8 key (257 EXTENT_DATA 33554432) itemoff 3416 itemsize 53
	item 9 key (257 EXTENT_DATA 67108864) itemoff 3363 itemsize 53

The main point I'm trying to make is that it may be necessary to create more
EXTENT_DATAs in order to preserve the correct on-disk location.

Since you're not using a preallocated file, I'd guess that the writes are
reading in part of a larger extent, which isn't fully read-into memory, and
then the write ends up breaking that extent into two smaller extents. You may
have better luck figuring out what's happening using the 'filefrag -v<file>'
command.

Hope this helps/answers your question.

Regards,
Wade

  
On 10/25/2012 11:35 AM, Alex Lyakas wrote:

> Hi everybody,
> I need some help understanding the nodatacow behavior.
>
> I have set up a large file (5GiB), which has very few EXTENT_DATAs
> (all are real, not bytenr=0). The file has NODATASUM and NODATACOW
> flags set (flags=0x3):
> 	item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
> 		inode generation 5 transid 5 size 5368709120 nbytes 5368709120
> owner[0:0] mode 100644
> 		inode blockgroup 0 nlink 1 flags 0x3 seq 0
> 	item 7 key (257 EXTENT_DATA 131072) itemoff 3469 itemsize 53
> 	item 8 key (257 EXTENT_DATA 33554432) itemoff 3416 itemsize 53
> 	item 9 key (257 EXTENT_DATA 67108864) itemoff 3363 itemsize 53
> 	item 10 key (257 EXTENT_DATA 67112960) itemoff 3310 itemsize 53
> 	item 11 key (257 EXTENT_DATA 67117056) itemoff 3257 itemsize 53
> 	item 12 key (257 EXTENT_DATA 67121152) itemoff 3204 itemsize 53
> 	item 13 key (257 EXTENT_DATA 67125248) itemoff 3151 itemsize 53
> 	item 14 key (257 EXTENT_DATA 67129344) itemoff 3098 itemsize 53
> 	item 15 key (257 EXTENT_DATA 67133440) itemoff 3045 itemsize 53
> 	item 16 key (257 EXTENT_DATA 67137536) itemoff 2992 itemsize 53
> 	item 17 key (257 EXTENT_DATA 67141632) itemoff 2939 itemsize 53
> 	item 18 key (257 EXTENT_DATA 67145728) itemoff 2886 itemsize 53
> 	item 19 key (257 EXTENT_DATA 67149824) itemoff 2833 itemsize 53
> 	item 20 key (257 EXTENT_DATA 67153920) itemoff 2780 itemsize 53
> 	item 21 key (257 EXTENT_DATA 67158016) itemoff 2727 itemsize 53
> 	item 22 key (257 EXTENT_DATA 67162112) itemoff 2674 itemsize 53
> 	item 23 key (257 EXTENT_DATA 67166208) itemoff 2621 itemsize 53
> 	item 24 key (257 EXTENT_DATA 67170304) itemoff 2568 itemsize 53
> 	item 25 key (257 EXTENT_DATA 67174400) itemoff 2515 itemsize 53
> 		extent data disk byte 67174400 nr 5301534720
> 		extent data offset 0 nr 5301534720 ram 5301534720
> 		extent compression 0
> As you see by last extent, the file size is exactly 5Gib.
>
> Then I also mount btrfs with nodatacow option.
>
> root@vc:/btrfs-progs# ./btrfs fi df /mnt/src/
> Data: total=5.47GB, used=5.00GB
> System: total=32.00MB, used=4.00KB
> Metadata: total=512.00MB, used=28.00KB
>
> (I have set up block groups myself by playing with mfks code and
> convertion code to learn about the extent tree. The filesystem passes
> btrfsck fine, with no errors. All superblock copies are consistent.)
>
> Then I run parallel random IOs on the file, and almost immediately hit
> ENOSPC. When looking at the file, I see that now it has a huge amount
> of EXTENT_DATAs:
> item 4 key (257 INODE_ITEM 0) itemoff 3593 itemsize 160
> 	inode generation 5 transid 21 size 5368709120 nbytes 5368709120
> owner[0:0] mode 100644
> 	inode blockgroup 0 nlink 1 flags 0x3 seq 130098
> item 6 key (257 EXTENT_DATA 0) itemoff 3525 itemsize 53
> item 7 key (257 EXTENT_DATA 131072) itemoff 3472 itemsize 53
> item 8 key (257 EXTENT_DATA 262144) itemoff 3419 itemsize 53
> item 9 key (257 EXTENT_DATA 524288) itemoff 3366 itemsize 53
> item 10 key (257 EXTENT_DATA 655360) itemoff 3313 itemsize 53
> item 11 key (257 EXTENT_DATA 1310720) itemoff 3260 itemsize 53
> item 12 key (257 EXTENT_DATA 1441792) itemoff 3207 itemsize 53
> item 13 key (257 EXTENT_DATA 2097152) itemoff 3154 itemsize 53
> item 14 key (257 EXTENT_DATA 2228224) itemoff 3101 itemsize 53
> item 15 key (257 EXTENT_DATA 2752512) itemoff 3048 itemsize 53
> item 16 key (257 EXTENT_DATA 2883584) itemoff 2995 itemsize 53
> item 17 key (257 EXTENT_DATA 11927552) itemoff 2942 itemsize 53
> item 18 key (257 EXTENT_DATA 12058624) itemoff 2889 itemsize 53
> item 19 key (257 EXTENT_DATA 13238272) itemoff 2836 itemsize 53
> item 20 key (257 EXTENT_DATA 13369344) itemoff 2783 itemsize 53
> item 21 key (257 EXTENT_DATA 16646144) itemoff 2730 itemsize 53
> item 22 key (257 EXTENT_DATA 16777216) itemoff 2677 itemsize 53
> item 23 key (257 EXTENT_DATA 17432576) itemoff 2624 itemsize 53
> ...
>
> and:
> root@vc:/btrfs-progs# ./btrfs fi df /mnt/src/
> Data: total=5.47GB, used=5.46GB
> System: total=32.00MB, used=4.00KB
> Metadata: total=512.00MB, used=992.00KB
>
> Kernel is for-linus branch from Chris's tree, up to
> f46dbe3dee853f8a860f889cb2b7ff4c624f2a7a (this is the last commit
> there now).
>
> I was under impression that if a file is marked as NODATACOW, then new
> writes will never allocate EXTENT_DATAs if appropriate EXTENT_DATAs
> already exist. However, it is clearly not the case, or maybe I am
> doing something wrong.
>
> Can anybody please help me to debug further and understand why this is
> happening.
>
> Thanks,
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

