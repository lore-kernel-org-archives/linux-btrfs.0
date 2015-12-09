Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34224 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbLITEN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 14:04:13 -0500
Received: by igvg19 with SMTP id g19so130819803igv.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 11:04:13 -0800 (PST)
Subject: Re: subvols and parents - how?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1448340960.14125.51.camel@scientia.net>
 <pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
 <1448400350.21291.88.camel@scientia.net>
 <pan$22dc8$4457dc54$1cd0d037$c9fb9e32@cox.net>
 <1449635797.20578.0.camel@scientia.net>
 <pan$a4433$5d5ccde9$c53fc1f2$f519d361@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56687B26.7070300@gmail.com>
Date: Wed, 9 Dec 2015 14:04:06 -0500
MIME-Version: 1.0
In-Reply-To: <pan$a4433$5d5ccde9$c53fc1f2$f519d361@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050403030004050101080509"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050403030004050101080509
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-12-09 05:53, Duncan wrote:
> Christoph Anton Mitterer posted on Wed, 09 Dec 2015 05:36:37 +0100 as
> excerpted:
>=20
>> On Fri, 2015-11-27 at 01:02 +0000, Duncan wrote:
>> [snip snap]
>>> #2 The point I was trying to make, now, to mount it you'll mount not =
a
>>> native nested subvol, and not a directly available sibling
>>> 5/subvols/home, but you'll actually be reaching into an entirely
>>> different nesting structure to grab something down inside, mounting
>>> 5/subvols/root/home subvolume nesting down inside the direct
>>> 5/subvols/root sibling subvol.
>>
>> Okay so your main point was basically "keeping things administrable"..=
=2E
>=20
> =3D:^)
>=20
>>> one of which was that everything that the package manager installs
>>> should be on the same partition with the installed-package database, =
so
>>> if it has to be restored from backup, at least if it's all old, at
>>> least it's all equally old, and the package database actually matches=

>>> what's on the system because it's in the same backup!
>=20
>> I basically agree, though I'd allow few exceptions, like database-like=

>> data that is stored in /var/ sometimes and that doesn't need to be
>> consistent with anything but iself... e.g. static web pages
>> (/var/www)... postgresl DB, or sks keyserver DB... and so on.
>=20
> Of course.  But such data isn't usually managed by the package manager,=
=20
> so splitting off a partition or subvolume or whatever, is fair game.
>=20
> IOW, /var can and should still be on /, but /var/www and the like can b=
e=20
> on some other subvolume or filesystem.
>=20
Agreed.  It's not too bad fixing a Gentoo system (as long as
/var/lib/portage/world is still correct, you can just nuke the installed
package database and emerge world, it'll take time, but it will get your
system in a guaranteed consistent state).  On something using dpkg or
rpm though, it's got the potential to be almost impossible to recover
from without a significant amount of low-level knowledge of the package
manager's installation database.



--------------ms050403030004050101080509
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA5MTkwNDA3WjBPBgkq
hkiG9w0BCQQxQgRAec4pKG5WZYKSn+XUuyh7WJPAlPyvmtZZ52KBgFXdmFkg8XdvlXOv5ZQt
4tfdAlXr8soot1XMzG5BH7OgAuld2TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA4at8YuHPe/aDiAGOYrytaTmSw1fg+XS9+1f6XgrkwGNOFqAOy
jt3bg66DUqJv67cWJLNzu71JLxt9h2w/S4wnQxC616JSGNY3cbmy/k3wmyD7eHtJADL2YJlr
Ta/n27YdoZk+LbkeytTDLYH5Oek+KjtQi7o1lnbM18qvyziHECOaH+OJbXU2G6CuquQNgtU4
P+CYp69P9TnuLerHqBzqlzuJZIb1VwCB0FKqOnN7QMbpov0CmH6jeivh1qZQbAdfYFfDOAoL
fqgZQFQlHcP9QeKEP48rKatfFQu6t5SuTEeTE5hoAO91pCAulsNWLSsCkV7WGLQ9xw3p3CCM
ymMtoztVPsivT6a9lyzMSWT/KpSKAlzjNcmIcmiiYhR1u8ok0kTxHILH/Q1A8/xLnAx9wJde
e8ZwSnXJAT77VWLAwXWmoAqgrFSbZYtYgh+yDgj9pNt2XsZQyFCHYnuEFfnCuyW5eglw0Rhn
OYhe6JiRkitffrwXfkwLRM4MVo7kndvXHJjrN0TjtGhH/vRJ8IHYNAjmaoPOzhVQpwzTlhV6
qtC9m3iMGz//eC8HfkrjuUxlsoiOO+sBk06jZYxm0Xw29z1o4Wqnx2MGDHrjsdT2RfN9Oru7
Kat/wh0gIB/xxsYnfu2IIdpYTGl6QL65ECcueRGdxBer3wVoThkRnPdt/AAAAAAAAA==
--------------ms050403030004050101080509--
