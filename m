Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34748 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbbH1PfE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 11:35:04 -0400
Received: by iofe124 with SMTP id e124so31526181iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 08:35:02 -0700 (PDT)
Subject: Re: BTRFS errors on fresh filesystem
To: J - <mailinglists@hotmail.nl>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <DUB126-W37868A0DCD702A054C464CB46E0@phx.gbl>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55E07F8B.6080705@gmail.com>
Date: Fri, 28 Aug 2015 11:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <DUB126-W37868A0DCD702A054C464CB46E0@phx.gbl>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000603080106020708080109"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000603080106020708080109
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-28 11:10, J - wrote:
> I have noticed a BTRFS error mentioned in two consecutive identical ent=
ries  in my kernel log:
> "BTRFS error (device sda2): bad extent! em: [0 0] passed [0 4096]"
>
> sda2 contains a btrfs with skinny extents has been created a few days a=
go and contains a few subvolumes (mounted as root and home) and subsubvol=
umes a few gigabites of data in smallish files. It is mounted with 'rw,re=
latime,compress-force=3Dlzo,ssd,space_cache',
>
> Shortly after noticing the errors, which cannot have been long after th=
eir occurrence, I rebooted and ran 'btrfs check' on the filesystem, with =
output as follows:
>
> 'Checking filesystem on /dev/sda2
> UUID: c2c63f52-a322-413f-84f6-b4106fdff8c1
> found 16882602001 bytes used err is 0
> total csum bytes: 15775044
> total tree bytes: 610959360
> total fs tree bytes: 563019776
> total extent tree bytes: 28459008
> btree space waste bytes: 85192798
> file data blocks allocated: 19913826304
>   referenced 24478576640
> btrfs-progs v4.1.2'
>
> After this I ran 'btrfs scrub' which reported no errors.
>
> The filesystem has been created (and also checked) with Arch Linux, ker=
nel 4.1.6, btrfs-progs 4.1.2.
> The computer has a AMD FX-8350CPU, 32GB ECC ram, a 990fx chipset and th=
e drive is a OCZ Vector 180 (GPT, 2 partition, ESP from 2048s to 1050623s=
, .linux partition from 1050624s to 468860175s)
I would suggest some serious testing of that OCZ SSD, they are known to=20
have data corruption issues under heavy load or across unclean=20
shutdowns, and these issues will cause problems with any filesystem you=20
put on it.  Personally I would not trust an OCZ SSD as anything other=20
than scratch space for testing, and even then would only do so cautiously=
=2E



--------------ms000603080106020708080109
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI4MTUzNDM1WjBPBgkq
hkiG9w0BCQQxQgRAgohDNzeijPH4v4Uf5I5A3bMEzZhkcQ0CF/r4T+OwWQqwW2Ph7LFE3Gj5
t4x2j6vCkiOCmvluZTltTdanjqLO7zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAF9ExSN8MoJ0EIe63RYSkBSXAVGCmN6rdbGdheEf1mStk5ilEs
DfQUwpSEa78T3OPWXykg2DWlM8wLE82Y3m6MhBXIsoDrqBi9PrHifuKVm2hoq/5/yUbSud7+
+gbnzFjOre/7utl3Do7sg0HG9f5JCf9XNYWgheSKJ8GbsmsKrqa6XoPhacj4l6/UXZR9c7Ht
nl35XIzF6yH+nMK0VMfjtoKbSINtVhtwGV5P1y4WAurerQJ4ykJvmF+tcl3l5Oa6W0iE+rTQ
YzanFJnKKzDQoXivFJArfSzHYx+3p8YbUk9mVObQT6jUZQhBg0Jru2E4cQfbw4f9KmMQFDYh
G+Hm/otCmVOYHEQGlHq2jf+6LjLTVRBuO6BqXqpmPekzhYogFtmySlCJ1ejVQCF1Gllk0e++
6kGKa1SI8otP5mva7Nbq9vPQ/Ol3aJ7WbNw88sWjO5gWDjkTCb+FJd5Eu3eUf6LYY4YODW4B
7ECZEuO6TwMraJEAmM59pXC7so0hr55vF7UGkI8VhbEB9132WhkkotSrIVz57zFB2oi5kOOG
+CAFJ+hgKjJtrTrFdmVROGEEfFMvf5xQwGDsqJ3KbttF7mbS0RZyWpmEK4II2SsEjBdSk7G5
/g3WPMTRrWhkyBWUJsFnFYV3in5RHyzpxxWCf4rQNtUL7b/03TPik5kG8QAAAAAAAA==
--------------ms000603080106020708080109--
