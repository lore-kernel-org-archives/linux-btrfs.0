Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35548 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964863AbbLGPj0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 10:39:26 -0500
Received: by igl9 with SMTP id 9so76385231igl.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 07:39:25 -0800 (PST)
Subject: Re: Scrub on btrfs single device only to detect errors, not correct
 them?
To: Jon Panozzo <jonp@lime-technology.com>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
 <CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
 <pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
 <CA+pSGYeYwC=eWmSuC4MXsSz1qVvWqzxxv7KzxkhQ84BKUDO-MA@mail.gmail.com>
 <56659F48.6000800@gmail.com>
 <CA+pSGYdE8FxCGjR_=gU58jej6AuMMZ-wn6EzyE_g0n7Trqb_Hw@mail.gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5665A819.9030804@gmail.com>
Date: Mon, 7 Dec 2015 10:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <CA+pSGYdE8FxCGjR_=gU58jej6AuMMZ-wn6EzyE_g0n7Trqb_Hw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030507010400050102010807"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030507010400050102010807
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-07 10:12, Jon Panozzo wrote:
> This is what I was thinking as well.  In my particular use-case,
> parity is only really used today to reconstruct an entire device due
> to a device failure.  I think if btrfs scrub detected errors on a
> single device, I could do a "reverse reconstruct" where instead of
> syncing TO the parity disk, I sync FROM the parity disk TO the btrfs
> single device with the error, replacing physical blocks that are out
> of sync with parity (thus repairing the scrub-found errrors).  The
> downside to this approach is I would have to perform the reverse-sync
> against the entire btrfs block device, which could be much more
> time-consuming than if I could single out the specific block addresses
> and just sync those.  That said, I guess option A is better than no
> option at all.
>
> I would be curious if any of the devs or other members of this mailing
> list have tried to correlate btrfs internal block addresses to a true
> block-address on the device being used.  Any interesting articles /
> links that show how to do this?  Not expecting much, but if someone
> does know, I'd be very grateful.
I think there is a tool in btrfs-progs to do it, but I've never used it, =

and you would still need to get scrub to spit out actual error addresses =

for you.



--------------ms030507010400050102010807
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA3MTUzOTA1WjBPBgkq
hkiG9w0BCQQxQgRA4h33FI2WhwPasKHK0P54N5QYGiiy2psNRXpnv69sBZg2bCSBdsGzyv10
RSMDDSL4ND0gQS4f/nxkaaVk/DOktDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCOcF0RJRhyt3ecifl95ms9JtlLgA9spUqRzH7EKrBBT9UG+Djp
JIkNYvf7fNhGZVY2TB5AtOVeHupAqNKIHOGJDHnZyOTryz8us2goLr/hXN+vdj/lYT12bdnU
aN2zhg3gYVdz8lblXzVy5sjrWjsFmGiykFsJsBs0nk2/rCLpm3B1sgEeBhTGG+t6uxHaIZo0
TJO45XS9rLm0qyE/u2+FjcbwdX0lBkby5Ej+rv/WSwV3aViSvLrlI6Az8oGIT/in37PJfbJh
T3OADP08uTPIMKd6mzYUcaJpZZDtDZbKR76L5CLIHZU+EPUGLsE1Z8of5gp2+oTVmCDQ2VSr
bUM6/UWPHehC4pVE0iq7Vrc2AMoi+mg1u9XE0uOQg7GBnscEPlq6vsby6GFZqcuDEtMCWw1g
FZGSHzKMV64oxBHAzV81+24aypv457TwRpni64PXUXYqf4fayh6Lx2ZVObgAIW+Vi9ju8V5H
he/FFbbQDLE5IeK69W8wkGqYFXW/KcjjhCcBuamOmReUu/ATLl3Lcd3PSD4T6PdOSnSsxOhS
Wg5YkOtup8+Xo9iZqylbg4ZL+jSQNc4RaO/DutXekxkbtfry+3lU5b1jVSidY1b3BwqBQjKu
1VjCpnIJUZ24J4dUgP1I7IGBlJJ3Ulon03UE12bzIch2DQcnk5gn+FlfYAAAAAAAAA==
--------------ms030507010400050102010807--
