Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33866 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbLDNxp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 08:53:45 -0500
Received: by igvg19 with SMTP id g19so36120020igv.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 05:53:44 -0800 (PST)
Subject: Re: 3.16.0 Debian kernel hang
To: Russell Coker <russell@coker.com.au>
References: <201512042100.58127.russell@coker.com.au>
 <5661906A.50309@gmail.com> <201512050042.32497.russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56619AC3.5000309@gmail.com>
Date: Fri, 4 Dec 2015 08:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <201512050042.32497.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050709090804010800010307"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050709090804010800010307
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-04 08:42, Russell Coker wrote:
> On Sat, 5 Dec 2015 12:08:58 AM Austin S Hemmelgarn wrote:
>>> I know that there are no plans to backport things to 3.16 and I don't=

>>> think the Debian people are going to be very interested in this.  So
>>> this message is a FYI for users, maybe consider not using the
>>> Debian/Jessie kernel for BTRFS systems.
>>
>> I'd suggest extending that suggestion to:
>> If you're not using an Enterprise distro (RHEL, SLES, CentOS, OEL), th=
en
>> you should probably be building your own kernel, ideally using upstrea=
m
>> sources.
>
> There are lots of ways of dealing with this.
>
> Debian development doesn't stop.  Anyone who is running a Jessie system=
 can
> easily run a kernel from Testing or Unstable (which really isn't partic=
ularly
> unstable).  It's generally expected that Debian user-space will work wi=
th a
> kernel from +- one release of Debian.  Also every time I've tried it De=
bian
> has worked well with a CentOS kernel of a similar version.
Well yes, that does usually work, but that doesn't mean that it keeps up =

with mainline very well.  Back when I used Debian on a regular basis, I=20
ran the 'unstable' kernels, and they still lagged behind mainline by at=20
least a minor version, and often more than that.  And there have been=20
cases where things got horribly broken in mainline due to lack of proper =

vetting of code (Most recent example being the insanity with the=20
clustered MD code, which broke non-clustered soft raid for at least two=20
major releases), which prevents them from safely keeping up-to-date with =

mainline.
>
> The only reason I'm not running Unstable kernels on my Debian systems i=
s
> because I run some Xen servers and upgrading Xen is problemmatic.  Lino=
de is
> moving from Xen to KVM so I guess I should consider doing the same.  If=
 I
> migrate my Xen servers to KVM I can use newer kernels with less risk.
That's interesting, that must be something with how they do kernel=20
development in Debian, because I've never had any issues upgrading=20
either Xen or Linux on any of the systems I've run Xen on, and I=20
directly track mainline (with a small number of patches) for Linux, and=20
stay relatively close to mainline with Xen (Gentoo doesn't have all that =

many patches on top of the regular release for Xen, aside from XSA patche=
s).



--------------ms050709090804010800010307
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTM1MzA3WjBPBgkq
hkiG9w0BCQQxQgRAIs0ULz9fc9Ia3VvUIDv4e69kcOQLtqAwmZCO2KIZSUjScEdIuVph+LXN
cO9K1ge4UmxzOhJ0xq7Lr9rqemIjszBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAhZNH/56YjX+yQEYOYe/vw7aIWEJGedXrrV5Pm199ZGKIWtFlp
+GYlOS7sNx6i8dtrBwzVR8bVFidawxVwIJIJJ7rttiy5hAlr2kZJnYUXV3ZgGShd6yAaGpAU
HzZWcasmqdq7ygtzh3abHDJp6ybYunX/V4fv9gKGygZYfeAAp1FtksykaogAEfy6+9yUZ5eV
zEDoy2eEcBmAmKGjPhjxbXoe5d46oEU/XqChvsJXH3oxcAXEQQkohazG7ltAGBaLuito1ntp
bf6lyexYxN+vsk7RX2XRrUdX33uOqYHN/SeykQel+oh0yBIruMD+u96qRkjxougz79rewF3A
DtwAFR7/aRHorBMMx8WnYCNqHxMBS7jYYlEZ/V+257I545TRkN3LA1cNkCSkhmeN87x0Qyto
AOVmnzZOMeaqS4u6zF92/WO5UQAUX53t8EpYvVLyMwa3ecOsX8XTdKsKS0VaSkWUufh7oueK
D8wteBsqLvvznCWy6l1GEwcB6VEqRPSvExJRaEvKY4qemU7bVwpsSGiLJagQOm+Trn4aFjcp
0R+CuMHPZhCo/cpf265JVUjp46O/VO7KHBDAQSeVnl/+8fh7YtHZ67kap6ZVP4ke8jrc/QoO
j0rJCNVANRArnd4qZDQGm3X7nZPkHfxGX9jjzHtsxBzdridWnidugCg2EwAAAAAAAA==
--------------ms050709090804010800010307--
