From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: revert to static snapshot on reboot
Date: Thu, 12 Jan 2012 21:38:13 +0000
Message-ID: <20120112213813.GA21769@carfax.org.uk>
References: <20120109064304.18411.qmail@otpproductions.com>
 <b14e2228999a5acd0ee5d38705da7260.squirrel@webmail.decarpentier.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Cc: btrfs@spiritvideo.com, linux-btrfs@vger.kernel.org
To: Niels de Carpentier <niels@decarpentier.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b14e2228999a5acd0ee5d38705da7260.squirrel@webmail.decarpentier.com>
List-ID: <linux-btrfs.vger.kernel.org>


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2012 at 04:21:31PM +0100, Niels de Carpentier wrote:
> > The plan that occurs to me is to make a snapshot of the system in the
> > state that I want to always boot.  Then, I would rewrite the init
> > script in the initrd to (a) delete any old tmp copy of the snapshot;
> > (b) copy the static snapshot to a tmp copy; (c) mount the tmp copy.
> >
> > That's a little harder than I was hoping to work -- is there an easier
> > way to get this functionality?
> 
> I would just create a filesystem with the static content, and on boot do:
> 
> mount fs
> delete snapshots
> create snapshot
> unmount fs and mount snapshot.
> 
> I'm not sure if you can snapshot a snapshot, otherwise you could start
> with a snapshot as well. (Just be sure not to delete it)

   Yes, you can make snapshots of snapshots. A btrfs snapshot is a
first-class citizen -- there's no real distinction between the
original subvolume and a snapshot of it.

   Hugo

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- 2 + 2 = 5,  for sufficiently large values of 2. ---         

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPD1LFIKyzvlFcI40RAl7ZAKDDakqp8+Dn8TB2Sg3ZnE7q3msSiwCgmuR9
p5894WWdltLDGkLSDvH0EE0=
=EMff
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
