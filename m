Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34713 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbcELS3U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 14:29:20 -0400
Received: by mail-io0-f178.google.com with SMTP id 190so106121684iow.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 11:29:19 -0700 (PDT)
Subject: Re: BTRFS Data at Rest File Corruption
To: "Richard A. Lochner" <lochner@clone1.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
 <1463075341.3636.56.camel@clone1.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ebe609bb-3ce6-b929-97ef-ad323a254dc7@gmail.com>
Date: Thu, 12 May 2016 14:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <1463075341.3636.56.camel@clone1.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-12 13:49, Richard A. Lochner wrote:
> Austin,
>
> I rebooted the computer and reran the scrub to no avail.  The error is
> consistent.
>
> The reason I brought this question to the mailing list is because it
> seemed like a situation that might be of interest to the developers.
>  Perhaps, there might be a way to "defend" against this type of
> corruption.
>
> I suspected, and I still suspect that the error occurred upon a
> metadata update that corrupted the checksum for the file, probably due
> to silent memory corruption.  If the checksum was silently corrupted,
> it would be simply written to both drives causing this type of error.
That does seem to be the most likely cause, and sadly, is not something 
any filesystem can protect reliably against on any commodity hardware.
>
> With that in mind, I proved (see below) that the data blocks match on
> both mirrors.  This I expected since the data blocks should not have
> been touched as the the file has not been written.
>
> This is the sequence of events as I see them that I think might be of
> interest to the developers.
>
> 1. A block containing a checksum for the file was read into memory.
> The block read would have been checksummed, so the checksum for the
> file must have been good at that moment.
It's worth noting that BTRFS doesn't verify all the checksums in a 
metadata block when it loads that metadata block, only the ones for the 
reads that triggered the metadata block being loaded will get verified.
>
> 2. The checksum block was the altered in memory (perhaps to add or
> change a value).
>
> 3. A new checksum would then have been calculated for the checksum
> block.
>
> 4. The checksum block would have been written to both mirrors.
>
> Presumably, in the case that I am experiencing, an undetected memory
> error must have occurred after 1 and before step 3 was completed.
>
> I wonder if there is a way to correct or detect that situation.
The closest we could get is to provide an option to handle this in 
scrub, preferably with a big scary warning on it as this same situation 
can be easily cause by someone modifying the disks themselves (we can't 
reasonably protect against that, but we shouldn't make it trivial for 
people to inject arbitrary data that way either).
>
> As I stated previously, the machine on which this occurred does not
> have ECC memory, however, I would not think that the majority of users
> running btrfs do either.  If it has happened to me, it likely has
> happened to others.
>
> Rick Lochner
>
> btrfs dmesg(s):
>
> [16510.334020] BTRFS warning (device sdb1): checksum error at logical
> 3037444042752 on dev /dev/sdb1, sector 4988789496, root 259, inode
> 1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
> [16510.334043] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 0, rd
> 0, flush 0, corrupt 5, gen 0
> [16510.345662] BTRFS error (device sdb1): unable to fixup (regular)
> error at logical 3037444042752 on dev /dev/sdb1
>
> [17606.978439] BTRFS warning (device sdb1): checksum error at logical
> 3037444042752 on dev /dev/sdc1, sector 4988750584, root 259, inode
> 1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
> [17606.978460] BTRFS error (device sdb1): bdev /dev/sdc1 errs: wr 0, rd
> 13, flush 0, corrupt 4, gen 0
> [17606.989497] BTRFS error (device sdb1): unable to fixup (regular)
> error at logical 3037444042752 on dev /dev/sdc1
>
> How I compared the data blocks:
>
> #btrfs-map-logical -l 3037444042752  /dev/sdc1
> mirror 1 logical 3037444042752 physical 2554240299008 device /dev/sdc1
> mirror 1 logical 3037444046848 physical 2554240303104 device /dev/sdc1
> mirror 2 logical 3037444042752 physical 2554260221952 device /dev/sdb1
> mirror 2 logical 3037444046848 physical 2554260226048 device /dev/sdb1
>
> #dd if=/dev/sdc1 bs=1 skip=2554240299008 count=4096 of=c1
> 4096+0 records in
> 4096+0 records out
> 4096 bytes (4.1 kB) copied, 0.0292201 s, 140 kB/s
>
> #dd if=/dev/sdc1 bs=1 skip=2554240303104 count=4096 of=c2
> 4096+0 records in
> 4096+0 records out
> 4096 bytes (4.1 kB) copied, 0.0142381 s, 288 kB/s
>
> #dd if=/dev/sdb1 bs=1 skip=2554260221952 count=4096 of=b1
> 4096+0 records in
> 4096+0 records out
> 4096 bytes (4.1 kB) copied, 0.0293211 s, 140 kB/s
>
> #dd if=/dev/sdb1 bs=1 skip=2554260226048 count=4096 of=b2
> 4096+0 records in
> 4096+0 records out
> 4096 bytes (4.1 kB) copied, 0.0151947 s, 270 kB/s
>
> #diff b1 c1
> #diff b2 c2
Excellent thinking here.

Now, if you can find some external method to verify that that block is 
in fact correct, you can just write it back into the file itself at the 
correct offset, and fix the issue.

