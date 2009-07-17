From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Fri, 17 Jul 2009 11:58:24 -0400
Message-ID: <4A609FA0.7060404@redhat.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com> <4A609D8D.8050501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Dan Williams <dan.j.williams@intel.com>,
	David Woodhouse <dwmw2@infradead.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A609D8D.8050501@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2009 11:49 AM, H. Peter Anvin wrote:
> Ric Wheeler wrote:
>>>
>>> The bottom line is pretty much this: the cost of changing the encoding
>>> would appear to outweigh the benefit. I'm not trying to claim the Linux
>>> RAID-6 implementation is optimal, but it is simple and appears to be
>>> fast enough that the math isn't the bottleneck.
>>
>> Cost? Thank about how to get free grad student hours testing out
>> things that you might or might not want to leverage on down the road :-)
>>
>
> Cost, yes, of changing an on-disk format.
>
> -hpa
>

Putting RAID6 behind us, we still might be interested in the other encodings 
that are in:

"A Performance Evaluation and Examination of Open-Source Erasure Coding 
Libraries For Storage"

http://www.cs.utk.edu/~plank/plank/papers/FAST-2009.html

since they give us even more flexibility....

ric
