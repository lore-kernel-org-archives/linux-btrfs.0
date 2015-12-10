Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33790 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbbLJMb4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 07:31:56 -0500
Received: by mail-ig0-f172.google.com with SMTP id mv3so16507796igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 04:31:55 -0800 (PST)
Subject: Re: subvols and parents - how?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1448340960.14125.51.camel@scientia.net>
 <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
 <1448400350.21291.88.camel@scientia.net>
 <pan$22dc8$4457dc54$1cd0d037$c9fb9e32@cox.net>
 <1449635797.20578.0.camel@scientia.net>
 <pan$a4433$5d5ccde9$c53fc1f2$f519d361@cox.net> <56687B26.7070300@gmail.com>
 <pan$f0e4$be60fa55$99baefcb$2044c99d@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <566970B8.7030700@gmail.com>
Date: Thu, 10 Dec 2015 07:31:52 -0500
MIME-Version: 1.0
In-Reply-To: <pan$f0e4$be60fa55$99baefcb$2044c99d@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020005070303060102080102"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020005070303060102080102
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-12-09 22:56, Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 09 Dec 2015 14:04:06 -0500 as
> excerpted:
>=20
>> Agreed.  It's not too bad fixing a Gentoo system (as long as
>> /var/lib/portage/world is still correct, you can just nuke the install=
ed
>> package database and emerge world, it'll take time, but it will get yo=
ur
>> system in a guaranteed consistent state).
>=20
> For sufficiently loose values of "consistent", yes, as I found out by=20
> experience.  But it can be done, and I do have the experience to prove =
it.
>=20
> What happens in practice is that while yes, as long as @world is correc=
t=20
> you can install to current and have all those files tracked again as=20
> appropriate, if your package installation database is missing or out of=
=20
> sync with what's actually on your filesystem(s), where the new version =
of=20
> various packages will replace older files as they come across them duri=
ng=20
> the install process (subject to CONFIG_PROTECT of course, this part isn=
't=20
> the problem), the problem is actually where the files of the actually=20
> installed but untracked version differ from those of the version you're=
=20
> installing.
Oh, definately, it's a useable system short term, but not something you
should be depending on.  The other big difference though is that it's
then trivial to bootstrap a clean install on the same system if you have
the space for it (which is what I usually end up doing).


--------------ms020005070303060102080102
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjEwMTIzMTUyWjBPBgkq
hkiG9w0BCQQxQgRAg2qKUkSaVW2r/wtHS+JP2XPmjDhqj6ZVBZD/4KNApvVh8k3lGnFUfkji
jOyJwp9oIaWWObwTgyMsspknv7nylzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBUrvBJTNlGIeOn8OR6iQBIQr+wDcIRoaBJzhuCHP6yBmAzinFC
yqWpaqS4ytHG6OBPmIzlpSfHKE0AZzcTqssfvSB1LHxirah2+SKY6K58Mcl8m//Pm+7C0RNR
P+GsczcLYfhjp9F3CiIbyAeDg09fkDAovgJNStuGmMgHp6FecuGg9uK6+Np09GxdDbeK97/e
Q3cEihy5WTmIQ3DCQ0Svh9BnNAoGFLmpLheN5/9j8gQbnBw3N0R7xUsqfmb+6Wd90hEXSp37
ljecpy+dmhAYIQTb15yYAiGPjriLEz0nFWkpD4UdWDSXEjYH+g+ixRf+jzkGthquKXWaOJbS
hEZpp0fPX61U97V9iu4O08/zqkxw2+TMEHOnLS2uue9W9mKxZ3hy/UqfVBQzVQwSAg3kduTC
lg47yPkNP36AdgPjGA3It34a1GL4Aygbft2eXg0dfCDNFin9+znY5fXNxh9gb6BCCst77Ot/
nfzFjuZfautHXhnoZJ8MjQ0+AFp801MVeD1+twxPZEzQbb9EODcpsKf+4y94OF4tPzy8rox1
jG/4srNLc2ocWHNiWTTxbQ7ngUush7bWNbYXyWVR9fWjrqyuUCFWR5DVSGKSAw67a2RpAE1O
5PQEUbYUjFAjFEjjqVPy7SA+yVxgGSqHPf9Vku7ZpVH2jfFKBQTTnsuYNwAAAAAAAA==
--------------ms020005070303060102080102--
