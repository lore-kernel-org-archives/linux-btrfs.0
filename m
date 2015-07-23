Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35292 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbbGWTzE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 15:55:04 -0400
Received: by igr7 with SMTP id 7so99468088igr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2015 12:55:04 -0700 (PDT)
Subject: Re: INFO: task btrfs-transacti:204 blocked for more than 120 seconds.
 (more like 8+min)
To: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55B1468E.2010605@gmail.com>
Date: Thu, 23 Jul 2015 15:54:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010708040407070500050408"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010708040407070500050408
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-23 15:12, james harvey wrote:
> Up to date Arch.  linux kernel 4.1.2-2.  Fresh O/S install 12 days
> ago.  No where near full - 34G used on a 4.6T drive.   32GB memory.
>
> Installed bonnie++ 1.97-1.
>
> $ bonnie++ -d bonnie -m btrfs-disk -f -b
>
> I started trying to run with a "-s 4G" option, to use 4GB files for
> performance measuring.  It refused to run, and said "file size should
> be double RAM for good results".  I sighed, removed the option, and
> let it run, defaulting to **64GB files**.  So, yeah, big files.  But,
> I do work with Photoshop .PSB files that get that large.
>
> During the first two lines ("Writing intelligently..." and
> "Rewriting..." the filesystem seems to be completely locked out for
> anything other than bonnie++.  KDE stops being able to switch focus,
> change tasks.  Can switch to tty's and log in, do things like "ls",
> but attempting to write to the filesystem hangs.  Can switch back to
> KDE, but screen is black with cursor until bonnie++ completes.  top
> didn't show excessive CPU usage.
>
> My dmesg is at http://www.pastebin.ca/3072384  Attaching it seemed to
> make the message not go out to the list.
>
> Yes, my kernel is tained... See "[5.310093] nvidia: module license
> 'NVIDIA' taints kernel."  Sigh, it's just that the nvidia module
> license isn't GPL...
>
> During later bonnie++ writing phases (start 'em", "Create files in
> sequential order...", "Create files in random order") show no
> detrimental effect on the system.
>
> I see some 1.5+ year old references to messages like "INFO: task
> btrfs... blocked for more than 120 seconds."  With the amount of
> development since then, figured I'd pretty much ignore those and bring
> up the issue again.
>
> I think the "Writing intelligently" phase is sequential, and the old
> references I saw were regarding many re-writes sporadically in the
> middle.
>
> What I did see from years ago seemed to be that you'd have to disable
> COW where you knew there would be large files.  I'm really hoping
> there's a way to avoid this type of locking, because I don't think I'd
> be comfortable knowing a non-root user could bomb the system with a
> large file in the wrong area.
>
> IF I do HAVE to disable COW, I know I can do it selectively.  But, if
> I did it everywhere... Which in that situation I would, because I
> can't afford to run into many minute long lockups on a mistake... I
> lose compression, right?  Do I lose snapshots?  (Assume so, but hope
> I'm wrong.)  What else do I lose?  Is there any advantage running
> btrfs without COW anywhere over other filesystems?
>
> How would one even know where the division is between a file small
> enough to allow on btrfs, vs one not to?
>
First off, you're running on a traditional hard disk, aren't you?=20
That's almost certainly why the first few parts of bonnie++ effectively=20
hung the system.  WRT that issue, there's nothing I can really give=20
advice wise other than to either get more and faster RAM, or get an SSD=20
to use for your system disk (and use the huge hard drive for data files=20
only).

As far as NOCOW, you can still do snapshots, although you lose=20
compression, data integrity (without COW, BTRFS's built in RAID is=20
actually _worse_ than other software RAID, because without COW being=20
enabled, it can't use checksums on the filesystem blocks), and data=20
de-duplication.  Overall, there are still advantages to using BTRFS even =

with NOCOW (much easier data migration when upgrading storage for=20
example, btrfs-replace is a wonderful thing :), but most of the biggest=20
advantages are lost.

Also, if you can deal with not having CUDA support, you should probably=20
try using the noveau driver instead of NVIDIA's proprietary one, OpenGL=20
(and almost every other rendering API as well) is horribly slow on the=20
official NVIDIA driver.



--------------ms010708040407070500050408
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwNzIzMTk1NDU0WjBPBgkq
hkiG9w0BCQQxQgRAELXgdDK1axHF8MwRJ4tfH0KGjzXF3PCpdK5JXvrugjixnSEJe4OFQkHH
+aDSyCgRRZ0YRjQ1iQx7RqyiWmEXlzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAUH31aRrnnSC6i5A5MTRt1DVKoK/SoYqAVGtdPYgHbzRXDlAGN
iB8uuCJz4CBfCg9BsglqtWGNODxFmKwavtSY7RCK0dvAVCxqpY3dWuscVsKhxshF7jfevkYY
lZZ/an7gmIB4CrjytT5vZhCCpho06RF3JIMAXU0PtqCRWh51ZTtsuyHGsSBryLx/ZLiu/nri
YSN2MBSWZpQid7uCBrCxZuZOVQ6i+mF6zCWDC2P+LNW66VkAuV7ZR7RqK2qdSC40qsmEbQXo
OscMCYmTqrxgEHDtV4hX2n+KhcfMPnaBd5GznEiFOnyaShUE/NTuCTOrTdQ+QTVp7iIYZTNX
NF2pk5RYiksiWCrc9ETQV3m8+ivK3LLVM6PtW4zru4xPvxIXjKB8RO3PkdiPk7kvvR7bdHsq
GnParP+9ijw1nVCYyiCAOVTK7PT2XEJc62IYwJRoViiJ3w+LSJqiNiw1DBUMPZ/Z2IJ8I1Fy
TMRCAPsVRRslGR9xE7k9pNiPQe4aohiqUd8lWT7L2y7blLPoWHNkTEk5GJA4uie0Tm7CCwVw
iGaVweqgAXoJotTG+ETF6aUrlf8fqwcyeJp6gZs+SpnKQ8NU0DqDKyBRAN931uKx+suB2J8A
05anvU94u20ZGQP4OqqP5PrT/emNVlDABuzlGPCNgOX/l+igEisksB/8JgAAAAAAAA==
--------------ms010708040407070500050408--
