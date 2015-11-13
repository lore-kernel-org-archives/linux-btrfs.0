Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38595 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbbKMOvH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 09:51:07 -0500
Received: by igbxm8 with SMTP id xm8so15689803igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 06:51:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5644CB2F.8010302@mail.ru>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
	<20151111202403.GA19245@wheatley.student.rit.edu>
	<56448A54.9020404@gmail.com>
	<5644CB2F.8010302@mail.ru>
Date: Fri, 13 Nov 2015 09:51:06 -0500
Message-ID: <CAJCQCtTFj2dPUw-sxda3B+_G_-9777S1UdNrGkEQMQsPqLxGBQ@mail.gmail.com>
Subject: Re: Potential to loose data in case of disk failure
From: Chris Murphy <lists@colorremedies.com>
To: Dmitry Katsubo <dma_k@mail.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 12:23 PM, Dmitry Katsubo <dma_k@mail.ru> wrote:
> On 2015-11-12 13:47, Austin S Hemmelgarn wrote:
>>> That's a pretty unusual setup, so I'm not surprised there's no quick and
>>> easy answer. The best solution in my opinion would be to shuffle your
>>> partitions around and combine sda3 and sda8 into a single partition.
>>> There's generally no reason to present btrfs with two different
>>> partitions on the same disk.
>>>
>>> If there's something that prevents you from doing that, you may be able
>>> to use RAID10 or RAID6 somehow. I'm not really sure, though, so I'll
>>> defer to others on the list for implementation details.
>> RAID10 has the same issue.  Assume you have 1 block.  This gets stored
>> as 2 copies, each with 2 stripes, with the stripes split symmetrically.
>>  For this, call the first half of the first copy 1a, the second half 1b,
>> and likewise for 2a and 2b with the second copy.  1a and 2a have
>> identical contents, and 1b and 2b have identical contents.  It is fully
>> possible that you will end up with this block striped such that 1a and
>> 2a are on one disk, and 1b and 2b on the other.  Based on this, losing
>> one disk would mean losing half the block, which would mean based on how
>> BTRFS works that you would lose the whole block (because neither copy
>> would be complete).
>
> Does it equally apply to RAID1? Namely, if I create
>
> mkfs.btrfs -mraid1 -draid1 /dev/sda3 /dev/sda8
>
> then btrfs will "believe" that these are different drives and mistakenly
> think that RAID pre-condition is satisfied. Am I right?

Yes.


>If so then I
> think this is a trap, and mkfs.btrfs should at least warn (or require
> --force) if two partitions are on the same drive for raid1/raid5/raid10.

Does mdadm warn in the same situation? LVM?

There are some assumptions being made about the end user's
understanding of the system they're working on, and those assumptions
aren't unreasonable. But I'm not opposed to an informational message.



-- 
Chris Murphy
