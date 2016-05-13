Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40560 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751104AbcEMGBF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 02:01:05 -0400
Date: Fri, 13 May 2016 02:01:03 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, Mark Fasheh <mfasheh@suse.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160513060103.GE15597@hungrycats.org>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
 <20160511025211.GF7633@wotan.suse.de>
 <20160511173659.GI29353@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
In-Reply-To: <20160511173659.GI29353@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 11, 2016 at 07:36:59PM +0200, David Sterba wrote:
> I like the in-memory dedup backend. It's lightweight, only a heuristic,
> does not need any IO or persistent storage. OTOH I consider it a subpart
> of the in-band deduplication that does all the persistency etc. So I
> treat the ioctl interface from a broader aspect.
>=20
> A usecase I find interesting is to keep the in-memory dedup cache and
> then flush it to disk on demand, compared to automatically synced dedup
> (eg. at commit time).

The tradeoff depends on a lot of parameters, like your expected dup rate,
memory size, and seek latency.  If the dup rate is high (say 40%) and
your seek latency is high (low-cost spinning rust) and you don't have
enough RAM to load the whole hash table into memory, then an on-disk
dedup cache _itself_ creates an unusable I/O load.  Hash table lookups
generate random I/O, and at 40% dup rate every other block you write
requires a performance-crippling disk seek to read the half of the cache
that isn't in RAM.

I looked at my parameters and concluded that an in-memory cache (with
persistence by saving the data at regular intervals) was the *only*
kind of cache I'd ever be able to use with any dedup implementation.

If the dup rate is lower or you're using SSD then you might trade some
IOs for more free RAM and consider an on-disk hash table with some sort of
paging scheme.  If you have huge amounts of RAM you don't need an on-disk
scheme at all--you can add persistence e.g. by trickle-writing the data
over the space of an hour to avoid adding a lot of latency or memory
pressure at once.

> > Users can get better dedupe via the ioctl today than with what
> > you propose go in as an experimental feature so I don't see many people
> > caring to test it. IMHO you would have to provide a more compelling rea=
son
> > to include this code.
>=20
> I see it as a complementary feature in the deduplication capabilities,
> covering more usecases.

If you have unlimited amounts of RAM, fast CPU, and slow disks, then it
certainly makes sense, even with the SHA256 hash.  That seems to be the
use case ZFS was designed for.


--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlc1bZ8ACgkQgfmLGlazG5wXxwCgy1MarhSUpJMEFE5JwWNP+4tL
+1YAn0ZHghfcsH/QRaQS2O/W13TiruhX
=rzMH
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
