Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35176 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbbLGPBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 10:01:46 -0500
Received: by igl9 with SMTP id 9so75559475igl.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 07:01:45 -0800 (PST)
Subject: Re: Scrub on btrfs single device only to detect errors, not correct
 them?
To: Jon Panozzo <jonp@lime-technology.com>, Duncan <1i5t5.duncan@cox.net>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
 <CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
 <pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
 <CA+pSGYeYwC=eWmSuC4MXsSz1qVvWqzxxv7KzxkhQ84BKUDO-MA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56659F48.6000800@gmail.com>
Date: Mon, 7 Dec 2015 10:01:28 -0500
MIME-Version: 1.0
In-Reply-To: <CA+pSGYeYwC=eWmSuC4MXsSz1qVvWqzxxv7KzxkhQ84BKUDO-MA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000800060205000202020905"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000800060205000202020905
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-07 09:47, Jon Panozzo wrote:
> And I'll throw this question out to everyone:
>
> Let's say I have a means of providing parity for a btrfs device, but
> in a way that's external to btrfs (imagine a btrfs single device as
> part of a hardware or software RAID).  If BTRFS detected an error
> during a scrub, and parity wasn't updated as a result (say the result
> of bitrot on the btrfs device), couldn't parity be used to repair the
> broken bit(s)?  If so, the big question is how to use scrub to
> determine the sector/bit (forgive me if I'm using wrong terminology)
> at the block level that needs to be fixed.  I think my theory is sound
> in principle, but not sure if it's possible to correlate a scrub-found
> uncorrectable error to a physical location on the block device.
>
In theory, this is possible, but it's _really_ tricky to do right.=20
BTRFS uses it's own internal block addressing that is mostly independent =

from what's done at the block device level, which makes things=20
non-trivial to map to actual addresses.  On top of that, it's=20
non-trivial to get a address for a block that failed the scrub=20
operation.  It's probably easier to just run a check on the lower-level=20
device if scrub reports errors.  If that fails, then it's probably=20
fixable by the lower level directly, if it passes, then the issue is=20
probably a bug in BTRFS.



--------------ms000800060205000202020905
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA3MTUwMTI4WjBPBgkq
hkiG9w0BCQQxQgRAVMeDX9o2tsfmBZaORJpRh0JK24q7NWlX1y+WxgdmCbaEVMhzo/XUysFI
F0sRH8l+qmkAIY/bU4gtxuPCqKHY8TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBaXRIr0cDJd2nW4YvMehbP9wRbAEIWbsXuM09g355XycjERlgA
ZfmzIwRBmziBSiwp3Q4dy5SgBHpINRyMumfCSMTS3pd8ObkZmQOYwmXN/XoQwwMm63v/l5v3
2AzdhTvXVHfOuRwmxH0EvEmqHMbDpvi/bDImcqAUB5e9TbXduKUAO7jK+LA+HrgGHGXqtP4O
fKXa9+1azPMGyoMmAPew1pWkcZqBxq3FFUZBJUXcp3DN5nMTxHKUNYCNo14Sw7gA02vz4gix
aJ7iAvmEtNkE4GPil0941L1JI8S1qvaGf6E6TSeOBsg3VOP2l3yiVOQ8gpzm+x7l1r9jG0N2
T0bOxl0Qa7dvYVwUlM3Fi5m9JN9U1sLCWvt4CCrhuYxYTOwpd4eFFbZ+6+CKafF7ySPXdKNA
zkKAmOl7M9rOM2YkhDsIyfuWD4QEbmwij8lWSoFtgOfxJwSBCeNbkcyqowyG7k9RtqQe3kDy
wokVq33Te7XBVKq24Z+gz8sBafq2caztjlHP/qHxUR/PmN0lEGq3F0TbyBnd9rfHvYZfpyu1
0mmpG8KYNlG53u6/7EyW0vnQmyeENQCokqmE7XGbj6XRItOicUNa/Yw8mtRlD51arDIbTFYy
jWlwBKdRroL9COWknqFF5MIhpssmeEZnDkt5byj2CW9ggqbckQEEDOzBHgAAAAAAAA==
--------------ms000800060205000202020905--
