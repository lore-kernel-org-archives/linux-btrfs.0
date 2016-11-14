Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36422 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933969AbcKNT47 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 14:56:59 -0500
Received: by mail-yw0-f195.google.com with SMTP id r204so8667174ywb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 11:56:58 -0800 (PST)
Subject: Re: Announcing btrfs-dedupe
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
Cc: James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
Date: Mon, 14 Nov 2016 14:56:51 -0500
MIME-Version: 1.0
In-Reply-To: <20161114195102.GI21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-14 14:51, Zygo Blaxell wrote:
> On Mon, Nov 14, 2016 at 01:39:02PM -0500, Austin S. Hemmelgarn wrote:
>> On 2016-11-14 13:22, James Pharaoh wrote:
>>> One thing I am keen to understand is if BTRFS will automatically ignore
>>> a request to deduplicate a file if it is already deduplicated? Given the
>>> performance I see when doing a repeat deduplication, it seems to me that
>>> it can't be doing so, although this could be caused by the CPU usage you
>>> mention above.
>> What's happening is that the dedupe ioctl does a byte-wise comparison of the
>> ranges to make sure they're the same before linking them.  This is actually
>> what takes most of the time when calling the ioctl, and is part of why it
>> takes longer the larger the range to deduplicate is.  In essence, it's
>> behaving like an OS should and not trusting userspace to make reasonable
>> requests (which is also why there's a separate ioctl to clone a range from
>> another file instead of deduplicating existing data).
>
> Deduplicating an extent that may might be concurrently modified during the
> dedup is a reasonable userspace request.  In the general case there's
> no way for userspace to ensure that it's not happening.
I'm not even talking about the locking, I'm talking about the data 
comparison that the ioctl does to ensure they are the same before 
deduplicating them, and specifically that protecting against userspace 
just passing in two random extents that happen to be the same size but 
not contain the same data (because deduplication _should_ reject such a 
situation, that's what the clone ioctl is for).

The locking is perfectly reasonable and shouldn't contribute that much 
to the overhead (unless you're being crazy and deduplicating thousands 
of tiny blocks of data).
>
> That said, some optimization is possible (although there are good reasons
> not to bother with optimization in the kernel):
>
> 	- VFS could recognize when it has two separate references to
> 	the same physical extent and not re-read the same data twice
> 	(but that requires teaching VFS how to do CoW in general, and is
> 	hard for political reasons on top of the obvious technical ones).
>
> 	- the extent-same ioctl could check to see which extents
> 	are referenced by the src and dst ranges, and return success
> 	immediately without reading data if they are the same (but
> 	userspace should already know this, or it's wasting a huge amount
> 	of time before it even calls the kernel).
>
>> TBH, even though it's kind of annoying from a performance perspective, it's
>> a rather nice safety net to have.  For example, one of the cases where I do
>> deduplication is a couple of directories where each directory is an
>> overlapping partial subset of one large tree which I keep elsewhere.  In
>> this case, I can tell just by filename exactly what files might be
>> duplicates, so the ioctl's check lets me just call the ioctl on all
>> potential duplicates (after checking size, no point in wasting time if the
>> files obviously aren't duplicates), and have it figure out whether or not
>> they can be deduplicated.
>>>
>>> In any case, I'm considering some digging into the filesystem structures
>>> to see if I can work this out myself before i do any deduplication. I'm
>>> fairly sure this should be relatively simple to work out, at least well
>>> enough for my purposes.
>> Sadly, there's no way to avoid doing so right now.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

