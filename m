Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34587 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbbFPMTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 08:19:47 -0400
Received: by lbbti3 with SMTP id ti3so9592051lbb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 05:19:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557FD632.6050609@cn.fujitsu.com>
References: <CAN8=bazs9GeqtA5+kOoN=MWrtaQQw0+TUxA8jrTfY5ouuqVm+A@mail.gmail.com>
	<557FD632.6050609@cn.fujitsu.com>
Date: Tue, 16 Jun 2015 14:19:45 +0200
Message-ID: <CAN8=bayDf7VDNuTTHkamk0xqzs+eFkKJ9-Rq3Mr+8MA6+5PT9Q@mail.gmail.com>
Subject: Re: I_ERR_FILE_EXTENT_DISCOUNT when there are no file extent holes in inode
From: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?=
	<przemyslaw@pawelczyk.it>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 16, 2015 at 9:54 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Przemysław Pawełczyk wrote on 2015/06/14 21:38 +0200:

>> I wanted to move and resize /home btrfs partition of my debian jessie
>> v8.1 (w/ btrfs-tools v3.17) in virtual machine using gparted 0.22.0
>> after booting from latest SysRescCD 4.5.3 (w/ btrfs-progs v3.19.1).
>> GParted does fs check before, to make sure that everything is fine,
>> but it wasn't. There were following errors from `btrfsck`:
>>
>> checking fs roots
>> root 5 inode 1521611 errors 100, file extent discount
>> Found file extent holes:
>> start: 12288, len:4096
>> root 5 inode 1521634 errors 100, file extent discount
>> Found file extent holes:
>> root 5 inode 1521645 errors 100, file extent discount
>> Found file extent holes:
>> start: 8192, len:4096
>> root 5 inode 1521647 errors 100, file extent discount
>> Found file extent holes:
>> start: 8192, len:8192
>> start: 20480, len:4096
>> root 5 inode 1521648 errors 100, file extent discount
>> Found file extent holes:
>> root 5 inode 1521649 errors 100, file extent discount
>> Found file extent holes:
>> ...
>>
>> As you can see not every inode w/ file extent discount error flag has
>> file extent holes. I'm not sure of exact definition of this error
>> flag, so cannot tell myself how (ab?)normal it is. I was using this
>> partition almost daily for almost a year (back then it was debian
>> testing when installed) and beside occasional VirtualBox hangups
>> (during rsync from USB), I had no problems at all.
>>
>> Qu Wenruo's discount file extent hole repairing function landed in
>> btrfs-progs v3.19, so I couldn't use debian's old btrfsck to improve
>> the situation, but sysresccd's one was recent enough (and I was
>> already booted into it), so I went with its `btrfsck --repair`. I got
>> many 'Fixed discount file extents for inode' messages, but next
>> `btrfsck` run still reported file extent discount errors. Looking
>> closely there was some improvement, because 2 inodes were no longer
>> reported (only one within visible part of the below log dump):
>>
>> checking fs roots
>> root 5 inode 1521634 errors 100, file extent discount
>> Found file extent holes:
>> root 5 inode 1521645 errors 100, file extent discount
>> Found file extent holes:
>> root 5 inode 1521647 errors 100, file extent discount
>> Found file extent holes:
>> root 5 inode 1521648 errors 100, file extent discount
>> Found file extent holes:
>> root 5 inode 1521649 errors 100, file extent discount
>> Found file extent holes:
>> ...
>>
>> I cloned btrfs-progs.git with latest stable v4.0.1, and executed
>> self-built `btrfsck --repair` from my debian, hoping that maybe there
>> were some improvements in that department. Sadly no, I got many 'Fixed
>> discount file extents for inode', but next `btrfsck` revealed same old
>> file extent discount errors. It looked like flag error is simply not
>> cleared, so I finally looked into the code.
>>
>> When I found repair_inode_discount_extent() in cmds-check.c, I though
>> I've found the bug. I_ERR_FILE_EXTENT_DISCOUNT is cleared only within
>> while (node) loop, so if there are no file extents hole, it won't be
>> cleared. So I moved
>>
>>      if (RB_EMPTY_ROOT(&rec->holes))
>>          rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;
>
>
> Thanks a lot for pointing out the problem.
> I'll try to fix it soon.

I would send a patch separately if I was convinced that it fixes the
real problem, but as your read from the rest of the mail, I am not. It
may seem as slight optimization (checking things once instead of
repeatedly), but it also "masks" error flag (i.e. clears it) for cases
that are not really fixed in the function and only next btrfsck run
will reset this file extent discount error flag (in case of these
holeless inodes having extent_end < isize), so I think that it needs
to be postponed after repair_inode_discount_extent() will be smart
enough to thoroughly fix inode's extents deficiency.

> Also, welcome aboard to btrfs development! :)

