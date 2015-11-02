Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37258 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbbKBMhC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Nov 2015 07:37:02 -0500
Received: by igbhv6 with SMTP id hv6so52926061igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2015 04:37:01 -0800 (PST)
Subject: Re: trying to balance, filesystem keeps going read-only.
To: Ken Long <kelargo1000@gmail.com>, Roman Mamedov <rm@romanrm.net>
References: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
 <20151101184844.0d67e5e2@natsu>
 <CAAvdE8T8AzeENxgYDvTTCN7H2RsBZg07mv+KsuPDG7AdLixCxA@mail.gmail.com>
 <20151101191730.298dcff4@natsu>
 <CAAvdE8QrXGnGeDC+w8PY7Cx1Q7uF9xLWcF+ASLVi59sL_aKd2w@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <563758E9.3080107@gmail.com>
Date: Mon, 2 Nov 2015 07:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAAvdE8QrXGnGeDC+w8PY7Cx1Q7uF9xLWcF+ASLVi59sL_aKd2w@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010003090207080003040306"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010003090207080003040306
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2015-11-01 09:33, Ken Long wrote:
> I get a similar read-only status when I try to remove the drive from th=
e array..
>=20
> Too bad the utility's function can not be slowed down.. to avoid
> triggering this error... ?
>=20
Actually, there are a couple of ways you could do this.  The most reliabl=
e way to do it
(and arguably the only correct way) is to use the blkio cgroup to put ban=
dwidth  or
IOPS limits on the process.  For authoritative info about how to do this,=
 check
Documentation/cgroups/blkio-controller.txt in the Linux source tree.

If the issue really is the device not responding soon enough, you may als=
o try increasing
the device timeout the kernel uses.  A udev rule like the following will =
increase the
timeout for all ATA/SCSI/USB (it says SCSI devices, but all ATA and USB d=
evices get
routed through the SCSI subsystem anyway unless you're using really old a=
nd deprecated
drivers) devices to 150 seconds (2.5 minutes, which is reasonable for mos=
t non-enterprise
devices):

DRIVER=3D=3D"sd", SUBSYSTEM=3D=3D"scsi", ENV{DEVTYPE}=3D=3D"scsi_device",=
 ATTR{timeout}=3D"150"


--------------ms010003090207080003040306
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTAyMTIzNjU3WjBPBgkq
hkiG9w0BCQQxQgRAnWl8Q+kn4R/oMDnWfW7uS1C+SMkrEjzOcbjV88brrDvYMnjz+qIUb3cB
7Juj8nXs3IAKoFflKYowayfltaGgZDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAqnutudY+1S5xmEJx7Kynt+wyAfQSICMFtL/gcAu+NJXOt0s2b
XvVqoQM/CZEZYyd/uJeKSFJTGxovtpJVyr294MKcJ5DcVWtEU+FGQQb6TBCaV4RL/uDAUyx6
9QxyYdzxDJnBOG9LZpPnwaIOnnJrr2EcpEnnAyGJRUY2+zjBcX4lBIhoEAnN6gFzDd8wtXRc
IU939aADBe0eEb9Kj1Fu2kfHUHKH9AfIvTvh5lMZUcDz/qkFxNY4xTzKjf0qFtjGQv2TRoKU
/udGtXB+eDmLMtp3FiJOjSKcDMivngyUi6S6bmyieGyQYlAqN/E++xmC95stJPWnaXOcgkSe
ZwcyThG4l+VBBW94bos/p7XtWtfapmlTVASx7+dgAUG3n4FCce4qN0cHSpQy6sj0Pvx3iAwp
6RKIzEK/MJFA3IFD6HhvsZJMre38DVrGyp++A2j4RLzkOSKciNI7DU5diJ3H9Z3TJBCnQD8k
j1MsxGA1J7wsLGEArc1CDsqbIoQ+qNg6/vgU+O0JpXDwIMBKqIyqSzAELapE9YZ/f9M5yVNS
fX1GYGKbgQDZ5L8ZLCRJ2SndJdlrBpA3IJYD60DjsNUr++XsO2V7YG0ScPeTAgjnCMEVfBw/
+xugULiTLNmlAgSvpsT2RNXxQ5U40RtsGxeEB7I8BrASIMMRVz7z2WRLMgAAAAAAAA==
--------------ms010003090207080003040306--
