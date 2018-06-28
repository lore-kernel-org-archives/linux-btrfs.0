Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:38635 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753210AbeF1Fj6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 01:39:58 -0400
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: remi@georgianit.com, linux-btrfs@vger.kernel.org
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
Date: Thu, 28 Jun 2018 13:39:50 +0800
MIME-Version: 1.0
In-Reply-To: <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wFx56KP55rtu2DkFj7RzS1mZYr294ls2u"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wFx56KP55rtu2DkFj7RzS1mZYr294ls2u
Content-Type: multipart/mixed; boundary="Uq8YtWGhJTAQJVFMR2A4cjJao3VZ0toG0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: remi@georgianit.com, linux-btrfs@vger.kernel.org
Message-ID: <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
In-Reply-To: <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>

--Uq8YtWGhJTAQJVFMR2A4cjJao3VZ0toG0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 11:14, remi@georgianit.com wrote:
>=20
>=20
> On Wed, Jun 27, 2018, at 10:55 PM, Qu Wenruo wrote:
>=20
>>
>> Please get yourself clear of what other raid1 is doing.
>=20
> A drive failure, where the drive is still there when the computer reboo=
ts, is a situation that *any* raid 1, (or for that matter, raid 5, raid 6=
, anything but raid 0) will recover from perfectly without raising a swea=
t. Some will rebuild the array automatically,

WOW, that's black magic, at least for RAID1.
The whole RAID1 has no idea of which copy is correct unlike btrfs who
has datasum.

Don't bother other things, just tell me how to determine which one is
correct?

The only possibility is that, the misbehaved device missed several super
block update so we have a chance to detect it's out-of-date.
But that's not always working.

If you're talking about missing generation check for btrfs, that's
valid, but it's far from a "major design flaw", as there are a lot of
cases where other RAID1 (mdraid or LVM mirrored) can also be affected
(the brain-split case).

> others will automatically kick out the misbehaving drive.  *none* of th=
em will take back the the drive with old data and start commingling that =
data with good copy.)\ This behaviour from BTRFS is completely abnormal..=
 and defeats even the most basic expectations of RAID.

RAID1 can only tolerate 1 missing device, it has nothing to do with
error detection.
And it's impossible to detect such case without extra help.

Your expectation is completely wrong.

>=20
> I'm not the one who has to clear his expectations here.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Uq8YtWGhJTAQJVFMR2A4cjJao3VZ0toG0--

--wFx56KP55rtu2DkFj7RzS1mZYr294ls2u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls0dKYACgkQwj2R86El
/qh87Af/SzhV4TR9lnjc4fvvUkwBzNHmyvUlNG74cCekRzgcTjeDa7k23KFnrBnu
YCTq6zv9NXaTYTGIkAPd+8AtX9VP47eH4IuVrBtSoOFPYnLBa8MK057HHBbCXPVJ
4hGH3wWk0i8s0VCy+Pwlh1IfHpU3VQwrmNfwrM+7UMj4dqkukVlIxuuI/fkCMBy9
bRARyyelXnJZENGAKJHrptGg7TFm+6zh7s2HJNgLuQ36Qz8gsUA3AOG6eZ+5Bqlw
dDouuKLPMd72aXPyH4Xa0PsrKV+u5/UhNOv8NkF8IYGTOfluJvV/NwsqzgtMKFl9
sWn6lOA/OKCn3buLkb5fQxlpnKO5pw==
=OTRH
-----END PGP SIGNATURE-----

--wFx56KP55rtu2DkFj7RzS1mZYr294ls2u--
