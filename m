Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41738 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaG1SgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 14:36:23 -0400
MIME-Version: 1.0
In-Reply-To: <53D67828.3040802@gmail.com>
References: <CAPDOMViXEgN1U8Og52Fd7EaM86Ad2Dfex9TVQ-+tRZ9SL9Kcig@mail.gmail.com>
	<53D5BBCA.3020109@gmail.com>
	<CAPDOMVjB9ErEwA7mf91X7pff5LAkeT=BT4pR7TuoEp3LL333Lg@mail.gmail.com>
	<53D6218A.5080401@gmail.com>
	<CAPDOMVg869TJJPgrW86XaMT2WyisbT9fg0jLETCAvg59xpvs4Q@mail.gmail.com>
	<CAPDOMVh5kFE2kZtnpjQdAv1n+7FN=X_oc3YRyWOxpPmo=qW_cQ@mail.gmail.com>
	<53D67828.3040802@gmail.com>
Date: Mon, 28 Jul 2014 14:36:22 -0400
Message-ID: <CAPDOMVhNAqF_KSeT9MamLgk8Mwe1Qb3uZRK9oipE_49ScO8UHQ@mail.gmail.com>
Subject: Re: Multi Core Support for compression in compression.c
From: Nick Krause <xerofoify@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 28, 2014 at 12:19 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-07-28 11:57, Nick Krause wrote:
>> On Mon, Jul 28, 2014 at 11:13 AM, Nick Krause <xerofoify@gmail.com>
>> wrote:
>>> On Mon, Jul 28, 2014 at 6:10 AM, Austin S Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>> On 07/27/2014 11:21 PM, Nick Krause wrote:
>>>>> On Sun, Jul 27, 2014 at 10:56 PM, Austin S Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>> On 07/27/2014 04:47 PM, Nick Krause wrote:
>>>>>>> This may be a bad idea , but compression in brtfs seems
>>>>>>> to be only using one core to compress. Depending on the
>>>>>>> CPU used and the amount of cores in the CPU we can make
>>>>>>> this much faster with multiple cores. This seems bad by
>>>>>>> my reading at least I would recommend for writing
>>>>>>> compression we write a function to use a certain amount
>>>>>>> of cores based on the load of the system's CPU not using
>>>>>>> more then 75% of the system's CPU resources as my system
>>>>>>> when idle has never needed more then one core of my i5
>>>>>>> 2500k to run when with interrupts for opening eclipse are
>>>>>>> running. For reading compression on good core seems fine
>>>>>>> to me as testing other compression software for reads ,
>>>>>>> it's way less CPU intensive. Cheers Nick
>>>>>> We would probably get a bigger benefit from taking an
>>>>>> approach like SquashFS has recently added, that is,
>>>>>> allowing multi-threaded decompression fro reads, and
>>>>>> decompressing directly into the pagecache. Such an approach
>>>>>> would likely make zlib compression much more scalable on
>>>>>> large systems.
>>>>>>
>>>>>>
>>>>>
>>>>> Austin, That seems better then my idea as you seem to be more
>>>>> up to date on brtfs devolopment. If you and the other
>>>>> developers of brtfs are interested in adding this as a
>>>>> feature please let me known as I would like to help improve
>>>>> brtfs as the file system as an idea is great just seems like
>>>>> it needs a lot of work :). Nick
>>>> I wouldn't say that I am a BTRFS developer (power user maybe?),
>>>> but I would definitely say that parallelizing compression on
>>>> writes would be a good idea too (especially for things like
>>>> lz4, which IIRC is either in 3.16 or in the queue for 3.17).
>>>> Both options would be a lot of work, but almost any performance
>>>> optimization would.  I would almost say that it would provide a
>>>> bigger performance improvement to get BTRFS to intelligently
>>>> stripe reads and writes (at the moment, any given worker thread
>>>> only dispatches one write or read to a single device at a
>>>> time, and any given write() or read() syscall gets handled by
>>>> only one worker).
>>>>
>>>
>>> I will look into this idea and see if I can do this for writes.
>>> Regards Nick
>>
>> Austin, Seems since we don't want to release the cache for inodes
>> in order to improve writes if are going to use the page cache. We
>> seem to be doing this for writes in end_compressed_bio_write for
>> standard pages and in end_compressed_bio_write. If we want to cache
>> write pages why are we removing then ? Seems like this needs to be
>> removed in order to start off. Regards Nick
>>
> I'm not entirely sure, it's been a while since I went exploring in the
> page-cache code.  My guess is that there is some reason that you and I
> aren't seeing that we are trying for write-around semantics, maybe one
> of the people who originally wrote this code could weigh in?  Part of
> this might be to do with the fact that normal page-cache semantics
> don't always work as expected with COW filesystems (cause a write goes
> to a different block on the device than a read before the write would
> have gone to).  It might be easier to parallelize reads first, and
> then work from that (and most workloads would probably benefit more
> from the parallelized reads).
>
I will look into this later today and work on it then.
Regards Nick
