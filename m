Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:32987 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbIYLVe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 07:21:34 -0400
Received: by igbkq10 with SMTP id kq10so9142600igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 04:21:33 -0700 (PDT)
Subject: Re: Latest kernel to use?
To: Sjoerd <sjoerd@sjomar.eu>, linux-btrfs@vger.kernel.org
References: <4362384.AA8xu4anSN@hoefnix>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56052E0D.3090702@gmail.com>
Date: Fri, 25 Sep 2015 07:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <4362384.AA8xu4anSN@hoefnix>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060701070007010003090503"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060701070007010003090503
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-24 17:07, Sjoerd wrote:
> Maybe a silly question for most of you, but the wiki states to always t=
ry to
> use the latest kernel with btrfs. Which one would be best:
> - 4.2.1 (currently latest stable and matches the btrfs-progs versioning=
) or
> - the 4.3.x (mainline)?
>
> Stable sounds more stable to me(hence the name ;) ), but the mainline k=
ernel
> seems to be in more active development?
>
Like Hugo said, 4.2.1 is what you want right now.  In general, go with=20
the highest version number that isn't a -rc version (4.3 isn't actually=20
released yet, IIRC they're up to 4.3-rc2 right now, and almost at -rc3)=20
(we should probably be specific like this on the wiki).

As far as mainline being under more 'active development', that is=20
correct, but to understand why, you have to understand the workflow in=20
Linux development.  In general, it goes like this:
1. People send in patches either fixing bugs or adding new features.
2. These get picked up (hopefully) by the individual subsystem=20
maintainers, who collect them in their local git repository.
3. When Linus opens the merge window (IOW, right after they release a=20
version with a new minor version number), the subsystem maintainers send =

pull requests for him to merge into mainline the patches they've picked u=
p.
4. After the merge window closes, the first -rc (release candidate) for=20
the next version gets released, and people start testing.
5. After about a week of testing, people send in bug-fixes (and only bug =

fixes) that then get pulled into the next -rc version.
6. After about 6 to 8 -rc releases, the official release comes out (and=20
the merge window for the next version opens).
While all that is happening, bug-fixes that end up in mainline (usually) =

get back-ported to older kernel versions.  Each time one of these=20
versions gets a batch of back-ported bug-fixes, the third number in the=20
version gets incremented.  So, to sum it up, mainline is where things=20
get developed, but the bug-fixes end up in the stable releases anyway.



--------------ms060701070007010003090503
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTI1MTEyMDQ1WjBPBgkq
hkiG9w0BCQQxQgRAHNxekjtee0Z4DyRlium43iA/gFmrKk2gEv8HwFx3M5fI9R7NXuHsYnal
qmLdrRuWGo1/f9Vgwug4+KixZKVnuzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAUcb9iBxuMzt/h6Tm908vkaPl8fnnsUnP8buqTO6w3Uq9dDwp2
2QeGc8KElVkyBczReVIXJtv3ArJGARY9eUPJX2Tc6zOwFmD6L2YcmjnvqILlPgk+l7qFRj7W
aztGQuJEC4L2d7nF3Ft+Fn62YHWrnGK6TCjOr8FJZNvKXfTbGI7ECQEP4qtPcg2RX/Fgafvb
+Trs0cPrzN2NpAOwfqlvpP4dAA11FbTpjq0k1SkPNbJ5x11i9sAXYKUD4kXgcYG24bZ8KIEQ
p93+hztgExEtmStT1Dy2rDQ2/qH+SUXYBFtuNS6Qqh9rG2MEzXJereGu2Y+Yr3LjqWuS14wF
uAJRnl8FkSkF69kuXHZa6s+YA6QpWGOEi3tdPF3YYRtzT3LTHK4HshYS5w+DpFpXY5I7GcIN
sJk8yvH167LSgpAL3cRJq7lJzQJe1AT1YBs828x+087mouc8QoUv48egweNi6j8ue2+iC63Y
xyigcpuopQJ8t5+pRICDIMrwJPh/uQVM9XL1LQaRJT5sQryE5e2Azk2L3lJAQYh3gRJO3M5d
ADis3O5iYlO/Hr6UYfV48Pwuv4VtnZxw9A5xifrqxF4J+CqOjkCxSr7mSW5bkwbkmThWDsvW
CD06BufpxSDGhBGhRJZjqAVwkCkccri7JFi5tiq0UVobhwZczvxitaHOsgAAAAAAAA==
--------------ms060701070007010003090503--
