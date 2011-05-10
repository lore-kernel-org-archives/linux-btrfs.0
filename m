From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 3/4] btrfs: don't spin in shrink_delalloc if there is
 nothing to free
Date: Tue, 10 May 2011 22:27:32 +0300
Message-ID: <20110510222732.4fc79ef7@sf>
References: <1304803784-23756-1-git-send-email-slyfox@gentoo.org>
	<1304803784-23756-2-git-send-email-slyfox@gentoo.org>
	<4DC80F9C.10706@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CvuPF4=BItt5O6mrLTJ/ZgG"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC80F9C.10706@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/CvuPF4=BItt5O6mrLTJ/ZgG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 May 2011 12:00:28 -0400
Josef Bacik <josef@redhat.com> wrote:

> On 05/07/2011 05:29 PM, slyich@gmail.com wrote:
> > Observed as a large delay when --mixed filesystem is filled up.
> > Test example:
> > 1. create tiny --mixed FS:
> >     $ dd if=3D/dev/zero of=3D2G.img seek=3D$((2048 * 1024 * 1024 - 1)) =
count=3D1 bs=3D1
> >     $ mkfs.btrfs --mixed 2G.img
> >     $ mount -oloop 2G.img /mnt/ut/
> > 2. Try to fill it up:
> >     $ dd if=3D/dev/urandom of=3D10M.file bs=3D10240 count=3D1024
> >     $ seq 1 256 | while read file_no; do echo $file_no; time cp 10M.fil=
e ${file_no}.copy; done
> >
> > Up to '200.copy' it goes fast, but when disk fills-up each -ENOSPC
> > message takes 3 seconds to pop-up _every_ ENOSPC (and in usermode linux
> > it's even more: 30-60 seconds!). (Maybe, time depends on kernel's timer=
 resolution).
> >
> > No IO, no CPU load, just rescheduling. Some debugging revealed busy spi=
nning
> > in shrink_delalloc.
> >
> > Signed-off-by: Sergei Trofimovich<slyfox@gentoo.org>
> > ---
> >   fs/btrfs/extent-tree.c |    4 ++++
> >   1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 9ee6bd5..9f5fdd3 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -3425,6 +3425,10 @@ static int shrink_delalloc(struct btrfs_trans_ha=
ndle *trans,
> >   	if (reserved =3D=3D 0)
> >   		return 0;
> >
> > +	/* nothing to shrink - nothing to reclaim */
> > +	if (root->fs_info->delalloc_bytes =3D=3D 0)
> > +		return 0;
> > +
> >   	max_reclaim =3D min(reserved, to_reclaim);
> >
> >   	while (loops<  1024) {
>=20
> Nice catch, you can add
>=20
> Reviewed-by: Josef Bacik <josef@redhat.com>

Will add it (and fix patch enumeration) and resend.

Thanks for the review!

--=20

  Sergei

--Sig_/CvuPF4=BItt5O6mrLTJ/ZgG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3JkaQACgkQcaHudmEf86qG3wCfZ3RhoLXHHfiPOEGI61jmK29b
fhAAn30mrU1qDCnK4FPB3aC6ao9w8xZ9
=mLnK
-----END PGP SIGNATURE-----

--Sig_/CvuPF4=BItt5O6mrLTJ/ZgG--
