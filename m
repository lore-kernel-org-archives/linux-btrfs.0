Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37631 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbHYSMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 14:12:12 -0400
Received: by igui7 with SMTP id i7so17699946igu.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 11:12:12 -0700 (PDT)
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <55A4F74D.9000305@gmail.com> <55A50DBF.1080602@gmail.com>
 <CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>
 <55A63F03.2080207@gmail.com>
 <CAJCQCtRWSvHtH0rjn2twd3yOPFMECE--UJxTUO0r_ydXQ7AhRQ@mail.gmail.com>
 <20150715161546.GR10539@carfax.org.uk>
 <CAJCQCtQFBjbuBHXfZ831YAKQwNDh+kxugFE_iMW6VyRzSpio2Q@mail.gmail.com>
 <55A79854.6020309@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DCAFF6.3020007@gmail.com>
Date: Tue, 25 Aug 2015 14:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <55A79854.6020309@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020008010100050007090402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020008010100050007090402
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-16 07:41, Austin S Hemmelgarn wrote:
> On 2015-07-15 17:29, Chris Murphy wrote:
>> On Wed, Jul 15, 2015 at 10:15 AM, Hugo Mills <hugo@carfax.org.uk> wrot=
e:
>>
>>>     There is at least one superblock on every device, usually two, an=
d
>>> often three. Each superblock contains the virtual address of the root=
s
>>> of the root tree, the chunk tree and the log tree. Those are useless
>>> without having the chunk tree, so there's also some information about=

>>> the chunk tree appended to the end of each superblock to bootstrap th=
e
>>> virtual address space lookup.
>>
>> So maybe Austin can use btrfs-show-super -a on every device and see if=

>> there's anything different on some of the devices, that shouldn't be
>> different? There must be something the kernel is tripping over that
>> the use space tools aren't for some reason.
>>
>>
>>
>>
> I actually did do so when this happened most recently (I just didn't
> think to mention it in the most recent e-mail), and nothing appeared to=

> be different either between devices or within a given device (IIRC,
> there's 2 sb per device in each of the filesystems in question).
>
> I'm going to try and reproduce this in a VM for inspection as all the
> filesystems I had this issue with now seem to be working fine (with the=

> exception of some errors in the data blocks of one that got caught by
> scrub).
>
After an a long time of trying to reproduce this in a Virtual Machine=20
with no success, and increasing issues from the motherboard in the=20
system in question culminating in it dying completely, I'm pretty sure=20
now that this was in fact a hardware problem and not a bug in BTRFS.=20
I've been unable to reproduce it at all after replacing the motherboard.


--------------ms020008010100050007090402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI1MTgxMjA2WjBPBgkq
hkiG9w0BCQQxQgRAMb7Z/JCLTI39Hdjhy91WerYcxA8hfZyrbkIKqn413WwxPP3x1UO7SX4S
wDurTwf6tfNXhkd58pzGS7SIo1cbxTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAqhG+Aw7nNEyapePn9GrGg7KAdmOCCvaxwle02yQx21G3GnkMp
twGWT7mF0LEn2clQF+DBTkxJEJ6fYftacAs4Yuo2Zt4T/QG1pf85sCukhaaH4Coknk4SEFwv
OHsTxcrnaRFM2t0cnpvgnpzRjCQYmKRz7m1VzKPfe8tIYs12ypgpgnKT1J3T1XfuhiuwyrUx
npTmATYjAQNNe+nh/0tX4y385dDyFY0vZRe3HogawAfW8GiCE0vlFA1sk2MzWxokYPIzcN/G
x3YyTZF7Wza1fpwCf3zbWZ9qMKkrO0iX/caslWU43zJPPvdZ/P9tWNahy5Lp6vb7PyHPjn7q
45FLaisXp5GwoJrfchylO0O+w1o8A6QA4WiHo0c2S4XH+xR3VsDQ+JliOaBd/A95vsuerfMK
X/2h6o5k8ZZWtP6DpdKxaaaD8rpZ/V7HVklpDGkbjfcucyk1xjhye7hqOVHc+Acyd4/0tyTs
ZtCDWJ7rA8GOtBcUymI14RyDxDJEEx4BeX8e3L9foOUMMrYSvswUTRDYK++1DYHr829onupK
9nuleXMc/kn0N64dHfqu36u3/2yBTXChFebxJvb0pLwm0QelIE7MrmC5IdDknr1j3zz6d5Bm
CX7ynnIasM95gKiK10IVWMiUkBB8aylUeaVh3+jG9cbCekpz6IiY67brpAAAAAAAAA==
--------------ms020008010100050007090402--
