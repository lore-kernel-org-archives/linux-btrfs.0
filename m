Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33284 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbbJ2LRJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 07:17:09 -0400
Received: by igvi2 with SMTP id i2so21789441igv.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 04:17:09 -0700 (PDT)
Subject: Re: How to replicate a Xen VM using BTRFS as the root filesystem.
To: Russell Coker <russell@coker.com.au>
References: <5630BA78.1090804@gmail.com>
 <201510291339.52680.russell@coker.com.au>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56320025.4050208@gmail.com>
Date: Thu, 29 Oct 2015 07:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <201510291339.52680.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080205040900020006070303"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080205040900020006070303
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-28 22:39, Russell Coker wrote:
> On Wed, 28 Oct 2015 11:07:20 PM Austin S Hemmelgarn wrote:
>> Using this methodology, I can have a new Gentoo PV domain running in
>> about half an hour, whereas it takes me at least two and a half hours
>> (and often much longer than that) when using the regular install proce=
ss
>> for Gentoo.
>
> On my virtual servers I have a BTRFS subvol /xenstore for the block dev=
ices of
> virtual machines.  When I want to duplicate a VM I run
> "cp -a --reflink=3Daways /xenstore/A /xenstore/B" which takes a few sec=
onds.
Well yes, that works quickly too, but is kind of hard to do when using=20
LVM or other non-file-backed block storage, and the usual recommendation =

when not using blktap for storage is to use normal block storage devices =

(that, and I've had some horrible experience WRT performance with=20
running VM's with BTRFS filesystems on files on a BTRFS filesystem on=20
the host system).



--------------ms080205040900020006070303
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDI5MTExNjUzWjBPBgkq
hkiG9w0BCQQxQgRAMKXaKQjC00xP8j/8AAKljzwtvGaMlJ7G44vpKDxVk0Av+2JOF+uTa+QT
Vz4vJkiNco8HrpqD9yQAzM0jSOUY6zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB0IKQcU0nl1bDheLVNWg+xJdiM63c2KOKAYlnV4OcgGnHrEtON
ePOmSJmCqxzjbyX/G6wk8JX6p7uRQyiUyyn7OCVa/F31GmEpDQR4lUfGNhshLpwkP9DxRh1B
oXTAu/d/wvYAzasL3RorLSQz7PyVVov+lk02vTiKQdFWxQg1J6lqceom3BtFTNlcNujjK0AO
tme22kgOkeHxyfkKoOQfdiaiSlf68hitzY/LH1xGxp1+/wGvf4RabQRXk3c3FmrXpumy0mCb
hjf0LzOvIgL9Kiaqg9rLXmPUMCuPaq3sJgaWtrAKzZF8xRXqfZ66MUsS8Q7/o6P7aenJl/3c
PmqVKxA4RtJ0hwHOXwajZVs6JGBKizuyhHT9txjGUOi4DSGNcGa6Hezez+TBfhX30uOzCIFz
kNQn3oY4M6SmgqjKNs+/FQyWhvz+f3QBJSOEpLy+j6YQxI+kGiZO7I8T/Qsu3apyL5h1mrP8
oPpIT3hncr5mH6RNRpPyw/Cy+7Vyk8IoigsaFP4CA9gC0jAUgW6Afu/+/2cGLO8S2aqu/Jvj
wTNONCvjTzQaYtF34Lxurgimnl/nDVQoNvGQU0zaNLnibZalwAs3cj9RcmlOWQgLqHdMSI9M
zGGGtqb+Q4qjm014H/sEyz434mlpsgfcBBgCUVz2cB2TaXwLZw/SSZDxKQAAAAAAAA==
--------------ms080205040900020006070303--
