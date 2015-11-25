Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35397 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbbKYMd0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:33:26 -0500
Received: by ioc74 with SMTP id 74so52036410ioc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 04:33:26 -0800 (PST)
Subject: Re: shall distros run btrfsck on boot?
To: Eric Sandeen <sandeen@redhat.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
 <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
 <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net> <56549AFB.3040904@redhat.com>
 <1448385809.21291.22.camel@scientia.net> <5654CAE0.5040907@gmail.com>
 <5654E427.6060708@redhat.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5655AA62.2070901@gmail.com>
Date: Wed, 25 Nov 2015 07:32:34 -0500
MIME-Version: 1.0
In-Reply-To: <5654E427.6060708@redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090709020008080708060001"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090709020008080708060001
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-24 17:26, Eric Sandeen wrote:
> On 11/24/15 2:38 PM, Austin S Hemmelgarn wrote:
>
>> if the system was
>> shut down cleanly, you're fine barring software bugs, but if it
>> crashed, you should be running a check on the FS.
>
> Um, no...
>
> The *entire point* of having a journaling filesystem is that after a
> crash or power loss, a journal replay on next mount will bring the
> metadata into a consistent state.
>
OK, first, that was in reference to BTRFS, not ext4, and BTRFS is a COW=20
filesystem, not a journaling one, which is an important distinction as=20
mentioned by Hugo in his reply.  Second, there are two reasons that you=20
should be running a check even of a journaled filesystem when the system =

crashes (this also applies to COW filesystems, and anything else that=20
relies on atomicity of write operations for consistency):

1. Disks don't atomically write anything bigger than a sector, and may=20
not even atomically write the sector itself.  This means that it's=20
possible to get a partial write to the journal, which in turn has=20
significant potential to put the metadata in an inconsistent state when=20
the journal gets replayed (IIRC, ext4 has a journal_checksum mount=20
option that is supposed to mitigate this possibility).  This sounds like =

something that shouldn't happen all that often, but on a busy=20
filesystem, the probability is exactly proportionate to the size of the=20
journal relative to the size of the FS.

2. If the system crashed, all code running on it immediately before the=20
crash is instantly suspect, and you have no way to know for certain that =

something didn't cause random garbage to be written to the disk.  On top =

of this, hardware is potentially suspect, and when your hardware is=20
misbehaving, then all bets as to consistency are immediately off.


--------------ms090709020008080708060001
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTI1MTIzMjM0WjBPBgkq
hkiG9w0BCQQxQgRAYRg5wsLzuUO7Zi9ZbygGcITY/vzq55QCmtSoJpJrQb6dUYZpwINwsjKy
l2/d0W3FzL32aDWzrxfhlmWfgSVwJDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAjs7+MFKBLjSMjKRKXkDOltcgrqHaLPCs+efEUlxA6PG/h3muq
0+OFE8N+J4lGfpHVW96L9io8ddCETZYCkr0cDsEIUrcNGtNzMJBBvMEggoVC6O9qOK8Jb82y
AREJlRLZriQTr0T1bNBhTLTYvW+vuGxc6oOdqM6ty4gYBv72d97WtjBuYsue/aio4rtFAnlH
2fwrBiUoWobK0DsWQL3dUK4nuUTKbuESCnqzUUzDG9Oldios+OagiCzbVH3iolxcBbQkpyb4
BFdczBqRUvjLvk+x96N7WTKirJ9/hYb6zmGlcLr481anBuMO7qulpQAY6dWYGugjhu7Goej6
S1uVbp8269rP9QcE2UIwx2JWOY4kj83ncijrzS9BQesNWWz+saw05c8JFA3nj0vTKy6MvoRU
xo4Yfb5wKaR24DQTFY5ZVbm2J0zsdVbKNOzWXyJ2+dTjmy5iQtSFwSj+7Hoar2zUCTEsRPp2
/2ev+lcx2zhp2Wc9hCEurxPpaQJEIwuGkfrKtZFYUqycSnmu6LEnq2apMd0knm69T5C2iluC
vtfpyS8O1DP5FLk5vWANhQtByNgn0haDRXtFAI/FcXBdoxyaAXd5zlnqWAKLXX2zR45QAGyZ
QLWUu6Pj5WjygXk8cDc2byVMTcpSfGtBtVw5z3Vi9fet48Gwuw2d1vf8PgAAAAAAAA==
--------------ms090709020008080708060001--
