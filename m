Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33325 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbKWM0v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 07:26:51 -0500
Received: by igcmv3 with SMTP id mv3so27342205igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 04:26:50 -0800 (PST)
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
To: Nils Steinger <nst@voidptr.de>, linux-btrfs@vger.kernel.org
References: <56523AC8.7050205@voidptr.de>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56530608.50906@gmail.com>
Date: Mon, 23 Nov 2015 07:26:48 -0500
MIME-Version: 1.0
In-Reply-To: <56523AC8.7050205@voidptr.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050902040502080407030805"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050902040502080407030805
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-22 16:59, Nils Steinger wrote:
> Hi,
>
> I recently ran into a problem while trying to back up some of my btrfs
> subvolumes over the network:
> `btrfs send` works flawlessly on snapshots of most subvolumes, but keep=
s
> failing on snapshots of a certain subvolume =E2=80=94 always after send=
ing 15 GiB:
>
> btrfs send /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT =
|
> pv | ssh kappa "btrfs receive /mnt/300gb/backups/snapshots/zeta/home/"
> At subvol /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT
> At subvol 2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT
> ERROR: send ioctl failed with -2: No such file or directory
>    15GB 0:34:34 [7,41MB/s]
>
> I've tried piping the output to /dev/null instead of ssh and got the
> same error (again after sending 15 GiB), so this seems to be on the
> sending side.
This is an issue that comes up sometimes with send, it's not well=20
understood or documented, but sometimes something in source FS can get=20
into a state that send chokes on, and then crashes.  I've actually been=20
trying to reproduce this myself on a small filesystem so that it's=20
easier to debug, but so far been unsuccessful.  I have yet to find any=20
reliable way to reproduce this, and thus have no reliable way to prevent =

it from happening either.
>
> However, btrfs scrub reports no errors and I don't get any messages in
> dmesg when the btrfs send fails.
Scrub is intended to fix corruption due to hardware failures.  In almost =

all cases that I've seen of what you are getting, it wasn't a provable=20
hardware issue, and scrub returned no errors.
>
> What could cause this kind of error?
> And is there a way to fix it, preferably without recreating the FS?
In general (assuming you are seeing the same issue I run into from time=20
to time), there are two options other than recreating the filesystem:
1. Recreate the file that scrub is choking on.  You can see what file by =

adding -vv to the receive command-li9ne, although be ready for lots of=20
output.  It's important to note that mv won't work for this unless=20
you're moving the data to a different filesystem (if it's a directory,=20
copy everything out and then recreate the directory, then copy=20
everything back in).  The downside to this option is that you will=20
usually run into multiple files that send chokes on, and the only way to =

find them all is to keep repeating the process until send completes=20
successfully.
2. Run a full balance on the FS (this doesn't work anywhere near as=20
reliably as the first option, but is the only way to fix some issues=20
caused by doing batch deduplication on some older kernels).


--------------ms050902040502080407030805
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIzMTIyNjQ4WjBPBgkq
hkiG9w0BCQQxQgRAv9ytFjZ82+LRYgpb6Q2vTH95h11KNW1JNzr3Gerj1Vc2cbxIIJVJ72Zn
+YsxSs+DQHGhIH2n+AMo/RiXajLMqTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBl3bSgjAvOpAy6wjcrQ3xOFq9sBt+pJ/7oQB1Y6FgupS30T29d
G1e+bIc278WYqhcxGZsQ2uSwbRZLQYo5KjJI4hg3Rr3YoLbfa0hw80/qC5V8vRbQn7ozWgrZ
aB/u5j709a5X9T878QsPnKfF3lo+Qis4uc48hIS5yCyhi9wotRSACbhtXQFNdQ6I6V/6sQrV
GmJ/j+kQwSITXnRftwBrw5NcPOtsDWOhg6n3wIBf2IedoVhQ2j+s+xpVeKxDsDmN85i0BZ5A
4i1yZHGfiehEYb9LqpJIl7C++3Z06YaLL57h22uYcnr2yjws3DhYBThtXRxJPUjfjWCIECeo
eVNu6HqZBls1mwaViis4YRfYhUhIMSNfbes+ePUhTdbYBE7AEr778Dzb1oRg7OafM42g3RTI
W6DCphGNVMVcz+zfWHCuSLpelPMryANErAznEns8vQZKWOs0k1gFGXALpcJMmcuWWFjr67oC
ccAtrgrX/P3mou2TWNm0N/uXWfTEVqfV6jE150jZ1ODffirg8/P8xkdn9G/fN5NRwIwMZsqw
wzMBe/zmjIPOBEwLPGJLU2O+3ffRYG2+9e6BDf6AuCZvkjjiyZmQwhy7mNiL9xX20aeJIFBv
MebL9+dqBogqiGmQYV+v633eZL/ycxGRBck4h4OSeJVHNaEF7bSKFgB3mwAAAAAAAA==
--------------ms050902040502080407030805--
