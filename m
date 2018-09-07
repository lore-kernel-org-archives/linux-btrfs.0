Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54981 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727654AbeIGPyO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:54:14 -0400
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>
Cc: linux-btrfs@vger.kernel.org
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
 <e3fa019e-32ff-252c-8307-b871ee40b71f@gmx.com>
 <adf0619f947779c7c9c13939f8229a4d@t-5.eu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1270fa3c-1bb6-25d7-faf5-b2bae322e99a@gmx.com>
Date: Fri, 7 Sep 2018 19:13:38 +0800
MIME-Version: 1.0
In-Reply-To: <adf0619f947779c7c9c13939f8229a4d@t-5.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n8ANT0srr681l1SLCZ9AVZbWOinqWpzA8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n8ANT0srr681l1SLCZ9AVZbWOinqWpzA8
Content-Type: multipart/mixed; boundary="LRRpd3LEWSvsl4uAFaiJiF5dfLw9e1YQc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <1270fa3c-1bb6-25d7-faf5-b2bae322e99a@gmx.com>
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
 <e3fa019e-32ff-252c-8307-b871ee40b71f@gmx.com>
 <adf0619f947779c7c9c13939f8229a4d@t-5.eu>
In-Reply-To: <adf0619f947779c7c9c13939f8229a4d@t-5.eu>

--LRRpd3LEWSvsl4uAFaiJiF5dfLw9e1YQc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/7 =E4=B8=8B=E5=8D=886:45, J=C3=BCrgen Herrmann wrote:
> Am 7.9.2018 12:15, schrieb Qu Wenruo:
>> On 2018/9/7 =E4=B8=8B=E5=8D=885:56, J=C3=BCrgen Herrmann wrote:
>>> Hello!
>>>
>>> I'm having a problem with btrfs send which stops after several second=
s.
>>> The process hangs with 100% cpu time on one cpu. The system is still
>>> responsive to input but no io is happening anymore so the system
>>> basically becomes unuseable.
>>
>> Do you have a lot of snapshots or reflinked files (common for offline
>> dedupe)?
>>
>> If so, send can spend a lot of time trying to iterate all referencers.=

>=20
> Linux Mint 19 uses timeshift-btrfs which i find very handy. here's
> a list of snapshot directories, each containing two subvolumes for
> @ and @home:
>=20
> drwxr-xr-x 1 root root 30 Aug 16 20:00 2018-08-16_20-00-01
> drwxr-xr-x 1 root root 30 Aug 17 14:00 2018-08-17_14-00-02
> drwxr-xr-x 1 root root 30 Aug 23 20:00 2018-08-23_20-00-01
> drwxr-xr-x 1 root root 30 Aug 30 20:00 2018-08-30_20-00-01
> drwxr-xr-x 1 root root 30 Aug 31 17:00 2018-08-31_17-00-01
> drwxr-xr-x 1 root root 30 Sep=C2=A0 1 20:00 2018-09-01_20-00-02
> drwxr-xr-x 1 root root 30 Sep=C2=A0 2 20:00 2018-09-02_20-00-02
> drwxr-xr-x 1 root root 30 Sep=C2=A0 3 22:00 2018-09-03_22-00-01
> drwxr-xr-x 1 root root 30 Sep=C2=A0 4 22:00 2018-09-04_22-00-02
> drwxr-xr-x 1 root root 30 Sep=C2=A0 5 22:00 2018-09-05_22-00-01
> drwxr-xr-x 1 root root 30 Sep=C2=A0 6 20:00 2018-09-06_20-00-01
> drwxr-xr-x 1 root root 30 Sep=C2=A0 6 22:00 2018-09-06_22-00-01

Considering the number of snapshots, it's not that many, so it may be
another bug.
Not sure about mint, but most deb/ubuntu based distributions don't ship
the latest kernel, while latest kernel may have a chance to solve it.

>=20
>>
>>>
>>> I'm on linux mint 19, freshly installed on a new laptop about 6 weeks=

>>> ago. So i wanted to compile latest btrfs-progs and latest stable kern=
el
>>> first before reporting that here, BUT: I cannot compile btrfs-progs
>>> 4.17.1
>>> because of the following error:
>>
>> Your configure detects reiserfs support but it seems that your reiserf=
s
>> progs is not up-to-date.
>>
>> You could disable reiserfs convert support by:
>>
>> $ ./configure --with-convert=3Dext2
>=20
> This gives me the following error:
>=20
> =C2=A0=C2=A0=C2=A0 [LD]=C2=A0=C2=A0=C2=A0=C2=A0 btrfs-convert
> convert/main.o: In function `convert_open_fs':
> /home/jh/Documents/src/_external/btrfs-progs/convert/main.c:1066:
> undefined reference to `reiserfs_convert_ops'
> /home/jh/Documents/src/_external/btrfs-progs/convert/main.c:1066:
> undefined reference to `reiserfs_convert_ops'
> collect2: error: ld returned 1 exit status
> Makefile:506: recipe for target 'btrfs-convert' failed
> make: *** [btrfs-convert] Error 1

This is strange, did you clean (make clean) your previous build before
re-configure?

If it still fails, you could disable convert completely by:

$ ./configure --disable-convert

Thanks,
Qu

>=20
> Best regards, J=C3=BCrgen
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> =C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=A0=C2=A0 convert/source-reiser=
fs.o
>>> In file included from convert/source-reiserfs.c:30:0:
>>> ./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No s=
uch
>>> file or directory
>>> =C2=A0#include <reiserfs/misc.h>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~~~~~~~~~~~~=
~~~
>>> compilation terminated.
>>> Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
>>> make: *** [convert/source-reiserfs.o] Error 1
>>>
>>> A google search did not turn up any help nor does apt know of any
>>> reiserfs related libs that i could install.
>>>
>>> Best regards,
>>> J=C3=BCrgen
>>>
>=20


--LRRpd3LEWSvsl4uAFaiJiF5dfLw9e1YQc--

--n8ANT0srr681l1SLCZ9AVZbWOinqWpzA8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluSXWIACgkQwj2R86El
/qifZggAipQjVTMjip4+D6vu873ur3K5cgxhgy2KyJTA2mfk7WWGblS2Jygy4U9y
xIDIET6V59dom483gHoCplJBgO6sxs7UtIt7bUoz2NTwDNyy91XSckmrlMKAdl7y
EpHUcgiUoysOGgw0Tp5UGNCgNKWTrzBvJaMnfkXqXPNsbzFEKf3lQOz9WA0lqChf
79Pm+LBXIMiHf+qWoL/ET7czDlvG8yz5dZ2YP6IL7pe1m+v42TjY6pxmLHQHrXyO
BKlhEKqX+hpCsiSCw4OI1wA6fgFn8JC08ZGqlRBkABRy3p50/GtQuFvPRYQ5vpmf
px+VaZRUXIgsibSdQrjanCGdubTQwQ==
=+woQ
-----END PGP SIGNATURE-----

--n8ANT0srr681l1SLCZ9AVZbWOinqWpzA8--
