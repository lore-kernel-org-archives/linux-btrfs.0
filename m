Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35085 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbcGFPMb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 11:12:31 -0400
Received: by mail-io0-f169.google.com with SMTP id f30so202392884ioj.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 08:12:31 -0700 (PDT)
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, antonio@gnu.org
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
 <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
 <577D191F.90709@gnu.org>
 <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
Cc: linux-btrfs@vger.kernel.org, bug-tar@gnu.org, adilger@dilger.ca
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <12d68c4e-5918-4ed0-9172-be7bd166c020@gmail.com>
Date: Wed, 6 Jul 2016 11:12:24 -0400
MIME-Version: 1.0
In-Reply-To: <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 10:53, Joerg Schilling wrote:
> Antonio Diaz Diaz <antonio@gnu.org> wrote:
>
>> Joerg Schilling wrote:
>>> POSIX requires st_blocks to be != 0 in case that the file contains data.
>>
>> Please, could you provide a reference? I can't find such requirement at
>> http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_stat.h.html
>
> 	blkcnt_t st_blocks      Number of blocks allocated for this object.
>
> It should be obvious that a file that offers content also has allocated blocks.
What you mean then is that POSIX _implies_ that this is the case, but 
does not say whether or not it is required.  There are all kinds of 
counterexamples to this too, procfs is a POSIX compliant filesystem 
(every POSIX certified system has it), yet does not display the behavior 
that you expect, every single file in /proc for example reports 0 for 
both st_blocks and st_size, and yet all of them very obviously have content.
>
> Blocks are "allocated" when the OS decides whether the new data will fit on the
> medium. The fact that some filesystems may have data in a cache but not yet on
> the medium does not matter here. This is how UNIX worked since st_block has
> been introduced nearly 40 years ago.
Tradition is the corpse of wisdom.  Backwards comparability is a problem 
just as much as a good thing.

In all seriousness though, this started out because stuff wasn't cached 
to anywhere near the degree it is today, and there was no such thing as 
delayed allocation.  When you said to write, the filesystem allocated 
the blocks, regardless of when it actually wrote the data.  IOW, the 
behavior that GNU tar is relying on is an implementation detail, not an 
API.  Just like df, this breaks under modern designs, not because they 
chose to break it, but because it wasn't designed for use with such 
implementations.

In the case of tar and similar things though, I'd argue that it's not 
sensible to special case files that are 'sparse', it should store any 
long enough run of zeroes as a sparse region, then provide an option to 
say to not make those files sparse when restored.
>
> A new filesystem cannot introduce new rules just because people believe it would
> save time.
Saying the file has no blocks when there are no blocks allocated for it 
is not to 'save time', it's absolutely accurate.  Suppose SVR4 UFS had a 
way to pack file data into the inode if it was small enough.  In that 
case, it woulod be perfectly reasonable to return 0 for st_blocks 
because the inode table in UFS is a fixed pre-allocated structure, and 
therefore nothing is allocated to the file itself except the inode.  The 
same applies in the case of a file packed into it's own metadata block 
on BTRFS, nothing is allocated to that file beyond the metadata block it 
has to have to store the inode.  In the case of delayed allocation where 
the file hasn't been flushed, there is nothing allocated, so st_blocks 
based on a strict interpretation of it's description in POSIX _should_ 
be 0, because nothing is allocated yet.
