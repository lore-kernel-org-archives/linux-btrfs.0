Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34528 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbcEWLc0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 07:32:26 -0400
Received: by mail-io0-f193.google.com with SMTP id d197so14817107ioe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 May 2016 04:32:25 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org> <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
 <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
 <CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
 <1c1358af-4549-618a-c408-b93832d33225@gmail.com>
 <CAPmG0jbjdWf+98wr-NaL622wVAkfMJdHEij7feM9OK=AwZw68A@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f1fd9821-03e7-079a-3894-2543c26aafd0@gmail.com>
Date: Mon, 23 May 2016 07:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbjdWf+98wr-NaL622wVAkfMJdHEij7feM9OK=AwZw68A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-20 18:26, Henk Slager wrote:
> Yes, sorry, I took some shortcut in the discussion and jumped to a
> method for avoiding this 0.5-2% slowdown that you mention. (Or a
> kernel crashing in bcache code due to corrupt SB on a backing device
> or corrupted caching device contents).
> I am actually bit surprised that there is a measurable slowdown,
> considering that it is basically just one 8KiB offset on a certain
> layer in the kernel stack, but I haven't looked at that code.
There's still a layer of indirection in the kernel code, even in the 
pass-through mode with no cache, and that's probably where the slowdown 
comes from.  My testing was also in a VM with it's backing device on an 
SSD though, so you may get different results on other hardware
> I don't know other tables than MBR and GPT, but this bcache SB
> 'insertion' works with both. Indeed, if GRUB is involved, it can get
> complicated, I have avoided that. If there is less than 8KiB slack
> space on a HDD, I would worry about alignment/performance first, then
> there is likely a reason to fully rewrite the HDD with a standard 1M
> alingment.
The 'alignment' things is mostly bogus these days.  It originated when 
1M was a full track on the disk, and you wanted your filesystem to start 
on the beginning of a track for performance reasons.  On most modern 
disks though, this is not a full track, but it got kept because a number 
of bootloaders (GRUB included) used to use the slack space this caused 
to embed themselves before the filesystem.  The only case where 1M 
alignment actually makes sense is on SSD's with a 1M erase block size 
(which are rare, most consumer devices have a 4M erase block).  As far 
as partition tables, you're not likely to see any other formats these 
days (the only ones I've dealt with other than MBR and GPT are APM (the 
old pre-OSX Apple format), RDB (the Amiga format, which is kind of neat 
because it can embed drivers), and the old Sun disk labels (from before 
SunOS became Solaris)), and I had actually forgotten that a GPT is only 
32k, hence my comment about it potentially being an issue.
> If there is more partitions and the partition in front of the one you
> would like to be bcached, I personally would shrink it by 8KiB (like
> NTFS or swap or ext4 ) if that saves me TeraBytes of datatransfers.
Definitely, although depending on how the system is set up, this will 
almost certainly need down time.
>
>> This also doesn't change the fact that without careful initial formatting
>> (it is possible on some filesystems to embed the bcache SB at the beginning
>> of the FS itself, many of them have some reserved space at the beginning of
>> the partition for bootloaders, and this space doesn't have to exist when
>> mounting the FS) or manual alteration of the partition, it's not possible to
>> mount the FS on a system without bcache support.
>
> If we consider a non-bootable single HDD btrfs FS, are you then
> suggesting that the bcache SB could be placed in the first 64KiB where
> also GRUB stores its code if the FS would need booting ?
> That would be interesting, it would mean that also for btrfs on raw
> device (and also multi-device) there is no extra exclusive 8KiB space
> needed in front.
> Is there someone who has this working? I think it would lead to issues
> on the blocklayer, but I have currently no clue about that.
I don't think it would work on BTRFS, we expect the SB at a fixed 
location into the device, and it wouldn't be there on the bcache device. 
  It might work on ext4 though, but I'm not certain about that.  I do 
know of at least one person who got it working with a FAT32 filesystem 
as a proof of concept though.  Trying to do that even if it would work 
on BTRFS would be _really_ risky though, because the kernel would 
potentially see both devices, and you would probably have the same 
issues that you do with block level copies.
