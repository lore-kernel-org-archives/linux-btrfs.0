Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:40113 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756056AbdJQMqY (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 08:46:24 -0400
Subject: Re: reproducable oops in btrfs/130 with latests mainline
To: Po-Hsu Lin <po-hsu.lin@canonical.com>, linux-btrfs@vger.kernel.org
References: <20161125080723.GA12776@infradead.org>
 <190cc125&#45;d1c1&#45;6005&#45;c23b&#45;cc54c825f242@fb.com>
 <20171017111151.4316-1-po-hsu.lin@canonical.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <4bd6e028-a4bf-6749-2894-e5f9a0e0f629@suse.com>
Date: Tue, 17 Oct 2017 20:46:16 +0800
MIME-Version: 1.0
In-Reply-To: <20171017111151.4316-1-po-hsu.lin@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="haFrPwQ0Cbk6PmFwL7dFdI6i41Q8VtCbv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--haFrPwQ0Cbk6PmFwL7dFdI6i41Q8VtCbv
Content-Type: multipart/mixed; boundary="n15NElAsTKg8hHO6mqI3XfhXrHSTTdb8S";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Po-Hsu Lin <po-hsu.lin@canonical.com>, linux-btrfs@vger.kernel.org
Message-ID: <4bd6e028-a4bf-6749-2894-e5f9a0e0f629@suse.com>
Subject: Re: reproducable oops in btrfs/130 with latests mainline
References: <20161125080723.GA12776@infradead.org>
 <190cc125&#45;d1c1&#45;6005&#45;c23b&#45;cc54c825f242@fb.com>
 <20171017111151.4316-1-po-hsu.lin@canonical.com>
In-Reply-To: <20171017111151.4316-1-po-hsu.lin@canonical.com>

--n15NElAsTKg8hHO6mqI3XfhXrHSTTdb8S
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8817=E6=97=A5 19:11, Po-Hsu Lin wrote:
> Hello Chris,
>=20
> I can reproduce this on my side too, with Ubuntu 16.04 + 4.4.0-97 kerne=
l.

Btrfs/130 is a known bug.

I submitted it to raise the concern about such situation and purposed
one possible solution (just disable deduped file detection).

But the solution doesn't get accepted.

Thanks,
Qu
>=20
> PREEMPT config:
> $ cat config-4.4.0-97-generic | grep PREEMPT
> CONFIG_PREEMPT_NOTIFIERS=3Dy
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=3Dy
> # CONFIG_PREEMPT is not set
>=20
> Bug reports on launchpad:
> https://bugs.launchpad.net/bugs/1718925
> https://bugs.launchpad.net/bugs/1717443
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--n15NElAsTKg8hHO6mqI3XfhXrHSTTdb8S--

--haFrPwQ0Cbk6PmFwL7dFdI6i41Q8VtCbv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnl+5gNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qA0sB/9BxE8nOUYL/u6K3hDZU7rjWIirAx+cBvaFRQCc
XY0F9P4gAio/ycFU3A5TKXkuQ9lU641aYszkqXCusII5zPOTFB/aQA6jW5bcfrDp
FTi2J7TiCyOW1uwzxJ+jm8M0l19VV+aiYq15542UxNlS2IqZXkE/V+3ktiJED2Ec
69Hd90tfUOGPUZKueaVWltc/JjHOUG4siqi9KGHfNxhJy9G6YXd2K6rqQzWzjTIm
9QK8nnXfiqCPNFKPpH7ui/p8v1FIGCRF2LqHUZuMmfAmJNP3HUCGdQR30NoRUzN5
0gL3F1OqpaGgyLw5sFciRxHsqpksaIIHHD6R0vS1T7NZWFz3
=OA6o
-----END PGP SIGNATURE-----

--haFrPwQ0Cbk6PmFwL7dFdI6i41Q8VtCbv--
