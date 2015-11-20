Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35109 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810AbbKTNOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 08:14:12 -0500
Received: by ioc74 with SMTP id 74so122544262ioc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 05:14:12 -0800 (PST)
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com> <564DC072.4060508@gmail.com>
 <pan$7d183$c0b735b0$44af3f79$b541cb8b@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <564F1C96.6050406@gmail.com>
Date: Fri, 20 Nov 2015 08:13:58 -0500
MIME-Version: 1.0
In-Reply-To: <pan$7d183$c0b735b0$44af3f79$b541cb8b@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000605030000020706080700"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000605030000020706080700
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-19 21:11, Duncan wrote:
> Austin S Hemmelgarn posted on Thu, 19 Nov 2015 07:28:34 -0500 as
> excerpted:
>
>> (having all updates installed on Ubuntu doesn't really count in this
>> case, they're pretty bad sometimes about not properly tracking upstrea=
m
>> development[)]
>
> No kidding.  I'm involved with an upstream that had a security patch an=
d
> version-bump a number of years ago.  An Ubuntu bug was filed... and it
> sat in the bug queue IIRC untouched until it was obsoleted by newer
> releases, where the new version /was/ included.  At least Fedora (which=
 I
> remember a poster confirming the update on) and Gentoo (which I run,
> personally filed a bug with, and saw the security bump) made the versio=
n
> bump available as an update.
>
> Apparently, as it wasn't a headline component (one would /hope/ they at=

> least get security updates out for /them/, and they evidently do for at=

> least some as they do publish security updates, but at this point I'd
> wonder how consistently they do for others), Ubuntu simply didn't care.=

> Made /me/ glad I wasn't on Ubuntu, that's for sure!
>
Yeah, that's one of the reasons that I switched to Gentoo.  For those=20
who may be interested, the full list is:
1. Way easier to stay up to date (from an administrative perspective,=20
not necessarily a computational time perspective (although emerge does=20
compute dependencies noticeably faster than dnf, yum, and zypper most of =

the time)).
2. Exponentially more configurable than almost any other full distro=20
(this is the big one that really made me choose Gentoo initially).
3. I build my own kernels, and Gentoo has direct integration for this=20
(in fact, they only distribute the sources for the kernel, you build it=20
locally regardless (which is really not hard even if you don't use=20
genkernel to automate it)).
4. Better response to bug reports (as compared to Ubuntu, although this=20
is on average, and not always consistent).
5. Proper support for a wide variety of desktop environments in the main =

project (In almost every other distro, any desktop other than the=20
default is usually an after thought, or maintained through a separate=20
project; and, Xfce (which is what I use) is not very popular as a=20
default environment for some reason).


--------------ms000605030000020706080700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIwMTMxMzU4WjBPBgkq
hkiG9w0BCQQxQgRAlKRpOCO9J6DJEoAfcP0FXjEVuMbCgEJxzdVcWJdP23vuNMnmZK842f5T
iWLxbyzoIjtIs+1kOjmmfz2icX84FTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA6J58QXt3vDIgHv2WN2I4GaZYfdRt9E/YptRH7y/4+SzmNqhgu
QEe85so7j9a83/aI96cZezv2dbs0Dh7ewYs5dK40MRUL7Tb0lowxlW9z9evMVioDSkZYGFFQ
zvvSxuJx8gvgBrw/uXcWvovfokLDHx1KFzVfhVdnjVSOrGyJ2+7w79ckob27sPq4wbO02ajH
kjono9jf6h0HNhgbQNMJck90HS9j6cf4FNo0q5/ACrh+hhSHZuOBPrUFs8Ky7F04TmJTkMVG
jWFLvnVro5doNUEfCGTR2B6l26UZU5tGycxKycjNAXPLpT/hi6cXElFOhzjeQUk2q4gr21m7
ZtavfFRkhfFCu+i61/rFIPvcssrjvlj9FFB/SfjMJUeDywDJW/HovA0cL/jZvCka+ZHuttLU
JDjXmszzPKI9041r9/NmZZJdLsicL6EXOvdlfUT8oNQkkO0VK53Zbq8z/LFIAetujjW+rWN9
ZKOesyRbiwLFV/TZzKLLZmK41cu4c9JdGxIZK/DaTfhxaCpp8+DuGlp5azhrR+4AwhRyRmJn
plujnn5c1adhGcWSjivJUWzyZaQajynrb3GmVko0lTnDiLMeY7DZKnKgOXwrrGO2t7NWX9m6
xUzUK5X6wnnEFii+NCwAg/Zb5cvEAEXEiC7cFw2BR3MwDPgo3IunwcJe0wAAAAAAAA==
--------------ms000605030000020706080700--
