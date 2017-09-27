Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:56097 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753185AbdI0OGP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 10:06:15 -0400
Received: by mail-wr0-f180.google.com with SMTP id l39so16695870wrl.12
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 07:06:15 -0700 (PDT)
Subject: Re: Wrong device?
To: Lukas Pirl <mail@lukas-pirl.de>, linux-btrfs@oh3mqu.pp.hyper.fi
Cc: linux-btrfs@vger.kernel.org
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
 <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
 <20170925141951.GD25529@carfax.org.uk>
 <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>
 <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
 <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
 <b07d7c1e-5337-c098-7aeb-eb2ec989e93f@lukas-pirl.de>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <614e375e-b98a-da9c-c4eb-bd24eb97af11@gmail.com>
Date: Wed, 27 Sep 2017 17:06:08 +0300
MIME-Version: 1.0
In-Reply-To: <b07d7c1e-5337-c098-7aeb-eb2ec989e93f@lukas-pirl.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="M7rbLV8rfgtpsHAHtCArsCndIQCh0wWiR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--M7rbLV8rfgtpsHAHtCArsCndIQCh0wWiR
Content-Type: multipart/mixed; boundary="9HdfDXSlTrvfmh4HAuwfTi5oQ286R1s2u";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Lukas Pirl <mail@lukas-pirl.de>, linux-btrfs@oh3mqu.pp.hyper.fi
Cc: linux-btrfs@vger.kernel.org
Message-ID: <614e375e-b98a-da9c-c4eb-bd24eb97af11@gmail.com>
Subject: Re: Wrong device?
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
 <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
 <20170925141951.GD25529@carfax.org.uk>
 <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>
 <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
 <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
 <b07d7c1e-5337-c098-7aeb-eb2ec989e93f@lukas-pirl.de>
In-Reply-To: <b07d7c1e-5337-c098-7aeb-eb2ec989e93f@lukas-pirl.de>

--9HdfDXSlTrvfmh4HAuwfTi5oQ286R1s2u
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

26.09.2017 10:31, Lukas Pirl =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 09/25/2017 06:11 PM, linux-btrfs@oh3mqu.pp.hyper.fi wrote as excerpt=
ed:
>> After a long googling (about more complex situations) I suddenly
>> noticed "device sdb" WTF???=C2=A0 Filesystem is mounted from /dev/md3 =
(sdb
>> is part of that mdraid) so btrfs should not even know anything about
>> that /dev/sdb.
>=20
> I would be interested in explanations regarding this too. It happened
> to me as well, that I was confused by /dev/sd* device paths being
> printed by btrfs in the logs, even though it runs on /dev/md-*
> (/dev/mapper/*) devices exclusively.
>=20

Could be related:

https://forums.opensuse.org/showthread.php/526696-Upgrade-destroys-dmraid=
?p=3D2838207#post2838207



--9HdfDXSlTrvfmh4HAuwfTi5oQ286R1s2u--

--M7rbLV8rfgtpsHAHtCArsCndIQCh0wWiR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlnLsFAACgkQR6LMutpd94zZtwCdHuE4PiIgTSFnAbplGnn2LtMR
03kAn2fDcfQEH9XsnLPqpx/cxHYKdQeZ
=Ok7i
-----END PGP SIGNATURE-----

--M7rbLV8rfgtpsHAHtCArsCndIQCh0wWiR--
