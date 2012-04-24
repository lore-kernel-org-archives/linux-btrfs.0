From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] btrfs: allow changing 'thread_pool' size at remount
 time
Date: Tue, 24 Apr 2012 21:11:15 +0300
Message-ID: <20120424211115.319d1154@sf.home>
References: <1335288404-11565-1-git-send-email-slyich@gmail.com>
	<20120424173237.GA6164@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=i1i_BFg.N4NLi3Mvba3Tq9"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120424173237.GA6164@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/=i1i_BFg.N4NLi3Mvba3Tq9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Apr 2012 13:32:37 -0400
Josef Bacik <josef@redhat.com> wrote:

> On Tue, Apr 24, 2012 at 08:26:44PM +0300, Sergei Trofimovich wrote:
> > From: Sergei Trofimovich <slyfox@gentoo.org>
> >=20
> > Changing 'mount -oremount,thread_pool=3D2 /' didn't make any effect:
> >=20
> > maximum amount of worker threads is specified in 2 places:
> > - in 'strict btrfs_fs_info::thread_pool_size'
> > - in each worker struct: 'struct btrfs_workers::max_workers'
> >=20
> > 'mount -oremount' updated only 'btrfs_fs_info::thread_pool_size'.
> >=20
> > Fix it by pushing new maximum value to all created worker structures
> > as well.
> >=20
> > Cc: Josef Bacik <josef@redhat.com>
> > Cc: Chris Mason <chris.mason@oracle.com>
> > Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> > ---
> > WARNING: This patch makes sense only with
> > WARNING:    "btrfs: fix early abort in 'remount'"
> > WARNING: sitting in Josef's -next branch.
> >  fs/btrfs/super.c |   38 +++++++++++++++++++++++++++++++++-----
> >  1 files changed, 33 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 2f28fc0..ed2dab9 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -435,11 +435,8 @@ int btrfs_parse_options(struct btrfs_root *root, c=
har *options)
> >  		case Opt_thread_pool:
> >  			intarg =3D 0;
> >  			match_int(&args[0], &intarg);
> > -			if (intarg) {
> > +			if (intarg)
> >  				info->thread_pool_size =3D intarg;
> > -				printk(KERN_INFO "btrfs: thread pool %d\n",
> > -				       info->thread_pool_size);
> > -			}
> >  			break;
> >  		case Opt_max_inline:
> >  			num =3D match_strdup(&args[0]);
> > @@ -1119,6 +1116,35 @@ error_fs_info:
> >  	return ERR_PTR(error);
> >  }
> > =20
> > +static void btrfs_set_max_workers(struct btrfs_workers *workers, int n=
ew_limit)
> > +{
> > +	workers->max_workers =3D new_limit;
> > +}
>=20
> This needs to be protected by it's spin lock, so do
>=20
> spin_lock_irq(&workers->lock);
> workers->max_workers =3D new_limit;
> spin_unlock_irq(&workers->lock);
>=20
> Also this doesn't do anything for thread pools that have already gone abo=
ve the
> new maximum.  In practice this shouldn't happen really since most of these
> workers are related to writing anyway, but it may be prudent in the futur=
e to
> make btrfs_set_max_workers to go through and stop threads until the worke=
rs are
> below the new limit.  This doesn't have to be done in this patch, just go=
od idea
> for future work.

I've found a place where value is seemingly read w/o lock:
/* fs/btrfs/disk-io.c */
unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
{
        unsigned long limit =3D min_t(unsigned long,
                                    info->workers.max_workers,
                                    info->fs_devices->open_devices);
        return 256 * limit;
}

How hot that path is? Is it fine to guard with similar lock
or it's better to consider something more SMP friendly?

> > +static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info, in=
t new_pool_size, int old_pool_size)
> > +{
> > +	if (new_pool_size !=3D old_pool_size) {
> > +		fs_info->thread_pool_size =3D new_pool_size;
> > +
> > +		printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n", old_pool_si=
ze, new_pool_size);
> > +
> > +		btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->endio_meta_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->endio_meta_write_workers, new_pool_s=
ize);
> > +		btrfs_set_max_workers(&fs_info->endio_write_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_siz=
e);
> > +		btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
> > +		btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
> > +	}
> > +}
> > +
>=20
> These lines are past the 80 column mark, if you are using vim do
>=20
> :set textwidth=3D80
>=20
> and that should help.  Thanks,
>
> Josef

Will do.

Thanks!

--=20

  Sergei

--Sig_/=i1i_BFg.N4NLi3Mvba3Tq9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk+W7MkACgkQcaHudmEf86pipgCeM+zUf9WbiH/gWXOgkqIJEjQ/
BlwAn00inEXQLQagddYG/Fw0JjLl+4AD
=AiSF
-----END PGP SIGNATURE-----

--Sig_/=i1i_BFg.N4NLi3Mvba3Tq9--
