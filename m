Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52723 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbeAGGVq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Jan 2018 01:21:46 -0500
Subject: Re: btrfs quota exceeded notifications through netlink sockets
To: "Karsai, Gabor" <gabor.karsai@Vanderbilt.Edu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <660251B721353E428446B0F99FE510A2A508D507@ITS-HCWNEM102.ds.vanderbilt.edu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f67fafee-fac3-21fa-d89f-a830da646ea5@gmx.com>
Date: Sun, 7 Jan 2018 14:21:36 +0800
MIME-Version: 1.0
In-Reply-To: <660251B721353E428446B0F99FE510A2A508D507@ITS-HCWNEM102.ds.vanderbilt.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Km5v218cFbDNFhXj3rpUar7AvGc26Roqz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Km5v218cFbDNFhXj3rpUar7AvGc26Roqz
Content-Type: multipart/mixed; boundary="Hw18aya0EYaEBNFfaSlgE39qHC4tjtqZU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Karsai, Gabor" <gabor.karsai@Vanderbilt.Edu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <f67fafee-fac3-21fa-d89f-a830da646ea5@gmx.com>
Subject: Re: btrfs quota exceeded notifications through netlink sockets
References: <660251B721353E428446B0F99FE510A2A508D507@ITS-HCWNEM102.ds.vanderbilt.edu>
In-Reply-To: <660251B721353E428446B0F99FE510A2A508D507@ITS-HCWNEM102.ds.vanderbilt.edu>

--Hw18aya0EYaEBNFfaSlgE39qHC4tjtqZU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8806=E6=97=A5 09:34, Karsai, Gabor wrote:
> I created a subvolume on a btrfs, set a limit and the quota is enforced=
 - dumping too much data into the subvolume results in a 'quota exceeded'=
 message (from dd, for example). But when I am trying to get netlink sock=
et notifications, nothing arrives on the socket (I am using pyroute2 whic=
h is supposedly able to receive disk quota notifications)
>=20
> $ uname -a
> Linux riaps-dev 4.10.0-42-generic #46~16.04.1-Ubuntu SMP Mon Dec 4 15:5=
7:59 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>=20
> btrfs: whatever Ubuntu 16.04 has=20
>=20
> Kconfig:
> CONFIG_QUOTA_NETLINK_INTERFACE=3Dy

This quota netlink support is for generic quota (implemented by
fs/quota/*), while btrfs is not using the generic quota for several
reasons (mostly related to subvolume quota).
So that's why quota netlink gets nothing to report.

Thanks,
Qu

>=20
> Any advice would be appreciated.
> Thanks,
> -- Gabor Karsai
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Hw18aya0EYaEBNFfaSlgE39qHC4tjtqZU--

--Km5v218cFbDNFhXj3rpUar7AvGc26Roqz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpRvHAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhWiwf9HdF3INKJpwQKQ8WLrSO30zs2
9XxerHZ+uJi3cGwo8ZTOZP50J75ARmkcyvjYBLEipPg9HpE3DW17VplCHcIk4iPo
skcd1eh5GChgzsQhvS60FPo9pBCBxUGOS4IrTyHdnY3dlzNc8IeL9qXT4AS7pWS6
Tgrrr04SDVfnxD2HdNbStkmp7oS7/QOuKwphuDKBCZuS+WzU3TS+5pIM29yukQbH
IbxART4PXh6pgpOr+QmveW4oMq1FKEwYYrVIrGmfXhVEpqU7VJZ8v4cqc3X6wpU3
YWmLWdAVD0p049qRk197zdwVs6CmOEC8tqvD7/OB8MEXXd/7qn+SOKpbZUe9ug==
=fgb0
-----END PGP SIGNATURE-----

--Km5v218cFbDNFhXj3rpUar7AvGc26Roqz--
