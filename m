From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Btrfs out of inodes becomes corrupt
Date: Wed, 8 Feb 2012 11:13:25 +0000
Message-ID: <20120208111325.GA19900@carfax.org.uk>
References: <b0ee762c11692ea16e81a34469311c14@localhost>
 <20120205195742.GC19330@carfax.org.uk>
 <CAE5mzvhwSLqBEMEOZo8Xxx63LciYLAxYWzVrQP+7qk_tgyRvwA@mail.gmail.com>
 <20120206114031.GD19330@carfax.org.uk>
 <20120206153514.GB8542@zwanebloem.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Tommy Faasen <tommy@zwanebloem.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120206153514.GB8542@zwanebloem.nl>
List-ID: <linux-btrfs.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 06, 2012 at 03:35:14PM +0000, Tommy Faasen wrote:
> I rolled a new kernel 3.2.4 and it picked everything up.
> No crashes, my disk was still full, with 40+ gigs free
> but now I can delete files and access them.
> 
> I'm running btrfs fi balance /mountpoint at the moment which I understand frees up the remaining space.

   Well, not quite. It has a side-effect that if you have an
over-allocation of space to one or other of data/metadata, it will
serve to reduce that allocation, giving back the over-allocated space
to the free pool, from where it can be reallocated by the other group
type.

   So if you have, say 5G allocated for metadata, but only 500M used,
you could gain back a large amount (but probably not all) of the
unused 4.5G by running a balance.

   Hugo.

> Thanks again for your assistance!
> 
> Tommy
> 
> On Mon, Feb 06, 2012 at 11:40:31AM +0000, Hugo Mills wrote:
> > On Mon, Feb 06, 2012 at 05:33:51AM -0600, cwillu wrote:
> > > >  3.0 is two revisions old -- something on the order of 6
> > > > months. There's been a lot of development since then, too. You really
> > > > should be running 3.2 or 3.2-rc2 (i.e. the latest released or latest
> > > > development version of the kernel).
> > > 
> > > I think you meant 3.2 or 3.3-rc2.
> > 
> >    I did indeed. Thanks for the correction.
> > 
> >    Hugo.
> > 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Quantum Mechanics: the dreams stuff is made of. ---         

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPMljVIKyzvlFcI40RAiHFAJoD4lFjBrzz6qsDdmKONfK1n5lEEwCfX60d
/MqA0cJcwqZkxLKUcTDNcEQ=
=xEuD
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
