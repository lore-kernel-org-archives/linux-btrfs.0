Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:47037 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbeHBMrH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 08:47:07 -0400
Subject: Re: BTRFS and databases
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <1276acbf-a834-cd7e-1f06-56e13386a240@gmx.com>
 <940C43FD-9710-4DAC-937E-6BE290A7A6F6@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4f670d3d-5586-5a34-d043-3015e180cb52@gmx.com>
Date: Thu, 2 Aug 2018 18:56:25 +0800
MIME-Version: 1.0
In-Reply-To: <940C43FD-9710-4DAC-937E-6BE290A7A6F6@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LkvphDxG8FQwLKO5Vk4izjkX0wzgPcLfz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LkvphDxG8FQwLKO5Vk4izjkX0wzgPcLfz
Content-Type: multipart/mixed; boundary="0EQTmbLlzlR8zPIJjlTUdIDbtnHDzVzwO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: MegaBrutal <megabrutal@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <4f670d3d-5586-5a34-d043-3015e180cb52@gmx.com>
Subject: Re: BTRFS and databases
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <1276acbf-a834-cd7e-1f06-56e13386a240@gmx.com>
 <940C43FD-9710-4DAC-937E-6BE290A7A6F6@gmail.com>
In-Reply-To: <940C43FD-9710-4DAC-937E-6BE290A7A6F6@gmail.com>

--0EQTmbLlzlR8zPIJjlTUdIDbtnHDzVzwO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8802=E6=97=A5 18:45, Andrei Borzenkov wrote:
>=20
>=20
> =D0=9E=D1=82=D0=BF=D1=80=D0=B0=D0=B2=D0=BB=D0=B5=D0=BD=D0=BE =D1=81 iPh=
one
>=20
>> 2 =D0=B0=D0=B2=D0=B3. 2018 =D0=B3., =D0=B2 10:02, Qu Wenruo <quwenruo.=
btrfs@gmx.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>>
>>
>>
>>> On 2018=E5=B9=B408=E6=9C=8801=E6=97=A5 11:45, MegaBrutal wrote:
>>> Hi all,
>>>
>>> I know it's a decade-old question, but I'd like to hear your thoughts=

>>> of today. By now, I became a heavy BTRFS user. Almost everywhere I us=
e
>>> BTRFS, except in situations when it is obvious there is no benefit
>>> (e.g. /var/log, /boot). At home, all my desktop, laptop and server
>>> computers are mainly running on BTRFS with only a few file systems on=

>>> ext4. I even installed BTRFS in corporate productive systems (in thos=
e
>>> cases, the systems were mainly on ext4; but there were some specific
>>> file systems those exploited BTRFS features).
>>>
>>> But there is still one question that I can't get over: if you store a=

>>> database (e.g. MySQL), would you prefer having a BTRFS volume mounted=

>>> with nodatacow, or would you just simply use ext4?
>>>
>>> I know that with nodatacow, I take away most of the benefits of BTRFS=

>>> (those are actually hurting database performance =E2=80=93 the exact =
CoW
>>> nature that is elsewhere a blessing, with databases it's a drawback).=

>>> But are there any advantages of still sticking to BTRFS for a databas=
e
>>> albeit CoW is disabled, or should I just return to the old and
>>> reliable ext4 for those applications?
>>
>> Since I'm not a expert in database, so I can totally be wrong, but wha=
t
>> about completely disabling database write-ahead-log (WAL), and let
>> btrfs' data CoW to handle data consistency completely?
>>
>=20
> This would make content of database after crash completely unpredictabl=
e, thus making it impossible to reliably roll back transaction.

Btrfs itself (with datacow) can ensure the fs is updated completely.

That's to say, even a crash happens, the content of the fs will be the
same state as previous btrfs transaction (btrfs sync).

Thus there is no need to rollback database transaction though.
(Unless database transaction is not sync to btrfs transaction)

Thanks,
Qu

>=20
>=20
>> If there is some concern about the commit interval, it could be tuned =
by
>> commit=3D mount option.
>>
>> It may either lead to super unexpected fast behavior, or some unknown
>> disaster. (And for latter, we at least could get some interesting
>> feedback and bugs to fix)
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>> Kind regards,
>>> MegaBrutal
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>


--0EQTmbLlzlR8zPIJjlTUdIDbtnHDzVzwO--

--LkvphDxG8FQwLKO5Vk4izjkX0wzgPcLfz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlti41kACgkQwj2R86El
/qhSEQf/QUxaoCMT0ZW03vxvY68p2nJIS1PGd9IHn4AfJ4IhttHHA4Z0MHZXB7ux
OH4H/t+2HTsVu546Ydq8rx+oFL3syUBNw8zXS6fcJIYwFnV+CGeNHH8hH9+q30CM
wtS93MRPX0EZnilOkmxxpJIWZGymqi1odbBxI233rtSzrnfTNUMsDbhNDDwdn+m1
Vq5oMJ1WEvOaRZERVUCcpFUOYHEiwWB/CrAurZtEHcThfwSuczA9XhkAiEFxZ24t
zcmm7fsDgMEuqdVuHg28GlvGuBiTOK0AUf9pOtRfzC8lf1PYjWHK0VgOmaYKBKPJ
aeCKsfMpGWDyg6WX55ZLqb4MRcv0Qw==
=pw23
-----END PGP SIGNATURE-----

--LkvphDxG8FQwLKO5Vk4izjkX0wzgPcLfz--
