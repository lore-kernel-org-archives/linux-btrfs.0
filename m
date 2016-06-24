Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36792 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751394AbcFXSG0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 14:06:26 -0400
Date: Fri, 24 Jun 2016 14:06:15 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Andrei Borzenkov <arvidjaar@gmail.com>,
        kreijack@inwind.it, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624180615.GS15597@hungrycats.org>
References: <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org>
 <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <20160624101658.GI3325@carfax.org.uk>
 <CAJCQCtT1erMUphkn_-NPhT3A0gV1b-7O+OTxO=OsFHefRd53dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w1A23YewkF9s+fLd"
In-Reply-To: <CAJCQCtT1erMUphkn_-NPhT3A0gV1b-7O+OTxO=OsFHefRd53dA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--w1A23YewkF9s+fLd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2016 at 11:40:56AM -0600, Chris Murphy wrote:
> On Fri, Jun 24, 2016 at 4:16 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Fri, Jun 24, 2016 at 12:52:21PM +0300, Andrei Borzenkov wrote:
> >    For data, say you have n-1 good devices, with n-1 blocks on them.
> > Each block has a checksum in the metadata, so you can read that
> > checksum, read the blocks, and verify that they're not damaged. From
> > those n-1 known-good blocks (all data, or one parity and the rest
> > data) you can reconstruct the remaining block. That reconstructed
> > block won't be checked against the csum for the missing block -- it'll
> > just be written and a new csum for it written with it.
>=20
> The last sentence is hugely problematic. Parity doesn't appear to be
> either CoW'd or checksummed. If it is used for reconstruction and the
> reconstructed data isn't compared to the data's EXTENT_CSUM entry, but
> that entry is rather recomputed and written, that's just like blindly
> trusting the parity is correct and then authenticating it with a csum.

I think what happens is the data is recomputed, but the csum on the
data is _not_ updated (the csum does not reside in the raid56 code).
A read of the reconstructed data would get a csum failure (of course,
every 4 billionth time this happens the csum is correct by random chance,
so you wouldn't want to be reading parity blocks from a drive full of
garbage, but that's a different matter).

> It's  not difficult to test. Corrupt one byte of parity. Yank a drive.
> Add a new one. Start a reconstruction with scrub or balance (or both
> to see if they differ) and find out what happens. What should happen
> is the reconstruct should work for everything except that one file. If
> it's reconstructed silently, it should contain visible corruption and
> we all collectively raise our eyebrows.

I've done something like that test:  write random data to 1000 random
blocks on one disk, then run scrub.  It reconstructs the data without
problems (except for the minor wart that 'scrub status -d' counts the
randomly against every device, while 'dev stats' counts all the errors
on the disk that was corrupted).

Disk-side data corruption is a thing I have to deal with a few times each
year, so I tested the btrfs raid5 implementation for that case before I
started using it.  As far as I can tell so far, everything in btrfs raid5
works properly if a disk fails _while the filesystem is not mounted_.

The problem I see in the field is not *silent* corruption.  It's a whole
lot of very *noisy* corruption detected under circumstances where I'd
expect to see no corruption at all (silent or otherwise).


--w1A23YewkF9s+fLd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldtdpcACgkQgfmLGlazG5xRZwCeOYsemOz1Hmjio6vxywfVqZks
EdUAniag/D4obfPg8SzaVQ0GiPQdzc52
=23I5
-----END PGP SIGNATURE-----

--w1A23YewkF9s+fLd--
