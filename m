Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35873 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbbLDQN6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 11:13:58 -0500
Received: by iofh3 with SMTP id h3so120958972iof.3
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 08:13:58 -0800 (PST)
Subject: Re: 3.16.0 Debian kernel hang
To: Russell Coker <russell@coker.com.au>
References: <201512042100.58127.russell@coker.com.au>
 <201512050042.32497.russell@coker.com.au> <56619AC3.5000309@gmail.com>
 <201512050126.09510.russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5661BB9F.3010908@gmail.com>
Date: Fri, 4 Dec 2015 11:13:19 -0500
MIME-Version: 1.0
In-Reply-To: <201512050126.09510.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090704000709080600020603"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090704000709080600020603
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-04 09:26, Russell Coker wrote:
> On Sat, 5 Dec 2015 12:53:07 AM Austin S Hemmelgarn wrote:
>>> The only reason I'm not running Unstable kernels on my Debian systems=
 is
>>> because I run some Xen servers and upgrading Xen is problemmatic.  Li=
node
>>> is moving from Xen to KVM so I guess I should consider doing the
>>> same.  If I migrate my Xen servers to KVM I can use newer kernels wit=
h
>>> less risk.
>>
>> That's interesting, that must be something with how they do kernel
>> development in Debian, because I've never had any issues upgrading
>> either Xen or Linux on any of the systems I've run Xen on, and I
>> directly track mainline (with a small number of patches) for Linux, an=
d
>> stay relatively close to mainline with Xen (Gentoo doesn't have all th=
at
>> many patches on top of the regular release for Xen, aside from XSA
>> patches).
>
> I don't think that Debian does anything wrong in this regard.  It's jus=
t that
> my experience of Xen is that it is fragile at the best of times.  The f=
act
> that Red Hat packaged the Xen kernel in the Linux kernel package is a m=
ajor
> indication of Xen problems IMHO, the concept of Xen is that it shouldn'=
t be
> tied to a Linux kernel.
In the case of Red Hat, that's probably the way it's done because that's =

originally what was needed to make things work.  Early versions of Xen=20
very much did need a special version of Linux running as Domain 0.=20
Coupling things like that also simplifies testing for the developers at=20
Red hat, as they then only need to test one combination, instead of a=20
big matrix of features.  Less to test means they can test more=20
thoroughly, which means they can provide a better guarantee that things=20
will work without intervention right out of the box, which is important=20
for enterprise distros.

Xen is supposed to be decoupled from the version of the Domain 0 kernel, =

and in most of my experience with it, they do a pretty good job.  90% of =

the issues I've heard of personally have been with patched versions put=20
together by Linux distros, not with an upstream release.
>
> If you haven't had Xen issues then I think you have been lucky.
>
I have personally had issues using Debian as Domain 0 and keeping Xen up =

to date myself, but all of those issues vanished when I switched to=20
Gentoo for that purpose (well, they vanished when I switched to NetBSD,=20
but haven't resurfaced since I switched from that to Gentoo Linux after=20
about a week of pulling my hair out from fighting with BSD). I'm=20
admittedly not doing anything other than small purpose built PV domains=20
for service isolation in most cases (although I do use a dedicated PV=20
domain for testing kernel patches from time to time), but that really=20
shouldn't have any impact.


--------------ms090704000709080600020603
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTYxMzE5WjBPBgkq
hkiG9w0BCQQxQgRAwlu0THJZy/DSXcv5rFM/qQjzQxMXYW/JmhQe/T8OybdPFgindPptRORM
t4wiABerFzElpeBVUOfFnc9jYClmdjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBJiYyAkxyh52kggcHxvmYTpmMWRTFtUW97BkfHqONlv0HrbpLY
VDU6HOyi1H79hXeWASZ08mvj38TorFf4l2Vef2TZH9P3lhjfv2g+V/JY/ktn4wKJY75cuQhh
dAqGGf40FpBgrkuKdPN7PE0DDTJsFLWg5iBolTur5Gyk2LWX/WqPExKTs+Wf2MvtTACg4dkW
d8MxpqpqsPhoRvcZ42Hx0xrjJXVDXCCwYcIHGosxHg7MH2c/iyqE8jO9I5NANTvaIey8Prot
Ee7f8w+NQqimHlRXnfto1ZuJgez8OmQHdQlJAO8equ0l5CnniN6OaOji+OQ1BExtl7GdeXsc
GALOt27GF8T8FPP4TJL67pN+ThRpAVzAOTgP5cfQrjEZuQi8LXdtv1n7XSHi6tUnmS+7OLYD
xHK5kyCed1gnZpf2+jZjN5TiGVqC9QW58ZnwyQkm1LqXzHdvcSUZ3vnht2AC7aNQIaRF7lRL
cXla7Q5+ymlLpgGIn/ltQ14QjUL2k29PzYdTSOUB9AaPLKezP9uAT4jc4Mk3FdzVTO9nqFmq
dnjVqOrbMGz9LlQB5p/W3SgyKlkaadBbuR9VR5hudMyKY59rjNh28tZfES5p7TQvHQB0c09e
5D9M6i/GzQIra5zrHwnTdkHb3SW3kzCryAs+36p0JNPM9caIRt4+4XcG1gAAAAAAAA==
--------------ms090704000709080600020603--
