Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52551 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbdKUBWi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 20:22:38 -0500
Subject: Re: test btrfs scrubbing/get system's total capacity
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
References: <1511196626.1657.29.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6e5b5480-bce6-4e4e-98bf-b85264abe40a@gmx.com>
Date: Tue, 21 Nov 2017 09:22:32 +0800
MIME-Version: 1.0
In-Reply-To: <1511196626.1657.29.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QaN3rpPA1hwKc8mbbt2nUBEWatE1e0vFK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QaN3rpPA1hwKc8mbbt2nUBEWatE1e0vFK
Content-Type: multipart/mixed; boundary="RqfgHLfw0d0oQ5AUKhD4ERmv4BdNvJ0iW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <6e5b5480-bce6-4e4e-98bf-b85264abe40a@gmx.com>
Subject: Re: test btrfs scrubbing/get system's total capacity
References: <1511196626.1657.29.camel@gmail.com>
In-Reply-To: <1511196626.1657.29.camel@gmail.com>

--RqfgHLfw0d0oQ5AUKhD4ERmv4BdNvJ0iW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 00:50, ST wrote:
> Hello,
>=20
> 1. is there a tool that I can use to test btrfs scrubbing? Namely I nee=
d
> to "damage" a file, i.e. change it without changing its meta
> information, so I can see how scrubbing performs... Is there something
> like this?

Btrfs-corrupt-block, which is not compiled by default.
And not well documented.

>=20
>=20
> 2. I want to use Ansible to set btrfs quota on a /home subvolume as say=

> 0.8*TotalCapacityOfRoot and then assign to it individual users'
> subvolumes with certain (smaller) quatos.

Quota only works on subvolumes.
Although you could do it using multi level qgroups.

Using higher level qgroup, 1/0 for example, as a big pool and then
assign real subvolume qgroup to that pool.

However, current qgroup will bring big performance overhead, especially
for balance and snapshot deletion.

Although not sure what Ansible is and if it uses btrfs quota.


> 2.1 Is it OK to rely on ansible_facts? Does it has correct information
> about btrfs-based "/" total capacity?

Not sure about ansible at all.

> 2.2 If not, is there a raw command to get TotalCapacityOfRoot in -TB so=

> I can set it? Is there something like btrfs filesystem usage / -t
> --device_size? to get only the total Device Size information?\

What is the meaning of TotalCapacityOfRoot? Device size? Fs size?

Thanks,
Qu

>=20
> Thank you!
> ST
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--RqfgHLfw0d0oQ5AUKhD4ERmv4BdNvJ0iW--

--QaN3rpPA1hwKc8mbbt2nUBEWatE1e0vFK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloTf9gXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh6Rgf+OFfBar4+aPhIBOZvShX3Sbsg
ilrLV/VcL/b+aY6KOgXdm7R75SuD0vi1q2snzyX6wQtj29XTaROMAZVl2bbkTAlK
OVd68GzbD3uaFhX2TVRVd7P+FKC2dWBNB3bfjph67EQH40PM+dYa9/i4foBO0b8f
tmI48p2xi/6mcjazyTXS7vJww3PBW3wQAPTY8mVc5sqZauNLDPcMKToCgZk1jXwY
X0RnmF03OzJRbQNOhBlqsASN8Nzqk4lC2C8RDKfKwFs77nQYVzIqXdy0M7c0rI49
3Xdq6A+j2bT6eJYOQOHa+ZAItDJXRcc+s/Uzz9cZbX0yUSb0w7a15LIqx+lFGA==
=XMrR
-----END PGP SIGNATURE-----

--QaN3rpPA1hwKc8mbbt2nUBEWatE1e0vFK--
