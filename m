Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36193 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbHNTu5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 15:50:57 -0400
Received: by iodv127 with SMTP id v127so79740409iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 12:50:56 -0700 (PDT)
Subject: Re: The performance is not as expected when used several disks on
 raid0.
To: Chris Murphy <lists@colorremedies.com>, Eduardo Bach <hellbach@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
 <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55CE4682.3080106@gmail.com>
Date: Fri, 14 Aug 2015 15:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040509050002010804090009"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040509050002010804090009
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-14 14:31, Chris Murphy wrote:
> On Fri, Aug 14, 2015 at 9:16 AM, Eduardo Bach <hellbach@gmail.com> wrot=
e:
>
>> With btrfs the result approaches 3.5GB/s. When using mdadm+xfs the
>> result reaches 6gb/s, which is the expected value when compared with
>> parallel dd made on discs.
>
> mdadm with what chunk (strip) size? The default for mdadm is 512KiB.
> On Btrfs it's fixed at 64KiB. While testing with 64KiB chunk with XFS
> on md RAID might improve its performance relative to Btrfs, at least
> it's a more apples to apples comparison.
>
I have a feeling that XFS will still win this.  It is one of the slower=20
filesystems for Linux, but it still beats BTRFS senseless when it comes=20
to performance as of right now.


--------------ms040509050002010804090009
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE0MTk1MDI2WjBPBgkq
hkiG9w0BCQQxQgRAQ4V3TsTRR61OXsSbtKkYFH1EhgToAY/ChUtqkXUFEq/+fQXW9enLQRzq
4tBqOufYWkjClS99/0iJR8wiuVTjtjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBjvuQRfdIJcK9LlrAc54AhixIjUjwlCfo+7Xi1hkHWTziKMQyz
42pFDKPYNctrM0LJkzaPJKyEOfjX1wmc4E2WvBm02QIkGdysEtQ70wKzNFRbbtSsmER6e4Df
gecF3VyXvCt85ru96Nar1XdDxR77FOYg3vf/E0qFnSzhwGAMf38H4Wz7W/ZWmrDX0h/BgeZN
+4UUMiF0z2YR/F3W4bZA0k/PUKej/6HuwpDKZe8UzM0BgKZDKBYPgb5qsNPigRwgj/0pNRKy
3WWB/dmoIlC1fbsb8R0seFsMF3w1OX0VGiKMZtp247E7Y+04+s9bR4+Qedm68QfmSoW08jaA
v7mUvP9YeG3sMOCLjXbWWQZN++MyDiQJBZtvTAMyz4JfcwQyvJ1tekTQBIp//t2qFtwjV0Yf
wGUNOQHrczoxjBOZ8MqqNA2pwl2jsmKz0gIhTPEYSJlq2x+FSvfJOtz7l12DSlaLAp3lzHMf
P+FlLcUC7X1EnLBb1JgTEvWTo6hmAcVDVMHSgyHmyvViDMsQkq+4sSUjs4XGuCkun6CGJAMR
qVjzYSfftUvCpMjJz39y9HI5mOKKMu8GRL3NqLp+FMFGF9Yo34Pohq+mLbrQ2L0+T4Wb+4Ox
GzBflyItfuQidd1Hi5IYKyR0drmLCBLNleePwZb5lJD+lBwjeGfCJxxeUwAAAAAAAA==
--------------ms040509050002010804090009--
