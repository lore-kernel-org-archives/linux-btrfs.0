From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Fri, 17 Jul 2009 12:02:12 -0700
Message-ID: <h3qhri$3di$2@ger.gmane.org>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com> <4A609D8D.8050501@zytor.com> <4A609FA0.7060404@redhat.com> <h3qhmp$3di$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: linux-raid@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Alex Elsayed wrote:

> Ric Wheeler wrote:
> 
>> On 07/17/2009 11:49 AM, H. Peter Anvin wrote:
>>> Ric Wheeler wrote:
>>>>>
>>>>> The bottom line is pretty much this: the cost of changing the encoding
>>>>> would appear to outweigh the benefit. I'm not trying to claim the 
Linux
>>>>> RAID-6 implementation is optimal, but it is simple and appears to be
>>>>> fast enough that the math isn't the bottleneck.
>>>>
>>>> Cost? Thank about how to get free grad student hours testing out
>>>> things that you might or might not want to leverage on down the road 
:-)
>>>>
>>>
>>> Cost, yes, of changing an on-disk format.
>>>
>>> -hpa
>>>
>> 
>> Putting RAID6 behind us, we still might be interested in the other 
> encodings 
>> that are in:
>> 
>> "A Performance Evaluation and Examination of Open-Source Erasure Coding 
>> Libraries For Storage"
>> 
>> http://www.cs.utk.edu/~plank/plank/papers/FAST-2009.html
>> 
>> since they give us even more flexibility....
> 
> Of course, there's also the fact that, using (essentially unchanged) the 
> current code for Reed-Solomon coding, it's completely doable to have 
> arbitrary NxM redundancy up to (N + M) < 256 disks (this limit is due to 
> the 
> current maximum of 8 for symsize [referred to as 'w' in the below paper] 
> in 
> rs_init. If increased to 16, the maximum number of disks would be 65535). 
> It's also space-optimal for all combinations of N (checksum) and M (data).
> 
> http://www.cs.utk.edu/~plank/plank/papers/CS-96-332.html even describes an 
> implementation _very_ similar to the current code, right down to using a 
> table for the logarithm and inverse logarithm calculations.
> 
> Also, (referencing the earlier-posted paper comparing open-source coding 
> techniques), Cauchy Reed-Solomon codes seem to maintain most of the 
> benefits 
> of the current system (including the ability to provide NxM redundancy, 
> while still retaining the property of being space-optimal), with 
> significant 
> performance gains. It also provides an optimization for the RAID6 case, so 
> once again the common case would get a benefit over less common cases (as 
> with Mr. Anvin's RAID6 optimization in the current system)
> 
> However, I will have to dispute that the other methods provide more 
> flexibility - Cauchy Reed-Solomon codes are at best a horizontal move 
> there, 
> and the other systems are restricted to (or at very least, far more 
> effective in) RAID6 systems.

Whoops, got N (data) and M (checksum) backwards.



