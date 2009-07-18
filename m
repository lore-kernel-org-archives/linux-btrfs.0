From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Sat, 18 Jul 2009 12:53:36 +0100
Message-ID: <1247918016.22313.138.camel@macbook.infradead.org>
References: <1247494302.19180.268.camel@macbook.infradead.org>
	 <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
	 <4A5F6590.9000006@zytor.com> <4A608913.1060808@redhat.com>
	 <4A6096A0.5050501@zytor.com> <4A609A52.7070506@redhat.com>
	 <4A609B72.2010901@zytor.com> <4A609CFA.2060707@redhat.com>
	 <4A609D8D.8050501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A609D8D.8050501@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-07-17 at 11:49 -0400, H. Peter Anvin wrote:
> Ric Wheeler wrote:
> >>
> >> The bottom line is pretty much this: the cost of changing the enco=
ding
> >> would appear to outweigh the benefit. I'm not trying to claim the =
Linux
> >> RAID-6 implementation is optimal, but it is simple and appears to =
be
> >> fast enough that the math isn't the bottleneck.
> >=20
> > Cost? Thank about how to get free grad student hours testing out th=
ings=20
> > that you might or might not want to leverage on down the road :-)
> >=20
>=20
> Cost, yes, of changing an on-disk format.

Personally, I don't care about that -- I'm utterly uninterested in the
legacy RAID-6 setup where it pretends to be a normal disk. I think that
model is as fundamentally wrong as flash devices making the similar
pretence.

I'm only interested in what we can use directly within btrfs -- and
ideally I do want something which gives me an _arbitrary_ number of
redundant blocks, rather than limiting me to 2. But the legacy code is
good enough for now=C2=B9.

When I get round to wanting more, I was thinking of lifting something
like http://git.infradead.org/mtd-utils.git?a=3Dblob;f=3Dfec.c to start
with, and maybe hoping that someone cleverer will come up with somethin=
g
better.

The less I have to deal with Galois Fields, the happier I'll be.

--=20
David Woodhouse                            Open Source Technology Centr=
e
David.Woodhouse@intel.com                              Intel Corporatio=
n

=C2=B9 Well, kind of. The xor_blocks() function will silently screw you=
 over
  if you ask it to handle more than 5 blocks at a time.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
