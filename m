Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:40221 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeECL0I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 May 2018 07:26:08 -0400
Received: by mail-io0-f179.google.com with SMTP id g14-v6so17504301ioc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 03 May 2018 04:26:07 -0700 (PDT)
Subject: Re: RAID56 - 6 parity raid
To: kreijack@inwind.it, waxhead@dirtcellar.net, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
 <99e79113-39ac-e67e-ff22-bfcfcdac00bc@gmail.com>
 <432bd25d-b823-9661-a408-11864df43425@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <213fdc27-747b-0b14-d4a6-9f3b8c3bf0d0@gmail.com>
Date: Thu, 3 May 2018 07:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <432bd25d-b823-9661-a408-11864df43425@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-02 16:40, Goffredo Baroncelli wrote:
> On 05/02/2018 09:29 PM, Austin S. Hemmelgarn wrote:
>> On 2018-05-02 13:25, Goffredo Baroncelli wrote:
>>> On 05/02/2018 06:55 PM, waxhead wrote:
>>>>>
>>>>> So again, which problem would solve having the parity checksummed ? On the best of my knowledge nothing. In any case the data is checksummed so it is impossible to return corrupted data (modulo bug :-) ).
>>>>>
>>>> I am not a BTRFS dev , but this should be quite easy to answer. Unless you checksum the parity there is no way to verify that that the data (parity) you use to reconstruct other data is correct.
>>>
>>> In any case you could catch that the compute data is wrong, because the data is always checksummed. And in any case you must check the data against their checksum.
>>>
>>> My point is that storing the checksum is a cost that you pay *every time*. Every time you update a part of a stripe you need to update the parity, and then in turn the parity checksum. It is not a problem of space occupied nor a computational problem. It is a a problem of write amplification...
>>>
>>> The only gain is to avoid to try to use the parity when
>>> a) you need it (i.e. when the data is missing and/or corrupted)
>>> and b) it is corrupted.
>>> But the likelihood of this case is very low. And you can catch it during the data checksum check (which has to be performed in any case !).
>>>
>>> So from one side you have a *cost every time* (the write amplification), to other side you have a gain (cpu-time) *only in case* of the parity is corrupted and you need it (eg. scrub or corrupted data)).
>>>
>>> IMHO the cost are very higher than the gain, and the likelihood the gain is very lower compared to the likelihood (=100% or always) of the cost.
>> You do realize that a write is already rewriting checksums elsewhere? It would be pretty trivial to make sure that the checksums for every part of a stripe end up in the same metadata block, at which point the only cost is computing the checksum (because when a checksum gets updated, the whole block it's in gets rewritten, period, because that's how CoW works).
>>
>> Looking at this another way (all the math below uses SI units):
>>
> [...]
> Good point: precomputing the checksum of the parity save a lot of time for the scrub process. You can see this in a more simply way saying that the parity calculation (which is dominated by the memory bandwidth) is like O(n) (where n is the number of disk); the parity checking (which again is dominated by the memory bandwidth) against a checksum is like O(1). And when the data written is 2 order of magnitude lesser than the data stored, the effort required to precompute the checksum is negligible.
Excellent point about the computational efficiency, I had not thought of 
framing things that way.
> 
> Anyway, my "rant" started when Ducan put near the missing of parity checksum and the write hole. The first might be a performance problem. Instead the write hole could lead to a loosing data. My intention was to highlight that the parity-checksum is not related to the reliability and safety of raid5/6.
It may not be related to the safety, but it is arguably indirectly 
related to the reliability, dependent on your definition of reliability. 
  Spending less time verifying the parity means you're spending less 
time in an indeterminate state of usability, which arguably does improve 
the reliability of the system.  However, that does still have nothing to 
do with the write hole.
> 
>>
>> So, lets look at data usage:
>>
>> 1GB of data is translates to 62500 16kB blocks of data, which equates to an additional 15625 blocks for parity.  Adding parity checksums adds a 25% overhead to checksums being written, but that actually doesn't translate to a huge increase in the number of _blocks_ of checksums written.  One 16k block can hold roughly 500 checksums, so it would take 125 blocks worth of checksums without parity, and 157 (technically 156.25, but you can't write a quarter block) with parity checksums. Thus, without parity checksums, writing 1GB of data involves writing 78250 blocks, while doing the same with parity checksums involves writing 78282 blocks, a net change of only 32 blocks, or **0.0409%**.
> 
> How you would store the checksum ?
> I asked that because I am not sure that we could use the "standard" btrfs metadata to store the checksum of the parity. Doing so you could face some pathological effect like:
> - update a block(1) in a stripe(1)
> - update the parity of stripe(1) containing block(1)
> - update the checksum of parity stripe (1), which is contained in another stripe(2) [**]
> 
> - update the parity of stripe (2) containing the checksum of parity stripe(1)
> - update the checksum of parity stripe (2), which is contained in another stripe(3)
> 
> and so on...
> 
> [**] pay attention that the checksum and the parity *have* to be in different stripe, otherwise you have the egg/chicken problem: compute the parity, then update the checksum, then update the parity again because the checksum is changed....
Unless I'm completely mistaken about how BTRFS handles parity, it's 
accounted as part of whatever type of block it's for.  IOW, for data 
chunks, it would be no different from storing checksums for data, and if 
you're running metadata as parity RAID (which is debatably a bad idea in 
most cases), checksums for that parity would be handled just like 
regular metadata checksums.  Do note that there is a separate tree 
structure on-disk that handles the checksums, and I'm not sure if it 
even makes sense (given how small it is) to checksum the parity for that.
> 
> In order to avoid that, I fear that you can't store the checksum over a raid5/6 BG with parity checksummed;
> 
> It is a bit late and I am a bit tired out, so may be that I am wrong however I fear that the above "write amplification problem" may be a big problem; a possible solution would be storing the checksum in a N-mirror BG (where N is 1 for raid5, 2 for raid6....)
N would have to be one more than the number of parities to maintain the 
same guarantees of reliability.  That said, if we had N-way mirroring, 
that would be far better for metadata on most arrays than parity RAID, 
as the primary benefit of parity RAID (space efficiency) doesn't really 
matter much for metadata com pared to access performance.
