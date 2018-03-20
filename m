Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59719 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752980AbeCTMwe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 08:52:34 -0400
Subject: Re: [PATCH] btrfs-progs: Beautify owner when printing leaf/nodes
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1521535551-23388-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c8b272b1-b987-c30a-6fad-ac058fe9d9cd@gmx.com>
Date: Tue, 20 Mar 2018 20:52:22 +0800
MIME-Version: 1.0
In-Reply-To: <1521535551-23388-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yZRTds5Uh6IBi8Sny6FC1OB5zVGnktHKO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yZRTds5Uh6IBi8Sny6FC1OB5zVGnktHKO
Content-Type: multipart/mixed; boundary="2gFv58up9pqpoHhGWTZsZ09uaCYI6SBrR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c8b272b1-b987-c30a-6fad-ac058fe9d9cd@gmx.com>
Subject: Re: [PATCH] btrfs-progs: Beautify owner when printing leaf/nodes
References: <1521535551-23388-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1521535551-23388-1-git-send-email-nborisov@suse.com>

--2gFv58up9pqpoHhGWTZsZ09uaCYI6SBrR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8820=E6=97=A5 16:45, Nikolay Borisov wrote:
> Currently we print the raw values of the owner field of leaf/nodes.
> This can result in output like the following:
>=20
> leaf 30490624 items 2 free space 16061 generation 4 owner 1844674407370=
9551607
>=20
> With the patch applied the same leaf looks like:
>=20
> leaf 30490624 items 2 free space 16061 generation 4 owner DATA_RELOC_TR=
EE
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  print-tree.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/print-tree.c b/print-tree.c
> index d59f9002f54c..a2f6bfc027c9 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -1188,11 +1188,12 @@ void btrfs_print_leaf(struct btrfs_root *root, =
struct extent_buffer *eb)
>  	header_flags_to_str(flags, flags_str);
>  	nr =3D btrfs_header_nritems(eb);
> =20
> -	printf("leaf %llu items %d free space %d generation %llu owner %llu\n=
",
> +	printf("leaf %llu items %d free space %d generation %llu owner ",
>  		(unsigned long long)btrfs_header_bytenr(eb), nr,
>  		btrfs_leaf_free_space(root, eb),
> -		(unsigned long long)btrfs_header_generation(eb),
> -		(unsigned long long)btrfs_header_owner(eb));
> +		(unsigned long long)btrfs_header_generation(eb));
> +	print_objectid(stdout, btrfs_header_owner(eb), 0);
> +	printf("\n");
>  	printf("leaf %llu flags 0x%llx(%s) backref revision %d\n",
>  		btrfs_header_bytenr(eb), flags, flags_str, backref_rev);
>  	print_uuids(eb);
> @@ -1365,12 +1366,13 @@ void btrfs_print_tree(struct btrfs_root *root, =
struct extent_buffer *eb, int fol
>  		btrfs_print_leaf(root, eb);
>  		return;
>  	}
> -	printf("node %llu level %d items %d free %u generation %llu owner %ll=
u\n",
> +	printf("node %llu level %d items %d free %u generation %llu owner ",
>  	       (unsigned long long)eb->start,
>  	        btrfs_header_level(eb), nr,
>  		(u32)BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - nr,
> -		(unsigned long long)btrfs_header_generation(eb),
> -		(unsigned long long)btrfs_header_owner(eb));
> +		(unsigned long long)btrfs_header_generation(eb));
> +	print_objectid(stdout, btrfs_header_owner(eb), 0);
> +	printf("\n");
>  	print_uuids(eb);
>  	fflush(stdout);
>  	for (i =3D 0; i < nr; i++) {
>=20


--2gFv58up9pqpoHhGWTZsZ09uaCYI6SBrR--

--yZRTds5Uh6IBi8Sny6FC1OB5zVGnktHKO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqxBAYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qheNwf/S9bBuFJC3DL7RnCNUNdxZYgk
Nk8kqebHVxfGGZUazTINNTIzeIgpiOO/x0sPR+fvPrYSwZ/FquMvEB+JJrhKeJGw
U7SxmS/ffB2jSW91AvHrFGQ5lKLbKcby/K3CEElNGxooe7JGCS4yPJLIvJC8Syjo
K9T43GOtDp6fi4MXVO2fUQJ3OKQvgGz/wf/qopdk1gkLACwikjdNPw0VLMEqTTqz
gO1PqKvo77tLTZxvvt0ZQPchksk93XxeRruhL9+wj+v2m/tXv03Wh2xIVL5Fj8Ac
lIuPFI6weGVeYNTjZHMs097IGWiIw0GluMWI6/9xQRVC5fJ7jhIr77H+2cz1iw==
=Uv0p
-----END PGP SIGNATURE-----

--yZRTds5Uh6IBi8Sny6FC1OB5zVGnktHKO--
