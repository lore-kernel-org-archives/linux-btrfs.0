Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61767 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbeAPKWh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 05:22:37 -0500
Subject: Re: invalid files names, btrfs check can't repair it
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
Date: Tue, 16 Jan 2018 18:22:14 +0800
MIME-Version: 1.0
In-Reply-To: <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NYaWJDWbql4cGMjPYvTCM6ebTdkyKaxYo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NYaWJDWbql4cGMjPYvTCM6ebTdkyKaxYo
Content-Type: multipart/mixed; boundary="1DUnq49TDYz9vNwX4On1DM9fw6SbAWcs2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Message-ID: <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
In-Reply-To: <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>

--1DUnq49TDYz9vNwX4On1DM9fw6SbAWcs2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8816=E6=97=A5 18:10, Sebastian Andrzej Siewior w=
rote:
> On 2018-01-16 13:19:50 [+0800], Qu Wenruo wrote:
>> Usage:
>> ./btrfs-corrupt-block -X <device>
> # ./btrfs-corrupt-block -X /dev/sdb4
> Fix is done successfully
>=20
> may I mount it now or should I run btrfs check or something first?

Btrfs check is always recommended before really mount it.

However as long as there is no other problem, btrfs check should not
report anything wrong.

Thanks,
Qu
>=20
>> Thanks,
>> Qu
>=20
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--1DUnq49TDYz9vNwX4On1DM9fw6SbAWcs2--

--NYaWJDWbql4cGMjPYvTCM6ebTdkyKaxYo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpd0lYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi4+AgArwWck3GSWwI0WYhh5k0yHp4Q
Vw8GKrtxZDMjbInXcLPyJu0l3VjeNQSRBH0IavAk7NFuS6L//cwDiHPNshNzhZW+
QzmzeYLaCXg7MAoKmyJe6DNBXo2Sr4w7/zqn8yggMCsO/yG1edAfYx/6VeaiqOgy
z6+69BBaTy8GlYp5drNl3/6VUREfkv8pgV1Gefg5PgOy+PFdFH0lMo7+t/38GjdU
15Y5jTgKf4fCD/5Etkq2YbbhuI50Y806R3BzAR5BIpqRlC9s6fZnk4Gt0QFuwNYk
ceg8AqlelTTdYv2z3smrGFzGegfnik1fI6LHgFHeYIy3ALFe3eW+Frb4KvYaiQ==
=vRdv
-----END PGP SIGNATURE-----

--NYaWJDWbql4cGMjPYvTCM6ebTdkyKaxYo--
