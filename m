From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kerenl bug after btrfs resize (reduce size)
Date: Mon, 19 Sep 2011 13:38:18 +0100
Message-ID: <20110919123818.GD21530@carfax.org.uk>
References: <CABVOS0_vA_BrA8+3mrgKUWRhmhMBA9bJUGwJvto16k3xM92+DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roman Kapusta <roman.kapusta@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABVOS0_vA_BrA8+3mrgKUWRhmhMBA9bJUGwJvto16k3xM92+DQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 19, 2011 at 02:24:55PM +0200, Roman Kapusta wrote:
> After running 'btrfs fi resize' I got following error, fortunately, it
> looks that filesystem is ok.
> I was changing filesystem size from 256 GB to 192 GB (reducing by
> 64GB), free space was 110GB.

   I would be careful here -- the FS may be OK in that it's all
readable, but it may not have shrunk by as much as you requested. In
other words, don't drop the size of the containing partition until
you've successfully run a resize without it crashing.

> My system is Fedora 14. I'm considering upgrade to Fedora 15, is this
> already fixed?
[snip]
> Not tainted 2.6.35.14-96.fc14.i686 #1 30A2/HP Compaq nx7400

   In btrfs terms, this is a kernel from the Dark Ages. You should
upgrade to something recent *immediately*. There are all kinds of
nasty bugs in 2.6.35 (and later) that have been fixed. I don't know if
this particular one is one of them, but running btrfs on 2.6.35 is
rather like juggling nitrogylcerine: bad things *will* happen, sooner
or later.

   I would strongly recommend running a 3.0 or 3.1-rc kernel (at least
until 3.1 comes out, then keep following the latest kernel releases).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- In the future, terrorists won't be carrying their ID cards. ---   
                   They'll be carrying yours. -- Henry                   
                         Porter,  Suspect Nation                         

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOdze5IKyzvlFcI40RAtgQAJ4p/ufc4VYrxRm97AvJ6jYfGr/GJQCglcN6
g6pHYvPZgdP+kMPopPOLZvI=
=vN6B
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
