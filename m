Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51971 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbbK2Fbx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 00:31:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a2uaR-0002Hd-Jc
	for linux-btrfs@vger.kernel.org; Sun, 29 Nov 2015 06:31:47 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Nov 2015 06:31:47 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Nov 2015 06:31:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
Date: Sun, 29 Nov 2015 05:31:45 +0000 (UTC)
Message-ID: <pan$8c5a3$43576c38$c4ab8cd7$5fc9a224@cox.net>
References: <1448643790.11377.39.camel@scientia.net>
	<CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
	<1448684040.6837.18.camel@scientia.net>
	<CAPmG0jbso5RM4UW_urBKa02LOKreCTx2PjX7YyUp6nuqOONo=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Sat, 28 Nov 2015 19:37:31 +0100 as excerpted:

> I did cp a 165G file to the SMR drive. The source had 130 extents and
> just uncompressed btrfs raid10 fs, steadily 150+MB/s throughput. The fs
> on the SMR disk is mounted like this:
> /dev/mapper/dmcrypt_smr on /mnt/smr type btrfs
> (rw,noatime,compress-force=zlib,nossd,space_cache,subvolid=5,subvol=/)

Note that compress-force=zlib.  It's important below.

> The result of the cp action is that the destination is 1018391 extents

> The fs on the SMR drive is almost exclusively adding files, so assume
> enough un-fragmented free space available still.

What are you using to tell you it has 1018391 extents?  If you're using 
filefrag, it's known not to understand btrfs compression, which uses 128 
KiB (pre-compression size, I believe, tho I'm not absolutely positive) 
blocks, and as a result, to report each of those blocks as a separate 
extent.

1018391 * 1/8 MiB (aka 128 KiB) * 1/1024 GiB/MiB ~= 124.3 GiB.

Are you sure that was a 165 GiB file, or was it (~) 125 GiB?  And GiB 
(2^30, 1024^3) or GB (10^9, 1000^3), or some horrible mixture of 1024s 
and 1000s?

Because if you're using compress-force, filefrag will see each 128 KiB 
compression block as an extent, and 1018391 reported "extents" (actually 
compression blocks) should be ~ 125 GiB.

> If you would do the same without compress-force-zlib, (also no other
> compression), you will see that btrfs can really do well (like 1 extent
> per GB or so) even with dm-crypt

AFAIK there's no easy "admin-level" way to check extent usage when btrfs 
compression is used on a file.  There's developer-level btrfs-debug 
output, but nothing admin-level or user-level at all.

>> Didn't marketing tell people that compression may even speed up IO
>> because the CPUs are so much faster than the disks?

> They did not tell that it can cause this million extent creation. And
> LZO might be different and force or not also has impact.

Except it's not (that we know of, and most likely not) million plus 
extents.  It's a million plus 128-KiB-each compression blocks.  Big 
difference!

LZO should report an identical number of compression blocks, because 
btrfs uses the same 128 KiB compression block size for both.

And while compress-force won't change the reported "extents" that are 
actually compression-blocks if the file is actually compressed, just 
compress by itself may or may not actually compress the file (there's an 
algorithm used, from what the devs have said, basically it checks whether 
the first block or two compress well, and assumes the rest of the file 
will be similar, compressing or not based on the result of that attempt), 
so it's quite possible you'll get better "extent" numbers if the file 
isn't actually compressed, in which case filefrag actually gets things 
right and reports real extent numbers, vs the number of compression 
blocks if the file is compressed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

