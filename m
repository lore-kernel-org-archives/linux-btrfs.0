Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35027 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbbKMPxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 10:53:08 -0500
Received: by ioc74 with SMTP id 74so101209587ioc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 07:53:08 -0800 (PST)
Subject: Re: Potential to loose data in case of disk failure
To: Chris Murphy <lists@colorremedies.com>, Dmitry Katsubo <dma_k@mail.ru>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
 <20151111202403.GA19245@wheatley.student.rit.edu>
 <56448A54.9020404@gmail.com> <5644CB2F.8010302@mail.ru>
 <CAJCQCtTFj2dPUw-sxda3B+_G_-9777S1UdNrGkEQMQsPqLxGBQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5646075A.1050606@gmail.com>
Date: Fri, 13 Nov 2015 10:52:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTFj2dPUw-sxda3B+_G_-9777S1UdNrGkEQMQsPqLxGBQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060605070005070807030206"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060605070005070807030206
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-13 09:51, Chris Murphy wrote:
> On Thu, Nov 12, 2015 at 12:23 PM, Dmitry Katsubo <dma_k@mail.ru> wrote:=

>> If so then I
>> think this is a trap, and mkfs.btrfs should at least warn (or require
>> --force) if two partitions are on the same drive for raid1/raid5/raid1=
0.
>
> Does mdadm warn in the same situation? LVM?
>
> There are some assumptions being made about the end user's
> understanding of the system they're working on, and those assumptions
> aren't unreasonable. But I'm not opposed to an informational message.
LVM doesn't, and I don't think MDADM does.  With LVM things are handled=20
differently from mkfs, you either specify which specific PV's you want=20
the LV to be on (in which case it's perfectly reasonable to assume you=20
know what you're doing), or you let LVM try to find optimal placement=20
(using a similar algorithm to how BTRFS decides what device a new chunk=20
goes on), and it doesn't check that the PV's are on different disks (and =

in fact, even if it did, you could use pvmove to force them onto the=20
same disk anyway), but either way it refuses to let you have more copies =

than you have PV's for a RAID set.  I'm not certain about how MDADM=20
handles things, but I don't think that it warns about having multiple=20
components for a given RAID set on the same disk.

Regardless of what LVM and MDADM do, it's not unreasonable to assume=20
that people will make the assumption that BTRFS is smart enough to=20
balance things properly (too many people don't do any research about a=20
program before trying to use it, and I must commend Jim for taking the=20
time to verify whether things would behave like he wanted them to), so I =

do think that putting a warning in would be a good idea.  This won't be=20
perfect of course, because people (myself included) use BTRFS on top of=20
DM (be it LVM, dmcrypt, or something else), MD, and other intervening=20
block layers, so we can't just try sub-string matching on the device name=
s.

We absolutely should not refuse to let the user do this if they want to=20
however, as there are people who use RAID1 on a single disk for the=20
protection against corruption, even though it doesn't protect against=20
hardware failure (although there is a patch on the ML for using dup=20
profile for data chunks, so hopefully this practice will become less=20
common in the near future).


--------------ms060605070005070807030206
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEzMTU1MjU4WjBPBgkq
hkiG9w0BCQQxQgRA5SdqheLbPsudjrEHcmWMfp5PtmrG5cMiG2yy/SYOFBgygEMSIHfsIaAa
moQSCAhv4ndeAFpjnj5SNPosviMJTjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgARRQgldRZwTY/dtO+4J8nq73wlyS6YBYd9PgpdxeQRaKdq3eex
bZZ5kXzutX4eW/QO6aM+vs3KLt4wPme9sbofSb7o5yj9gfJjzytZKNPUJXFtD1b/1xPFW45z
Pvp6TtyqHy2PmJb558Ul+X7YSrcQI9fRnBIpIOuXWw1qubc0wmiEmnnN/mBx4DgM/AEw+wVr
KyESzYQ45FFjLZd/FzIr/6uFS+Pf5tAMySmoJlyZEJpmInUAoIXZW3OW/66RsitHWq4++o94
WeZ6mYgoJ0AuBMh3FRghMSWX6g6EkciWU6YLwIxI1v1NyAuPjdHaWETZ6/IOLl7s8o/VtBtK
mFT/1GqE0F2GcS+oameeg8pk1e6FffapgAiGTdFomThFHcnwDMVNk7zFotvVwig87cUHq68w
WhTAEjVB42wpmna6qpDs2ttKTd+qz6Cv8bagcPE73O9m/hLIXNEmCw2B5lvxAdLFzdb1x7uu
5r1zZMwQvtsBsGK8RDYMN5bCBcll0AoZc1z2NeqF2mqsfV9soQmLJqR/veKGSqNaT+p1AVGt
BxOa6Pn/E9dC+Lk4qBU0bn0yGi0VCrkAtEoKn8Hry8F1OpQCLjlB0AQ1grc8CacXp8m9+fQf
VKezg6l+T1+0H8GJu3ZuVZzfs5+LcVL+0x38R2TDfyGGygadfdXQ5xH0fAAAAAAAAA==
--------------ms060605070005070807030206--
