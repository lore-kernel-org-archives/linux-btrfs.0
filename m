From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Fri, 17 Jul 2009 11:47:06 -0400
Message-ID: <4A609CFA.2060707@redhat.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Dan Williams <dan.j.williams@intel.com>,
	David Woodhouse <dwmw2@infradead.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A609B72.2010901@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2009 11:40 AM, H. Peter Anvin wrote:
> Ric Wheeler wrote:
>>>
>>> I have seen the papers; I'm not sure it really makes that much
>>> difference. One of the things that bugs me about these papers is that he
>>> compares to *his* implementation of my optimizations, but not to my
>>> code. In real life implementations, on commodity hardware, we're limited
>>> by memory and disk performance, not by CPU utilization.
>>>
>>
>> Fair enough - I thought that his coverage of the other open source
>> friendly encodings beyond RAID6 was actually quite interesting.
>>
>> If you have specifics that you found unconvincing in his work, I am
>> pretty sure that he would be delighted to hear from you first hand.
>> James seemed to me to be very reasonable and very much a pro-Linux
>> academic, so I would love to be able to get him and his grad students
>> aligned in a useful way for us :-)
>>
>
> The main flaw, as I said, is in the phrase "as implemented by the
> Jerasure library". He's comparing his own implementations of various
> algorithms, not optimized implementations.
>
> The bottom line is pretty much this: the cost of changing the encoding
> would appear to outweigh the benefit. I'm not trying to claim the Linux
> RAID-6 implementation is optimal, but it is simple and appears to be
> fast enough that the math isn't the bottleneck.
>
> -hpa

Cost? Thank about how to get free grad student hours testing out things that you 
might or might not want to leverage on down the road :-)

ric

