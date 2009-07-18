From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Sat, 18 Jul 2009 08:49:25 -0400
Message-ID: <4A61C4D5.6020707@redhat.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>	 <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>	 <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com>	 <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com>	 <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com>	 <4A609D8D.8050501@zytor.com> <1247918016.22313.138.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org, plank@cs.utk.edu
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247918016.22313.138.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2009 07:53 AM, David Woodhouse wrote:
> On Fri, 2009-07-17 at 11:49 -0400, H. Peter Anvin wrote:
>   =20
>> Ric Wheeler wrote:
>>     =20
>>>> The bottom line is pretty much this: the cost of changing the enco=
ding
>>>> would appear to outweigh the benefit. I'm not trying to claim the =
Linux
>>>> RAID-6 implementation is optimal, but it is simple and appears to =
be
>>>> fast enough that the math isn't the bottleneck.
>>>>         =20
>>> Cost? Thank about how to get free grad student hours testing out th=
ings
>>> that you might or might not want to leverage on down the road :-)
>>>
>>>       =20
>> Cost, yes, of changing an on-disk format.
>>     =20
>
> Personally, I don't care about that -- I'm utterly uninterested in th=
e
> legacy RAID-6 setup where it pretends to be a normal disk. I think th=
at
> model is as fundamentally wrong as flash devices making the similar
> pretence.
>
> I'm only interested in what we can use directly within btrfs -- and
> ideally I do want something which gives me an _arbitrary_ number of
> redundant blocks, rather than limiting me to 2. But the legacy code i=
s
> good enough for now=C2=B9.
>
> When I get round to wanting more, I was thinking of lifting something
> like http://git.infradead.org/mtd-utils.git?a=3Dblob;f=3Dfec.c to sta=
rt
> with, and maybe hoping that someone cleverer will come up with someth=
ing
> better.
>
> The less I have to deal with Galois Fields, the happier I'll be.
>
>   =20

I think that we are generally fine with the RAID5/6 support given a=20
small number of drives. The fancier erasure encodings are much more=20
interesting when you have a large number of drives - for example, we=20
just ordered 4 shelves of SATA drives (15/shelf) that will be driven by=
=20
a single server. You can certainly imagine profiling a lot of=20
interesting variations with that many things to play with.

Ric


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
