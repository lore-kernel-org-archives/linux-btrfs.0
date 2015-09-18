Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34472 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbIRNM5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 09:12:57 -0400
Received: by iofb144 with SMTP id b144so55877053iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 06:12:56 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
 <A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com> <55F9B357.4070505@gmail.com>
 <54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
 <20150916220856.GA23830@hungrycats.org>
 <pan$8db10$2ae04448$ef503df5$d1537993@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55FC0DCA.1080905@gmail.com>
Date: Fri, 18 Sep 2015 09:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <pan$8db10$2ae04448$ef503df5$d1537993@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010500010103050400010704"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010500010103050400010704
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-17 20:34, Duncan wrote:
> Zygo Blaxell posted on Wed, 16 Sep 2015 18:08:56 -0400 as excerpted:
>
>> On Wed, Sep 16, 2015 at 03:04:38PM -0400, Vincent Olivier wrote:
>>>
>>> OK fine. Let it be clearer then (on the Btrfs wiki): nobarrier is an
>>> absolute no go. Case closed.
>>
>> Sometimes it is useful to make an ephemeral filesystem, i.e. a btrfs o=
n
>> a dm-crypt device with a random key that is not stored.  This
>> configuration intentionally and completely destroys the entire
>> filesystem, and all data on it, in the event of a power failure.  It's=

>> useful for things like temporary table storage, where ramfs is too
>> small, swap-backed tmpfs is too slow, and/or there is a requirement th=
at
>> the data not be persisted across reboots.
>>
>> In other words, nobarrier is for a little better performance when you
>> already want to _intentionally_ destroy your filesystem on power
>> failure.
>
> Very good explanation of why it's useful to have such an otherwise
> destructive mount option even available in the first place.  Thanks! =3D=
:^)
>
The other reason, as has been pointed out in a different sub-thread, is=20
that if you have a guaranteed good hardware RAID controller, which has a =

known good built in non-volatile write cache, and you turn off=20
write-reordering, and you turn off the write-caches on all the connected =

hard drives, then it is relatively safe.  Of course, the chances of most =

people actually meeting all those conditions is pretty slim.


--------------ms010500010103050400010704
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE4MTMxMjQzWjBPBgkq
hkiG9w0BCQQxQgRA1lq/g9Bx2wwEmcJO6DOB03Qs7wiJL/QuvETp2nV525TGLQYzzLXfhF1K
nD+woDKkl5Apfi38Ofl7HHw3wN84pTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAQLlHqy1XcFrzWl41x9w+QSNpeAActpvkmnPtKigPSFZ7evMqD
gfE7YguuiAOViZZbCKel6y3JaP61KC0iNg4sW0tUN16trnGn6BKiYddfdj3ivSdZ7rL0KoFj
xlzvaNjZlGoff5V/kjR4ScTs+MrdFU2ldPUwYqjNqYRk9H5fyqy26jzn7i8KJAxLdv6sWRik
Q7h+Ve/x4LNdiAr22Pbg0bOiRUegEGBQ2Bobs22WJyAPQ7E6SSUvCWOCflQHa+q0C5QX64l+
Xcff4jPlj2vIYQ4j2oY9zgsUGnVdI95dki6tBBkxftM75opWw1n3s3xIdQ2tccNjUCBRhoyp
M2kr15IEjOPbngDQfG+9wS7ol1wohgMAdeAqRCbchbCsE2RsYnKoKthkNMCATEw+0ott1UmZ
TykP7rXsWtPQ5ntpZyNEZPJIN0nJi9zLNIYX/WP5Nz6eSMjhgD1CGH/yuvmS8McvIoiFO9jZ
jMK8A3a99pad5QFWgORjImEW9SP3Xn9WfA67ckcOaEnNuih2zRWsMEel/92mK5V/0IfrkS8U
yORlwz2PgqLicEaa71RPzTBS7TEnNl2DKDSKn79uFfqxEqAa+8scn6bb4OqbV9aKCsoAVULj
M7nMGUefzzkIsVaK6WPpxFK9dGwioR0ee8EVtDInc/9/vXUOeMHVvg/cbwAAAAAAAA==
--------------ms010500010103050400010704--
