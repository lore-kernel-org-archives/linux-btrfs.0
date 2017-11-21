Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55392 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdKUOgx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 09:36:53 -0500
Subject: Re: [PATCH] btrfs: extent-tree: Use round up to replace align macro
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171121055445.13972-1-wqu@suse.com>
 <20171121133652.GJ3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <838e4f7d-013f-d08f-9624-45400eb62551@gmx.com>
Date: Tue, 21 Nov 2017 22:36:37 +0800
MIME-Version: 1.0
In-Reply-To: <20171121133652.GJ3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hq34I01lmTprie17Lu24c5opJvsLf4AhK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hq34I01lmTprie17Lu24c5opJvsLf4AhK
Content-Type: multipart/mixed; boundary="Sj7PVTLdiNdV9H4Mh5GpR6JRhheEqNnbd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <838e4f7d-013f-d08f-9624-45400eb62551@gmx.com>
Subject: Re: [PATCH] btrfs: extent-tree: Use round up to replace align macro
References: <20171121055445.13972-1-wqu@suse.com>
 <20171121133652.GJ3553@twin.jikos.cz>
In-Reply-To: <20171121133652.GJ3553@twin.jikos.cz>

--Sj7PVTLdiNdV9H4Mh5GpR6JRhheEqNnbd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 21:36, David Sterba wrote:
> On Tue, Nov 21, 2017 at 01:54:45PM +0800, Qu Wenruo wrote:
>> To save reader seconds before checking if it's rounding up or down.
>=20
> Agreed, this is more clear. Please switch all instances of ALIGN to
> round_up, there's not much point doing it file by file.

OK.

I just encountered this when digging space reservation related code.

Converting all won't be a problem.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Sj7PVTLdiNdV9H4Mh5GpR6JRhheEqNnbd--

--hq34I01lmTprie17Lu24c5opJvsLf4AhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloUOfUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhWvwgAgXoaC2133kplWS4wXxR9hex5
4WZn22BFV9UzpUd4+3t5iRexlXggb4scUVwTLmc/8b5KuJU6iD79t3AIXLiPfCUA
AEQnjWuinLPiAgblJWYhbG2nlALD+HpOvyoklA8Dsjk5NuBDMj0KcB8s5wa6QBpf
HPhX3o/RE1llfWLd8T6xzqS0INUUjki2q4b0gQ8eT45r/0Y61FBuZ7m4Rte3eUxW
ZBDT+sHPcgaPSRAiRtNxbZP+CjCAHnCiZcmEM04eHjC59yk0ufi3wBUB1RBp/xV8
jtuKARhtKT4RYXLJMlk/jJSJS8anHhl8Oqpxi4fN7SdEDRZLD3QTXsQFIXxHsg==
=hSJU
-----END PGP SIGNATURE-----

--hq34I01lmTprie17Lu24c5opJvsLf4AhK--
