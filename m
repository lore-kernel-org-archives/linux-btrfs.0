Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37621 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbHTLfs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 07:35:48 -0400
Received: by igui7 with SMTP id i7so28108487igu.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 04:35:48 -0700 (PDT)
Subject: Re: So, wipe it out and start over or keep debugging?
To: Chris Murphy <lists@colorremedies.com>
References: <CAK7bmU88ZfLJmFfMiV=q9RjS+=vAWbniu9w6MUTv_xSG+-hj_g@mail.gmail.com>
 <55D1C8D3.5090501@gmail.com>
 <CAK7bmU_oXstgxwkWY_6tSc90aU-=WKh0TLH+1Xw+ec3YZogzbQ@mail.gmail.com>
 <55D31533.4040409@gmail.com>
 <CAJCQCtT3kGNZ3vcvhjP==6L402Zys=a3mHexErajTSDDbNBdNw@mail.gmail.com>
Cc: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D5BB83.80203@gmail.com>
Date: Thu, 20 Aug 2015 07:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT3kGNZ3vcvhjP==6L402Zys=a3mHexErajTSDDbNBdNw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020301050708030101090500"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020301050708030101090500
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-18 17:09, Chris Murphy wrote:
> On Tue, Aug 18, 2015 at 5:21 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-08-17 14:52, Timothy Normand Miller wrote:
>>>
>>> I'm not sure if I'm doing this wrong.  Here's what I'm seeing:
>>>
>>> # btrfs-image -c9 -t4 -w /mnt/btrfs ~/btrfs_dump.z
>>> Superblock bytenr is larger than device size
>>> Open ctree failed
>>> create failed (No such file or directory)
>>
>>
>> For the source, you need to specify the underlying block device, not t=
he top
>> of the mounted filesystem.  It's trying to read the directory as a blo=
ck
>> device and getting very confused.  We should probably add some kind of=
 check
>> to btrfs-image to warn about that.
>
> Should it even be possible to use btrfs-image on a mounted volume? If
> it's written to at all, the collected image is going to be
> inconsistent.
>
In theory, it might be useful, but we would need to slap a big obnoxious =

warning on such functionality.  I don't think it's possible right now,=20
and as such we should do something to account for the possibility of=20
someone trying it.


--------------ms020301050708030101090500
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODIwMTEzNTMxWjBPBgkq
hkiG9w0BCQQxQgRAUx6tepU2aZQwewH/m2CoeLqTwQ8j4oIHZUZ2CM/wux42UpMQN2z2F2lN
/aS7Agy6u/Bg2yThcSJtm9x8UZ8LBTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBBhOUCG6F0qRRvGI9j2r7ELyJT2uF+dJlUmk+RN4MXujIEHWO5
DOrjbYDq1FQTSIUPr20UmUtN4IfB/pgj7yZQl7gv6CyMei1rvL2gR0bN0tBH2aV6MTZswEbj
c8LIWyqormqr7DQxvB4P6280+qnKwfVLcYCsFrQeM+VpNbGSd4ysNiPmlXzJGAKKazp37fOm
zUZcxuv3+BRQvbbU/IU8TTs62qC+BaHgkJfKCRrShDZxuCS2pyIyvbARUMc36Xu5sorKgCoN
6S23ALTlJyGaE8gY0MsbR5BIGbdv4aHJVJQyV9hsED3GE5315go/JnkahBT3kAxDL5cridNU
PF2A0icVqj7mq/vX9c+ftsFCm3RCN7YUDOVZuZWn+ewmpevgDzP8VmnFiSHe3++zOZ74NDs4
pqiM9+kfEOF/2Acp5rAM1BklQg0D30c/5jpF5DI0s/1o4yettx+OD0/Fe4ICsGgfzk15oeKK
BgLs4AfQvC7LKLFDS8bdbS91sGZCtHrL0pnbwB10NZ+ppc2Dyp5USGu1ud9yfNqbTw8Czc/D
FOppO3HOSI7/oH40ULTUs3EXH9m8BFVy/2ZZbJ60zUNuvWiP6C0Y5ngTjInwZ+hK2I2rwv0Q
SNGtmbPZ/GHUBz0lF95DyC5jimGOAm80xG2jSXiR6EqdrBs5keAVTUpoVgAAAAAAAA==
--------------ms020301050708030101090500--
