Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56310 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbdKXIGv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 03:06:51 -0500
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
 <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
Date: Fri, 24 Nov 2017 16:06:45 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4lxk7I2L2QpexEdrfr7NITRHqGk4k0HqA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4lxk7I2L2QpexEdrfr7NITRHqGk4k0HqA
Content-Type: multipart/mixed; boundary="Q2jxBcqEpc58qNLrXCg7O2Ppr1dwC89pw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
 <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
In-Reply-To: <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>

--Q2jxBcqEpc58qNLrXCg7O2Ppr1dwC89pw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8824=E6=97=A5 15:47, Lakshmipathi.G wrote:
> Hi Qu,
>=20
> I'm using btrfs-progs devel branch. mount command is failing with misc/=
021.
> When I tried to manually mount it. dmesg shows  "unrecognized super
> flag: 17179869184"
> and interestingly "df -h" shows 16E as available!

That flag is meta dump flag, any image recovered from btrfs-image should
have that flag.

16E may also related to that, but not a big problem as btrfs-image
result should only be used by developers, and all its data is wiped out.
(Maybe one day we will not allow RW mount for such image)


The problem happens when you try to mount the image, there may be some
new commits doing more restrict check for rw mount in devel branch.

Would you please try v4.14 kernel?

Thanks,
Qu

>=20
> https://asciinema.org/a/4JGYg7YGQz1PHtdBRJ6AVw0fh
>=20
> Let me check further.
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>=20
>=20
> On Fri, Nov 24, 2017 at 9:55 AM, Lakshmipathi.G
> <lakshmipathi.g@gmail.com> wrote:
>> Hi Qu,
>>
>> I'm using the same instance. Let me check again with and without the
>> commits list on Nov-23
>> (https://github.com/kdave/btrfs-devel/commits/misc-next) and get back
>> with results.
>>
>> ----
>> Cheers,
>> Lakshmipathi.G
>> http://www.giis.co.in http://www.webminal.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Q2jxBcqEpc58qNLrXCg7O2Ppr1dwC89pw--

--4lxk7I2L2QpexEdrfr7NITRHqGk4k0HqA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloX0xUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi9sAf+MIieXWZHrmEcHj5+frQArK19
UavjQ8PIAoH8eZk1IkrbxT749DCdhHJDhkc7VsTo7U1EYZGFklkEU+IGu0LVZQqU
vB0hoyL9LsL3SVaQamUpz91/LFexHmqvt/D07xpnXmal2YFKX/wNpTuN2SoSczcM
ef6DltbG72rAO/GRW+cI3o/H0Mk4rvpZXmXeSxdql9956OUpTHMVrYEL9XpmXxcD
0W9JYpdxCcoS+CN2uRYNHnIWVPDa1XGyYx5lu0Wjb00cTM2kCVBGrUHwn/Nl8bMR
EDwHetsr9flFKpPa/Wj6uvXd4aC/HaPiUrnR22++Xm4IlBrGZjeJqiBqhj+2ow==
=nhrs
-----END PGP SIGNATURE-----

--4lxk7I2L2QpexEdrfr7NITRHqGk4k0HqA--
