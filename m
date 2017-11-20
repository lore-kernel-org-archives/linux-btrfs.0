Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39465 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752196AbdKTUBU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:01:20 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
 <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
Message-ID: <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
Date: Mon, 20 Nov 2017 15:01:17 -0500
MIME-Version: 1.0
In-Reply-To: <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Oqd3Um18aehoFBNBcx1kRmsLktMLjaS0H"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Oqd3Um18aehoFBNBcx1kRmsLktMLjaS0H
Content-Type: multipart/mixed; boundary="k8k1jpTPM3PnfiLqipl4t1iDFOFlrCPJr";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>,
 Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
 <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>
In-Reply-To: <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com>

--k8k1jpTPM3PnfiLqipl4t1iDFOFlrCPJr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/20/17 3:00 PM, Jeff Mahoney wrote:
> On 11/19/17 4:38 PM, Chris Murphy wrote:
>> On Sat, Nov 18, 2017 at 11:27 PM, Andrei Borzenkov <arvidjaar@gmail.co=
m> wrote:
>>> 19.11.2017 09:17, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>> fstrim should trim free space, but it only trims unallocated. This i=
s
>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>>>> behaved this way with 4.12 also.
>>>>
>>>
>>> Well, I was told it should also trim free space ...
>>>
>>> https://www.spinics.net/lists/linux-btrfs/msg61819.html
>>>
>>
>> It definitely isn't. If I do a partial balance, then fstrim, I get a
>> larger trimmed value, corresponding exactly to unallocated space.
>=20
>=20
> I've just tested with 4.14 and it definitely trims within block groups.=


Derp.  This should read 4.12.

> I've attached my test script and the log of the run.  I'll build and
> test a 4.14 kernel and see if I can reproduce there.  It may well be
> that we're just misreporting the bytes trimmed.
>=20
> -Jeff
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--k8k1jpTPM3PnfiLqipl4t1iDFOFlrCPJr--

--Oqd3Um18aehoFBNBcx1kRmsLktMLjaS0H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAloTNI0PHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyUeQP/RRBrpO9BrZXWv7f5y5YO83cOq9Tpefyubo3
zPxvtEWnuhI4d169D0AMUTm60ScS6wArdhJyTRz6LRZgC3P/qBSLPoJiNccFvyPm
IsNf6DVYpWUErijglZDK9W4zRJcSpKPC9NRo8a2wPBSVIZ80w4nAP0NGyk2uDobZ
FsBbrOyT39T9/b34/rQQYz7kitTqTS0j5bP2l3X7L5blbW5jvtBtJ0CWzhNBobpW
9XC9nPHQRjj2DHOVGAdIyoqOdxVo0UoPj1odpnYAC7I/sXs9jHHfA+76InSsdDPf
/u3VaUZzU8OYUP6X1xLkj1Lt7UXx4xKS8sxmUrbAFp4JFVugVoyjf3eOjTXZzLwH
qPu3NDpyzRC/86a6LcTWqR7r8+lBHtVvXpDyUkEBrBxiq2VWk2AbmDV8owcIdRrn
qNZavjzCD8si+oC+zUJJ3MCzCHhdfSBuOlTmymjyzymrs+TzMz7WsMvsHv8AX3uu
tEcaGKEKhsKcynS2MMPNz9Ae4QeZzkjlx4NpY1oB+CI0Yr0+QwAIkZ5RkPhOKAf8
wCFEqRo3y5rkk9V5YJpMb4wuSFPtpNR6sC8OY6ANfOMzgRkJ6t7kpL/6NHthlajg
sxFdtKBm3sU/eb0/blMZcTiQlFHuRROo3XlZCrCIF6P8dvuUaNxhpmo5fT7+00oq
Ub/L0qdY
=2mIa
-----END PGP SIGNATURE-----

--Oqd3Um18aehoFBNBcx1kRmsLktMLjaS0H--
