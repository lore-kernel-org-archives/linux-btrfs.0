Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33090 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbHTLjK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 07:39:10 -0400
Received: by iods203 with SMTP id s203so42463973iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 04:39:10 -0700 (PDT)
Subject: Re: btrfs-image gets stuck, using 100%, looping on bad file
 descriptor
To: Timothy Normand Miller <theosib@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
 <55D3DCA5.9070607@cn.fujitsu.com>
 <CAK7bmU_=JcjNT-tqcHmCTQNdFJdGqiCKptypC2c949eG_aAVqA@mail.gmail.com>
 <55D3EE99.2000702@cn.fujitsu.com>
 <CAK7bmU8RK25Zd=sgni1i3M17=mY9xRecFtn+e=Mj03DwjMSBTw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D5BC4E.9080806@gmail.com>
Date: Thu, 20 Aug 2015 07:38:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8RK25Zd=sgni1i3M17=mY9xRecFtn+e=Mj03DwjMSBTw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010707030606010102070809"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010707030606010102070809
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-18 22:55, Timothy Normand Miller wrote:
> On Tue, Aug 18, 2015 at 10:48 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> w=
rote:
>>
>>
>> Timothy Normand Miller wrote on 2015/08/18 22:46 -0400:
>>>
>>> On Tue, Aug 18, 2015 at 9:32 PM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>>
>>>> Hi Timothy,
>>>>
>>>> Although I have replied to the bugzilla, IMHO it's more appropriate =
to
>>>> discuss it in mail list, as it's not a kernel bug.
>>>>
>>>
>>> All four devices were online.  The "missing" one was a drive that
>>> died, which was replaced by a new one, but btrfs wouldn't finish the
>>> deletion of the missing device.
>>>
>> By replaced, did you mean "btrfs replace"? Or just change the physical=
 disk
>> without using "btrfs replace"?
>
> Here's what happened:
>
> - A drive started throwing bad sectors.  Somehow this caused metadata
> on other drives to get messed up.
> - I took that drive offline and mounted degraded (it's a 4-drive RAID1)=

> - I did a "btrfs add" on a new drive and then a "btrfs delete missing"
> - The replacement drive failed during the replacement operation, and
> everything went to crap.
> - With some help, I got a kernel patch that allowed me to mount the
> original three drives with TWO missing devices.
> - I added a brand new drive and then did "delete missing" again.  This
> time, the first "delete missing" was successful, but it didn't fully
> balance the drives, and there was another missing device, so I had to
> do a "delete missing" again, and that failed.
>
Just for reference, I've found that it is usually safer to delete the=20
missing device first if possible, then add the new one and re-balance.=20
There seem to be some edge-cases in the code for deleting missing devices=
=2E



--------------ms010707030606010102070809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODIwMTEzODU0WjBPBgkq
hkiG9w0BCQQxQgRATD9jzKGM3Z5D7Cc58eSEdRxZA6FsaZLqIEisMJ4wYP0+i1lnzGO7iUYN
pextfPnct4mJ/6ZXynSnNquQpeX3mzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBE4XFo7c2yT5GYoVBRL2TUhTO4Zf0ah69s68b7GS/+hr/WxRt7
jEijbuHWtms2eWl/HRQOvm0AHWblcEcSYuzVHTCyzUBO1Dmj+XZnVPhslhzoSTSgtz0eQ+Sr
16iyqO45MQHdIGznIT6CQdJHiPR9oH5J6MKLY2TrvEvmBCcq1+eKCWPn5+GIBje4C+tsx9Hq
LuBNvHuIQ9lyRBtX+Ipmg2jJ8x7To5HNOSo5wjU7Jn0q2kvdR1en8hIEPNoBGwQK/hABuuac
xngqPRMe9trGE7YvCK0l0ho0MzGCTR7l9VCq5qyKdzDC8C6VcwGRmSDpeWJZKRmfzwQI5Ucv
Q5t80kRmjcSqXBQY5QNtSmPvTCfBf9T3N4ZR5wezrXgO5WY6LqCqMUFEgBD6XwnUUvK05dZx
4tyqLXE6PLerc6tvEzXarhs67GyTErDJgPmv3fHdOGEOizgHJy4khVBnMIp/lztsNkJWueBq
bDwDMCU4ysXU60JDtyWlSjkTioWcdGVnwF05h7tJCFnm++GH7si5oYxKPkKuDsjhJ8O1SriS
DE+QQ3s+A6UK4w5eX+YU7fMVDjYJN5O8Nk+YYtvhYugF8fq+a1LVJHvJ6+J9tNETWkRQPWaJ
ly/2FWSb2s8VovKT5uJz0m/F3ZwIzgBPzaLFa4MX8W+bgYdDVvjyl0tvJAAAAAAAAA==
--------------ms010707030606010102070809--
