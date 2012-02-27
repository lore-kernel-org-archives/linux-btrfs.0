From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: LABEL only 1 device
Date: Mon, 27 Feb 2012 10:11:55 +0000
Message-ID: <20120227101154.GE18898@carfax.org.uk>
References: <20120226171419.GD18898@carfax.org.uk>
 <C3f2Sw5i1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X3gaHHMYHkYqP6yf"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3f2Sw5i1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--X3gaHHMYHkYqP6yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 27, 2012 at 07:44:00AM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 26.02.12:
> 
> >    mkfs.btrfs creates a new filesystem. The -L option sets the label
> > for the newly-created FS. It *cannot* be used to change the label of
> > an existing FS.
> 
> The safest way may be deleting this option ... it seems to work as  
> expected only when I create a new FS on 1 disk/partition.

   I've said this several times: Your expectations are wrong. You
don't label partitions. You label filesystems. You are using the wrong
tool (filesystems labels) for the job (uniquely identifying
partitions).

> > If you want to do that, use "btrfs filesystem label".
> 
> And that seems to work as I expected - fine.
> 
> Adding a device works, deleting a device works. Fine!
> Now I'll try the job with my Terabyte disks.
> 
> (Yes - I have backups ...)
> 
> Viele Gruesse!
> Helmut

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                  --- Be pure. Be vigilant. Behave. ---                  

--X3gaHHMYHkYqP6yf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPS1bqIKyzvlFcI40RAnAiAJ90CJVgouKzxLfOSGZYxNYChmi/BQCgoy0y
hSEi7p35gY6rOUPyB8xMr5U=
=gOXZ
-----END PGP SIGNATURE-----

--X3gaHHMYHkYqP6yf--
