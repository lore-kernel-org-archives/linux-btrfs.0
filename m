From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 14:00:57 +0000
Message-ID: <20120317140057.GF3172@carfax.org.uk>
References: <C52pxfli1uB@helmut.hullen.de>
 <loom.20120317T131420-684@post.gmane.org>
 <20120317122522.GD3172@carfax.org.uk>
 <loom.20120317T141129-14@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120317T141129-14@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 17, 2012 at 01:36:04PM +0000, Alex wrote:
> >    No, a balance isn't going to help here. RAID-0 requires a minimum
> > of 2 chunks in a block group. With two disks, you're only going to be
> > able to fill the smallest one before you run out of space.
> > 
> > > Isn't this going to be a problem for anyone restoring from a backup? Lots of
> > > data heading to btrfs without a pause.
> > 
> >    Again, not the issue here.
> 
> Thank you HH for the explanation.
> 
> What's the 'solution' though to Hugo's situation?
> By 'solution' I mean the highest-utility way of dealing with unequal devices
> problem in a two or more -up setting.

   Use mkfs.btrfs -d single, as I said in another part of this thread.

   We have a bit of a problem right now with adding a second device to
an existing FS with -d single, where the FS "upgrades" the single to
RAID-0. However, there's patches from Ilya that stop that behaviour,
and the restriper can be used to switch back to single after the
"upgrade".

> (I understand that we're violating the expectations of RAID0 and
> have read the
> http://btrfs.ipv5.de/index.php?title=FAQ#How_much_space_do_I_get_with_unequal_devices_in_RAID-1_mode.3F
> about RAID1.)

   I'm working on a comprehensive explanation of the limits on btrfs's
space usage, and a little JavaScript tool to help plan/explain disk
usage.

> Disks are (were) getting cheaper per MB faster than I could run out
> of space! So I have increasing size array of drives - apparently the
> similar situation as Hugo (I have three btrfs-ready drives).

   I don't have this problem personally. I just know something about
the way btrfs allocates chunks. I think you meant Helmut has the
problem. :)

> I'm struggling how to mkfs.btrfs with this new knowledge whilst resolving it
> with the btrfs storage pool concept.
> 
> I stress there is a difficulty with my understanding not btrfs.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- UNIX: Spanish manufacturer of fire extinguishers. ---        

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPZJkYIKyzvlFcI40RAlZmAKDFbzx5O/AVzTO8ddyWNUQmTJM7eACgxXdc
m+G4DahCGz/7hMaNb4Zqa5w=
=XrIL
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
