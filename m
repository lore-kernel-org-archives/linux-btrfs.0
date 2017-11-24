Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752645AbdKXI3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 03:29:41 -0500
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
Date: Fri, 24 Nov 2017 16:29:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CVRtHk3s6eDvGbnTtjDIPIexgGS9m09JG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CVRtHk3s6eDvGbnTtjDIPIexgGS9m09JG
Content-Type: multipart/mixed; boundary="tWdAkk9ljuKgm3R7tbJrLV4rasKpIk7gE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <19a5ec80-3860-20b8-cb12-fcb41b21dc00@gmx.com>
Subject: Re: misc/021-image-multi-devices fails on latest
 btrfs-devel/misc-next
References: <CAKuJGC9bi3V5acV6CJEH8GYrdOZ4dA52D-4a7WEGPiVQHTsuxw@mail.gmail.com>
 <CAKuJGC9PnKn0FdZZG9F_LTOc2tcS=a-mGTo8qmg5ubtHfBq8pg@mail.gmail.com>
 <54224bfa-153a-ad2d-0e84-41c43e752be2@gmx.com>
 <CAKuJGC-w2HuNXFeFhLN21BAPdtzG=8rWX4rFDU6WPkH1F5RSSQ@mail.gmail.com>
 <CAKuJGC-hOTkWwKQasocRociw=jOritrLgBaG7_dD==A-jadTpQ@mail.gmail.com>
 <55e496fe-6a73-b759-ed8c-4f415ddacd1d@gmx.com>
 <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>
In-Reply-To: <CAKuJGC-SRh=hrF6uo0vRuQd5=61CbPe-mSpuwMA1DcStihY=dg@mail.gmail.com>

--tWdAkk9ljuKgm3R7tbJrLV4rasKpIk7gE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8824=E6=97=A5 16:20, Lakshmipathi.G wrote:
> Okay thanks for the details on btrfs-image. I was about to try with
> previous version of
> btrfs-image.

No, it's not about btrfs-image itself, the flag is introduced long long
long way ago.

It's about kernel change which doesn't allow image with such flag to be
mounted AFAIK.

Thanks,
Qu

>=20
> I'll use v4.14 (https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14=
=2Etar.xz)
> and check
> again.
>=20
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>=20
>=20
> On Fri, Nov 24, 2017 at 1:36 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8824=E6=97=A5 15:47, Lakshmipathi.G wrote:
>>> Hi Qu,
>>>
>>> I'm using btrfs-progs devel branch. mount command is failing with mis=
c/021.
>>> When I tried to manually mount it. dmesg shows  "unrecognized super
>>> flag: 17179869184"
>>> and interestingly "df -h" shows 16E as available!
>>
>> That flag is meta dump flag, any image recovered from btrfs-image shou=
ld
>> have that flag.
>>
>> 16E may also related to that, but not a big problem as btrfs-image
>> result should only be used by developers, and all its data is wiped ou=
t.
>> (Maybe one day we will not allow RW mount for such image)
>>
>>
>> The problem happens when you try to mount the image, there may be some=

>> new commits doing more restrict check for rw mount in devel branch.
>>
>> Would you please try v4.14 kernel?
>>
>> Thanks,
>> Qu
>>
>>>
>>> https://asciinema.org/a/4JGYg7YGQz1PHtdBRJ6AVw0fh
>>>
>>> Let me check further.
>>> ----
>>> Cheers,
>>> Lakshmipathi.G
>>> http://www.giis.co.in http://www.webminal.org
>>>
>>>
>>> On Fri, Nov 24, 2017 at 9:55 AM, Lakshmipathi.G
>>> <lakshmipathi.g@gmail.com> wrote:
>>>> Hi Qu,
>>>>
>>>> I'm using the same instance. Let me check again with and without the=

>>>> commits list on Nov-23
>>>> (https://github.com/kdave/btrfs-devel/commits/misc-next) and get bac=
k
>>>> with results.
>>>>
>>>> ----
>>>> Cheers,
>>>> Lakshmipathi.G
>>>> http://www.giis.co.in http://www.webminal.org
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--tWdAkk9ljuKgm3R7tbJrLV4rasKpIk7gE--

--CVRtHk3s6eDvGbnTtjDIPIexgGS9m09JG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloX2G8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qitVQgAhxgWw+hfTmmRZFKzsykRYxRC
M4nOcsZjwH4PE77IDohjmGeFIggJNAiZFNg6/dBTayBgP7r1ONcM9RWbWSxhimRF
0Lv9cTXgn1+z5q3ZIEgEGsjkFoxhYs4tCVX7GcON6mgL9NhMxBLiJa8rrh15LWoS
x+x/821d0YQAq+BDEXDCEp3VUcFaXH/iqzH3h8obJQqM0MaxgWm9Jf8Z134HYwD6
pqY7r8q+0/sYcwFCDs0RsVu7zzcSpP9RK6522nBslyERZcaaK1KDqg65Il0gAbUb
mGaHt27D0wwtYGwbsgT9YK+DUE5NU/I8b+IHPWXxHZ3y/sbNSSz2+u222FP44Q==
=V305
-----END PGP SIGNATURE-----

--CVRtHk3s6eDvGbnTtjDIPIexgGS9m09JG--
