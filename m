Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38348 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbbJNNMq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 09:12:46 -0400
Received: by igsu6 with SMTP id u6so16140245igs.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 06:12:45 -0700 (PDT)
Subject: Re: System completely unresponsive after `btrfs balance start
 -dconvert=raid0 /` and `btrfs fi show /`
To: Hugo Mills <hugo@carfax.org.uk>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
 <pan$39697$bacd3e0c$3e39ab12$ed8c21a7@cox.net>
 <20151014091325.GL25907@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <561E54BD.4000402@gmail.com>
Date: Wed, 14 Oct 2015 09:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <20151014091325.GL25907@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090409020806040502090908"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090409020806040502090908
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-14 05:13, Hugo Mills wrote:
> On Wed, Oct 14, 2015 at 05:08:17AM +0000, Duncan wrote:
>> Carmine Paolino posted on Tue, 13 Oct 2015 23:21:49 +0200 as excerpted=
:
>>
>>> I have an home server with 3 hard drives that I added to the same btr=
fs
>>> filesystem. Several hours ago I run `btrfs balance start -dconvert=3D=
raid0
>>> /` and as soon as I run `btrfs fi show /` I lost my ssh connection to=

>>> the machine. The machine is still on, but it doesn=E2=80=99t even res=
pond to
>>> ping[. ...]
>>>
>>> (I have a 250gb internal hard drive, a 120gb usb 2.0 one and a 2TB us=
b
>>> 2.0 one so the transfer speeds are pretty low)
>>
>> I won't attempt to answer the primary question[1] directly, but can po=
int
>> out that in many cases, USB-connected devices simply don't have a stab=
le
>> enough connection to work reliably in a multi-device btrfs.  There's
>> several possibilities for failure, including flaky connections (someti=
mes
>> assisted by cats or kids), unstable USB host port drivers, and unstabl=
e
>> USB/ATA translators.  A number of folks have reported problems with su=
ch
>> filesystems with devices connected over USB, that simply disappear if
>> they direct-connect the exact same devices to a proper SATA port.  The=

>> problem seems to be /dramatically/ worse with USB connected devices, t=
han
>> it is with, for instance, PCIE-based SATA expansion cards.
>>
>> Single-device btrfs with USB-attached devices seem to work rather bett=
er,
>> because at least in that case, if the connection is flaky, the entire
>> filesystem appears and disappears at once, and btrfs' COW, atomic-comm=
it
>> and data-integrity features, kick in to help deal with the connection'=
s
>> instability.
>>
>> Arguably, a two-device raid1 (both data/metadata, with metadata includ=
ing
>> system) should work reasonably well too, as long as scrubs are done af=
ter
>> reconnection when there's trouble with one of the pair, because in tha=
t
>> case, all data appears on both devices, but single and raid0 modes are=

>> likely to have severe issues in that sort of environment, because even=

>> temporary disconnection of a single device means loss of access to som=
e
>> data/metadata on the filesystem.  Raid10, 3+-device-raid1, and raid5/6=
,
>> are more complex situations.  They should survive loss of at least one=

>> device, but keeping the filesystem healthy in the presence of unstable=

>> connections is... complex enough I'd hate to be the one having to deal=

>> with it, which means I can't recommend it to others, either.
>
>     Note also that RAID-0 is a poor choice for this configuration,
> because you'll only get 640 GB usable space out of it. With single,
> you'll get the full sum of 2370 GB usable. With RAID-1, you'll have
> 320 GB usable. The low figures for the RAID-0 and -1 come from the
> fact that you've got two small devices, and that both RAID-0 and
> RAID-1 have a minimum of two devices per block group. You can play
> around with the configurations at http://carfax.org.uk/btrfs-usage
>
>     But I second Duncan's advice about not using USB. It's really not a=

> reliable configuration with btrfs.
I'd also second that statement, but go even further and say to not use=20
USB for anything except backups and transferring data between computers=20
unless you have absolutely no other option, and be wary of using any=20
externally connected storage device for other use cases (I've seen=20
similar issues with eSATA drives and BTRFS, and have heard of such=20
issues with some Thunderbolt connected storage devices).



--------------ms090409020806040502090908
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE0MTMxMjI5WjBPBgkq
hkiG9w0BCQQxQgRABL9yvsY6po8LQocW36XPG1Y77xsMWZpTyArH+aSRuqq43FKNY7gbti/S
QMx1pWTtbwnjf8jkLTkhB8b7P6QzRTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAsAf6ZGUqgBDsX1QlZhEYw0Kwyt2joziLWQmCFpA9IJjgV/8Q7
h5oM8q0/kRGg8EO/XQdYYKi+g7W15Amwiv/IWzJ0js9ma1d8X6TGRqsaKWhczJZJ1e6iKWmv
nB/6plQAaze629ixPeqXwZwbsb91jUntWLocroqBVVFIfBR/GdVaeMi3VNX7tzhwDSEXlkJ5
xs/HL+uf9AUjdggTjCph/1jRi6gi3PqieCcDcYULBzy/2Aqi+Z/d5DJ7LZD55KRXz/kRc3H8
fWkzd/PODTvXF7uBKjSd42aOQJlhMcAFrle8qGv6SAcp6fKikph4xRiTI31v4xgBC+qSGxHT
Q2AExlfJ+KVVLMM8FC2/ynLccYDRQWDxESvU51A0vH8HPE97FxfCi2iduuBuoyw341/RNdIR
NBnt3MD7UagArSRDOo/O4EtnHuldcUeC/LDJfgTghMKLsO20XaCkQ6k0+G//EWtZOyDlyYHR
hR+07huyX2DdJ4pKQHyZPitjtMBy5Es4S/bTDqA2oWCg9WY7uWeIoXM9x1f6SsrGwrtWjVM7
R2hxWnKM6tMqQ7NXDGhVX+4NIsR3zQ+DJOjbWQ4DHG6xGL7+SxV3XAOPT7op9jaoPKBBnJVa
qvPS99yfTz4+MpZiyoGVbWoD/+EeVY3M+ZXMg0OBTsWlbaptJqKEA8JligAAAAAAAA==
--------------ms090409020806040502090908--
