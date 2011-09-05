From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 5 Sep 2011 17:29:44 +0100
Message-ID: <20110905162944.GQ9907@carfax.org.uk>
References: <4E64F77B.1090401@wpkg.org>
 <20110905162521.GA29124@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="63aIh6YiuHX+oBFP"
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905162521.GA29124@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>


--63aIh6YiuHX+oBFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 05, 2011 at 12:25:21PM -0400, Christoph Hellwig wrote:
> On Mon, Sep 05, 2011 at 06:23:23PM +0200, Tomasz Chmielewski wrote:
> > >   That's because dpkg is known for using (f)sync very heavily.  btrfs
> > >honours the sync request in all cases, so it's much much slower than
> > >ext3, which doesn't.
> > 
> > Hmm, is it really the case with ext3/ext4 (ignoring fsync in some cases)?
> > 
> > Sounds like a bug in ext3/ext4 then.
> > 
> > Is it documented anywhere where ext3/ext4 would just silently ignore fsync?
> 
> They don't.  Unteil recently ext3 and reiserfs would not flush the
> disk caches unless enabled by a mount option, but even that has recently
> been fixed.

   Apologies for disseminating my misunderstanding, then.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- You can get more with a kind word and a two-by-four than you ---   
                       can with just a kind word.                        

--63aIh6YiuHX+oBFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOZPj4IKyzvlFcI40RArhvAJ9jxvHjxuCBHtgvWRNU2XrQEb3DjACg0ILC
qsvb33MRCSXBdtXq7tDIIW8=
=LbQB
-----END PGP SIGNATURE-----

--63aIh6YiuHX+oBFP--
