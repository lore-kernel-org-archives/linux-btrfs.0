Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754036AbeDBCJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Apr 2018 22:09:22 -0400
Subject: Re: [PATCH] btrfs-progs: mkfs rootdir: use lgetxattr() not to follow
 a symbolic link
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <f53cc5d0-24ff-81b7-68db-0c615edf4936@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fad736ed-5353-bd9a-5af3-125f409d6c4e@gmx.com>
Date: Mon, 2 Apr 2018 10:09:11 +0800
MIME-Version: 1.0
In-Reply-To: <f53cc5d0-24ff-81b7-68db-0c615edf4936@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8vFmjDWLF7PFMuGGfNwdkBEIDnUjaHs3w"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8vFmjDWLF7PFMuGGfNwdkBEIDnUjaHs3w
Content-Type: multipart/mixed; boundary="iXrGPQc77wLjlyhfPajcaNCIpVbc7WfbL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <fad736ed-5353-bd9a-5af3-125f409d6c4e@gmx.com>
Subject: Re: [PATCH] btrfs-progs: mkfs rootdir: use lgetxattr() not to follow
 a symbolic link
References: <f53cc5d0-24ff-81b7-68db-0c615edf4936@jp.fujitsu.com>
In-Reply-To: <f53cc5d0-24ff-81b7-68db-0c615edf4936@jp.fujitsu.com>

--iXrGPQc77wLjlyhfPajcaNCIpVbc7WfbL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8802=E6=97=A5 09:59, Misono Tomohiro wrote:
> mkfs-test 016 "rootdir-bad-symbolic-link" fails when selinux is enabled=
=2E
> This is because add_xattr_item() uses getxattr() and tries to follow a
> bad symbolic link for selinux item, which causes ENOENT error.
>=20
> The line above already uses llistxattr() for getting list of xattr in
> order not to follow a symbolic link, so just use lgetxattr() too.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  mkfs/rootdir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
> index 33c3ff1e..ff00bb0f 100644
> --- a/mkfs/rootdir.c
> +++ b/mkfs/rootdir.c
> @@ -249,7 +249,7 @@ static int add_xattr_item(struct btrfs_trans_handle=
 *trans,
>  		cur_name_len =3D strlen(cur_name);
>  		next_location +=3D cur_name_len + 1;
> =20
> -		ret =3D getxattr(file_name, cur_name, cur_value, XATTR_SIZE_MAX);
> +		ret =3D lgetxattr(file_name, cur_name, cur_value, XATTR_SIZE_MAX);
>  		if (ret < 0) {
>  			if (errno =3D=3D ENOTSUP)
>  				return 0;
>=20


--iXrGPQc77wLjlyhfPajcaNCIpVbc7WfbL--

--8vFmjDWLF7PFMuGGfNwdkBEIDnUjaHs3w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrBkMcACgkQwj2R86El
/qj8bwf/QXvxaHdp7kd8Wo4JXR8LeqxXEJ2coMIh0rYNkrZTcMRv4iQKYruoKonV
0wgHCP9xwIug8O7QWLp/T2ve2jeKgp9EtyFXw6rGswb1qIXF/bqoKoL5+o1qk6Qa
TRS5vuNH72mymLkVnuAEo3uVyFxePbUT/gvUZ25uOPsCA1dMWy0UgSzRlZuEkBfi
b6BPMxeNzZj/rSMjPMhwrxj96GiQwecuPHV0p6nRbdJdLrcNJYnGRO98Vbx/EUxR
d1vQMCHMBRwF8rpcii7L6Z7DsRw7d2IXMFhpSiiaDlSuO9wabDRoj4Vh/gXd+mY+
rYHiusVopQjaeonH3YSI/FQCP9gOgg==
=a6Jc
-----END PGP SIGNATURE-----

--8vFmjDWLF7PFMuGGfNwdkBEIDnUjaHs3w--
