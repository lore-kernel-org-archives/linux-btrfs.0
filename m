Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp42.i.mail.ru ([94.100.177.102]:42882 "EHLO smtp42.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbbKLRXG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 12:23:06 -0500
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:59912 helo=centurion)
	by smtp42.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1ZwvaQ-0000zP-PQ
	for linux-btrfs@vger.kernel.org; Thu, 12 Nov 2015 20:23:03 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 69C9D3A625E
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 18:23:03 +0100 (CET)
Subject: Re: Potential to loose data in case of disk failure
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
 <20151111202403.GA19245@wheatley.student.rit.edu>
 <56448A54.9020404@gmail.com>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <5644CB2F.8010302@mail.ru>
Date: Thu, 12 Nov 2015 18:23:59 +0100
MIME-Version: 1.0
In-Reply-To: <56448A54.9020404@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-12 13:47, Austin S Hemmelgarn wrote:
>> That's a pretty unusual setup, so I'm not surprised there's no quick and
>> easy answer. The best solution in my opinion would be to shuffle your
>> partitions around and combine sda3 and sda8 into a single partition.
>> There's generally no reason to present btrfs with two different
>> partitions on the same disk.
>>
>> If there's something that prevents you from doing that, you may be able
>> to use RAID10 or RAID6 somehow. I'm not really sure, though, so I'll
>> defer to others on the list for implementation details.
> RAID10 has the same issue.  Assume you have 1 block.  This gets stored
> as 2 copies, each with 2 stripes, with the stripes split symmetrically.
>  For this, call the first half of the first copy 1a, the second half 1b,
> and likewise for 2a and 2b with the second copy.  1a and 2a have
> identical contents, and 1b and 2b have identical contents.  It is fully
> possible that you will end up with this block striped such that 1a and
> 2a are on one disk, and 1b and 2b on the other.  Based on this, losing
> one disk would mean losing half the block, which would mean based on how
> BTRFS works that you would lose the whole block (because neither copy
> would be complete).

Does it equally apply to RAID1? Namely, if I create

mkfs.btrfs -mraid1 -draid1 /dev/sda3 /dev/sda8

then btrfs will "believe" that these are different drives and mistakenly
think that RAID pre-condition is satisfied. Am I right? If so then I
think this is a trap, and mkfs.btrfs should at least warn (or require
--force) if two partitions are on the same drive for raid1/raid5/raid10.
In other words, the only scenario when this check should be skipped is:

mkfs.btrfs -mraid0 -draid0 /dev/sda3 /dev/sda8

-- 
With best regards,
Dmitry
