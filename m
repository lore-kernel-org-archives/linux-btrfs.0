From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [PATCH] btrfs: rename the option to nospace_cache
Date: Fri, 11 Nov 2011 21:54:52 +0600
Message-ID: <20111111215452.736ece71@natsu>
References: <1321026115-26424-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lOT1YR_WtT6y2b0kFkBQllo"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321026115-26424-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/lOT1YR_WtT6y2b0kFkBQllo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Nov 2011 16:41:55 +0100
David Sterba <dsterba@suse.cz> wrote:

> Rename no_space_cache option to nospace_cache to be more consistent with
> the rest, where the simple prefix 'no' is used to negate an option.
>=20
> The option has been introduced during the -rc1 cycle and there are has no=
t been
> widely used, so it's safe.

In my opinion as soon as you start using underscores to split words in an i=
dentifier, you have to use them to separate all the words, not just some of=
 them. So it should be either no_space_cache, or nospacecache; the version =
proposed here looks puzzling and wrong ("does this enable a 'cache for nosp=
ace'?").

Also, space_cache=3Doff would be vastly better IMO. Consistent with compres=
s=3Dblah/compress-force=3Dblah, too. And in the same manner theoretically t=
here could be several algorithms for space caching in future, switchable by=
 this same option ("space_cache=3Dwhatever").

>=20
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>=20
>  fs/btrfs/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 629281c..8bd9d6d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -197,7 +197,7 @@ static match_table_t tokens =3D {
>  	{Opt_subvolrootid, "subvolrootid=3D%d"},
>  	{Opt_defrag, "autodefrag"},
>  	{Opt_inode_cache, "inode_cache"},
> -	{Opt_no_space_cache, "no_space_cache"},
> +	{Opt_no_space_cache, "nospace_cache"},
>  	{Opt_recovery, "recovery"},
>  	{Opt_err, NULL},
>  };
> @@ -711,7 +711,7 @@ static int btrfs_show_options(struct seq_file *seq, s=
truct vfsmount *vfs)
>  	if (btrfs_test_opt(root, SPACE_CACHE))
>  		seq_puts(seq, ",space_cache");
>  	else
> -		seq_puts(seq, ",no_space_cache");
> +		seq_puts(seq, ",nospace_cache");
>  	if (btrfs_test_opt(root, CLEAR_CACHE))
>  		seq_puts(seq, ",clear_cache");
>  	if (btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/lOT1YR_WtT6y2b0kFkBQllo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk69RUwACgkQTLKSvz+PZwivRwCffA1kQwfJ9PufPvsf97GNbsWz
mGIAn3WvVLVQDvD7pLG+ziqrDX/xykQ6
=6KkI
-----END PGP SIGNATURE-----

--Sig_/lOT1YR_WtT6y2b0kFkBQllo--
