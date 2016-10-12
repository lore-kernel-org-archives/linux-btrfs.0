Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46876 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934181AbcJLVLe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 17:11:34 -0400
Date: Wed, 12 Oct 2016 17:10:18 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012211017.GJ26140@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
 <20161012171936.GD26140@hungrycats.org>
 <20161012195528.GB4800@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hk6Zb6cduJ+I0Tmj"
In-Reply-To: <20161012195528.GB4800@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hk6Zb6cduJ+I0Tmj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2016 at 09:55:28PM +0200, Adam Borowski wrote:
> On Wed, Oct 12, 2016 at 01:19:37PM -0400, Zygo Blaxell wrote:
> > On Wed, Oct 12, 2016 at 01:48:58PM +0800, Qu Wenruo wrote:
> > > In fact, the _concept_ to solve such RMW behavior is quite simple:
> > >=20
> > > Make sector size equal to stripe length. (Or vice versa if you like)
> > >=20
> > > Although the implementation will be more complex, people like Chandan=
 are
> > > already working on sub page size sector size support.
> >=20
> > So...metadata blocks would be 256K on the 5-disk RAID5 example above,
> > and any file smaller than 256K would be stored inline?  Ouch.  That wou=
ld
> > also imply the compressed extent size limit (currently 128K) has to bec=
ome
> > much larger.
> >=20
> > I had been thinking that we could inject "plug" extents to fill up
> > RAID5 stripes.  This lets us keep the 4K block size for allocations,
> > but at commit (or delalloc) time we would fill up any gaps in new RAID
> > stripes to prevent them from being modified.  As the real data is delet=
ed
> > from the RAID stripes, it would be replaced by "plug" extents to keep a=
ny
> > new data from being allocated in the stripe.  When the stripe consists
> > entirely of "plug" extents, the plug extent would be deleted, allowing
> > the stripe to be allocated again.  The "plug" data would be zero for
> > the purposes of parity reconstruction, regardless of what's on the disk.
> > Balance would just throw the plug extents away (no need to relocate the=
m).
>=20
> Your idea sounds good, but there's one problem: most real users don't
> balance.  Ever.  Contrary to the tribal wisdom here, this actually works
> fine, unless you had a pathologic load skewed to either data or metadata =
on
> the first write then fill the disk to near-capacity with a load skewed the
> other way.

> Most usage patterns produce a mix of transient and persistent data (and at
> write time you don't know which file is which), meaning that with time ev=
ery
> stripe will contain a smidge of cold data plus a fill of plug extents.

Yes, it'll certainly reduce storage efficiency.  I think all the
RMW-avoidance strategies have this problem.  The alternative is to risk
losing data or the entire filesystem on disk failure, so any of the
RMW-avoidance strategies are probably a worthwhile tradeoff.  Big RAID5/6
arrays tend to be used mostly for storing large sequentially-accessed
files which are less susceptible to this kind of problem.

If the pattern is lots of small random writes then performance on raid5
will be terrible anyway (though it may even be improved by using plug
extents, since RMW stripe updates would be replaced with pure CoW).

> Thus, while the plug extents idea doesn't suffer from problems of big
> sectors you just mentioned, we'd need some kind of auto-balance.

Another way to approach the problem is to relocate the blocks in
partially filled RMW stripes so they can be effectively CoW stripes;
however, the requirement to do full extent relocations leads to some
nasty write amplification and performance ramifications.  Balance is
hugely heavy I/O load and there are good reasons not to incur it at
unexpected times.


>=20
> --=20
> A MAP07 (Dead Simple) raspberry tincture recipe: 0.5l 95% alcohol, 1kg
> raspberries, 0.4kg sugar; put into a big jar for 1 month.  Filter out and
> throw away the fruits (can dump them into a cake, etc), let the drink age
> at least 3-6 months.
>=20

--hk6Zb6cduJ+I0Tmj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlf+prkACgkQgfmLGlazG5wD8QCXdojzFtZ+7vfnG1LwkPW5Hefp
lgCgmIz4ZogdvavJ0EKwJyZqi92AJ5Y=
=jnHw
-----END PGP SIGNATURE-----

--hk6Zb6cduJ+I0Tmj--
