Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33853 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbHELao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 07:30:44 -0400
Received: by ioea135 with SMTP id a135so45840876ioe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2015 04:30:43 -0700 (PDT)
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
 <55BAFEF9.1070107@cn.fujitsu.com>
 <CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
 <55BB0A39.1050208@cn.fujitsu.com>
 <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
 <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
 <55C017E7.40704@cn.fujitsu.com>
 <CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
 <55C02AF9.3070600@cn.fujitsu.com>
 <CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
 <55C0A1ED.6020407@gmail.com>
 <CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55C1F3DD.7020603@gmail.com>
Date: Wed, 5 Aug 2015 07:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010201040606090809090300"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010201040606090809090300
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-04 13:36, John Ettedgui wrote:
> On Tue, Aug 4, 2015 at 4:28 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-08-04 00:58, John Ettedgui wrote:
>>>
>>> On Mon, Aug 3, 2015 at 8:01 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> w=
rote:
>>>>
>>>> Although the best practice is staying away from such converted fs, e=
ither
>>>> using pure, newly created btrfs, or convert back to ext* before any
>>>> balance.
>>>>
>>> Unfortunately I don't have enough hard drive space to do a clean
>>> btrfs, so my only way to use btrfs for that partition was a
>>> conversion.
>>
>> If you could get your hands on a decent sized flash drive (32G or more=
), you
>> could do an incremental conversion offline.  The steps would look some=
thing
>> like this:
>>
>> 1. Boot the system into a LiveCD or something similar that doesn't nee=
d to
>> run from your regular root partition (SystemRescueCD would be my perso=
nal
>> recommendation, although if you go that way, make sure to boot the
>> alternative kernel, as it's a lot newer then the standard ones).
>> 2. Plug in the flash drive, format it as BTRFS.
>> 3. Mount both your old partition and the flash drive somewhere.
>> 4. Start copying files from the old partition to the flash drive.
>> 5. When you hit ENOSPC on the flash drive, unmount the old partition, =
shrink
>> it down to the minimum size possible, and create a new partition in th=
e free
>> space produced by doing so.
>> 6. Add the new partition to the BTRFS filesystem on the flash drive.
>> 7. Repeat steps 4-6 until you have copied everything.
>> 8. Wipe the old partition, and add it to the BTRFS filesystem.
>> 9. Run a full balance on the new BTRFS filesystem.
>> 10. Delete the partition from step 5 that is closest to the old partit=
ion
>> (via btrfs device delete), then resize the old partition to fill the s=
pace
>> that the deleted partition took up.
>> 11. Repeat steps 9-10 until the only remaining partitions in the new B=
TRFS
>> filesystem are the old one and the flash drive.
>> 12. Delete the flash drive from the BTRFS filesystem.
>>
>> This takes some time and coordination, but it does work reliably as lo=
ng as
>> you are careful (I've done it before on multiple systems).
>>
>>
> I suppose I could do that even without the flash as I have some free
> space anyway, but moving Tbs of data with Gbs of free space will take
> days, plus the repartitioning. It'd probably be easier to start with a
> 1Tb drive or something.
> Is this currently my best bet as conversion is not as good as I thought=
?
>
> I believe my other 2 partitions also come from conversion, though I
> may have rebuilt them later from scratch.
>
> Thank you!
> John
>
Yeah, you're probably better off getting a TB disk and starting with=20
that.  In theory it is possible to automate the process, but I would=20
advise against that if at all possible, it's a lot easier to recover=20
from an error if you're doing it manually.


--------------ms010201040606090809090300
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODA1MTEzMDM3WjBPBgkq
hkiG9w0BCQQxQgRALRNvJO4WXXrHe4ONHMLPjc9UobtO+IFAjVyYXTfwKEqKnPs8kahEeIHu
UlVtH1RTAliDKZXXxKsT+GZTRYhrDTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgCP2Ia9s0L+WZXFeqXRcA4Y3N+SrmmgW4b5FcxtDMDpRYsDmRzU
WN1rYTZe9ARthUpyllHrA3NoWWOxSso2f+DWTjGt55gnUfXGmJgjdPc8aa9Ssyk4pq3GzyC6
Fi+sVq+Q0yUty8DQ8c4i6doMolLaqV0L1Rcz0cMtLOhs0/Rp3fZjLajADjYmqLAICHbkRqVs
lZep0rcD38fDAe14KSInL0e8Du6n3Wc0/2VZy4f+qh9xR6+CEj1GUUZRdfsXFwQH7nX3RCdv
hle/2HruZXDYxxXavmKEKtsYHI3R62nyv4Z9eFKq/zJKNBoMFb4HASNPF5vXs4/gz58SdgIy
5aRjl1i+U7tvIZb4TdRWjjNRMCTG1IzKnE9FAI9qvqzuicO8Jt+RwbRG/Aj3Ihopu6jxUUzB
oc1SpIr6jpyKUoeOgV3uZPbj81Yko9uG4XMNN9TCWygo8+HhpKt8caXO0LAmG1yODkuUYnLO
khuqbPLvSo1XFWIhBbuFlAREC0+9RHjsgMY8kwJPsLQGQDNCjlX0L4a7mL269VYnREgMYm9V
DibNLsBA7m+eRnubFBCkhp2m9FfImu3r+2HFWChFaz6/fe5e5oGism+bddfgVOEuxK3n3kYS
lFsY9NxoGt4QUcAe1aDHLRXL5gdscfVkhXLxN9qq5t5RvHR/wsL22aEBsQAAAAAAAA==
--------------ms010201040606090809090300--
