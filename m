Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54031 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbcAIVP4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 16:15:56 -0500
Date: Sat, 9 Jan 2016 21:15:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "cheater00 ." <cheater00@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Message-ID: <20160109211553.GE6060@carfax.org.uk>
References: <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+b56+3nqLzpiR9O"
In-Reply-To: <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--a+b56+3nqLzpiR9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 09, 2016 at 10:07:50PM +0100, cheater00 . wrote:
> Would like to point out that this can cause data loss. If I'm writing
> to disk and the disk becomes unexpectedly read only - that data will
> be lost, because who in their right mind makes their code expect this
> and builds a contingency (e.g. caching, backpressure, etc)...
> 
> There's no loss of data on the disk because the data doesn't make it
> to disk in the first place. But it's exactly the same as if the data
> had been written to disk, and then lost.

   That's only the same kind of data loss that you'd encounter if the
power went out unexpectedly at the same point. The application isn't
told that data has been written to disk when it hasn't. It's far from
a good situation, but it's not a failure of data durability.

   Hugo.

> On Sat, Jan 9, 2016 at 10:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
> >> OK. How do we track down that bug and get it fixed?
> >
> >    I have no idea. I'm not a btrfs dev, I'm afraid.
> >
> >    It's been around for a number of years. None of the devs has, I
> > think, had the time to look at it. When Josef was still (publicly)
> > active, he had it second on his list of bugs to look at for many
> > months -- but it always got trumped by some new bug that could cause
> > data loss.
> >
> >    Hugo.
> >
> >> On Sat, Jan 9, 2016 at 9:26 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> > On Sat, Jan 09, 2016 at 09:00:47PM +0100, cheater00 . wrote:
> >> >> Hello,
> >> >> I can repeatedly trigger this bug by making the "data" portion fill
> >> >> up. If you remember the partition is 6 TB but in btrfs filesystem df
> >> >> Data is shown as only 2TB when in fact it should be nearly 6TB. So
> >> >> this has nothing to do with kernel bugs. The filesystem on disk is
> >> >> structured incorrectly. How do i fix this? How do I make "Data"
> >> >> bigger? What is it exactly?
> >> >
> >> >    This is *exactly* the behaviour of the known kernel bug. The bug is
> >> > that the FS *should* be extending the data allocation when it gets
> >> > near to full, and it's not. There is no way of manually allocating
> >> > more (because the FS should be doing it automatically). There is no
> >> > known way of persuading the FS to it when it isn't.
> >> >
> >> >    The only good solution I know of is to reformat the FS and restore
> >> > from backups. Even then, some people manage to repeatedly hit this
> >> > with newly-created filesystems.
> >> >
> >> >    Hugo.
> >> >
> >> >> Thanks
> >> >>
> >> >> P.S. Sorry about reposting twice, apparently Google's "Inbox" app
> >> >> doesn't allow posting plain text at all and the mail got rejected from
> >> >> the list.
> >> >>
> >> >> On Thu, 7 Jan 2016 23:22 Chris Murphy <lists@colorremedies.com> wrote:
> >> >> >
> >> >> > On Thu, Jan 7, 2016 at 3:04 PM, cheater00 . <cheater00@gmail.com> wrote:
> >> >> > > Yes, both times it was the same drive. I only have one usb drive now.
> >> >> >
> >> >> > That it's the same drive is suspicious. But I don't know what
> >> >> > errno=-28 means or what could trigger it, if some USB weirdness could
> >> >> > cause Btrfs to get confused somehow. I have one 7200rpm drive that
> >> >> > wants 1.15A compared to all the others that have a 900mA spec, and
> >> >> > while it behaves find 99% of the time like the others, rarely I would
> >> >> > get the reset message and most of the time it was that drive (and less
> >> >> > often one other). Now that doesn't happen anymore.
> >> >> >
> >> >> > >
> >> >> > > I am not sure if chasing the kernel makes sense unless you think there is a
> >> >> > > specific commit that would have foxed it. I only reported here in case
> >> >> > > anyone here wanted to do some form of debugging before i reset the drive and
> >> >> > > rescan the fs to make it writeable again. But since there seems to be no
> >> >> > > interest i will go forward.
> >> >> >
> >> >> > I'd chase the hardware problem then first. It's just that the kernel
> >> >> > switch is easier from my perspective. And it's just as unclear this is
> >> >> > hardware related than just a bug. And since there are hundreds to
> >> >> > thousands of Btrfs bugs being fixed per kernel release, I have no way
> >> >> > to tell you whether it's fixed and maybe even a developer wouldn't
> >> >> > either, you'd just have to try it.
> >> >> >
> >> >> >
> >> >
> >

-- 
Hugo Mills             | make bzImage, not war
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Markus Reichelt

--a+b56+3nqLzpiR9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWkXiJAAoJEFheFHXiqx3k0ZoP/2H5VrDtr2btjGirZ45N/N9X
r22BfQ2CwPP2VU0z6mwku19rGcIwdkF916ElulZnI6nDkSPABNjVWTVxw6Vf4ph5
wWS+PeJILarhO43H4UBCp+8wm/SU1tjMQUxu5h0iNiIPV8Qa+u2Ud6uNBG+2hGN2
RnQNeD0wSvB2bbdJLHhe+HulBRWNK7XzxKdvNeT1Ffw5TG5h2h9b/n1Y1cfV7Jnl
l/IEfhnBQWzg3M8un8ZwinL3AcT71op7lOyLY1atTP7o9arsV28Dnz0avf5/AF/0
xmuQtGqWCJKwku2byzUiW7jEKXyvW9iwmW1Zlc3ohXMnMldZPjJw9TXawwXttbjv
NcIQvEjzamEWnZ8iDSQoqzwCpjXSzOl29CjZ5rvxZ8rIVZq1e+u3C0mFLXyac1rf
t7SUlTX8nyh+rrP+RaYd/Dz9U10LBSvvxriQOpKSB2a37WwRTGfRE1vTx+hCgs9k
lX2cQc/R65nZrlJ5ZxM4/a5B8QR8Etr/zJOJCu6an+//CBhYPlw1TRO0fROfDBnr
pngjwdOML6SbVBCqyp9kTv0rDvxi+8sO1nbJVw9ph0KfVaPRxNo0PB8WB53s+EU6
Ju57BzOvbCz9Q2xLYADuVsanNuDXE6QGbP5UbTPL2H05DtKAP9jgVCc8a7HMZfy0
D8ODV8ywmhXBbZz+WT75
=mbiU
-----END PGP SIGNATURE-----

--a+b56+3nqLzpiR9O--
