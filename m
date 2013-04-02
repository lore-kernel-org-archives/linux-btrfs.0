Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:34163 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668Ab3DBQzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Apr 2013 12:55:08 -0400
Date: Tue, 2 Apr 2013 22:55:04 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Still getting a lot of -28 (ENOSPC?) errors during balance
Message-ID: <20130402225504.77f42c9a@natsu>
In-Reply-To: <20130402134626.GO1876@localhost.localdomain>
References: <20130402140452.2b71794f@natsu>
	<20130402134626.GO1876@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VqP3BmyGzBDevVlPwIp4WLY"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/VqP3BmyGzBDevVlPwIp4WLY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Apr 2013 09:46:26 -0400
Josef Bacik <jbacik@fusionio.com> wrote:

> On Tue, Apr 02, 2013 at 02:04:52AM -0600, Roman Mamedov wrote:
> > Hello,
> >=20
> > With kernel 3.7.10 patched with "Btrfs: limit the global reserve to 512=
mb".
> > (the problem was occuring also without this patch, but seemed to be eve=
n worse).
> >=20
> > At the start of balance:
> >=20
> > Data: total=3D31.85GB, used=3D9.96GB
> > System: total=3D4.00MB, used=3D16.00KB
> > Metadata: total=3D1.01GB, used=3D696.17MB
> >=20
> > "btrfs balance start -musage=3D5 -dusage=3D5" is going on for about 50 =
minutes
> >=20
> > Current situation:
> >=20
> > Balance on '/mnt/r1/' is running
> > 1 out of about 2 chunks balanced (20 considered),  50% left
> >=20
> > Data: total=3D30.85GB, used=3D10.04GB
> > System: total=3D4.00MB, used=3D16.00KB
> > Metadata: total=3D1.01GB, used=3D851.69MB
> >=20
> > And a constant stream of these in dmesg:
> >=20
>=20
> Can you try this out and see if it helps?  Thanks,

Hello,

Well that balance has now completed, and unfortunately I don't have a compl=
ete
image of the filesystem from before, to apply the patch and check if the sa=
me
operation goes better this time.

I'll keep it in mind and will try to test it out if I will get a similar
situation again on some filesystem.

Generally what seems to make me run into various problems with balance, is =
the
following usage scenario: On an active filesystem (used as /home and root F=
S),
a snapshot is made every 30 minutes with an unique (timestamped) name; and =
once
a day snapshots from more than two days ago are purged. And it goes like th=
is
for months.

Another variant of this, a backup partition, where snapshots are made every=
 six
hours, and all snapshots are kept for 1-3 months before getting purged.

I guess this kind of usage causes a lot of internal fragmentation or
something, which makes it difficult for a balance to find enough free space=
 to
work with.

>=20
> Josef
>=20
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 0d89ff0..9830e86 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -2548,6 +2548,13 @@ static int do_relocation(struct btrfs_trans_handle=
 *trans,
>  	list_for_each_entry(edge, &node->upper, list[LOWER]) {
>  		cond_resched();
> =20
> +		ret =3D btrfs_block_rsv_refill(rc->extent_root, rc->block_rsv,
> +					     rc->extent_root->leafsize,
> +					     BTRFS_RESERVE_FLUSH_ALL);
> +		if (ret) {
> +			err =3D ret;
> +			break;
> +		}
>  		upper =3D edge->node[UPPER];
>  		root =3D select_reloc_root(trans, rc, upper, edges, &nr);
>  		BUG_ON(!root);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
With respect,
Roman

--Sig_/VqP3BmyGzBDevVlPwIp4WLY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFbDWgACgkQTLKSvz+PZwgA/ACgkJVSq2Oae/MMRhJhKzq6t3kR
PvUAoIEVUFVtMjlxvlMXMLwXXlbe7YiB
=iMeR
-----END PGP SIGNATURE-----

--Sig_/VqP3BmyGzBDevVlPwIp4WLY--
