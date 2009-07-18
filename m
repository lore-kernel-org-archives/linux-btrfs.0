From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Sat, 18 Jul 2009 08:45:13 -0400
Message-ID: <4A61C3D9.6020200@zytor.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>	 <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>	 <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com>	 <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com>	 <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com>	 <4A609D8D.8050501@zytor.com> <1247918016.22313.138.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247918016.22313.138.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

David Woodhouse wrote:
>=20
> I'm only interested in what we can use directly within btrfs -- and
> ideally I do want something which gives me an _arbitrary_ number of
> redundant blocks, rather than limiting me to 2. But the legacy code i=
s
> good enough for now=C2=B9.
>=20
> When I get round to wanting more, I was thinking of lifting something
> like http://git.infradead.org/mtd-utils.git?a=3Dblob;f=3Dfec.c to sta=
rt
> with, and maybe hoping that someone cleverer will come up with someth=
ing
> better.
>=20
> The less I have to deal with Galois Fields, the happier I'll be.
>=20

Well, if you want something with more than 2-block redundancy you need=20
something other than the existing RAID-6 code which, as you know, is a=20
special case of general Reed-Solomon coding that I happen to have spent=
=20
a lot of time optimizing.  The FEC code is not optimized at all if I ca=
n=20
tell, and certainly doesn't use SSE in any way -- never mind the GF=20
accelerators that are starting to appear.  That doesn't mean it=20
*couldn't*, just that noone has done the work to either implement it or=
=20
prove it can't be done.

Either way, perhaps the Plank paper that Rik pointed to could be useful=
=20
as a starting point; it's probably worth taking their performance=20
numbers with a *major* grain of salt: their implementation of RAID-6=20
"RS-Opt" which is supposed to be equivalent to my code performs at
400 MB/s, which is less than Pentium III-era performance of the real=20
world code (they compare not to real code but to their own=20
implementation in Java, called "Jerasure".)  Implementability using rea=
l=20
array instruction sets is key to decent performance.

	-hpa
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
