Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48364 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750847AbcFXBrx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 21:47:53 -0400
Date: Thu, 23 Jun 2016 21:47:52 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: kreijack@inwind.it, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624014752.GB14667@hungrycats.org>
References: <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
In-Reply-To: <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 06:26:22PM -0600, Chris Murphy wrote:
> On Thu, Jun 23, 2016 at 1:32 PM, Goffredo Baroncelli <kreijack@inwind.it>=
 wrote:
> > The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to the che=
cksum.
>=20
> Yeah I'm kinda confused on this point.
>=20
> https://btrfs.wiki.kernel.org/index.php/RAID56
>=20
> It says there is a write hole for Btrfs. But defines it in terms of
> parity possibly being stale after a crash. I think the term comes not
> from merely parity being wrong but parity being wrong *and* then being
> used to wrongly reconstruct data because it's blindly trusted.

I think the opposite is more likely, as the layers above raid56
seem to check the data against sums before raid56 ever sees it.
(If those layers seem inverted to you, I agree, but OTOH there are
probably good reason to do it that way).

It looks like uncorrectable failures might occur because parity is
correct, but the parity checksum is out of date, so the parity checksum
doesn't match even though data blindly reconstructed from the parity
*would* match the data.

> I don't read code well enough, but I'd be surprised if Btrfs
> reconstructs from parity and doesn't then check the resulting
> reconstructed data to its EXTENT_CSUM.

I wouldn't be surprised if both things happen in different code paths,
given the number of different paths leading into the raid56 code and
the number of distinct failure modes it seems to have.


--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldskUgACgkQgfmLGlazG5xkWgCeOVAy7iMlB8dSxL7SRCxtTM4j
9LQAoJNl1/GkJEuxkjfSyVm1vTLJ+QPY
=q47n
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
