Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37885 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbGOLHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 07:07:55 -0400
Received: by igbpg9 with SMTP id pg9so33310601igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 04:07:54 -0700 (PDT)
Message-ID: <55A63F03.2080207@gmail.com>
Date: Wed, 15 Jul 2015 07:07:47 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
References: <55A4F74D.9000305@gmail.com>	<55A50DBF.1080602@gmail.com> <CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>
In-Reply-To: <CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000904020102000405020007"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000904020102000405020007
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-14 19:20, Chris Murphy wrote:
> On Tue, Jul 14, 2015 at 7:25 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-07-14 07:49, Austin S Hemmelgarn wrote:
>>>
>>> So, after experiencing this same issue multiple times (on almost a do=
zen
>>> different kernel versions since 4.0) and ruling out the possibility o=
f it
>>> being caused by my hardware (or at least, the RAM, SATA controller an=
d disk
>>> drives themselves), I've decided to report it here.
>>>
>>> The general symptom is that raid6 profile filesystems that I have are=

>>> working fine for multiple weeks, until I either reboot or otherwise t=
ry to
>>> remount them, at which point the system refuses to mount them.
>>>
>>> I'm currently using btrfs-progs v4.1 with kernel 4.1.2, although I've=
 been
>>> seeing this with versions of both since 4.0.
>>>
>>> Output of 'btrfs fi show' for the most recent fs that I had this issu=
e
>>> with:
>>>           Label: 'altroot'  uuid: 86eef6b9-febe-4350-a316-4cb00c40bbc=
5
>>>          Total devices 4 FS bytes used 9.70GiB
>>>          devid    1 size 24.00GiB used 6.03GiB path
>>> /dev/mapper/vg-altroot.0
>>>          devid    2 size 24.00GiB used 6.01GiB path
>>> /dev/mapper/vg-altroot.1
>>>          devid    3 size 24.00GiB used 6.01GiB path
>>> /dev/mapper/vg-altroot.2
>>>          devid    4 size 24.00GiB used 6.01GiB path
>>> /dev/mapper/vg-altroot.3
>>>
>>>           btrfs-progs v4.1
>>>
>>> Each of the individual LVS that are in the FS is just a flat chunk of=

>>> space on a separate disk from the others.
>>>
>>> The FS itself passes btrfs check just fine (no reported errors, exit =
value
>>> of 0), but the kernel refuses to mount it with the message 'open_ctre=
e
>>> failed'.
>>>
>>> I've run btrfs chunk recover and attached the output from that.
>>>
>>> Here's a link to an image from 'btrfs image -c9 -w':
>>> https://www.dropbox.com/s/pl7gs305ej65u9q/altroot.btrfs.img?dl=3D0
>>> (That link will expire in 30 days, let me know if you need access to =
it
>>> beyond that).
>>>
>>> The filesystems in question all see relatively light but consistent u=
sage
>>> as targets for receiving daily incremental snapshots for on-system ba=
ckups
>>> (and because I know someone will mention it, yes, I do have other bac=
kups of
>>> the data, these are just my online backups).
>>>
>> Further updates, I just tried mounting the filesystem from the image a=
bove
>> again, this time passing device=3D options for each device in the FS, =
and it
>> seems to be working fine now.  I've tried this with the other filesyst=
ems
>> however, and they still won't mount.
>>
>
> And it's the same message with the usual suspects: recovery,
> ro,recovery ? How about degraded even though it's not degraded? And
> what about 'btrfs rescue zero-log' ?
Yeah, same result for both, and zero-log didn't help (although that kind =

of doesn't surprise me, as it was cleanly unmounted).
>
> Of course it's weird that btrfs check doesn't complain, but mount
> does. I don't understand that, so it's good you've got an image. If
> either recovery or zero-log fix the problem, my understanding is this
> suggests hardware did something Btrfs didn't expect.
I've run into cases in the past where this happens, although not=20
recently (last time I remember it happening was back around 3.14 I=20
think); and, interestingly, running check --repair in those cases did=20
fix things, although that didn't complain about any issues either.

I've managed to get the other filesystems I was having issues with=20
mounted again with the device=3D options and clear_cache after running=20
btrfs dev scan a couple of times.  It seems to me (at least from what=20
I'm seeing) that there is some metadata that isn't synchronized properly =

between the disks.  I've heard mention from multiple sources of similar=20
issues happening occasionally with raid1 back around kernel 3.16-3.17,=20
and passing a different device to mount helping with that.



--------------ms000904020102000405020007
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcxNTExMDc0N1owIwYJKoZIhvcNAQkE
MRYEFO3icqxJhUcZfvF9ly6ecNweloMDMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICABOJIPfUnZFYImuBFTuJ03TaephXrsIgzYC8wAGK6sfRmVn8
GXlk+FK2IcuOeqkjdrVdenIqGn0rQQz3ufvgXALzw5LEcgPFe+7Plft/80aFF39gUwP0uP/l
bLzQ6y5YgFxVqNXCE0blYpzmBngQ+/dBleBG5lgy9VTXLOHYeJGZht4S6Ifd3J4GP/z5um29
twiomjm+PdQE1lmkjct6jWjO4b3uTzZG4YNrcRGplAKT3rLfAX0g4UaxxNli4MUgAWf+j2iN
cbAmwzmYJnG5nRrkoVSkWO1F8y5qPx8b5ZRK5hvQsWWC7ljq9+nzqYlnXomUcSOk/qKbrjDi
xW6T/qrqpRbei271XzgQEYRSCRIu9TF7luG/N1N1xIdTtrBuB6/cj4H8N6cVKKZvY+2hauSn
1BAA/aVlXDJ4kN0UwxRi0s7nOTK8CXa8eUVaBanu6oV66ysT219/Qe3cvWKYiBYn8gfi4FJ4
l3m/szA2xxeyRg4ky9uuslgew3dh3z7xDJawuiHBKyM+A34T5DetpTx4wdstwOWezBcfu0fs
CzcqYpAO9EojKGswTNPtyTR11jO3Esf1pCg/5UJ7a2KBuqQO1Lhl2VWxGaCodwDzsdlP0ZwE
EOM6MqQFFj6mTRy+TU2vdJ7g94Kzv4eXON5oi4qS1SkU4UxlPPYM8wU5h2XjAAAAAAAA
--------------ms000904020102000405020007--
