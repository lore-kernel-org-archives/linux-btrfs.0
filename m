Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35572 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964835AbbHKNU2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 09:20:28 -0400
Received: by iodt126 with SMTP id t126so10251998iod.2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 06:20:20 -0700 (PDT)
Subject: Re: Usage of new added disk not updated while doing a balance
To: Juan Orti Alcaine <j.orti.alcaine@gmail.com>,
        Btrfs <linux-btrfs@vger.kernel.org>
References: <CAC+fKQUhwxYkMcCtmnh__EMAh0CjmmM7XE0+roegBCL9=vOuiA@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55C9F68B.9070309@gmail.com>
Date: Tue, 11 Aug 2015 09:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAC+fKQUhwxYkMcCtmnh__EMAh0CjmmM7XE0+roegBCL9=vOuiA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070406030107090808070009"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070406030107090808070009
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-11 07:08, Juan Orti Alcaine wrote:
> Hello,
>
> I have added a new disk to my filesystem and I'm doing a balance right
> now, but I'm a bit worried that the disk usage does not get updated as
> it should. I remember from earlier versions that you could see the
> disk usage being balanced across all disks.
>
> These are the commands I've run:
> # btrfs device add /dev/sdb2 /mnt/btrfs_raid1
> # btrfs fi balance /mnt/btrfs_raid1
>
> I see the unallocated space of sdc2 and sdd2 increasing, but for sdb2
> (the new disk), it doesn't change. sdb2 doesn't even appear in the
> btrfs usage command for data, metadata and system.
>
> Is this normal? It's very strange the disk not showing up in the usage =
report.
How much slack space was allocated by BTRFS before running the balance=20
(ie, how big a difference was there between the allocated and used=20
space), and did the balance run to completion?  If you had a lot of=20
mostly empty chunks and stopped the balance part way through, then this=20
is what I would expect to happen (balance back-fills partial chunks=20
before it starts allocating new ones).

If that is not the case however, then this is very much _not_ normal,=20
and is almost certainly a bug, in which case you should make sure any=20
important data on the filesystem is backed up before doing anything=20
further with it (including unmounting it or rebooting the system).


--------------ms070406030107090808070009
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODExMTMyMDExWjBPBgkq
hkiG9w0BCQQxQgRA4ZYIoiTzEbK1Ye9w0NVercITDZxIJ6yezKX0xA7QnWgKqfhf+5yUn3Qt
2JdyulQXUVfw+qU4ue7/VmqZJXzrvTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAUPkfVlXdd8iUhY1+pgzgW/572gg1cpKCFHWO4m7xFABO9e+i+
gNoirNUZF5iz0WNVe8jfb9a0iL6ZM/XjmvoiRNODD+yRJtRrATp1t/nv5TVlmKl7S+tNFgLn
5fc6St/BpgSbaFW1VlkJTndS/ldN6hm/phAhS/Bx2vXMr1uQqxTRD0Na12BAp0z2hfQ7NPCZ
xr6lwWj4p+lcSCvqzaW4BWIlGRqsqr59dQgjMSVfixeLhPDy6+kc1RHLtPUC64Em52WeG7c1
dx0hLsXAbed6QYCBRjGJ7njcR1oghm6ZMFuj+7wMySh7e7DQsNtY1jqkfIPg4jzmHl7fyXt0
EVSD54e/YZPBcqqjUQlkyhOBY/4aVDerDmiqN9sf2r4z7yqbRWADyysTFkPuqEMsqk/0AvX6
Dmsuvy4kKFE0orJCSMLQ80AWBCKMirZXFtjAjqDved294+4BlI98n4mVixqVI1+YcWjjFYQk
lOrJMr3W35xmlUYCh0QrBZg+CH2aLDBLToUXBlhp9fWqLKtiMiyjVr3TClCZkjo2RMviPS9+
uIedEPb3LigHa/Vknw1pDs2MoMAKRkNCGNLZJ/ndpaCBBFpHzkJym5p7HDoX3r/WKxNJUQc9
8Voo7kC8696w1pvuO7TsJfUSutP+iujq7QkQEfTct5BYS6DEK89Kz1MFwgAAAAAAAA==
--------------ms070406030107090808070009--