Thank you, but I don't plan to truly dive into btrfs (at least yet). :)
I just hoped I could work my problem out myself and even if not, I
could at least provide more detailed report than "File extent discount
errors are not fixed by btrfsck."

>>
>> after the while loop. It must have helped clearing error flag during
>> `btrfsck --repair`, but rerunning `btrfsck` revealed that there are
>> still the same file extent discount errors, so apparently they were
>> reset in some other code path.
>>
>> I added some debug printf to verify that RB_EMPTY_ROOT(&rec->holes)
>> was not false (i.e. 0) and other one in maybe_free_inode_rec() after
>> conditions that lead to setting I_ERR_FILE_EXTENT_DISCOUNT error flag,
>> to see the values that met the conditions:
>>
>>      if (rec->nlink > 0 && !no_holes
>>          && (   rec->extent_end < rec->isize
>>              || first_extent_gap(&rec->holes) < rec->isize
>>             )
>>         )
>>
>> Rerunning `btrfsck` gave me this new info:
>>
>> Checking filesystem on /dev/sda7
>> UUID: 8b889e4c-5dba-43e3-a116-e13874bfb311
>> !Set discount file extents for inode    1521634 (nlink=1 extent_end=0
>>          isize=1408       first_extent_gap(holes)=18446744073709551615)
>> !Set discount file extents for inode    1521645 (nlink=1
>> extent_end=20480      isize=47496
>> first_extent_gap(holes)=18446744073709551615)
>> !Set discount file extents for inode    1521647 (nlink=1
>> extent_end=36864      isize=37728
>> first_extent_gap(holes)=18446744073709551615)
>> !Set discount file extents for inode    1521648 (nlink=1 extent_end=0
>>          isize=936        first_extent_gap(holes)=18446744073709551615)
>> !Set discount file extents for inode    1521649 (nlink=1 extent_end=0
>>          isize=936        first_extent_gap(holes)=18446744073709551615)
>>
>> (This long number is ((u64)-1)
>>
>> So extent_end < isize for these bloody inodes.
>
> My first thought on this is that my codes lacks check on inlined extent.
> But a quick test shows that's not true.
> For inlined extent, if inline file extent is found, its extent_end should be
> 4096.
>
> So if that's OK for you, would you please upload a btrfs-image dump of your
> filesystem and send it to me for further debugging?
>
> # btrfs-image <YOUR_BTRFS_DEV> <OUTPUT_FILE> -c9
>
> WARNING: btrfs-image dump will only contains metadata, no data at all.
> But even metadata, including the filename or dir name contains confidential
> or personal info, just ignore my request.

I'm sure such btrfs-image dump would be immensely helpful in debugging
this problem, but I cannot provide it. I may try to prepare stripped
version of my /home partition, i.e. the one I would be comfortable
with providing metadata dump from it, but there is a chance that
during stripping I'll remove problematic inodes. Is there any easy way
to find filenames behind particular inodes? That way I could
"preserve" them during stripping and simply rename if needed.

>>
>> Now I have a few questions related to my problem.
>>
>> 1. What is the exact meaning of I_ERR_FILE_EXTENT_DISCOUNT nowadays
>> and are the conditions leading to setting this error flag proper
>> w.r.t. current btrfs state?
>
> This error flags means your file extents are not continuous.
> Without enable the no-holes feature, btrfs won't allow non-continuous file
> extents.

Did you meant here "With no-hole feature enabled, btrfs won't allow
non-continuous file extents"?

If there are holes, we have non-continuous file extents, because in
place of missing file extents there are holes.
With no-hole mode present, all file extents are continuous. Did I get it right?

> Even you do things like:
> dd if=/dev/zero of=/btrfs/mnt/test.file bs=1m count=1 seek=1.
>
> The first 1M extent will be a "hole" extent, which takes no space on disk.
> And the second 1M extent will be a normal file extent, which takes 1M on
> disk.

Your above example assumes mode w/ holes? What it would be in no-hole mode?

>>
>> 2. How these errors should be fixed?
>>
>> I guess extending repair_inode_discount_extent() to fiddle with
>> extents properly, even if there are no file extent holes, will be
>> required, but I don't have enough btrfs knowledge to do it myself
>> right now (first time looking into btrfs-related code today). My
>> moving of error clearing out of the loop was bogus, because real issue
>> is apparently not fixed then (and clearing within loop can be bogus as
>> well for the same reason).
>
> For normal file extent case, repair_inode_discount_extent() will fix it by
> insert "hole" file extent fill the hole and make them continuous.
> For inlined file extent case, it shouldn't happen as it will only be one
> extent...
> And you hit the impossible case :(

I hate hitting "impossible cases"... :(

> Thanks,
> Qu

Regards.

-- 
Przemysław Pawełczyk
