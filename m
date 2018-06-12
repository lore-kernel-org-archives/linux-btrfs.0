Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58649 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933569AbeFLBSm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 21:18:42 -0400
Subject: Re: corrupt leaf; unaligned key offset for csum item
To: Simon Kaiser <simon.kaiser@kit.edu>, linux-btrfs@vger.kernel.org
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
 <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
 <f1f681f2-2bed-7686-604a-846bc5078dbf@gmx.com>
 <87in6pe0ln.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8fb5a8bc-8b5d-c82b-b0c4-8e209b6c17b1@gmx.com>
Date: Tue, 12 Jun 2018 09:18:26 +0800
MIME-Version: 1.0
In-Reply-To: <87in6pe0ln.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WaTc5xDXqLmbQUfbtik07bopDvIcy88u7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WaTc5xDXqLmbQUfbtik07bopDvIcy88u7
Content-Type: multipart/mixed; boundary="XqgWcmjx3k5WTQ8sgxXMf5EnQOk26j3tC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Simon Kaiser <simon.kaiser@kit.edu>, linux-btrfs@vger.kernel.org
Message-ID: <8fb5a8bc-8b5d-c82b-b0c4-8e209b6c17b1@gmx.com>
Subject: Re: corrupt leaf; unaligned key offset for csum item
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
 <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com>
 <f1f681f2-2bed-7686-604a-846bc5078dbf@gmx.com>
 <87in6pe0ln.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
In-Reply-To: <87in6pe0ln.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>

--XqgWcmjx3k5WTQ8sgxXMf5EnQOk26j3tC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8812=E6=97=A5 00:42, Simon Kaiser wrote:
>> On 2018=E5=B9=B406=E6=9C=8810=E6=97=A5 09:56, Qu Wenruo wrote:
>>
>> Since there is no other csum error exposed by btrfs check/scrub, the f=
ix
>> for this particular csum item key bit flip can be fetched here:
>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>>
>> The usage will be (after the normal compile procedure)
>> $ ./btrfs-corrupt-block -X <device>
>>
>> It needs to be executed offline (the <device> must be unmounted).
>>
>> Thanks,
>> Qu
>>
>=20
> Thank you very much, that fixed the issue :)
>=20
> btrfs scrub now shows 5 checksum errors on a single file
>=20
> [ 1869.456426] BTRFS warning (device sda5): checksum error at logical 1=
271386112 on dev /dev/sda5, physical 1271386112, root 257, inode 8016535,=
 offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
> 2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000=
000000001-00056e3429e252bb.journal)                                      =
                                                                   =20
> [ 1869.456429] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd=
 370, flush 0, corrupt 1, gen 0
> [ 1869.457975] BTRFS warning (device sda5): checksum error at logical 1=
271390208 on dev /dev/sda5, physical 1271390208, root 257, inode 8016535,=
 offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
> 2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000=
000000001-00056e3429e252bb.journal)                                      =
                                                                   =20
> [ 1869.457978] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd=
 370, flush 0, corrupt 2, gen 0
> [ 1869.459381] BTRFS warning (device sda5): checksum error at logical 1=
271394304 on dev /dev/sda5, physical 1271394304, root 257, inode 8016535,=
 offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
> 2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000=
000000001-00056e3429e252bb.journal)                                      =
                                                                   =20
> [ 1869.459383] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd=
 370, flush 0, corrupt 3, gen 0
> [ 1869.460827] BTRFS warning (device sda5): checksum error at logical 1=
271398400 on dev /dev/sda5, physical 1271398400, root 257, inode 8016535,=
 offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
> 2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000=
000000001-00056e3429e252bb.journal)                                      =
                                                                   =20
> [ 1869.460829] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd=
 370, flush 0, corrupt 4, gen 0
> [ 1869.462118] BTRFS warning (device sda5): checksum error at logical 1=
271402496 on dev /dev/sda5, physical 1271402496, root 257, inode 8016535,=
 offset 655360, length 4096, links 1 (path: var/log/journal/31d9cc011
> 2694cdab3887013fb7bbcf9/system@d8ae7586248c492d8d51c44efd7316da-0000000=
000000001-00056e3429e252bb.journal)                                      =
                                                                   =20
> [ 1869.462120] BTRFS error (device sda5): bdev /dev/sda5 errs: wr 1, rd=
 370, flush 0, corrupt 5, gen 0
>=20
> I don't really need that file, can I simply delete it and forget about
> it or is there something else I should do?

Of course you can delete it, and if nothing else went wrong, it should
fix the problem.

And of course, remove that offending memory stick.

Thanks,
Qu

>=20
> Yours,
> Simon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--XqgWcmjx3k5WTQ8sgxXMf5EnQOk26j3tC--

--WaTc5xDXqLmbQUfbtik07bopDvIcy88u7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsfH2MACgkQwj2R86El
/qhXDgf+MRGzIJvgx3jc20x0bpWU8Ra9R3DXIv6S/hKEP6VtWGyL5WF+eY/N5hBv
ss+traLB6sAM/tZENDj/Vq9AkTbuZHeGMEDPOjLfEvrpkzsYR8rAL2GQTMKxeEji
PfEwJ1C0lVI8ZC+WRCeu8yFsMHXAnRe60aIcqsrrHdOnMb3zCdKSFyuPICidFk97
5YNJdHbo7+Zlt7UA322EGUhS2h98B27+kcrH1KhLskGUtky2+Owk7k6T3G/yAg+r
7h7b/rRL6uSRoWuHxuwe/MdGeq4zP7t5TlptQk9JowAOBuRlMByQV/9SStMkCj9n
YKUqqG4C6IiWYwZxGguWBTLYzYjCwA==
=QAzJ
-----END PGP SIGNATURE-----

--WaTc5xDXqLmbQUfbtik07bopDvIcy88u7--
