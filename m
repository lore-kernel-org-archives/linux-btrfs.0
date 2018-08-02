Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44697 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732150AbeHBOXL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 10:23:11 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 94A3E20DE3
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Aug 2018 08:32:12 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2360510278
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Aug 2018 08:32:12 -0400 (EDT)
From: Remi Gauvin <remi@georgianit.com>
Subject: BTRFS and databases
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <8b5d3277-1afc-9b10-2960-f9fd4396e2e1@georgianit.com>
 <46d12c3f-9756-99be-a99c-75af5acc3296@gmx.com>
Message-ID: <72a43ca7-bba5-2ecd-c33e-412a1b258e6f@georgianit.com>
Date: Thu, 2 Aug 2018 08:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <46d12c3f-9756-99be-a99c-75af5acc3296@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="79j5APsGjY2JaeGljKM5SwmWaOCNK56ia"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--79j5APsGjY2JaeGljKM5SwmWaOCNK56ia
Content-Type: multipart/mixed; boundary="4Q1Zbzh1zUsfUonIX9CI7ziVwudOAEUal";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <72a43ca7-bba5-2ecd-c33e-412a1b258e6f@georgianit.com>
Subject: BTRFS and databases
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <8b5d3277-1afc-9b10-2960-f9fd4396e2e1@georgianit.com>
 <46d12c3f-9756-99be-a99c-75af5acc3296@gmx.com>
In-Reply-To: <46d12c3f-9756-99be-a99c-75af5acc3296@gmx.com>

--4Q1Zbzh1zUsfUonIX9CI7ziVwudOAEUal
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-08-02 03:07 AM, Qu Wenruo wrote:


> For data, since we have cow (along with csum), it should be no problem
> to recover.
>=20
> And since datacow is used, transaction on each device should be atomic,=

> thus we should be able to handle one-time device out-of-sync case.
> (For multiple out-of-sync events, we don't have any good way though).
>=20
> Or did I miss something from previous discussion?

As far as I know, that is indeed correct and works very well.  The
question was specifically about using nodatacow for databases,, and
that's the question I was responding too.  In the current state, I do no
believe btrfs nodatacow is in any way appropriate for databases/vm
hosting when combined with multi-device.



--4Q1Zbzh1zUsfUonIX9CI7ziVwudOAEUal--

--79j5APsGjY2JaeGljKM5SwmWaOCNK56ia
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJbYvnLAAoJEO9Tn/JHRWptP18H/iSYUUpa0lwCi7cBFP9E7zCt
h8hTPV5zQC30HotLe2x5s6kalWf0LCDpPHOxjRTNqgUIxjVxzR9rPzB56WMTkRXL
K8so1og5YX4CnkHkLfr6JFXjEm8Y8D79Pp+1QGW1kD2IwXn+NH8iN2T6AOAw/CJz
5JNl0dSHJW2SGAxrI7x8jYI+ARGmoKYngFXhyH3gVFcuf1hPoum8SYWXzmV/ufCv
f5cSd2Gg04L54Y6nd4aPFzJJaKktzjP1mn4vkujFRt5NbuivVi6V2WdUiPoq3vee
Yn0lBpL6ipRG45wRa3Iprh1lH5t/f/yfqnF/1CCRoVWN7vYAoByC9M04fxL1bd4=
=/HEP
-----END PGP SIGNATURE-----

--79j5APsGjY2JaeGljKM5SwmWaOCNK56ia--
