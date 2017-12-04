Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60501 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbdLDN6b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 08:58:31 -0500
Subject: Re: command to get quota limit
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1512389667.1707.109.camel@gmail.com>
 <d06860e1-f905-30ff-941a-92ed61355483@gmx.com>
 <1512395190.1707.113.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2411124a-7e2e-6dd3-d4e3-c8611237aefc@gmx.com>
Date: Mon, 4 Dec 2017 21:58:24 +0800
MIME-Version: 1.0
In-Reply-To: <1512395190.1707.113.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="To1KV1HAfavXVplXxAS65rhGa75oDqDqu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--To1KV1HAfavXVplXxAS65rhGa75oDqDqu
Content-Type: multipart/mixed; boundary="k9j2LTRtub7tD8JA6Lj8vrPiLtQ5KrHjO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <2411124a-7e2e-6dd3-d4e3-c8611237aefc@gmx.com>
Subject: Re: command to get quota limit
References: <1512389667.1707.109.camel@gmail.com>
 <d06860e1-f905-30ff-941a-92ed61355483@gmx.com>
 <1512395190.1707.113.camel@gmail.com>
In-Reply-To: <1512395190.1707.113.camel@gmail.com>

--k9j2LTRtub7tD8JA6Lj8vrPiLtQ5KrHjO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8804=E6=97=A5 21:46, ST wrote:
>>> Hello,
>>>
>>> what is the command to get btrfs quota limit on certain subvolume?
>>
>> btrfs qgroup show -re
>>
>> The result is for all subvolumes, then just find the subvolume you nee=
d.
>>
>=20
> I need to use the quota number in a script... is there a more specific
> command, otherwise I need to get the groupID first and then to parse th=
e
> output...

IIRC "btrfs qgroup show -re <mnt>" is specific enough.

Just try it, and read btrfs-qgroup(8).

As long as you're using it in a script, the you will need subvolume id
anyway.

Thanks,
Qu

>=20
> Thank you!
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--k9j2LTRtub7tD8JA6Lj8vrPiLtQ5KrHjO--

--To1KV1HAfavXVplXxAS65rhGa75oDqDqu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlolVIAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjkNwf+OBChDuY85x+VUFK8fzkadmHC
s79mrmWEZYDPYSzpMpEoOKSw40Tv/NF5NN/Bb2HphaZ8N1tz5Bg/6PJRrpeABn6g
yHMrcxqTRINtQpAVIRmvpMYFBiO91EmxgVqmvb7AQTqPC20QoraAEO/8BfHTHYzL
ZL/V7SCm/HBJz5cpgHkpJ1XBIHDzIxJTEqRsmhkcLzKYBspHYZDLXwR0+nyby+Wb
3ZIGdg0t+F677pkk7icYKf03FgUY/LwbOYXfnulQVYIsJ5uiynWG6PRLT3JB1Adw
tkadVK2XIZdg4zIbLxyq35A5lscvI8xwBA9oklqL5kh78JPIGVSxyQ9BEG+Yrw==
=qiHN
-----END PGP SIGNATURE-----

--To1KV1HAfavXVplXxAS65rhGa75oDqDqu--
