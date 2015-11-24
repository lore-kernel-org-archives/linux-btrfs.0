Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34311 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbKXU6v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 15:58:51 -0500
Received: by ioir85 with SMTP id r85so33620573ioi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 12:58:51 -0800 (PST)
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, Nils Steinger <nst@voidptr.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56530608.50906@gmail.com> <20151123211012.GA12286@ny.voidptr.de>
 <pan$7e9cd$79273243$6e85efe7$7ee378ef@cox.net> <56545C1B.1080507@gmail.com>
 <1448390914.21291.42.camel@scientia.net> <5654CC1B.4030209@gmail.com>
 <1448398257.21291.63.camel@scientia.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5654CF58.8080207@gmail.com>
Date: Tue, 24 Nov 2015 15:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <1448398257.21291.63.camel@scientia.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090006060201060207040606"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090006060201060207040606
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-24 15:50, Christoph Anton Mitterer wrote:
> On Tue, 2015-11-24 at 15:44 -0500, Austin S Hemmelgarn wrote:
>> I would say it's currently usable for one-shot stuff, but probably
>> not
>> reliably useable for automated things without some kind of
>> administrative oversight.  In theory, it wouldn't be hard to write a
>> script to automate fixing this particular issue when send encounters
>> it,
>> but that has it's own issues (you have to either toggle the snapshot
>> writable temporarily, or modify the source and re-snapshot).
>
> Well AFAIU, *this* very issue is at least something that bails out
> loudly with an error... I rather worry about cases where send/receive
> just exits without any error (status or message) and still didn't
> manage to correctly copy everything.
>
> The case that I had was that I incrementally send/received (with -p)
> backups to another disk.
> At some point in time I removed one of the older snapshots on that
> backup disk... and then had fs errors... as if the data would have been=

> gone.. :(
>
I had tried using send/receive once with -p, but had numerous issues.=20
The incrementals I've been doing have used -c instead, and I hadn't had=20
any issues with data loss with that.  The issue outlined here was only a =

small part of why I stopped using it for backups.  The main reason was=20
to provide better consistency between my local copies and what I upload=20
to S3/Dropbox, meaning I only have to test one back up image per=20
filesystem backed-up, instead of two.


--------------ms090006060201060207040606
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTI0MjA1ODAwWjBPBgkq
hkiG9w0BCQQxQgRAhsBsjui1zjx16x6z9F9XqhGxTviXzjuOfI15XceWHUjIPhZPu4bCYkwW
zHS3WoRXbBvxXyyOr1i7EXHZQJDb/zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBWOohGcL4kzHV3/qbHFjew8pt8yjSkEpQBkeaEfokroztSGd36
SBbSU62vOJGuPBkeCInCM61rqoBjgdBtL5513DJYh+N9r7e7nbCC9P1/2lwb8Lfvo4hoqwKD
BXyE+tMp1lMH+OxN8LNW0EhWWrHOLaKRdnUx4Bg46dDW3uAIShRNvmkNpqt1W1eGJgGv8fUa
xYh4GSbZKnkpG4VKX8P07NdELkTJ+4FgjuMcjrxSUo2MP9ZXunOLiIfXGeLlruzOzw6k+jaV
lfpfTjP5s8uGHJLk9QZy2VkgTVpgJ2ChLAnhuGBfJJtZDdJdi4Cj2datm5sVTDgthI01n0om
8tY/ZNMPp49qqql9+95tTDz/Oulj0KTQLaUgJTY+kqi8A5u1Nb+qA7K1PQMoiN86Waw9MYDN
pC5p3nApcNUEycEKcTnOe/ujBJRnZ2VEsbIKCkDCCKbqi+aTiQ4eTUJeQ5E6u088AuIMyrmq
oSsZWO11H7QQ1wfdabyhbb6vSGaoDJ9DLF7jBVkjuvtd+0NnH/HgJNmcQkbJQuDh84/mFoXf
gkQDF1vxNAMH/SpOUjD7dty6VAMUAT6W18IJ/O8GkB54ZmebldT1rsiS6zllPnvChcP8jEBa
lwFqj2r6S5hxu4io/K8uIQhKvIVDrUzOuzIkOCkcgx1SoY2YMVZRdJkLswAAAAAAAA==
--------------ms090006060201060207040606--
