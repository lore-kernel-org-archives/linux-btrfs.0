Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:36270 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbeEBT3s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 15:29:48 -0400
Received: by mail-it0-f47.google.com with SMTP id e20-v6so18472447itc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 May 2018 12:29:48 -0700 (PDT)
Subject: Re: RAID56 - 6 parity raid
To: kreijack@inwind.it, waxhead@dirtcellar.net, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <99e79113-39ac-e67e-ff22-bfcfcdac00bc@gmail.com>
Date: Wed, 2 May 2018 15:29:46 -0400
MIME-Version: 1.0
In-Reply-To: <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-02 13:25, Goffredo Baroncelli wrote:
> On 05/02/2018 06:55 PM, waxhead wrote:
>>>
>>> So again, which problem would solve having the parity checksummed ? On the best of my knowledge nothing. In any case the data is checksummed so it is impossible to return corrupted data (modulo bug :-) ).
>>>
>> I am not a BTRFS dev , but this should be quite easy to answer. Unless you checksum the parity there is no way to verify that that the data (parity) you use to reconstruct other data is correct.
> 
> In any case you could catch that the compute data is wrong, because the data is always checksummed. And in any case you must check the data against their checksum.
> 
> My point is that storing the checksum is a cost that you pay *every time*. Every time you update a part of a stripe you need to update the parity, and then in turn the parity checksum. It is not a problem of space occupied nor a computational problem. It is a a problem of write amplification...
> 
> The only gain is to avoid to try to use the parity when
> a) you need it (i.e. when the data is missing and/or corrupted)
> and b) it is corrupted.
> But the likelihood of this case is very low. And you can catch it during the data checksum check (which has to be performed in any case !).
> 
> So from one side you have a *cost every time* (the write amplification), to other side you have a gain (cpu-time) *only in case* of the parity is corrupted and you need it (eg. scrub or corrupted data)).
> 
> IMHO the cost are very higher than the gain, and the likelihood the gain is very lower compared to the likelihood (=100% or always) of the cost.
You do realize that a write is already rewriting checksums elsewhere? 
It would be pretty trivial to make sure that the checksums for every 
part of a stripe end up in the same metadata block, at which point the 
only cost is computing the checksum (because when a checksum gets 
updated, the whole block it's in gets rewritten, period, because that's 
how CoW works).

Looking at this another way (all the math below uses SI units):

Assume you have a BTRFS raid5 volume consisting of 6 8TB disks (which 
gives you 40TB of usable space).  You're storing roughly 20TB of data on 
it, using a 16kB block size, and it sees about 1GB of writes a day, with 
no partial stripe writes.  You, for reasons of argument, want to scrub 
it every week, because the data in question matters a lot to you.

With a decent CPU, lets say you can compute 1.5GB/s worth of checksums, 
and can compute the parity at a rate of 1.25G/s (the ratio here is about 
the average across the almost 50 systems I have quick access to check, 
including a number of server and workstation systems less than a year 
old, though the numbers themselves are artificially low to accentuate 
the point here).

At this rate, scrubbing by computing parity requires processing:

* Checksums for 20TB of data, at a rate of 1.5GB/s, which would take 
13333 seconds, or 222 minutes, or about 3.7 hours.
* Parity for 20TB of data, at a rate of 1.25GB/s, which would take 16000 
seconds, or 267 minutes, or roughly 4.4 hours.

So, over a week, you would be spending 8.1 hours processing data solely 
for data integrity, or roughly 4.8214% of your time.

Now assume instead that you're doing checksummed parity:

* Scrubbing data is the same, 3.7 hours.
* Scrubbing parity turns into computing checksums for 4TB of data, which 
would take 3200 seconds, or 53 minutes, or roughly 0.88 hours.
* Computing parity for the 7GB of data you write each week takes 5.6 
_SECONDS_.

So, over a week, you would spend just over 4.58 hours processing data 
solely for data integrity, or roughly 2.7262% of your time.

So, in terms of just time spent, it's almost twice as fast to use 
checksummed parity (roughly 43% faster to be more specific).

So, lets look at data usage:

1GB of data is translates to 62500 16kB blocks of data, which equates to 
an additional 15625 blocks for parity.  Adding parity checksums adds a 
25% overhead to checksums being written, but that actually doesn't 
translate to a huge increase in the number of _blocks_ of checksums 
written.  One 16k block can hold roughly 500 checksums, so it would take 
125 blocks worth of checksums without parity, and 157 (technically 
156.25, but you can't write a quarter block) with parity checksums. 
Thus, without parity checksums, writing 1GB of data involves writing 
78250 blocks, while doing the same with parity checksums involves 
writing 78282 blocks, a net change of only 32 blocks, or **0.0409%**.

Note that the difference in the amount of checksums written is a simple 
linear function directly proportionate to the amount of data being 
written provided that all rewrites only rewrite full stripes (because 
that's equivalent for this to just adding new data).  In other words, 
even if we were to increase the total amount of data that array was 
getting in a day, the net change from having parity checksumming would 
still stay within the range of 0.03-0.05%.

Making some of those partial re-writes skews the value upwards, but it 
can never be worse than 25% on a raid5 array (because you can't write 
less than a single block, and therefore the pathological worst case 
involves writing one data block, which translates to a single checksum 
and parity write, and in turn to only a single block written for parity 
checksums).  The exact level of how bad it can get is of course worse 
with higher levels of parity (it's a 33.333% increase for RAID6, 60% for 
raid with 3 parity blocks, etc).

So, given the above, this is a pretty big net win in terms of overhead 
for single-parity RAID arrays, even in the pathological worst case (25% 
higher write overhead (which happens once for each block), in exchange 
for 43% lower post-write processing overhead for data integrity (which 
usually happens way more than once for each block)).
