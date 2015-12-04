Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38485 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbLDNJf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 08:09:35 -0500
Received: by igbxm8 with SMTP id xm8so36148363igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 05:09:35 -0800 (PST)
Subject: Re: 3.16.0 Debian kernel hang
To: Russell Coker <russell@coker.com.au>, linux-btrfs@vger.kernel.org
References: <201512042100.58127.russell@coker.com.au>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5661906A.50309@gmail.com>
Date: Fri, 4 Dec 2015 08:08:58 -0500
MIME-Version: 1.0
In-Reply-To: <201512042100.58127.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020804070107020508020904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020804070107020508020904
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-04 05:00, Russell Coker wrote:
> One of my test laptops started hanging on mounting the root filesystem.=
  I
> think that it had experience an unexpected power outage prior to that w=
hich
> may have caused corruption.
>
> When I tried to mount the root filesystem the mount process would stick=
 in D
> state, there would be no disk IO, and the computer would get hot - pres=
umably
> due to kernel CPU use even though "top" didn't seem to indicate that.
>
> When I mounted the filesystem with a 4.2.0 kernel it said "The free spa=
ce cache
> file (1103101952) is invalid, skip it" and then things worked.  Now tha=
t the
> machine is running 4.2.0 everything is fine.
>
> I know that there are no plans to backport things to 3.16 and I don't t=
hink
> the Debian people are going to be very interested in this.  So this mes=
sage is
> a FYI for users, maybe consider not using the Debian/Jessie kernel for =
BTRFS
> systems.
>
I'd suggest extending that suggestion to:
If you're not using an Enterprise distro (RHEL, SLES, CentOS, OEL), then =

you should probably be building your own kernel, ideally using upstream=20
sources.

Ubuntu is notorious for picking 'stable' kernels that then fail to be=20
marked by kernel.org as LTS, Debian picks kernels that are multiple=20
versions old by the time they make a release, and I've heard similar=20
from other non-enterprise distros that don't inherently make you build=20
your own kernel.  Even among ones that you have to build the kernel=20
yourself anyway, there are issues (Gentoo for example doesn't often mark =

new kernels as stable, even when they are perfectly usable for pretty=20
much everyone).


--------------ms020804070107020508020904
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTMwODU4WjBPBgkq
hkiG9w0BCQQxQgRA0v5DJKbkCTIqitySrrLdwlPJAJVfbfJxm+eti7RqwS+Nd1XzuKvcBasv
WSHud+vV921w9SNtPK7Wsqs4GCV8NTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAvc1fSpI5sr10KkQYAyMyuxAX2ECDJXEFkTbEscSQL4X0dhyN+
rLJBzP1Zl2YRcY8o2EAk+j2/EGM/qgN/yYcdPAisY3B2DJ1L4KPqnKC58p1cTDNJvG+2malF
ERO5BAvBuJIZi1dO1BElhSUhCpp1SYbefM/0xKHi5UUSX7O0Q27iYEWBc5l5Rfmy8PVYQNw+
5sjoHUiXPFWpr8MEFhnKwJwC4+o9V9gNdoFrt9CETGLZmGmssayOF565httu1UD4+hfwiHNq
zmtHVOARB9FYMD68TQmGzkPmS9N4LxKZSb2imbgDvj6gb4/yjAifwej7GrVyoovHLTBANkwN
c9rzY9WYhuIVFQbdfxffaBjCqU+oOYT3vghIhJhyTaT38WEY8wzHfwTbald2YX8lIxOipC+G
lGdUWi21YY++hRmhe0Dgd3ghnAL2DfeK7YZ5VlfFIlvLvX9LjwHWvAdBDf2yVzlcpQDT8a7c
WV+C7qQSMHDIoI/K4/VhOnIgsykFByUnFIWUZITETNn2Ng4XolVXY2VyPWGowWDfX5lMHwlZ
6kQIrc2WO015pAojFFsAHb0u6UgejNADavbKau2rj2qS45UBAbNJdXuWzTA0b7FpwYFxokhG
zME7Dp8f5UP5P2CxlQoOB33NgY9STL9t32Q9qslwe65I7FisxuidYHTKLwAAAAAAAA==
--------------ms020804070107020508020904--
