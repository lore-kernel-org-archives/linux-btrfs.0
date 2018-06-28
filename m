Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55739 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966732AbeF1WAS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 18:00:18 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id D6A6721D1E
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 18:00:17 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10E3610269
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 18:00:17 -0400 (EDT)
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: linux-btrfs@vger.kernel.org
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
 <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
 <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
From: Remi Gauvin <remi@georgianit.com>
Message-ID: <6741f78c-0a25-ea52-9e37-0a8bb3c01140@georgianit.com>
Date: Thu, 28 Jun 2018 18:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R5BjNhJ8jypbSSQNfl14XbzI8fkQsh84t"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R5BjNhJ8jypbSSQNfl14XbzI8fkQsh84t
Content-Type: multipart/mixed; boundary="tgXDFlHKa4yfZ7vq5IKMW2mKhk6ytjPro";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <6741f78c-0a25-ea52-9e37-0a8bb3c01140@georgianit.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
 <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
 <fb26f3cc-fa80-222e-e403-0eead6f5e575@gmx.com>
 <CAA91j0VTewHifyxBisMgiOw0ufmSWM7m-Cm4=5d0DP4kppSK6w@mail.gmail.com>
 <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>
In-Reply-To: <3ac88a8e-f12e-5477-1e44-ea1037a1d5de@gmx.com>

--tgXDFlHKa4yfZ7vq5IKMW2mKhk6ytjPro
Content-Type: multipart/mixed;
 boundary="------------80ED944B3AFE99089E2F9507"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------80ED944B3AFE99089E2F9507
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> Acceptable, but not really apply to software based RAID1.
>=20

Which completely disregards the minor detail that all the software
Raid's I know of can handle exactly this kind of situation without
loosing or corrupting a single byte of data, (Errors on the remaining
hard drive notwithstanding.)

Exactly what methods they employ to do so I'm not an expert at,, but it
*does* work, contrary to your repeated assertions otherwise.

In any case, thank you the for the patch you wrote.  I will, however,
propose a different solution.

Given the reliance of BTRFS on csum, and the lack of any
resynchronization, (no matter how the drives got out of sync, doesn't
matter.).  I think NoDataCow should just be ignored in the case of RAID,
just like the data blocks would get copied if there was a snapshot.

In the current implementation of RAID on btrfs, RAID and nodatacow are
effectively mutually exclusive.  Consider the kinds of use cases
nodatacow is usually recommended for,  VM images and databases.   Even
though those files should have their own mechanisms for dealing with
incomplete writes, and data verification, BTRFS RAID creates a unique
situation where parts of the file can be inconsistent, with different
data being read depending on which device is doing the reading.

Regardless of which method, short term and long term, developers choose
to address this, this next part I have stress I consider very important.

The status page really needs to be updated to reflect this gotchya.  It
*will* bite people in ways they do not expect, and disastrously.


--------------80ED944B3AFE99089E2F9507
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------80ED944B3AFE99089E2F9507--

--tgXDFlHKa4yfZ7vq5IKMW2mKhk6ytjPro--

--R5BjNhJ8jypbSSQNfl14XbzI8fkQsh84t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJbNVpwAAoJEO9Tn/JHRWptXUAIAIwGDNRZXGKMbdmC8mx/8EPY
PpMjyVdAIEgq3++86c7pBnPfRQ6oiJDVnjkQtdL9Nt3fIoMW8ifbzJnd90G0SeEq
x0CH3tU8jX+urUyIWkXvr3KWazCUDYYuoI/WDY/EjRvJpgJQcYS9gTPMnroRcb+o
eaajbNR5Vw3f+bf3FuMqfuEwwUaQywo+ik/mO07QX/lDZ5yb5eYLPBg4CLqg1I7b
jijGhfdmQmtRVm7Lw8JT/qjbcvUWs7uMTwt0DrfLxur+WlvlNKNQIe7LcXEhp35u
hvfb1i9d2oSmNDDpbxGmjhqdL6xZ48o0CuWeXrk+cBa1zKL47JFWQ0ceauO9/PM=
=uIiT
-----END PGP SIGNATURE-----

--R5BjNhJ8jypbSSQNfl14XbzI8fkQsh84t--
