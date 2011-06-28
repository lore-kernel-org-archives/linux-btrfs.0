From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v8 7/8] btrfs: Replication-type information
Date: Tue, 28 Jun 2011 20:26:43 +0100
Message-ID: <20110628192643.GC24675@carfax.org.uk>
References: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
 <1309120615-18104-8-git-send-email-hugo@carfax.org.uk>
 <20110628163243.GS12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110628163243.GS12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2011 at 06:32:43PM +0200, David Sterba wrote:
> On Sun, Jun 26, 2011 at 09:36:54PM +0100, Hugo Mills wrote:
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 828aa34..fb11550 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -117,6 +117,52 @@ static void requeue_list(struct btrfs_pending_bios=
 *pending_bios,
> >  		pending_bios->tail =3D tail;
> >  }
> > =20
> > +void btrfs_get_replication_info(struct btrfs_replication_info *info,
> > +								u64 type)
> > +{
> > +	info->sub_stripes =3D 1;
> > +	info->dev_stripes =3D 1;
> > +	info->devs_increment =3D 1;
> > +	info->num_copies =3D 1;
> > +	info->devs_max =3D 0;	/* 0 =3D=3D as many as possible */
> > +	info->devs_min =3D 1;
> > +
> > +	if (type & BTRFS_BLOCK_GROUP_DUP) {
> > +		info->dev_stripes =3D 2;
> > +		info->num_copies =3D 2;
> > +		info->devs_max =3D 1;
> > +	} else if (type & BTRFS_BLOCK_GROUP_RAID0) {
> > +		info->devs_min =3D 2;
> > +	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
> > +		info->devs_increment =3D 2;
> > +		info->num_copies =3D 2;
> > +		info->devs_max =3D 2;
> > +		info->devs_min =3D 2;
> > +	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
> > +		info->sub_stripes =3D 2;
> > +		info->devs_increment =3D 2;
> > +		info->num_copies =3D 2;
> > +		info->devs_min =3D 4;
> > +	}
> > +
> > +	if (type & BTRFS_BLOCK_GROUP_DATA) {
> > +		info->max_stripe_size =3D 1024 * 1024 * 1024;
> > +		info->min_stripe_size =3D 64 * 1024 * 1024;
> > +		info->max_chunk_size =3D 10 * info->max_stripe_size;
> > +	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
> > +		info->max_stripe_size =3D 256 * 1024 * 1024;
> > +		info->min_stripe_size =3D 32 * 1024 * 1024;
> > +		info->max_chunk_size =3D info->max_stripe_size;
> > +	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
> > +		info->max_stripe_size =3D 8 * 1024 * 1024;
> > +		info->min_stripe_size =3D 1 * 1024 * 1024;
> > +		info->max_chunk_size =3D 2 * info->max_stripe_size;
> > +	} else {
> > +		printk(KERN_ERR "Block group is of an unknown usage type: not data, =
metadata or system.\n");
> > +		BUG_ON(1);

   From inspection, this looks like it's a viable solution:

+               info->max_stripe_size =3D 0;
+               info->min_stripe_size =3D -1ULL;
+               info->max_chunk_size =3D 0;

We only run into problems if a user of this function passes a
RAID-only block group type and then tries to use the size parameters
=66rom it. There's only three users of the function currently, and this
case is the only one that doesn't pass a "real" block group type flag.

   I'll run a quick test of dev rm and see what happens...

> I'm hitting this BUG_ON with 'btrfs device delete', type =3D 24 which is
> BTRFS_BLOCK_GROUP_RAID0 + BTRFS_BLOCK_GROUP_RAID1 .
>=20
> in btrfs_rm_device:
>=20
> 1277         all_avail =3D root->fs_info->avail_data_alloc_bits |
> 1278                 root->fs_info->avail_system_alloc_bits |
> 1279                 root->fs_info->avail_metadata_alloc_bits;
>=20
> the values before the call are:
>=20
> [  105.107074] D: all_avail 24
> [  105.111844] D: root->fs_info->avail_data_alloc_bits 8
> [  105.118858] D: root->fs_info->avail_system_alloc_bits 16
> [  105.126110] D: root->fs_info->avail_metadata_alloc_bits 16
>=20
>=20
> there are 5 devices, sdb5 - sdb9, i'm removing sdb9, after clean
> mount.
>=20
>=20
> david

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- vi vi vi:  the Editor of the Beast. ---              =20

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOCirzIKyzvlFcI40RAuftAJ0Z++Q6uNUDHbFU4spReB5T/9duTwCfUGhq
C0k9bFSZDwLBNzWo7sbS+18=
=NxXH
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
