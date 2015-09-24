Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34008 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbbIXSg3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 14:36:29 -0400
Received: by igcpb10 with SMTP id pb10so21794756igc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 11:36:28 -0700 (PDT)
Subject: Re: btrfs: obtain block checksums from user space
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <mu1e38$io1$1@ger.gmane.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5604427D.1000708@gmail.com>
Date: Thu, 24 Sep 2015 14:35:41 -0400
MIME-Version: 1.0
In-Reply-To: <mu1e38$io1$1@ger.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010004040805030208080208"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010004040805030208080208
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-24 14:06, Matwey V. Kornilov wrote:
>
> Hello,
>
> I would like to read the list of the checksums for the specific file
> stored onto btrfs filesystem. I think I could use the checksums in the
> manner like rsync does, but safe both CPU (because csums are already
> calculated for the file) and I/O (because I don't need to reread all th=
e
> file from the hard drive).
As of right now, there is no way to do this from userspace without just=20
directly parsing the on-disk format (which isn't safe or reliable if the =

filesystem is mounted). It has been discussed before, but the=20
discussions haven't really gotten anywhere.

It's worth noting that the way btrfs does checksums isn't per-file, it's =

per-block. This means that:
a. I think (I'm not 100% certain about this) that the checksum in btrfs=20
includes the padding up to the end of the block for blocks that aren't fu=
ll.
b. Files that get stored in-line in their metadata block won't have a=20
checksum just for the file data (because the checksum will cover the=20
whole metadata block).
c. While it is possible with some checksum algorithms (if I remember=20
right, CRC32c is one such algorithm, and that is what btrfs uses for=20
it's checksums) to combine the checksums from a group of data blocks to=20
get the checksum for data as a whole, this in and of itself takes a=20
significant amount of CPU time for large amounts of data.

All in all, this means that if you just want a checksum of the contents=20
of the file, it's almost certainly better to just do it in userspace.
If you're trying to figure out what changed, using send/receive and=20
snapshots is more efficient (usually).
>
> I've looked through linux kernel sources and not found appropriate ioct=
l
> to do this. Frankly speaking, I've not found good documentations for al=
l
> available btrfs ioctls.
I agree that this documentation really needs to be improved (if you want =

to take the time to figure out how it all works, patches for the=20
documentation would be greatly appreciated).


--------------ms010004040805030208080208
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTI0MTgzNTQxWjBPBgkq
hkiG9w0BCQQxQgRARLW5D5IGur1Eyc1+MHNbrWhNsCySdk9dkiCO5xAPYGNKHx3DN9iiGjyW
zN+eVCibFGoBt9tRyPr956sPueCyLzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCL2SpjWWV69ogLS5kL2430mTrf1Y/j/CCWNLwCW7BfPXsjhRK5
2leFB/F79eouh2jcLGS9Ix3Wy/MLW0vCJBjdwOa4OpWNgKw9XVVl33rEoRLZpJZ70WESFrdz
Q32cHSe3nVLBtIN8cpa0jHgqUH+VDg31DusqjVAzG/kFAht0zL7lvlzXv6wInhMub09Y29CB
M5DAAOw9NKdGcwmSMi8ulOhiwSnh4GvpvIUI1Jlok8bXkxMtgjTooT4gdQDLeyGxHNgMq1fw
37VJmZsI1Z4w4HdOcacdEwfyZpt9h3US+LZG8QKZUiclC9YhAEAXak9W7K3qgsCBweeEmafn
xZoEA7+KiZFbI3EgSM7zG7VQptS8ETZCLHyA4VQXjH1LA8efGXijT2nwk031lWxc5517+aRP
kvxySpCVI1Bh0E6rHnqWoalPFCm49c9XhCv4vu6D1PeE4XwlxsBvK3tXj/F6NXE67+haqD67
pdykGqCXORxVktYadf7uv7hMZL8G6u+w7IRy6Y53lIjSCumoUb8fkS9Dt+0VQqNkYbZC/s3p
/L0THEkI10iHULWx/4WeIBALTSZ8G/6vVn/dirTBbGD1dIID8Zfx2hKAEuAIi+7jquaUNdsd
z75xtw03tb7CEzYmcJi8yqSsy4iLd6kJ992OmL5RCFCsfabyOzXhcny9uAAAAAAAAA==
--------------ms010004040805030208080208--
