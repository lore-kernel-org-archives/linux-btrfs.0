Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34421 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbbKXU3T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 15:29:19 -0500
Received: by igvg19 with SMTP id g19so103628651igv.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 12:29:18 -0800 (PST)
Subject: Re: btrfs check help
To: Vincent Olivier <vincent@up4.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5654C86C.9080800@gmail.com>
Date: Tue, 24 Nov 2015 15:28:28 -0500
MIME-Version: 1.0
In-Reply-To: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040907050707040307000809"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040907050707040307000809
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-24 12:06, Vincent Olivier wrote:
> Hi,
>
> Woke up this morning with a kernel panic (for which I do not have detai=
ls). Please find below the output for btrfs check. Is this normal ? What =
should I do ? Arch Linux 4.2.5. Btrfs-utils 4.3.1. 17x4TB RAID10.
You get bonus points for being on a reasonably up-to-date kernel and=20
userspace :)

This is actually a pretty tame check result for a filesystem that's been =

through kernel panic. I think everything listed here is safe for check=20
to fix, but I would suggest waiting until the devs provide opinions=20
before actually running with --repair.  I would also suggest comparing=20
results between the different devices in the FS, if things are=20
drastically different, you may have issues that check can't fix on it's o=
wn.
> [root@3dcpc5 ~]# btrfs check /dev/sdk
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents
> checking free space cache
> checking fs roots
These next two lines are errors, but I'm not 100% certain if it's safe=20
to have check fix them:
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
This next one is also an error, and I am fairly certain that it's safe=20
to have check fix as long as the number at the end is not too big.
> found 19328809638262 bytes used err is 1
The rest is just reference info
> total csum bytes: 18849042724
> total tree bytes: 27389886464
> total fs tree bytes: 4449746944
> total extent tree bytes: 3075457024
> btree space waste bytes: 2880474254
The only other thing I know that's worth mentioning is that if the=20
numbers on these next two lines don't match, you may be missing some=20
writes from right before the crash.
> file data blocks allocated: 19430708535296
> referenced 20123773407232




--------------ms040907050707040307000809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTI0MjAyODI4WjBPBgkq
hkiG9w0BCQQxQgRARdP7D186n6VChC0Zxk3yLQVp0aQ0lcNF/Z0ElhPP1o/xG8t5EH8u7yN0
X1dbFCJpv0PAZTyfDsmnDsk8wE+FUTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA4QjekjSkF0qRRbtR1V1TXgroh5tb43s57z+vCC/jgjpFT/QDF
V7zrW8N4VLWzVehUlawrMdHmJw8VQ2R+MuOTDPTZqpKUVxDXjoYKkwyw/KvyqLSQCnMRtgbU
auMadA9PHiFXy6DZlyrbxTZ1zjnPvFZTU4aIUFKtrw9VZO5lCOhtgJrTGpZReFahvpw0OO3d
Nbecw9nGQhwTeJjff/0nK6UQG6Bf2UF8Yjyfa7cmBIauujOx2AH/w1vt2k7v8EXxBaoqftW7
9kgRZxW8Q9MRet4GNfAHZ3CKp5H2AJubUI1wNL03GOL366IbYQfiWkYexNFpFg125pm8Hfa0
zDEWobYiH7jva8GYXCDBEchS7blnhnVB+M9CHkDqQ8C2PimV92NiC20Dkha4Ae5i5UGVwVZm
DBqcXDnZIGGnp4QyHJa+yVitoWmi1GXVeXr6BPy8UwIz7UkdSpohihX3HF2qs/vjjZhBhBUW
FPyLEC1T4CFpZgZBEXH+lKUGYeN2q7S6eB961/nJ/y0y8squ92WwG5S8i0ToMXHZCGuoLHnX
pV5KXJgz07I/v4bLCiFiuEiy2gUkkMBnvGspZ6UBPt02pYl46jyzh1Pwkx7c33EyTmVO4bRT
5oQimZEYRMCamz1YSgmDvagLchQTxFZo4rnUX8e13KKmQS+Qo2Hlao0LjQAAAAAAAA==
--------------ms040907050707040307000809--
