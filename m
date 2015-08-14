Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37898 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbbHNL1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 07:27:09 -0400
Received: by igfj19 with SMTP id j19so9787077igf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 04:27:08 -0700 (PDT)
Subject: Re: RAID0 wrong (raw) device?
To: Gareth Pye <gareth@cerberos.id.au>, Hugo Mills <hugo@carfax.org.uk>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <55CC830D.2070304@gmail.com>
 <CA+WRLO9ZbjZyNnMM951xrkE5OqymO3E8gMeebOpkX1a4qCS+6g@mail.gmail.com>
 <20150813225406.GQ12976@carfax.org.uk>
 <CA+WRLO9ub4gX1Rj9+f1APNujL7zk_p7NApUUS-ExkfbuPjMQDQ@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55CDD07E.9090708@gmail.com>
Date: Fri, 14 Aug 2015 07:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+WRLO9ub4gX1Rj9+f1APNujL7zk_p7NApUUS-ExkfbuPjMQDQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080705010609040300070500"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080705010609040300070500
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-13 19:29, Gareth Pye wrote:
> I would have been surprised if any generic file system copes well with
> being mounted in several locations at once, DRBD appears to fight
> really hard to avoid that happening :)
>
> And yeah I'm doing the second thing, I've successfully switched which
> of the servers is active a few times with no ill effect (I would
> expect scrub to give me some significant warnings if one of the disks
> was a couple of months out of date) so I'm presuming that DRBD copes
> reasonably well or I've been very lucky. Either that luck is very
> deterministic, DRBD copes correctly, or I've been very very lucky.
>
> Very very lucky doesn't sound likely.
>
Yeah, I'd be willing to bet that DRBD does cope well with direct writes=20
to the backing store (either that or it prevents the kernel from doing=20
that, which would be even better and would not surprise me at all).  In=20
my experience it's one of the most resilient shared storage options out=20
there.



--------------ms080705010609040300070500
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE0MTEyNjU0WjBPBgkq
hkiG9w0BCQQxQgRAFP0PL/RXhsnG4nQV88jwttRUvuVYe7CkfmHz4z867cFtsSOmEbnYYrx3
BDe3UVj9uy5BW8CPssUXLHXICOm2QTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBXJiPIKcUQ34XIZXTxN/Ym29iEHx4x/cl6fJCDVdfNNpiHbUlG
e86J93lKqJ+KC7l90e+CnUeoXJrn5wthcpVFFYsqf6Wt6Bs0hF56VNSocOPqb9N+jeCe8Y/U
NCehzvzAFggq9dpWm8CWbI/aYxQxoTCtTj5HqG8b23yin5OsjIcjF18FcNNUJhthV+vHspw+
nJOjJy4nFDjUAc4cBhCHCzssRM8ozYOExa+uymuFfjatWQR/chnkpj/vFxgu0usFu72itQdy
6BI0Oyh5TwjaMbGwW2Pzz1oluftuhbdoRg2WHRYpTtPtsSk2TGsiMb/HzcOFxH3TZX7JHy9h
+T8gZNS2hi1Y7HsilMtMgdPc4mpQfxfZuL25AlzST9yfzkTW5vqBxjRJmAm4XlBnZwsS+qiI
RNSzkTdVK8nvf00ZiiypHDKHnCIpP6+/D0v1FJL1jF7NjFhu54nD4AD+X+wwLy7Fq/b6CkIf
OOrCmu9E2Nrfr6pRtkmn2+uocQGmzZZ8151wLE/hySQLNZTC+JQEzlYTHz0+WQj31VXpbv9T
foxShneIGKJtYzSSVuT6pfYEyGI8b9Rs5q+93ITLHgoAwzLZI+uXh2Rye2LiYYW3ae1x84up
uMObKVbplii9Sfuzyucr9yOXZwJ+AL9Z/AZZQKq3yvh07aoylcNTS51E3wAAAAAAAA==
--------------ms080705010609040300070500--
