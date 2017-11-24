Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54120 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753438AbdKXLu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 06:50:26 -0500
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
 <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
 <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
 <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
 <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
 <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>
 <ccdf8c94-3fae-8c04-7b4f-b5bb7546ed06@gmx.com>
 <CAKuJGC930Nm4pNqA+xH5HRbx0pWBKR4KXnS32hP+NYSdvO7arA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9932efee-4784-60db-114f-a6ce3ed01b7c@gmx.com>
Date: Fri, 24 Nov 2017 19:50:19 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC930Nm4pNqA+xH5HRbx0pWBKR4KXnS32hP+NYSdvO7arA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Jk5FPAlwtRmX3NouH2HcpTqSlviRMTkM4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Jk5FPAlwtRmX3NouH2HcpTqSlviRMTkM4
Content-Type: multipart/mixed; boundary="Rcmda0pfrnmIuBvIBWFP68JUgRoHvvVG7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9932efee-4784-60db-114f-a6ce3ed01b7c@gmx.com>
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
 <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
 <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
 <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
 <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
 <CAKuJGC-NaE3J2tu+HEED5fkBs5C=kkkrJqb0QfkTtpdmEdSn9Q@mail.gmail.com>
 <ccdf8c94-3fae-8c04-7b4f-b5bb7546ed06@gmx.com>
 <CAKuJGC930Nm4pNqA+xH5HRbx0pWBKR4KXnS32hP+NYSdvO7arA@mail.gmail.com>
In-Reply-To: <CAKuJGC930Nm4pNqA+xH5HRbx0pWBKR4KXnS32hP+NYSdvO7arA@mail.gmail.com>

--Rcmda0pfrnmIuBvIBWFP68JUgRoHvvVG7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8824=E6=97=A5 19:42, Lakshmipathi.G wrote:
>>
>> To make it clear, what kernel config and commit are you using when the=

>> test fails?
>>
> When I use attached kernel config along with tar from misc-next branch
> (wget https://github.com/kdave/btrfs-devel/archive/misc-next.zip) this
> issue happens.

BTW, David seems to update his branch more often in his git.kernel.org
branch than github.

So it's possible that the branch from github is out dated.

>=20
>> In my test, if I use the david/for-4.15 branch, it will fails to umoun=
t
>> the fs, due to the known bug if you enabled
>> CONFIG_BTRFS_FS_CHECK_INTEGRITY (you reported it first).
>> And for any upstream kernel version like v4.14-rc7 or v4.14, not probl=
em
>> at all.
>>
> Here's btrfs related config. I checked with 4.14.2 it worked fine there=
 too.
>=20
> The issue happens with v4.14-rc7, can you check with above config
> file and zip file(misc-next.zip)?
>=20
> $ cat kernel.config | grep "BTRFS"
> CONFIG_BTRFS_FS=3Dy
> CONFIG_BTRFS_FS_POSIX_ACL=3Dy
> CONFIG_BTRFS_FS_CHECK_INTEGRITY=3Dn
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS=3Dn
> CONFIG_BTRFS_DEBUG=3Dy
> CONFIG_BTRFS_ASSERT=3Dy
> CONFIG_BTRFS_FS_REF_VERIFY=3Dy

For v4.14-rc7, even I enabled all the btrfs related configs, I still
can't reproduce it.
------
$ zcat /proc/config.gz  | grep BTRFS
CONFIG_BTRFS_FS=3Dm
CONFIG_BTRFS_FS_POSIX_ACL=3Dy
CONFIG_BTRFS_FS_CHECK_INTEGRITY=3Dy
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=3Dy
CONFIG_BTRFS_DEBUG=3Dy
CONFIG_BTRFS_ASSERT=3Dy
------

So there is something strange happened.

Thanks,
Qu

>=20
> thanks!
>=20
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>=20


--Rcmda0pfrnmIuBvIBWFP68JUgRoHvvVG7--

--Jk5FPAlwtRmX3NouH2HcpTqSlviRMTkM4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloYB3sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiClQgAi4ATB6QsN3vx4i+3J0JTSos2
z8ZEnhWWZ9Av+14RhMVCLmd92RKa6v4C/bWAgWbh9s4LV0swoPzBL6L5diGIsbiB
IDY859L0bltLd5SIfcu5h7vIqaocZCJeoxNPUPzpV42wwv3Ax2OSZzdm0/aa8RZb
hzxAYpd7xhTgzkItZADcN/VkWWaocjxzYTI8Mn6ngOvJUgxZwdXmAAjgA5AltN6E
ebaNA8DaxDa1Tygw8artG0QQB0ZZfh2zIEFBaqBWzOwE6ybm4TclMUa/m/jKIb7z
ZGjXvCkq9BAZz9AKrpgCHk37jMwigfZvAIB2KvFy7yBWF8XWWRkkb1iArdYBCA==
=dVvb
-----END PGP SIGNATURE-----

--Jk5FPAlwtRmX3NouH2HcpTqSlviRMTkM4--
