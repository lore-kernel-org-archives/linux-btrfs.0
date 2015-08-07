Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34843 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbbHGLjP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 07:39:15 -0400
Received: by iodd187 with SMTP id d187so108910693iod.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 04:39:14 -0700 (PDT)
Subject: Re: btrfs raid1 metadata, single data
To: Mike Fleetwood <mike.fleetwood@googlemail.com>, Sjoerd <sjoerd@sjomar.eu>
References: <55C47136.2080402@render-wahnsinn.de>
 <201508071918.02231.russell@coker.com.au> <1520215.AbHMhTRmNr@hoefnix>
 <CAMU1PDjvc-rBFONt9cxyUatFsKHPibid1F--swBAv6MhuVD3FQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55C498D1.7030807@gmail.com>
Date: Fri, 7 Aug 2015 07:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAMU1PDjvc-rBFONt9cxyUatFsKHPibid1F--swBAv6MhuVD3FQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030007080705010603020605"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030007080705010603020605
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-07 06:40, Mike Fleetwood wrote:
> On 7 August 2015 at 10:47, Sjoerd <sjoerd@sjomar.eu> wrote:
>> While we're at it: any idea why the default for SSD's is single for me=
ta data
>> as described on the wiki?
>> (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Dev=
ices#Filesystem_creation)
>>
>> I was looking for an answer why my SSD just had single metadata, while=
 I
>> expected it to be DUP and stumbled on this wiki article. Can't find a =
reason
>> for why a SSD would be different?
>>
>> Cheers,
>> Sjoerd
>
> I would assume that it is because some SSD drives controllers
> deduplicate by default [1].  The developers probably think that when
> it comes to your data the truth, no mater how ugly, is preferable to a
> false sense of security.  (Btrfs thinking it has 2 copies of metadata
> when the SSD drive only actually has stored 1 copy).
>
> [1] How SSDs can hose your data
> http://www.zdnet.com/article/how-ssds-can-hose-your-data/
> "Researchers found that at least 1 Sandforce SSD controller - the
> SF1200 - does block-level deduplication by default. Which can be a
> problem.
>
> Many file systems - NTFS, most Unix/Linux FSs, ZFS are some - write
> critical metadata to multiple blocks in case one copy gets corrupted.
> But what if, unbeknownst to you, your SSD de-duplicates that block,
> leaving your file system with only 1 copy? "
>
And of course there's the counter-argument from the manufacturers that=20
do this:
"But we use ECC, so only having one copy of the data is still safe!"
which is obviously something from their marketing department and not the =

people who actually understand how this works, most SSD's only do SECDED =

(Single error correction, double error detection) ECC, which is very=20
much insufficient if it's MLC flash, as losing a single cell causes=20
multiple bits to go bad.

The other reason, which applies to all SSD's, is that the oisk layout is =

very different from how things are actually stored on the flash chips=20
themselves, and most firmware will group writes temporally, likely=20
causing both copies of the metadata to be put on the same erase block,=20
which in turn means that the duplication provides essentially zero=20
protection beyond having a single copy.



--------------ms030007080705010603020605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODA3MTEzODU3WjBPBgkq
hkiG9w0BCQQxQgRAOy/Kip1rVTDB8Y0bEOEfm7HXdb0bMfmeoNwHfUFy/lWmHnISRuWodfAo
xpjYaWMe9QSpPgcbjOZCezQp3lml+jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAyEXMHu1qdcC16lySflViSqMsXDZFAN6TLG33xmqQIFYSNA+7t
lViN12+tQUea7NURUst5qlVUJip2sRMZ5FEoJZmjFh7oe6E/xBuEw+EhhRM0kK5lUKcRZYVb
mO/qvTDQvw4+WyWSE6NizdyH0g5S4l3WOPVmCkaa6s2fs4ZL2iCJUvgNu5gqoZi4KFBICn1n
W4rpuJmxMBFNXxPF39Nphrk2bCmA/TVvNcvyvm+l1Y/emGxG2uuvOJVu1LAHA9dJPTudCcIJ
4kXFjK3ObnXvw0TASRtjP0jkrijQxI9Md5aWFIxXdqpbQuhTlunCWsCsNo8vJ+PJygx4A3bT
MFamVo3nZ1mDUxdZTypDqxgtxxU06j76VNQxF1aLD32VX2K3l03WVoayGduoCBzAzMaFYo4e
vdz0m40BNFo6Ii8n3o94KmuRQbXU4TBRFl2/ZxbPlYvV6+7fVXxDju8dSRUGsHh9ht5Wjpb+
0fbHB7OG+qke2oBgfLJlleOOEqIHHZxumf/FHw9fFyn93bXk7N6nTbQSzdG1nSF2cSWsBJC/
/aF9PRotRKLgPJqdZJgZ1qYVU9NadHn/G1lyDpinzmhezzGlnTgFHQR0sHJpCH5+AlMlvThM
wxGroZlfv392soWIua9mRYVB+z+u42+wxCQYjr4zVQOgerNZdSm9ayschQAAAAAAAA==
--------------ms030007080705010603020605--
