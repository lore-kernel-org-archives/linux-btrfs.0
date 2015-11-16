Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35109 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbKPNjQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 08:39:16 -0500
Received: by ioc74 with SMTP id 74so159340786ioc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 05:39:15 -0800 (PST)
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <5643F62D.6050703@cn.fujitsu.com> <56448E58.3070000@gmail.com>
 <564537D8.5020407@cn.fujitsu.com> <5645B986.9090903@oracle.com>
 <56468653.9050005@gmx.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5649DC80.5080106@gmail.com>
Date: Mon, 16 Nov 2015 08:39:12 -0500
MIME-Version: 1.0
In-Reply-To: <56468653.9050005@gmx.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090103090805000501000805"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090103090805000501000805
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-13 19:54, Qu Wenruo wrote:
>
>
> =E5=9C=A8 2015=E5=B9=B411=E6=9C=8813=E6=97=A5 18:20, Anand Jain =E5=86=99=
=E9=81=93:
>>
>>
>> Thanks for commenting.
>>
>>>>> I'm sorry but I didn't quite see the benefit of a spare device.
>>>> Aside from what Duncan said (and I happen to agree with him), there =
is
>>>> also the fact that hot-spares are (at least traditionally in most RA=
ID
>>>> systems) usually used with RAID5 or RAID6 (or some other parity
>>>> scheme).
>>>>
>>>> So, to summarize:
>>>> 1. Hot spares are more useful for most users in global context, and =
in
>>>> that case only if they have more than one filesystem.
>>>> 2. A pool of hot spares is even more useful.
>>>
>>> Agreed, just as Ducan said.
>>> Although only one spare device is supported yet.
>>
>>   You can add more than one spare device currently.
>>
>>>> 3. Assuming whole disk usage (as opposed to partitioning), the hot
>>>> spare
>>>> will have no load on it until it gets used, at which point it will
>>>> almost always be in better physical condition than the device it
>>>> replaced (which is important for HA systems, in such cases you repla=
ce
>>>> the disk that failed, and make the new disk a hot spare)
>>>
>>> OK, that's also right, if no one is calling btrfs dev scan with a
>>> interval.
>>
>>    Not too sure what you mean about the scan part.
>
> Btrfs device scan will need to read the sb of the device.
> So the hot spare device won't really sleep for a long time as each time=

> btrfs scan devices, it will wakeup the device.
Um, no, unless you have a device scan on a cron job, you will only scan=20
at boot (and the disk will usually be running then anyway, because most=20
firmware spins up all disks at boot), because using mkfs or (I assume)=20
registering the hot spare the first time automatically registers it with =

the kernel module.
>
> Not sure about soft raid hot spare. Maybe they won't cause any IO on th=
e
> device? Or just the same with btrfs hot spare.
That depends on the type of hot spare.  Most soft raid systems use a=20
similar policy to this patch-set (let the hot spare sit there until we=20
need, then auto-replace when a device fails), but some use it actively=20
in the set without counting it as part of the capacity (I see this=20
mostly in RAID6 setups, where it just reshapes the array online to=20
exclude the failed device).



--------------ms090103090805000501000805
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE2MTMzOTEyWjBPBgkq
hkiG9w0BCQQxQgRAkQDOSBecpeQbFttwanl3tS98z+Kh6JJQ9AEIN7S709n0IQlFKB7wmiWK
V5ScVcWgIMmXRcgSD3TfbBZbz2RCuDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBIvbxeh82NyahbvikYAT+CQQpYWBU6DGSNnv8p0hpjY+mIyexP
qRYSHH1M3V4gVdxgm1vloq2mvZ9P2SM5bp7Tyj25NPHgNNh+4ygdxQrMyZ/EXnHEr2we1iES
RANMmFoDYO1Uv1Op0JhToI/baBcfmgeAUzNOOPQ71WsAtYt0nXsu2IQ2QFl/x8B2IzPLzAwu
3FdBrZ4CwiDZkIq96gcStnsFVRAdgJLzHWhZHq6i+pEMXk77TT2gSqIzFYGdldQpJJvxZ6wQ
O7LzzZPVltpUb1xPd5ZwOQYz4lYqeik5Tv8eY55H2hBv5YpqnpwR9HuXIgHDYrlo5eB6cnmL
/1ahTGLLabwvxz5ZohVoxm2WfInbOPHWhHIn82sVm59KefkOQhQz7g431JMW3fcod45c5I5Y
oAzL1VrupZwyfPPIuHi1hmoOupC/AN9nCu6oW326hRICPZUhfrfDyjJBN+y/zaOFaDxQurzo
07hNLyq6WKDBitEyr4ZbqmpuTs0qptVThd6jRKmyBzT4kUNwmyS1cAo4pPXeV/CaZEmw5vDq
DBz8pjjPq3Jswe54zfoNi4PFU6dYICZimo43KvyWukgpYBIYarnvQNTdq5/Jty143BPnJkbt
Wslh+1VqMpCfdbt5AUrNrCi9XSmgH5aM/xBj8jevglYqOpQ0H+d+EAd24wAAAAAAAA==
--------------ms090103090805000501000805--
