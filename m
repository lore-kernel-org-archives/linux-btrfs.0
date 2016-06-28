Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33281 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbcF1MZX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 08:25:23 -0400
Received: by mail-io0-f176.google.com with SMTP id t74so15021536ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 05:25:23 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id p21sm11382074iop.0.2016.06.28.05.25.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2016 05:25:21 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: linux-btrfs@vger.kernel.org
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
 <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
Date: Tue, 28 Jun 2016 08:25:13 -0400
MIME-Version: 1.0
In-Reply-To: <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-28 08:14, Steven Haigh wrote:
> On 28/06/16 22:05, Austin S. Hemmelgarn wrote:
>> On 2016-06-27 17:57, Zygo Blaxell wrote:
>>> On Mon, Jun 27, 2016 at 10:17:04AM -0600, Chris Murphy wrote:
>>>> On Mon, Jun 27, 2016 at 5:21 AM, Austin S. Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>> On 2016-06-25 12:44, Chris Murphy wrote:
>>>>>> On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
>>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>
>>>>>> OK but hold on. During scrub, it should read data, compute checksums
>>>>>> *and* parity, and compare those to what's on-disk - > EXTENT_CSUM in
>>>>>> the checksum tree, and the parity strip in the chunk tree. And if
>>>>>> parity is wrong, then it should be replaced.
>>>>>
>>>>> Except that's horribly inefficient.  With limited exceptions involving
>>>>> highly situational co-processors, computing a checksum of a parity
>>>>> block is
>>>>> always going to be faster than computing parity for the stripe.  By
>>>>> using
>>>>> that to check parity, we can safely speed up the common case of near
>>>>> zero
>>>>> errors during a scrub by a pretty significant factor.
>>>>
>>>> OK I'm in favor of that. Although somehow md gets away with this by
>>>> computing and checking parity for its scrubs, and still manages to
>>>> keep drives saturated in the process - at least HDDs, I'm not sure how
>>>> it fares on SSDs.
>>>
>>> A modest desktop CPU can compute raid6 parity at 6GB/sec, a less-modest
>>> one at more than 10GB/sec.  Maybe a bottleneck is within reach of an
>>> array of SSDs vs. a slow CPU.
>> OK, great for people who are using modern desktop or server CPU's.  Not
>> everyone has that luxury, and even on many such CPU's, it's _still_
>> faster to computer CRC32c checksums.  On top of that, we don't appear to
>> be using the in-kernel parity-raid libraries (or if we are, I haven't
>> been able to find where we are calling the functions for it), so we
>> don't necessarily get assembly optimized or co-processor accelerated
>> computation of the parity itself.  The other thing that I didn't mention
>> above though, is that computing parity checksums will always take less
>> time than computing parity, because you have to process significantly
>> less data.  On a 4 disk RAID5 array, you're processing roughly 2/3 as
>> much data to do the parity checksums instead of parity itself, which
>> means that the parity computation would need to be 200% faster than the
>> CRC32c computation to break even, and this margin gets bigger and bigger
>> as you add more disks.
>>
>> On small arrays, this obviously won't have much impact.  Once you start
>> to scale past a few TB though, even a few hundred MB/s faster processing
>> means a significant decrease in processing time.  Say you have a CPU
>> which gets about 12.0GB/s for RAID5 parity, and and about 12.25GB/s for
>> CRC32c (~2% is a conservative ratio assuming you use the CRC32c
>> instruction and assembly optimized RAID5 parity computations on a modern
>> x86_64 processor (the ratio on both the mobile Core i5 in my laptop and
>> the Xeon E3 in my home server is closer to 5%)).  Assuming those
>> numbers, and that we're already checking checksums on non-parity blocks,
>> processing 120TB of data in a 4 disk array (which gives 40TB of parity
>> data, so 160TB total) gives:
>> For computing the parity to scrub:
>> 120TB / 12.25GB =  9795.9 seconds for processing CRC32c csums of all the
>> regular data
>> 120TB / 12GB    = 10000 seconds for processing parity of all stripes
>>                 = 19795.9 seconds total
>>                 ~ 5.4 hours total
>>
>> For computing csums of the parity:
>> 120TB / 12.25GB =  9795.9 seconds for processing CRC32c csums of all the
>> regular data
>> 40TB / 12.25GB  =  3265.3 seconds for processing CRC32c csums of all the
>> parity data
>>                 = 13061.2 seconds total
>>                 ~ 3.6 hours total
>>
>> The checksum based computation is approximately 34% faster than the
>> parity computation.  Much of this of course is that you have to process
>> the regular data twice for the parity computation method (once for
>> csums, once for parity).  You could probably do one pass computing both
>> values, but that would need to be done carefully; and, without
>> significant optimization, would likely not get you much benefit other
>> than cutting the number of loads in half.
>
> And it all means jack shit because you don't get the data to disk that
> quick. Who cares if its 500% faster - if it still saturates the
> throughput of the actual drives, what difference does it make?
It has less impact on everything else running on the system at the time 
because it uses less CPU time and potentially less memory.  This is the 
exact same reason that you want your RAID parity computation performance 
as good as possible, the less time the CPU spends on that, the more it 
can spend on other things.  On top of that, there are high-end systems 
that do have SSD's that can get multiple GB/s of data transfer per 
second, and NVDIMM's are starting to become popular in the server 
market, and those give you data transfer speeds equivalent to regular 
memory bandwidth (which can be well over 20GB/s on decent hardware (I've 
got a relatively inexpensive system using DDR3-1866 RAM that has roughly 
22-24GB/s of memory bandwidth)).  Looking at this another way, the fact 
that the storage device is the bottleneck right now is not a good excuse 
to not worry about making everything else as efficient as possible.
