Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34069 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbHZNGr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 09:06:47 -0400
Received: by iodb91 with SMTP id b91so17386328iod.1
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 06:06:46 -0700 (PDT)
Subject: Re: btrfs send/receive freezes a system
To: MASAKI Yuhsuke <yek@reasonset.net>, linux-btrfs@vger.kernel.org
References: <20150821021146.eb0d8b756fe7f3600685ee53@reasonset.net>
 <pan$cfe41$8e4e4add$ad942ea0$b8e86edd@cox.net>
 <20150826210416.04c96b66ab9e4d0727c0ec67@reasonset.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DDB9D5.5070001@gmail.com>
Date: Wed, 26 Aug 2015 09:06:29 -0400
MIME-Version: 1.0
In-Reply-To: <20150826210416.04c96b66ab9e4d0727c0ec67@reasonset.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090001060306080009090606"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090001060306080009090606
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-26 08:04, MASAKI Yuhsuke wrote:
> Hi Duncan, thank you for your reply.
>
> I understood it is guessed from development between 3.10 and 4.1.
>
> I will try to replace CentOS 7 Receiver with Manjaro (same as sender) a=
nd sync.
> I will report the result here anyway.
> If it doesn't work, I report it Kernel BTS.
>
>
> I searched distro for server use with later kernel.
> But I couldn't find.
> I wonder Arch Linux is better if I desire btrfs stability.
If you want the latest kernel and userspace, then Arch is definitely one =

of the two best options, the other being Gentoo.  For someone who is=20
used to Manjaro or CentOS, Arch will be a lot easier to adapt to than=20
Gentoo however.  Both Gentoo and Arch work very well for server systems, =

and make it a lot easier to keep up to date on security patches and=20
bugfixes than most of the other popular distributions.
>
>
> After on previous post, it completed on 8th try with nc and piped btrfs=
 receive.
> But the unstability make me nervous.
> I hope that latest kernel makes good.
I actually just recently tested send/recieve over the network myself=20
using ssh (along the lines of 'btrfs send snapshot | ssh user@remotehost =

btrfs recieve /target'), and only about 1 out of 3 attempts actually=20
worked.  At the time, I was on kernel 4.0.  I'm thinking that something=20
about recieve is timing dependent, as I got lower success rates as I=20
artificially increased the network latency.



--------------ms090001060306080009090606
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI2MTMwNjI5WjBPBgkq
hkiG9w0BCQQxQgRAd97quC77Pn2vtHJJAAfR+bxH7RZIiWqrp16GijnCeIjIJ1iVCpTPLuyV
B9vjmjpIDa+gMcU1UHPvpvIx+49yhTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAL3e1EUaJBvpoPCTl8Lpplqx6tFEXxmbhJ7QtAMPrydSoj4fZA
h3uthkPHhdFzRpbLPgn/D136FugSnzujWqWMrvB0bTW3RSfwWZyM/w5dPeB5pA3WCyVqdYiB
j99w7Bm/zfqeMvoLih75Rhx4lMShAkvVVRI3bXRh19+Wr0cqcFKtHd631xhga8C4kphtoxU/
V84/8KOkBuWq1TQEwnHxoO5cxlDbsIkIH5pmz76x3mZ6AG1nZf52eqp3IyUnkOQFLc/0IiZQ
iYwR5kLVp/3fhJned0NwjnboYvgG/OjXQpR1J2IlvslD+x0WH34q116shQP65G9zDOHhJfmg
ZABba/mh5JB2Yhe9f0nNtSxJ9wsCySur5+ixwsrksXhuTKpq1tTjQzfVj7Za3JkbDkT1jL6U
vXwF6kz3yO5JeOT41VRJlA6wGHCfZP8kMiEi177QWRZFRiarN6LLAO/iVlq+uAmBnsrqlbZu
Ql7OsVSluOUeTBK5j0AS2zKndXLlB23qn03d/SX0nOV8AlQE6qDRfd7fsgg0igVbbRVraqNm
UFgFwJEl+Hw33ECMuSKvJimhVqoi4CUjiZcISmYF03dpamdt1qdkIhzSxQH/FMSPfr5DErHi
DtnZ+3p9NnKmT40Urzns46WbwpQRrHjLwPoPwvVLIF6Lbq42FAD493WH2gAAAAAAAA==
--------------ms090001060306080009090606--
