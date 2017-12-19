Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56777 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965702AbdLSL3c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:32 -0500
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171219104511.3563-1-wqu@suse.com>
 <1dbba47b-2f03-2a65-1384-ba45bc6bc403@suse.com>
 <7d8cd1a8-fa0f-7b7a-f06b-ccc714b4e42e@gmx.com>
 <4a576fea-4245-702e-01a8-09d5ac359509@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cd4b5ff5-6207-12bf-ac88-1c45f31c2851@gmx.com>
Date: Tue, 19 Dec 2017 19:28:48 +0800
MIME-Version: 1.0
In-Reply-To: <4a576fea-4245-702e-01a8-09d5ac359509@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6ovENWfrRrtu9KuAB8TwiaD2JerKBXTUR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6ovENWfrRrtu9KuAB8TwiaD2JerKBXTUR
Content-Type: multipart/mixed; boundary="DsO8fvvH8l5mKqbFDUbb31QFjnhtQktBR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <cd4b5ff5-6207-12bf-ac88-1c45f31c2851@gmx.com>
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
References: <20171219104511.3563-1-wqu@suse.com>
 <1dbba47b-2f03-2a65-1384-ba45bc6bc403@suse.com>
 <7d8cd1a8-fa0f-7b7a-f06b-ccc714b4e42e@gmx.com>
 <4a576fea-4245-702e-01a8-09d5ac359509@suse.com>
In-Reply-To: <4a576fea-4245-702e-01a8-09d5ac359509@suse.com>

--DsO8fvvH8l5mKqbFDUbb31QFjnhtQktBR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8819=E6=97=A5 19:24, Nikolay Borisov wrote:
>=20
>=20
> On 19.12.2017 13:20, Qu Wenruo wrote:
>> Naming like pad1/2 will make the check in btrfs_qgroup_inherit() look
>> quite weird.
>>
>> Although I don't have any better idea, so I'm mostly fine with such re=
name.
>=20
> Right, I saw the check now, missed it the first time. I think we should=

> remove it and the code should completely ignore these values. Ideally,
> we would have removed them from qgroup_inherit struct as well but this
> means breaking the on-disk format. So let's ignore them altogether.

Ignoring the values completely seems quite reasonable.

I'll update the patch.

Thanks,
Qu
>=20
>>
>> Thanks,


--DsO8fvvH8l5mKqbFDUbb31QFjnhtQktBR--

--6ovENWfrRrtu9KuAB8TwiaD2JerKBXTUR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo49/EXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiWfwgAqwt3dbDngL94qxLIz/hxWa4D
kB6lH8sesN8rY6E2E1xiQPYGSAqyG4AOaYPrGIU9GLU/7Hl7ou5OEaK3WKWo6Z6J
Vfx+/kroOOZ5LmzC7d8hgdPwq8dEFiwib/4P1shfZZ2W61F3v9nKnpj+r25G81CQ
bGsb0yMOs8L0XRenkoqHG75pT34ymyoOWDeJMxCQ0EoiVv8pbvksetGz4TvEsYjB
r7mZdutZNI/GhQ6ObNFuDLncxk8jmFg8jmcIePctHkpUMZb4MbqGhouWDExGVreh
y6qBcBC4TdPKTBJaHws7d5yIU3VY/2iuE/5kyk5NAdz6hiBbAXMuRP/t7M2TBg==
=dGCH
-----END PGP SIGNATURE-----

--6ovENWfrRrtu9KuAB8TwiaD2JerKBXTUR--
