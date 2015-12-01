Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36700 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbbLAUaV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 15:30:21 -0500
Received: by iofh3 with SMTP id h3so22827432iof.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 12:30:20 -0800 (PST)
Subject: Re: utils version and convert crash
To: Gareth Pye <gareth@cerberos.id.au>, Duncan <1i5t5.duncan@cox.net>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
 <pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
 <CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565E0356.9030006@gmail.com>
Date: Tue, 1 Dec 2015 15:30:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050704090800060100080704"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050704090800060100080704
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-01 15:12, Gareth Pye wrote:
> On Wed, Dec 2, 2015 at 2:14 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> So if you're running into the same problem gentoo's live-git build did=
,
>> it's likely because you're building the devel branch cloned from
>> kernel.org, which is no longer updated.
>
>
> Woah, kernel.org is making a log that looks like it's up to date but
> isn't that's awkward :(
>
> Building now from the github you mentioned.
>
> Also running a scrub, but I'm starting to suspect something else is
> responsible. It ran fine overnight but crashed in less than a minute
> after I logged back in on ssh this morning . . .
>
Hmm, the fact that it's intermittent is the most concerning part IMHO.=20
It means it's a lot harder to track down.  If your hard drives aren't=20
any noisier than normal (most traditional hard disks get noticeably=20
noisier when they're failing), then I'd suggest running something like=20
memtest86+ for at least a full cycle with default options to verify if=20
your RAM is working correctly.  Usually, when I see intermittent crashes =

like this it's either a race condition in software somewhere, or bad=20
RAM, and it's a lot easier to test for bad RAM than it is to test for=20
race conditions.


--------------ms050704090800060100080704
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAxMjAzMDE0WjBPBgkq
hkiG9w0BCQQxQgRAtkJpGFSq4txq98eQBBTMd6KAl6VJfrhz/ouCntZoYinrK65KueaD4nZG
R29vBwCuzS01WdLoOrbUXIcV6f3mYjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAJz5U9t/W7ekFcZbHsjTak5kV/JPhqHgIRJZH2J9xcRtD7NpOn
OpMSeGfrDd/tvPBYwG15a7oNzGtq/f5Cj8cJHxjwIJeUukXWwSuAO5PW4asCsqxOyWRtfF5Z
jo85OHaTAlhbCyIPDD8j6kYXSh7fCRAUfQk7dvO0rwMeHNG/UKyUO8+h0W3C0Ja2uPXQNEZb
Ur2iKL6D1j1IG3BUf0HCSTurwKBXprf0a0i44GlcsmhWHjZ6jlpeFbLiQHRal6zEdh+rV1Bc
IL7c0IZaOTyY4tVaK+AZJIbaNUjHW3a1ZNWBiCKkrw426AbPU0dmAKCLB3mwWeqD1TW76cok
32d7cCfkmTjZtOrdRiyI62AbhDD7vrg8cLhY6yMqTTcARFxQqMP1iuYUmJkiFnwSOZlYXfDQ
WT3DunchZxIZKs38LBCQFjxLQSeNJTSBzCsqdVnyIRRZif43ZZhdbVGXOdrHf64teahX+4nU
gaxDX8L8ZGpGxvdSLQ0VD2Pp8/a58CNkMljauLSy1TZvx6yUkg4YcFPK55GqRKq7cwdKRwx1
zt0iIK5/lyNNPXh3Ux4i9JDagRGUJRhBfiDKtmtw3azftDM8PWmTBhbfIqdIyJLzUosoOqEz
LHEuakmNM9jRkE7z+Cs6lvKIe8NXiIIxDtkDDyiFQ/d6Q2bUzv6L55JPswAAAAAAAA==
--------------ms050704090800060100080704--
