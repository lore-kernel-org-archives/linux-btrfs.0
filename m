Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756239AbcIAVDo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 17:03:44 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <1472751548.3137.9.camel@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <416ba17a-24ad-9dd2-3513-31a8600850b0@suse.com>
Date: Thu, 1 Sep 2016 13:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <1472751548.3137.9.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Cnf1W7RUjfMQDE6e3l8fUCrM7JjcbbSuU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Cnf1W7RUjfMQDE6e3l8fUCrM7JjcbbSuU
Content-Type: multipart/mixed; boundary="2tgPqgfseF87scFPQPGGqfLhATn9i70ks";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <416ba17a-24ad-9dd2-3513-31a8600850b0@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
 <1472751548.3137.9.camel@gmail.com>
In-Reply-To: <1472751548.3137.9.camel@gmail.com>

--2tgPqgfseF87scFPQPGGqfLhATn9i70ks
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/1/16 1:39 PM, Ronan Arraes Jardim Chagas wrote:
> Hi Jeff,
>=20
> Em Qui, 2016-09-01 =C3=A0s 13:12 -0400, Jeff Mahoney escreveu:
>> It's not.  We use qgroups because that's the only way we can track
>> how
>> much space each subvolume is using, regardless of whether anyone
>> wants
>> to do enforcement.  When it's working properly, snapper can make use
>> of
>> that information to make informed decisions on how much space will
>> actually be released when removing old snapshots.
>>
>=20
> Given that, what am I loosing by disabling qgroups here? Will I still
> be able to recover my machine using snapshots (this saved my two or
> three times)?

Absolutely.  It doesn't affect the ability to take, retain, or recover
using snapshots.  It only affects the ability to see how much space a
particular snapshot is using on disk, both from the user wanting to know
and snapper using it to make retention decisions.  Snapper can handle
qgroups not being there.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--2tgPqgfseF87scFPQPGGqfLhATn9i70ks--

--Cnf1W7RUjfMQDE6e3l8fUCrM7JjcbbSuU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXyGjUAAoJEB57S2MheeWyIBkQALDsd9xwLv9z2fY64aMYEh/f
tsIaJyfwKPIHy1JWQo6T03yJ2NLMwZ9cXBwRG0AePdhKlT7x3r8Sf+cyaF/Bea+7
XQ/vRzPdpwGcUQPzyc+UtJiumyED5HCmTUsM7CBoDrziHlWzqOngy4QfB84eoqLg
NPGCj/32jcSCtSirnYZvU/lrcXMZNpkG65hwYFqwgDyQFi5PfrAH1cWN/6ryRsK0
rz5V+iMh6s9IhGph9Myvyi9eCCNXmJULBY156FS6UvmzluVRR0/ehR1keymOhypU
Yok9nZ5z+4qIa7CbB+MsvNe2qmTlBsmUkhoYwgd/RN1sv2kiInrThgjdDdRst++K
xaTFGnD1eIcOpcWZaexyl4n5c9/GIVlobNbbwmBHQXgrf0/5RH4ZTaaJh+dj4q7E
A5CyGofXFTRfD9dhcKbZDF3H+nghIINHL2H74FzkGZl3XBRklQwPolrFWOyGdoQL
Sod9bzPtXyWJ6ML4g/r+rDlP4e8kbBFnJgfFwNKH6w5ebsvceSyFN93TdMALWK97
ynT4M7g5zLm+1sWTauxCVeRfz+IZa5Tmh9ueYOpnFWQze//irvyUR/NtZE3JSHxd
jWHXVf16sSfe6yu31zvMytbaIQolG4h30DsBPaiBhF3pv/I9m/QOxtfblx0Nhf4f
CaOVdxdSw/IvM0yCnYfD
=4pdd
-----END PGP SIGNATURE-----

--Cnf1W7RUjfMQDE6e3l8fUCrM7JjcbbSuU--
