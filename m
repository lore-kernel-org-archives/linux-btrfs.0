Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35157 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbKLNEd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 08:04:33 -0500
Received: by igl9 with SMTP id 9so96558592igl.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 05:04:32 -0800 (PST)
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <5643F62D.6050703@cn.fujitsu.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56448E58.3070000@gmail.com>
Date: Thu, 12 Nov 2015 08:04:24 -0500
MIME-Version: 1.0
In-Reply-To: <5643F62D.6050703@cn.fujitsu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060708050607040301000207"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060708050607040301000207
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-11 21:15, Qu Wenruo wrote:
> Hi Anand,
>
> Nice work.
> But I have some small questions about it.
>
> Anand Jain wrote on 2015/11/09 18:56 +0800:
>> These set of patches provides btrfs hot spare and auto replace support=

>> for you review and comments.
>>
>> First, here below are the simple example steps to configure the same:
>>
>> Add a spare device:
>>      btrfs spare add /dev/sde -f
>
> I'm sorry but I didn't quite see the benefit of a spare device.
Aside from what Duncan said (and I happen to agree with him), there is=20
also the fact that hot-spares are (at least traditionally in most RAID=20
systems) usually used with RAID5 or RAID6 (or some other parity scheme).

So, to summarize:
1. Hot spares are more useful for most users in global context, and in=20
that case only if they have more than one filesystem.
2. A pool of hot spares is even more useful.
3. Assuming whole disk usage (as opposed to partitioning), the hot spare =

will have no load on it until it gets used, at which point it will=20
almost always be in better physical condition than the device it=20
replaced (which is important for HA systems, in such cases you replace=20
the disk that failed, and make the new disk a hot spare)
4. Hot spares are more often used (at least from what I've seen) on=20
parity based raid systems than raid1.

In the rather limited case you outlined, I would probably just use raid1 =

across all three devices myself (unless they were whole disks and not=20
individual partitions, in which case I'd use a hot spare), but looking=20
beyond that at my actual usage of BTRFS (multiple filesystems with=20
multiple different raid profiles, spread across various disks), hot=20
spares are definitely useful (although they would be more useful if I=20
could specify that a given hot spare be used only for a given set of=20
filesystems).



--------------ms060708050607040301000207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEyMTMwNDI0WjBPBgkq
hkiG9w0BCQQxQgRASxc/S0jTsICUpV9QrMTnr7xCGK9AyrCMiDeWfqciQOxPVnHyF+fXbx78
M6IuibTG9W+1/+yf/KaNVYLEGBFTeTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAbRB5az0yIRGMgJPEoLHSNOdN5uT3npP2fqzhXJ1hRHFk2hV+N
a/T4Qqj9lXg2lMnI67ygv/u0hg0n4dxWIl2Sy+r/r5D4i0mAw8CrCLBD/nm1hhQPPN9jg5Ld
ucZ3TIlb2rFaVdbhN0h2uOOMjZfhdB0t+CdnsRKem6AgNhwIoFiXmSnQWYQuCL/gFcODXIK0
mb2j8YemUHW2N51nqty9RFB9jRT28x7BSBW5r4/SzpGpC4TWJN+w0BMndCql5IH6NUu8kIx0
YHFjJdL+EFaCYIpbYWA/SyJkXb8rmqJ8igjkJv8X9XChss/QVX5fpseufzbZRCcxOUaOJC3B
/lPrBRiT4rNZcs8L7EkZCVe6CXG1Q5EREqJ04bsWug9Kkef0ihDEbDzq4K7zKTcnEC4q2LvC
2h1AlN09/JC33W2cqGUx3fwDdjqV03BSkFVyHYghxXPzWqemjJUQkw6y0lCX1oX6qtyg0kjp
fQwMptEGqCA/wGhhY1Eb1BWofOlJgeHK6AK/N+4CEyICLjjg/t83CdDEu2O28ZsHMpkZqneK
Q8DY8q3yVoTzAkieNTfilqDbC7agfwq23jWpffzHNkAJc3XGFks5KhS+MTZsrotgG/QIPaiB
r4c4AgXrORDP1yVCT5XgsHwcLooTSRBfQlqv71EAErW2qIrNX6HFJeQBIgAAAAAAAA==
--------------ms060708050607040301000207--
