Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48186 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753500AbbF2TfD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 15:35:03 -0400
Date: Mon, 29 Jun 2015 15:35:02 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: don't update mtime on deduped inodes
Message-ID: <20150629193501.GB14923@hungrycats.org>
References: <1435352461-17689-1-git-send-email-mfasheh@suse.de>
 <1435352461-17689-6-git-send-email-mfasheh@suse.de>
 <20150627214427.GC14931@hungrycats.org>
 <20150629175240.GB7507@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
In-Reply-To: <20150629175240.GB7507@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2015 at 10:52:41AM -0700, Mark Fasheh wrote:
> On Sat, Jun 27, 2015 at 05:44:28PM -0400, Zygo Blaxell wrote:
> > On Fri, Jun 26, 2015 at 02:01:01PM -0700, Mark Fasheh wrote:
> > > One issue users have reported is that dedupe changes mtime on files,
> > > resulting in tools like rsync thinking that their contents have chang=
ed when
> > > in fact the data is exactly the same. Clone still wants an mtime chan=
ge, so
> > > we special case this in the code.
> > >=20
> > > This was tested with the btrfs-extent-same tool.
> > >=20
> > > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > > ---
> > >  fs/btrfs/ioctl.c | 25 +++++++++++++++----------
> > >  1 file changed, 15 insertions(+), 10 deletions(-)
> > >=20
> > > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > > index 83f4679..0af0f13 100644
> > > --- a/fs/btrfs/ioctl.c
> > > +++ b/fs/btrfs/ioctl.c
> > > @@ -87,7 +87,8 @@ struct btrfs_ioctl_received_subvol_args_32 {
> > > =20
> > > =20
> > >  static int btrfs_clone(struct inode *src, struct inode *inode,
> > > -		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
> > > +		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
> > > +		       int no_mtime);
> > > =20
> > >  /* Mask out flags that are inappropriate for the given type of inode=
=2E */
> > >  static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
> > > @@ -3054,7 +3055,7 @@ static int btrfs_extent_same(struct inode *src,=
 u64 loff, u64 olen,
> > >  	/* pass original length for comparison so we stay within i_size */
> > >  	ret =3D btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
> > >  	if (ret =3D=3D 0)
> > > -		ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff);
> > > +		ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> > > =20
> > >  	if (same_inode)
> > >  		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> > > @@ -3219,13 +3220,17 @@ static int clone_finish_inode_update(struct b=
trfs_trans_handle *trans,
> > >  				     struct inode *inode,
> > >  				     u64 endoff,
> > >  				     const u64 destoff,
> > > -				     const u64 olen)
> > > +				     const u64 olen,
> > > +				     int no_mtime)
> > >  {
> > >  	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> > >  	int ret;
> > > =20
> > >  	inode_inc_iversion(inode);
> > > -	inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
> > > +	if (no_mtime)
> > > +		inode->i_ctime =3D CURRENT_TIME;
> >=20
> > I don't see a good reason to modify the ctime either.  Again, nothing
> > is changing here.  All we are doing is shuffling physical storage aroun=
d.
> >=20
> > Defrag and balance (which also move physical extents around) don't
> > touch ctime, mtime, or even atime.
>=20
> To be fair, those may actually be oversights, it's not uncommon to update
> ctime on metadata changes.

It makes no sense semantically.  There are no changes to any inode
fields here.  Normally when extents are moved around inodes don't change
at all.

The current balance behavior is definitely not an oversight.  Balance
would have to rewrite every inode on the filesystem (actually every
*snapshot* of every inode) to update ctime.

Defrag is copy-in-place while holding a lock to prevent concurrent
modifications.  Defrag does the complementary operation to extent-same.
Defrag will also not change any file contents, and it's already got the
correct ctime behavior.  ;)

> Does a ctime change hurt any backup software (the reason for my first
> patch)? I guess it could cause revaluation of meta data, but does that
> actually happen? From what I can tell stuff like rsync is using mtime +
> i_size to see if an inode changed.

Off the top of my head, git uses ctime to figure out whether its index is
up to date.  It probably borrowed that from other SCMs.

Some admins (myself included) build ad-hoc (and even formal) forensic
timelines from ctime data.  This doesn't work if dedup wipes out the
ctime, especially if you are doing aggressive dedup across multiple
snapshots.

The core problem is that deduping stops being a transparent rearrangement
of the physical layout of the data (like defrag or balance) if the ctime
changes whenever you do it.

> Is there any software out there that monitors an inodes extent state which
> might *want* ctime updates when this happens? Is that kind of usage a
> stretch (or even something we care about?).
>=20
> So my thinking is if it doesn't hurt anything, leave it in. Obviously if =
it
> *is* causing issues then we should take it right out :)
>=20
> Thanks for the discussion and review btw,
> 	--Mark
>=20
> --
> Mark Fasheh
>=20

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWRneUACgkQgfmLGlazG5wYGgCeJVUarChVqVSaDiOxv1arwBhP
1EkAoKdW/3lgtkYL98N26xq9re3BdIiz
=1Ny0
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
