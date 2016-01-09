Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53876 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbcAIU1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 15:27:03 -0500
Date: Sat, 9 Jan 2016 20:26:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "cheater00 ." <cheater00@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Message-ID: <20160109202659.GC6060@carfax.org.uk>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
 <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
In-Reply-To: <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 09, 2016 at 09:00:47PM +0100, cheater00 . wrote:
> Hello,
> I can repeatedly trigger this bug by making the "data" portion fill
> up. If you remember the partition is 6 TB but in btrfs filesystem df
> Data is shown as only 2TB when in fact it should be nearly 6TB. So
> this has nothing to do with kernel bugs. The filesystem on disk is
> structured incorrectly. How do i fix this? How do I make "Data"
> bigger? What is it exactly?

   This is *exactly* the behaviour of the known kernel bug. The bug is
that the FS *should* be extending the data allocation when it gets
near to full, and it's not. There is no way of manually allocating
more (because the FS should be doing it automatically). There is no
known way of persuading the FS to it when it isn't.

   The only good solution I know of is to reformat the FS and restore
=66rom backups. Even then, some people manage to repeatedly hit this
with newly-created filesystems.

   Hugo.

> Thanks
>=20
> P.S. Sorry about reposting twice, apparently Google's "Inbox" app
> doesn't allow posting plain text at all and the mail got rejected from
> the list.
>=20
> On Thu, 7 Jan 2016 23:22 Chris Murphy <lists@colorremedies.com> wrote:
> >
> > On Thu, Jan 7, 2016 at 3:04 PM, cheater00 . <cheater00@gmail.com> wrote:
> > > Yes, both times it was the same drive. I only have one usb drive now.
> >
> > That it's the same drive is suspicious. But I don't know what
> > errno=3D-28 means or what could trigger it, if some USB weirdness could
> > cause Btrfs to get confused somehow. I have one 7200rpm drive that
> > wants 1.15A compared to all the others that have a 900mA spec, and
> > while it behaves find 99% of the time like the others, rarely I would
> > get the reset message and most of the time it was that drive (and less
> > often one other). Now that doesn't happen anymore.
> >
> > >
> > > I am not sure if chasing the kernel makes sense unless you think ther=
e is a
> > > specific commit that would have foxed it. I only reported here in case
> > > anyone here wanted to do some form of debugging before i reset the dr=
ive and
> > > rescan the fs to make it writeable again. But since there seems to be=
 no
> > > interest i will go forward.
> >
> > I'd chase the hardware problem then first. It's just that the kernel
> > switch is easier from my perspective. And it's just as unclear this is
> > hardware related than just a bug. And since there are hundreds to
> > thousands of Btrfs bugs being fixed per kernel release, I have no way
> > to tell you whether it's fixed and maybe even a developer wouldn't
> > either, you'd just have to try it.
> >
> >

--=20
Hugo Mills             | Hey, Virtual Memory! Now I can have a *really big*
hugo@... carfax.org.uk | ramdisk!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWkW0TAAoJEFheFHXiqx3kUrwP/1OAI7TOmROgqEnZeFxNWqGL
gK/68dJ+1/foFMlPRc/RIiS4HSdaV5IAcf4iGtm92C86wZEnRYWeol+gssTrbqGl
/3PjqcgrH/v3i7ky4G4miWT2PR9RTRvO2cWJR8piu0eWwae7PSptVWRLzRtQDDTO
4KN18mYYMzM3Axjldlz5A8OFo9OSjdcX2wGEmmlIy351UzWsKCH/G9G1BmmCzwRZ
GFNocDz0Oz96XzHTch17UpLVg/lWRrdzNEwz3zfVe6QazTYy03kz5QEBEB8Z9XIv
jaSnK9fiWGmVR80bLxQ12PteeN+Auz/jB53djU6NF4d+6d+DuDL/aIgwGl4A+Dh1
XUS0v0U8dqD1snO8K2AhjK+EmQcfDWM/NDaTLPhSZ2olgdPWiFxItEMXgY+37hL3
KMKi8PjOPHTpP2q6ttK/WI6QSmDbn8rOdhzRQxLA6xzjeSXRe6OnKIs5F3Nv5R4c
Cjf1uVwWmp5j5QBCi3XC64A/8e6CV+vc778bVf7sYtveKghFQpE/bKaAREVVH9oe
8iiIfR7u0FcPB8stgMy57tvjAg77SIqYZr3mMEStRSGjNlpxnbHvYCudWA/awJ9e
n/oO3l1Dtxt1VNEZtD59czqutRVENwlDUoY9lC3YS8ZnrRml5Hz+MYZBGJ63zIbh
slTNndAdFsQ2NHkycwka
=TBIq
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
