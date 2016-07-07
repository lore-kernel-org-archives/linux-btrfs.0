Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34286 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbcGGPmf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 11:42:35 -0400
Received: by mail-io0-f182.google.com with SMTP id i186so23847152iof.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 08:42:30 -0700 (PDT)
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: Francesco Turco <fturco@fastmail.fm>, linux-btrfs@vger.kernel.org
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
 <87efcca5-6871-2dde-e2df-40602f1a24c2@gmail.com>
 <eefaeb0f-9eb0-bd2c-3ce5-5eb28bb43c68@fastmail.fm>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d2a820b5-7c53-aef4-6e55-0ed6b1da44ec@gmail.com>
Date: Thu, 7 Jul 2016 11:42:22 -0400
MIME-Version: 1.0
In-Reply-To: <eefaeb0f-9eb0-bd2c-3ce5-5eb28bb43c68@fastmail.fm>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 10:55, Francesco Turco wrote:
> On 2016-07-07 16:27, Austin S. Hemmelgarn wrote:
>> This seems odd, are you trying to access anything over NFS or some other
>> network filesystem protocol here?  If not, then I believe you've found a
>> bug, because I'm pretty certain we shouldn't be returning -ESTALE for
>> anything.
>
> No, I don't use NFS or any other network filesystem.
OK, I'm going to try and check the kernel code to figure out if there's 
any other case we might return that in.  I'm pretty certain that there's 
nowhere BTRFS should return that though, which means you've either hit a 
bug or have some other hardware issue (Given past experience, I think 
it's more likely that you've hit a bug).
>
>> The question here is: Do you get any data corruption when using ext4?
>> Quite often when there's a hardware issue, you won't see _any_
>> indication of it other than corrupted files when using something like
>> ext4 or XFS, but it will show up almost immediately with BTRFS because
>> we validate checksums on almost everything.  There have been at least a
>> couple of times I've found disk issues while converting from ext4 to
>> BTRFS that I didn't know existed before, and then going back was able to
>> reliable reproduce using other tools.
>>
>> Also, FWIW, badblocks is not necessarily a reliable test method for
>> flash drives, they often handle serialized reads like badblocks does
>> very well even when failing.
>
> I'm not sure. Commands don't fail explicitely when I use ext4, but I
> agree with you that I may get corruption silently nonetheless. Perhaps I
> should try to rule out an hardware problem by filling my USB flash drive
> with a large random file and then checking if its SHA-1 checksum
> corresponds to the original copy on the hard disk. But first I probably
> should backup the current Btrfs filesystem with the dd command. Can I
> proceed?
Yeah, I would suggest backing up the filesystem, be careful that you 
don't have both copies of the filesystem visible to the system at the 
same time once you've finished creating the backup copy though, as there 
are potential issues if you have both visible while trying to mount the FS.

As far as checking the drive, I'd do essentially what you had said, with 
two extra parts:
1. Calculate the checksum of the data on the drive multiple times and 
make sure that it matches each time as well as matching the original 
file (if it doesn't match the original file, but each calculation from 
the drive matches, then the issue is something in the write path only).
2. Do so multiple times so you can be sure to cover _every_ block.  Most 
flash drives have a pool of spare blocks that are used for wear 
leveling, and if the issue is in one of those, this is the only way to 
find it.

You might also try doing some testing with FIO or iozone, those tend to 
exercise a wider variety of things than stuff like badblocks or dd. 
Also, since you'll have a backup copy of the FS, you might consider 
running a destructive test with badblocks (it works a bit more reliably 
on flash devices this way, just make sure to run it multiple times too), 
both with and without the -B option (-B affects how things are buffered, 
if you see errors with it enabled but none without it, then you probably 
have some bad RAM).
>
>> Just to clarify, you're using BTRFS on top of disk encryption (LUKS? Or
>> is it just raw encryption, or even something completely different?), on
>> a USB flash drive (not a USB to SATA adapter with an SSD or HDD in it),
>> correct?
>
> I'm using a btrfs filesystem on a GUID partition encrypted with LUKS.
> It's a Kingston USB flash drive connected directly to my desktop machine
> via USB. It's definitively not a SSD or a HDD, and I'm not using any
> adapter.
OK, that both simplifies things, and makes them a bit more complicated. 
If it had been a SSD or HDD connected through an adapter, the preferred 
method of checking would be to pull it out and put it directly in the 
system to verify the drive.  However, since it's a regular flash drive, 
if it is the drive, it will probably be significantly less expensive to 
replace.

