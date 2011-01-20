From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Btrfs balance
Date: Thu, 20 Jan 2011 15:09:00 +0000
Message-ID: <20110120150900.GA4178@carfax.org.uk>
References: <4D38338B.3090903@gmail.com>
 <20110120133957.GB1301@carfax.org.uk>
 <4D384C75.5090202@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D384C75.5090202@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 20, 2011 at 03:53:41PM +0100, Andreas Philipp wrote:
> On 20.01.2011 14:39, Hugo Mills wrote:
> > On Thu, Jan 20, 2011 at 02:07:23PM +0100, Andreas Philipp wrote:
> >> Hi,
> >>
> >> Maybe it is a very stupid question but I want to ask it anyway. In
> >> general, 'btrfs filesystem balance' takes very long to finish and
> >> produces lots of IO. So what are the classical usage scenarios, when
> >> it is (really) worth doing a balance?
> >    The primary use-cases for balancing are to even out the filesystem
> > after adding, removing or changing the size of one of the underlying
> > volumes.
> Ok, so this is "a little bit" like for example resyncing a "classical"
> raid after it was in degraded mode etc.

   Pretty much exactly that.

> >    It will also be of use when we finally get around to allowing you
> > to change RAID settings on the whole volume, to implement the
> > requested changes to the RAID level.
> >
> Definitely, a nice feature.
> >    I'm in the process of implementing balance filters, so that some
> > other cases where balancing is useful (reclaiming unused block groups)
> > can be run more efficiently by only balancing the bits that need
> > doing.
> I have seen your post on balance filters. So then it will be (much)
> faster just because less is done?=20

   Yes, that's the idea. If you've lost and replaced a drive from a
2-drive RAID-1 array, there's not much that filters can do for you:
all your data will have to be read and rebuilt. However, if you're
changing just your metadata from DUP to RAID-1, say, or recovering
=66rom the loss of one drive in an 8-drive RAID-1 array, it should be an
awful lot faster with filters.

> When you have a version for trying it out and you need someone for
> testing I will give it a try.

   Thanks. I've got quite a bit reworked now to support multiple
filter types, but I need to do a full review of what I'm doing, and
test it myself first. I probably won't have much time to work on it
before Monday, now.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- emacs: Eats Memory and Crashes. ---                =20

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOFAMIKyzvlFcI40RAnqZAJ9BN3xLISzPZ7yK6TBMl5nfTpn+IACgkwmJ
Yquajb5IYaTucpuJGpaVH/8=
=ZuLx
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
