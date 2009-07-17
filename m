From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Fri, 17 Jul 2009 11:49:33 -0400
Message-ID: <4A609D8D.8050501@zytor.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com> <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com> <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Dan Williams <dan.j.williams@intel.com>,
	David Woodhouse <dwmw2@infradead.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A609CFA.2060707@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
>>
>> The bottom line is pretty much this: the cost of changing the encoding
>> would appear to outweigh the benefit. I'm not trying to claim the Linux
>> RAID-6 implementation is optimal, but it is simple and appears to be
>> fast enough that the math isn't the bottleneck.
> 
> Cost? Thank about how to get free grad student hours testing out things 
> that you might or might not want to leverage on down the road :-)
> 

Cost, yes, of changing an on-disk format.

	-hpa

