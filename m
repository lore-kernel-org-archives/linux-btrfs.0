Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57737 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbbGNRcZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 13:32:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZF446-0005CQ-A9
	for linux-btrfs@vger.kernel.org; Tue, 14 Jul 2015 19:32:22 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 19:32:22 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 19:32:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: counting fragments takes more time than defragmenting
Date: Tue, 14 Jul 2015 17:32:09 +0000 (UTC)
Message-ID: <pan$6e240$817b36df$ea5316f8$5d33403a@cox.net>
References: <20150604084245.GR23272@merlins.org>
	<20150624032008.GF20517@merlins.org>
	<CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
	<pan$5335b$94315604$8405c6ac$de90de30@cox.net>
	<CAA7pwKNtS6UB+tXdB9c4D9J2gOk56gM-O1q+19A6SZcdcdFVtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Tue, 14 Jul 2015 13:57:07 +0200 as excerpted:

> On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> Regardless of whether 1 or huge -t means maximum defrag, however, the
>> nominal data chunk size of 1 GiB means that 30 GiB file you mentioned
>> should be considered ideally defragged at 31 extents.  This is a
>> departure from ext4, which AFAIK in theory has no extent upper limit,
>> so should be able to do that 30 GiB file in a single extent.
>>
>> But btrfs or ext4, 31 extents ideal or a single extent ideal, 150
>> extents still indicates at least some remaining fragmentation.
> 
> So I converted the VMware VMDK file to a VirtualBox VDI file:
> 
> -rw------- 1 plu plu 28845539328 jul 13 13:36 Windows7-disk1.vmdk
> -rw------- 1 plu plu 28993126400 jul 13 14:04 Windows7.vdi
> 
> $ filefrag Windows7.vdi Windows7.vdi: 15 extents found
> 
> $ btrfs filesystem defragment -t 3g Windows7.vdi $ filefrag Windows7.vdi
> Windows7.vdi: 24 extents found
> 
> How can it be less than 28 extents with a chunk size of 1 GiB?
> 
> E2fsprogs version 1.42.12

That's why I said "nominal"[1] 1 GiB.  I'm just a list and filesystem 
user, not a dev, and I don't know the details, but someone (a dev or at 
least someone that can actually read code, but not a btrfs dev) mentioned 
in reply to a post of mine a few months ago, that under the right 
conditions, btrfs can allocate larger-than 1 GiB data chunks.

I /believe/ data chunk allocation size has something to do with the 
amount of unallocated space on the filesystem; that on large (TiB plus, 
perhaps) btrfs some of the initial allocations will be multiple GiB, 
which of course would allow greater-than 1 GiB extents as well.  But I 
really don't know the conditions under which that can happen and I've not 
seen an actual btrfs dev comment on it, and AFAIK the "base" data chunk 
size remains 1 GiB under most conditions.  Meanwhile, I tend to partition 
up my storage here, and while I have multiple separate btrfs, the 
partitions are all under 50 GiB, so I'm unlikely to see that sort of > 1 
GiB data chunk allocations at all, here.

So rather than go to the complexity of explaining all this detail that 
I'm not sure of anyway, I deliberately blurred out a bit as not necessary 
to the primary point, which was that for files over a GiB, don't expect 
to see or be able to defrag to a single extent, as 1 GiB data chunks and 
thus extents are nominal/normal.

If it does happen, I'd consider it due to those data "superchunks" and 
wouldn't be entirely surprised, but the point remains that you're 
unlikely to get the number of extents much below the file size number in 
GiB using defrag, even when everything is working "perfectly as designed".

---
[1] Nominal: In the sense of normal or standard as-designed value, see 
wiktionary's English adjective sense 6 and 10, as well as the wikipedia 
writeups on real vs. nominal values and nominal size:

https://en.wiktionary.org/wiki/nominal#Adjective
https://en.wikipedia.org/wiki/Real_versus_nominal_value
https://en.wikipedia.org/wiki/Nominal_size

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

