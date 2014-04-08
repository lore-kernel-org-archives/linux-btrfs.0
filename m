Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from theos.kyriasis.com ([185.24.223.82]:43047 "EHLO
	theos.kyriasis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaDHQNJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 12:13:09 -0400
Received: from theos.kyriasis.com (localhost [127.0.0.1]);
	by theos.kyriasis.com (OpenSMTPD) with ESMTP id b97ee754;
	for <linux-btrfs@vger.kernel.org>;
	Tue, 8 Apr 2014 16:06:25 +0000 (UTC)
Received: from localhost (213.141.70.53 [213.141.70.53]);
	by theos.kyriasis.com (OpenSMTPD) with ESMTPSA id c022ff5e;
	TLS version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO;
	for <linux-btrfs@vger.kernel.org>;
	Tue, 8 Apr 2014 16:06:25 +0000 (UTC)
Date: Tue, 8 Apr 2014 18:06:26 +0200
From: Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>
To: linux-btrfs@vger.kernel.org
Subject: Bug when trying to clone with cp --reflink=always
Message-ID: <20140408160626.GA23154@leeloo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I have a bunch of files that can't be cloned with `cp --reflink=3Dalways`=
=20
for no apparent reason. However, if I copy the file before doign the=20
clone it works.

Staces of a --reflink copy of the original file[1] and of the copied=20
file[2]:
[1]: http://sprunge.us/UXOO
[2]: http://sprunge.us/TUVa

lsattr says that no interesting attribute is set on any of the files and=20
I'm not sure what else to check.

--=20
Sincerely,
  Johannes L=C3=B6thberg
  PGP Key ID: 3A9D0BB5

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQRQBAABCgA6BQJTRB6CMxSAAAAAABUAFXBrYS1hZGRyZXNzQGdudXBnLm9yZ2pv
aGFubmVzQGt5cmlhc2lzLmNvbQAKCRBQ+5snOp0LtQgYH/94zu9qOwCXF2iytqDd
epB9NTwI5r0C+j612DY7jT9/aZ37o48DIcqbWye+0kW6nvoZiLY8htRODalc/3Aj
YlqKqBYyK3aSpk7m0RcSrwAviE5E8jaXMOar0WWLYkGKlryYQZigURYnHo79zsXJ
FwRV+tJjRK+qVSxRpIgD3gDSdNWPQAsP8h9uQk6xUFNwG0QGe4YxMRbSJaE1+oo1
OEmto2fXrp5fsbEF2bcXEroXq4H8jLqVyqcmxmGejHuzwMASdU5voXQH9rblXByN
Qwg3I2k3i26esE9faf8qvwc33gzu7YVtXoO2y5y1B5R1nuyxmfCYCN3Ksje3bwkO
YqoMT3oswHw6JlHrSlgsmPySq68JbVzEvfK/O/ZBqZ53tcMicuRyaH0epOQXdS2M
oDNrlaWQk80khbi9phvvmwMtXLYA/GGd3YItkmoEmCYLCZNk815u+acG13sx90Yf
DQJgokmB59Pj+UknMAvWoIPiEBN4dJSZN98VhNBED1H9c/jnCfJ1N3hMwxXj7+gk
AccTX4Yzb6jRhYEOqzO1rzcGeV+mH4c9hcAzegVOrcYECW6sspNtjNC/9XlTQRN7
QiY3UyUTJ728A+6WiQvl/BwZZb2NZ32tM3I07La8QBKkBnajPA+3OlzdSbJ/P1sR
XKCuRQaqmvtfU7lFRRceDuifPFH59rsC4+I7nBHFySuU81adsJmn5juT4ISa0I3Q
PzOslYUbct7Bjbd/KUxFPpYMoVwLb1bzQz9nSYEz+fCANS8o97n7iLwRthn0XmXK
ct2VehxbODpohS+onNmRBO2LHUE/UUsHQelMw3QOH8Qh8yvwO7O4zHSQEdQt0JsB
Jw/b8YJlACvRX8x20iG512ZYHotpoPFJQcIyoOfzvDWK1tdTnXFI3JTJ6I2hrO0w
KJZegB2jycE1OtNM+c91SROkgQSQQ63oqNPuIcg3Bh/gXQn+vyc/ly2rIO/dX3IJ
G9bJ8qNlJ5uxGHDHdfLg5D9gwKcXScop/G2H7bubYJ07SPjy+fms3Ico8Q2h8Iu4
2LOk/HriexlbFCqqbzmC5PZaTwAE6lr7z2Zh/bqD5PElyWyrruhiNqvR/zrjuSKe
Ul/JxFYxHwgfTZQoGggDMH/McV2agKQivuQE70E9RimquP08Kt82dJeAExrKWZGx
UhOiOOOZBeAvN18fFSLY+YyUUZBV8HMkIYwQ+atIqjPZA/nVezbAgsooBV3S1RX8
vSBvvWAzakx/dMoUNCqyQ7PNpqlz2B4g1nd0ADd95qDsOWcjuN62lGcvp4aFlF11
GP1Y8ny3zpIlcIsrCV3tZI99LS9CXvr2nXcK2Gg9ntME+1nr/oflOe1wR610bjcb
eDa1
=VRpW
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
