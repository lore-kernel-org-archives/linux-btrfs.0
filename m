Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60134 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750741AbdL3DPX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 22:15:23 -0500
Subject: Re: Hand Patching a BTRFS Superblock?
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
 <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>
 <cda353c4-8e9c-7bea-0c59-b4afc388da58@gmx.com>
 <CAJt7KB9d7yvE42gt+bVXVu8RxsVpD8BW15mM-ecjSFUdqNtUAg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <67d9fbdc-1986-c214-2228-cc48cf2d9772@gmx.com>
Date: Sat, 30 Dec 2017 11:15:15 +0800
MIME-Version: 1.0
In-Reply-To: <CAJt7KB9d7yvE42gt+bVXVu8RxsVpD8BW15mM-ecjSFUdqNtUAg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="b54a09YWSLFv996RQiMNbrRvScPNFFavs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b54a09YWSLFv996RQiMNbrRvScPNFFavs
Content-Type: multipart/mixed; boundary="PWxxkaHQLi5t1i3dHlSLmgEXFEHosu6lg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <67d9fbdc-1986-c214-2228-cc48cf2d9772@gmx.com>
Subject: Re: Hand Patching a BTRFS Superblock?
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
 <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>
 <cda353c4-8e9c-7bea-0c59-b4afc388da58@gmx.com>
 <CAJt7KB9d7yvE42gt+bVXVu8RxsVpD8BW15mM-ecjSFUdqNtUAg@mail.gmail.com>
In-Reply-To: <CAJt7KB9d7yvE42gt+bVXVu8RxsVpD8BW15mM-ecjSFUdqNtUAg@mail.gmail.com>

--PWxxkaHQLi5t1i3dHlSLmgEXFEHosu6lg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8830=E6=97=A5 03:30, Stirling Westrup wrote:
> You were right! grep found two more signature blocks! How do I make use=
 of them?
>=20
> videon:~ # LC_ALL=3DC grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" /d=
ev/sde
> 65600:_BHRfS_M

This the correct one.
Offset is 64K + 64.

> 26697111807:_BHRfS_M

It is a little tricky now.

Btrfs has its superblocks at:
64K (primary)
64M (backup 1)
256G (backup 2)

While this one is at 25G and has offset which is not 64 (magic inside
superblock).

Is there any btrfs image inside the fs?

> 26854350428:_BHRfS_M

Much like the previous one.

Despite that, you could try to use "inspect dump-super --bytenr" to
check if it's the super you want.

The bytenr you could pass is:
26697111743
26854350364

And at this point, I would say the chance to recover data is really very
low now.

Thanks,
Qu
>=20
> On Thu, Dec 28, 2017 at 11:00 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8829=E6=97=A5 11:35, Stirling Westrup wrote:
>>> On Thu, Dec 28, 2017 at 9:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>
>>>>
>>>> I strongly recommend to do a binary search for magic number "5f42 48=
52
>>>> 6653 5f4d" to locate the real offset (if it's offset, not a toasted =
image)
>>>>
>>> I don't understand, how would I do a binary search for that signature=
?
>>>
>> The most stupid idea is to use xxd and grep.
>>
>> Something like:
>>
>> # xxd /dev/sde | grep 5f42 -C1
>>
>=20
>=20
>=20


--PWxxkaHQLi5t1i3dHlSLmgEXFEHosu6lg--

--b54a09YWSLFv996RQiMNbrRvScPNFFavs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpHBMMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi6PAgAnO6kF+7Ip3vyh+59DXr9IvBK
lnBTFKE8P0tiZSeytYuYbJ9J3K9iD6EgLZ1Z7hoSi/LQnbb9R2dnuF7gR4/t3Js1
5Fx14vwPZ0quaxLF3HFXGmZEinKHiSziLUO6LTFRuiCSr1B5sTr7caoozAjxScsC
Zbag+my80iIOf+kglPVpkKIwy39WRy3Pb+0tKWcgoI5KJ3y2lJdOCfRx6/g/6ekt
aDW9mm1HGMf+BAgf8XTQZNSbNXw8UBV89ImA076alFc2AC0mH2XTzoHBbl2JLdcl
8zkUOKROaFU08Ijfxc6/EIhHH8aiDuCiGSEiRZ05ZInXwVblNL3Dy7TT1T4Xpg==
=urdO
-----END PGP SIGNATURE-----

--b54a09YWSLFv996RQiMNbrRvScPNFFavs--
