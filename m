Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33679 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbHNT7B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 15:59:01 -0400
Received: by iods203 with SMTP id s203so95925950iod.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 12:59:00 -0700 (PDT)
Subject: Re: The performance is not as expected when used several disks on
 raid0.
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
 <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
 <55CE4682.3080106@gmail.com>
 <CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55CE4866.6060207@gmail.com>
Date: Fri, 14 Aug 2015 15:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040603030407050100060507"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040603030407050100060507
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-14 15:54, Chris Murphy wrote:
> On Fri, Aug 14, 2015 at 1:50 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-08-14 14:31, Chris Murphy wrote:
>>>
>>> On Fri, Aug 14, 2015 at 9:16 AM, Eduardo Bach <hellbach@gmail.com> wr=
ote:
>>>
>>>> With btrfs the result approaches 3.5GB/s. When using mdadm+xfs the
>>>> result reaches 6gb/s, which is the expected value when compared with=

>>>> parallel dd made on discs.
>>>
>>>
>>> mdadm with what chunk (strip) size? The default for mdadm is 512KiB.
>>> On Btrfs it's fixed at 64KiB. While testing with 64KiB chunk with XFS=

>>> on md RAID might improve its performance relative to Btrfs, at least
>>> it's a more apples to apples comparison.
>>>
>> I have a feeling that XFS will still win this.  It is one of the slowe=
r
>> filesystems for Linux, but it still beats BTRFS senseless when it come=
s to
>> performance as of right now.
>
> Yeah I was suggesting with a 64KiB chunk the XFS case might get even fa=
ster.
>
>
Ah, misunderstood what you meant.  Yeah, that will almost certainly make =

things faster for XFS.

FWIW, running BTRFS on top of MDRAID actually works very well,=20
especially for BTRFS raid1 on top of MD-RAID0 (I get an almost 50%=20
performance increase for this usage over BTRFS raid10, although most of=20
this is probably due to how btrfs dispatches I/O's to disks in=20
multi-disk stetups).


--------------ms040603030407050100060507
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE0MTk1ODMwWjBPBgkq
hkiG9w0BCQQxQgRA1aFVaHFTL11SzmJXDxvk1ngszxli1lzbyn+KmMOezdCBeZyphLlt7DEo
Hy4CcrR3KXvjvwIc8megdp7bCAj9ZzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgB4jZQXioqZc6p8PgkMZZlSx5p6N0UDTBCYzG6g2UGo+Eafa0ly
wKj5B8GBc+OuVkjMerDJVro2soGPd+EjHekrKkJqXxj9Li183/p5yj13phPTW7Oi6pxUlze4
29juxXXNF2df5+HkB7Vs6+hP8rvUddxrIcKPX9EKaZdLbRN32yY5qSmXPJuC2iWCkLW8ofsK
X/vbQj70rjVJugwyowUkUmxoIqWI+bPbtSTTSb8GmTPX6YETKBzvz/dGFDbtJ7exClDDieWZ
sSs8oeWb8XZX5H6oLK2XJA42/otgIJfLmcnWLQp+Yesq5tnWkjdQeQkhk4AgnJOiJfDtiOzW
wcNe2AexO/18BLvQ6tMmDFx+m8ngN7NiVhTlD1T7R/tjqrZ1YZXEZJHuG/WrKglQ9kcugqkl
1to0llHzijhTxnutGPEm9OfbTiPo4TBCcIVLI4IaT8r3LkOMJ/U7F/mHLmvG1bE3kiVrnFZ2
Zz5JdJ8lachYmEZcgOXoR8Bvasyo+ctuUhDFoYujWxeE1Xi4RP0uTmbMVDuiPMDWvxdxk703
iwWyH+VZv8DuwFjuzoHAaKG6VntFYQvWFg0wE5RxNrHs3urwMsEEuCvM22l/dPeGVncceOfE
k41+sfinSHGmo3bHG4tBCFTz983gbEBmu8GjUEhLs2t9bRGMky1jHgdhpwAAAAAAAA==
--------------ms040603030407050100060507--
