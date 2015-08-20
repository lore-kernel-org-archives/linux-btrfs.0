Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35433 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbbHTNMx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 09:12:53 -0400
Received: by iodt126 with SMTP id t126so45242759iod.2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 06:12:53 -0700 (PDT)
Subject: Re: btrfs-image gets stuck, using 100%, looping on bad file
 descriptor
To: Timothy Normand Miller <theosib@gmail.com>
References: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
 <55D3DCA5.9070607@cn.fujitsu.com>
 <CAK7bmU_=JcjNT-tqcHmCTQNdFJdGqiCKptypC2c949eG_aAVqA@mail.gmail.com>
 <55D3EE99.2000702@cn.fujitsu.com>
 <CAK7bmU8RK25Zd=sgni1i3M17=mY9xRecFtn+e=Mj03DwjMSBTw@mail.gmail.com>
 <55D5BC4E.9080806@gmail.com>
 <CAK7bmU9h0s_cTY+r8b7EbvD6nAvK0NafGVace5+3yTFanT0M1A@mail.gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D5D244.6070507@gmail.com>
Date: Thu, 20 Aug 2015 09:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7bmU9h0s_cTY+r8b7EbvD6nAvK0NafGVace5+3yTFanT0M1A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050605030006010208020603"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050605030006010208020603
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-20 09:08, Timothy Normand Miller wrote:
> On Thu, Aug 20, 2015 at 7:38 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Just for reference, I've found that it is usually safer to delete the
>> missing device first if possible, then add the new one and re-balance.=
 There
>> seem to be some edge-cases in the code for deleting missing devices.
>>
>
> The problem is that you can't do that if there's not enough space on
> the remaining devices to hold all the data.
>
>
Good point, I often forget that not everyone over-provisions their=20
storage like I do.


--------------ms050605030006010208020603
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODIwMTMxMjM2WjBPBgkq
hkiG9w0BCQQxQgRApJn7pP4v/3eC9v9a/2s5TbzdagVbF+Hud6umjT289ds43coux9Y7G02z
AOCmoMZ+v2zsEd1/Z3kK4s6nIsqwQzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBgH9yAFRQ8O/g8cy1OYqwFzjm29k1Z4+4ixrhNVjNJG2pb3XlH
ovzXzSkiQMyUKSzIScZrZbCFKSnX9bFoLlC1Bgky6xTXXQslziyYfiNb9aG5I0+s0mePr0tS
lzBD5nBQpaIwYWzraIAxEKvaNb5mqzMUlQ/9I3D88kLjfIZ3Bc4ujUu+3BMno72OsR6uD3wl
l7UNGr+O46kkeklYC9nSWCJLMoCBl70N6CIIkUPN6ZBDtz8WGz9tos0Lm/l9u86pMKht8gNc
kOsASOzOwbeOmoNKLPWjuX9xUFXra8Pm2nbpkRs19Y8uSsZyEXWcbZ1YNPjXN9y37epz3neW
4nWkLxLwlzX+yq5y4SWrC3xFesPzR5g80FUkPU6YFUAEBeKSNlVb/ETOGMkSE+tmuyvMC0KO
e8hnSpGYBDwKc6GrI0rCc98MTyGP5wjorzaZWS2bA1DTyo9c/6EyGXlVxSE78msOpynZQFYi
pR0PJDdn7ukv3sjHXr4ToPoHk+CWiV8v9L8+IiroS/e0aToVEbbrWjs/wVCrQ7Hyt/1bTVN4
9L9G2utuV7nXMXfMKP8JjlM2+dcEPZfGkTr+ODxxiSSQwNsO3Q8PX/AECGOVmB8wieu8Xpwe
GB76ob5qNpErGSjZNJR/gmxpk66uHjslB25xcMu4isAJWCC7UHv50Hof6QAAAAAAAA==
--------------ms050605030006010208020603--
