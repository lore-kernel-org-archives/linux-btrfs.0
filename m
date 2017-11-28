Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62404 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752572AbdK1AvO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 19:51:14 -0500
Subject: Re: splat on 4.15-rc1: invalid ram_bytes for uncompressed inline
 extent
To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        linux-btrfs@vger.kernel.org
References: <20171127132349.cm7c3mgegbqhlnrm@angband.pl>
 <20171127142244.GZ3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bba97ff7-b08f-19d2-b980-f92443691c18@gmx.com>
Date: Tue, 28 Nov 2017 08:51:07 +0800
MIME-Version: 1.0
In-Reply-To: <20171127142244.GZ3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iLL0PtHER0rxEXjG23Uo660UKvqWiBoVm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iLL0PtHER0rxEXjG23Uo660UKvqWiBoVm
Content-Type: multipart/mixed; boundary="WkM21JinGRSCQhCgPdNwtLlkKe2n5lBaB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
 linux-btrfs@vger.kernel.org
Message-ID: <bba97ff7-b08f-19d2-b980-f92443691c18@gmx.com>
Subject: Re: splat on 4.15-rc1: invalid ram_bytes for uncompressed inline
 extent
References: <20171127132349.cm7c3mgegbqhlnrm@angband.pl>
 <20171127142244.GZ3553@twin.jikos.cz>
In-Reply-To: <20171127142244.GZ3553@twin.jikos.cz>

--WkM21JinGRSCQhCgPdNwtLlkKe2n5lBaB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 22:22, David Sterba wrote:
> On Mon, Nov 27, 2017 at 02:23:49PM +0100, Adam Borowski wrote:
>> Hi!
>> On 4.15-rc1, I get the following failure:
>>
>> BTRFS critical (device sda1): corrupt leaf: root=3D1 block=3D382066289=
8688
>> slot=3D43 ino=3D35691 file_offset=3D0, invalid ram_bytes for uncompres=
sed inline
>> extent, have 134 expect 281474976710677
>=20
> By a quick look at suspiciously large number
>=20
> hex(281474976710677) =3D 0x1000000000015
>=20
> may be a bitflip, but 0x15 does not match 134, so there could be
> something else involved in the corruption.

That's a known bug, fixed by that patch which is not merged yet.

https://patchwork.kernel.org/patch/10047489/

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--WkM21JinGRSCQhCgPdNwtLlkKe2n5lBaB--

--iLL0PtHER0rxEXjG23Uo660UKvqWiBoVm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlocsvsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgUYAgAgSpiLJqpLkrxZ7YP8T9VTZR3
+r/Qimw7py63nWSJSD/AxWE0Q7UAAzM6eb2W/JrtGqDjm5rrRrBh8cIqimFckmXj
B5foALM/lrpMkmg7hvT17fGey0i/IpENDytISGpU5RqsDNHb/K8nMEbxJ9zS78X7
jUAhMYmRc8gkbCPq7zltdFwoXzgz/a3kmIMjub1/qtYK+Z654Qgv0Ur4yoDhw7N8
0NWzAQZCgXRzvGBboxshP+WRjx9DTlkfEC2lO7+dSNS1JnQj/HaeE6pI7k34l1mV
x9pPh/CgUNPCYWgLrLRh6FuEg+E+wbg+L2P5E6FkUjMkE6IbprAHo1QWUWGwFA==
=EHnk
-----END PGP SIGNATURE-----

--iLL0PtHER0rxEXjG23Uo660UKvqWiBoVm--
