Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbdLEJKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 04:10:33 -0500
Subject: Re: [PATCH 3/7] btrfs-progs: Remove recover_get_good_super
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-4-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c57814ce-2b69-50d7-7fb8-63827a7019ef@gmx.com>
Date: Tue, 5 Dec 2017 17:10:06 +0800
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-4-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MgXF0SFoIGuTP9mL3cItPASCq30SCDr6b"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MgXF0SFoIGuTP9mL3cItPASCq30SCDr6b
Content-Type: multipart/mixed; boundary="VKrJh2L71nDWx4NKPhBw4euUxU5BS1cOT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c57814ce-2b69-50d7-7fb8-63827a7019ef@gmx.com>
Subject: Re: [PATCH 3/7] btrfs-progs: Remove recover_get_good_super
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-4-git-send-email-nborisov@suse.com>

--VKrJh2L71nDWx4NKPhBw4euUxU5BS1cOT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
> Currently getting the good super really consists of just getting the fi=
rst entry
> on the linked list, since it's the one with the highest transid. So rem=
ove
> the function and just use list_first_entry directly.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  super-recover.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>=20
> diff --git a/super-recover.c b/super-recover.c
> index 6a13d81b0b29..e12513100f17 100644
> --- a/super-recover.c
> +++ b/super-recover.c
> @@ -177,15 +177,6 @@ static int read_fs_supers(struct btrfs_recover_sup=
erblock *recover)
>  	return 0;
>  }
> =20
> -static struct super_block_record *recover_get_good_super(
> -				struct btrfs_recover_superblock *recover)
> -{
> -	struct super_block_record *record;
> -	record =3D list_entry(recover->good_supers.next,
> -				struct super_block_record, list);
> -	return record;
> -}
> -
>  static void print_super_info(struct super_block_record *record)
>  {
>  	printf("\t\tdevice name =3D %s\n", record->device_name);
> @@ -280,7 +271,9 @@ int btrfs_recover_superblocks(const char *dname,
>  			goto no_recover;
>  		}
>  	}
> -	record =3D recover_get_good_super(&recover);
> +	record =3D list_first_entry(&recover.good_supers,
> +				  struct super_block_record, list);
> +
>  	root =3D open_ctree(record->device_name, record->bytenr,
>  			  OPEN_CTREE_RECOVER_SUPER | OPEN_CTREE_WRITES);
>  	if (!root) {
>=20


--VKrJh2L71nDWx4NKPhBw4euUxU5BS1cOT--

--MgXF0SFoIGuTP9mL3cItPASCq30SCDr6b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomYm4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiHGwf/QadMDHuQJTvbYu5SGnrxqQhi
LV+qdAvbM6o1MI5ukPH5d69KXkLPl2N7Kb+Dm6ugnyfeATE6Re4462EC4EJgMvrM
MYGp6kECGKJa4ZlXmlFOdbynLAAdFoqk599d5KkkBJDEn0DHbxmReCVHsT9MJCS4
4u6YkGuGe5R0rGrMIkqpEoYShu3buYGxGI581rDV5orrTOARXaCf4Z40diHesrc+
zcXugy/OWYzy/xJubt4HKRKl4roPh/hYFeb+RhGj3JrtFJv6vCDE9pnt0CGWKNms
J1hO3TTXET6aE5xXsXrEbNbP7ZrElqdwOKIZ3xttYavj2ju/2Ozr9lMrl5VVqw==
=258P
-----END PGP SIGNATURE-----

--MgXF0SFoIGuTP9mL3cItPASCq30SCDr6b--
