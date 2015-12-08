Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33088 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbbLHMQR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 07:16:17 -0500
Received: by iouu10 with SMTP id u10so22741246iou.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 04:16:16 -0800 (PST)
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log
 replay
To: Eric Sandeen <sandeen@redhat.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5665B359.2050906@redhat.com> <2856934.1tulUexfpA@localhost.localdomain>
 <5665C1F2.8020407@redhat.com> <1449521684.6881.13.camel@scientia.net>
 <566610FA.1080408@redhat.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5666C9F7.2030509@gmail.com>
Date: Tue, 8 Dec 2015 07:15:51 -0500
MIME-Version: 1.0
In-Reply-To: <566610FA.1080408@redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030607070505000104080209"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030607070505000104080209
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-07 18:06, Eric Sandeen wrote:
> On 12/7/15 2:54 PM, Christoph Anton Mitterer wrote:
>
> ...
>
>> 2) a section that describes "ro" in btrfs-mount(5) which describes tha=
t
>> normal "ro" alone may cause changes on the device and which then refer=
s
>> to hard-ro and/or the list of options (currently nologreplay) which ar=
e
>> required right now to make it truly ro.
>>
>>
>> I think this is important as an end-user probably expects "ro" to be
>> truly ro,
>
> Yeah, I don't know that this is true.  It hasn't been true for over a
> decade (2?), with the most widely-used filesystem in linux history, i.e=
=2E
> ext3.  So if btrfs wants to go on this re-education crusade, more power=

> to you, but I don't know that it's really a fight worth fighting.  ;)
>
Actually, AFAICT, it's been at least 4.5 decades.  Last I checked, this=20
dates back to the original UNIX filesystems, which still updated atimes=20
even when mounted RO.

Despite this, it really isn't a widely known or well documented behavior =

outside of developers, forensic specialists, and people who have had to=20
deal with the implications it has on data recovery.  There really isn't=20
any way that the user would know about it without being explicitly told, =

and it's something that can have a serious impact on being able to=20
recover a broken filesystem.  TBH, I really feel that _every_=20
filesystem's documentation should have something about how to make it=20
mount truly read-only, even if it's just a reference to how to mark the=20
block device read-only.



--------------ms030607070505000104080209
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA4MTIxNTUxWjBPBgkq
hkiG9w0BCQQxQgRAwWE/BxgNP/+2FHAfM+O48jDT9TrBsWbcyKXYW+M3Vlk1sbtvJ8HTeUOX
zknL3R57E+Vm62aomSjM2xwbejrDOjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAXh5HQczsk6BoKjnV+wmj9h/G5EcQ8MEWc7xj61E+cEc1mFFwu
RLjVuwGW5O4NkF3w+xQjhfM1N8a5hvTqCNa/2B7XrycaCvSn4KNQ7o1u/re6WdaHPcKZxvo5
bIxuec5Y1l1+CxdKjDcFRntRnwKF1DTMb6Ag6xvyD0eCKfGIn4sguKOFu4Pv2EwcZVAvVBnQ
XvzONBzjxjXW2Y3JVRK08MMj9Z0fXhFKzsftKkaU8ZEpNAY92ApTFuv6f2kvuzEyUdRjUq50
Bt48sa2tZG7vC+zRKCpUjSYD3fXFMjWCERsFjPFW2BV0vc8ETVGped0GRLHpwkLDiOG2pf7A
DPSxhBGJgcOQfx3FNb45es/F0xbOOB+HyBJVESgQ9CBBCrb0ndVWio/3d0UgD7n1w7+b44lF
oO8UeDVRlaQfVk9QMU1NPHQYUFgek5kvnWLVMFQ/xBjKXqzOEg/qx73kpjOILcgfFJB2xNMO
kihsLuQ8Bjf/Iha6tF1ttcjazkwqpumBWoLnOzkwRDmbXsqlOSTbAjZlQYsyioW1KZVzSH/2
E4VkhukUyd6vkxXQ7fxl6GUvnRqnY84r+BUxPZ31cHT32VJvzCyV9DBhZHSnKWavAsMdxf89
XNtGk0aRP5XiD2Oxn/iC8RzFyYQYj2COv23Ak/lVJswzYF+pbStLyse/fwAAAAAAAA==
--------------ms030607070505000104080209--
