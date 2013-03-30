Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:48039 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab3C3UY4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Mar 2013 16:24:56 -0400
Date: Sun, 31 Mar 2013 02:24:51 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Josef Bacik <jbacik@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: limit the global reserve to 512mb
Message-ID: <20130331022451.575f6345@natsu>
In-Reply-To: <1364326446-8584-1-git-send-email-jbacik@fusionio.com>
References: <1364326446-8584-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cMLSadwCQl.8IK.tvkQQjf."; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/cMLSadwCQl.8IK.tvkQQjf.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Mar 2013 15:34:06 -0400
Josef Bacik <jbacik@fusionio.com> wrote:

> A user reported a problem where he was getting early ENOSPC with hundreds=
 of
> gigs of free data space and 6 gigs of free metadata space.  This is becau=
se the
> global block reserve was taking up the entire free metadata space.  This =
is
> ridiculous, we have infrastructure in place to throttle if we start using=
 too
> much of the global reserve, so instead of letting it get this huge just l=
imit it
> to 512mb so that users can still get work done.  This allowed the user to
> complete his rsync without issues.  Thanks

Just a note, I added this to 3.7.10 and was able to complete a balance on a
"difficult" filesystem (60GB in size, used for /home, with creation and
deletion of snapshots by cron), that was otherwise seeming to loop/hang
and continuously spewing -28 errors into dmesg.

> Cc: stable@vger.kernel.org
> Reported-and-tested-by: Stefan Priebe <s.priebe@profihost.ag>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent-tree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c08c7c8..5791da2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4554,7 +4554,7 @@ static void update_global_block_rsv(struct btrfs_fs=
_info *fs_info)
>  	spin_lock(&sinfo->lock);
>  	spin_lock(&block_rsv->lock);
> =20
> -	block_rsv->size =3D num_bytes;
> +	block_rsv->size =3D min_t(u64, num_bytes, 512 * 1024 * 1024);
> =20
>  	num_bytes =3D sinfo->bytes_used + sinfo->bytes_pinned +
>  		    sinfo->bytes_reserved + sinfo->bytes_readonly +


--=20
With respect,
Roman

--Sig_/cMLSadwCQl.8IK.tvkQQjf.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFXShMACgkQTLKSvz+PZwgvvACfYQ4kWABfvKPfHGskpMa4zJp/
qTYAniWup8buADV2BKJVs2KsmMfzLG6B
=JCB1
-----END PGP SIGNATURE-----

--Sig_/cMLSadwCQl.8IK.tvkQQjf.--
