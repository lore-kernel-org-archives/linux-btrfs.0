Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35610 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbbHYOxM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 10:53:12 -0400
Received: by iodt126 with SMTP id t126so189824105iod.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 07:53:11 -0700 (PDT)
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
To: =?UTF-8?Q?Miguel_Negr=c3=a3o?=
	<miguel.negrao-lists@friendlyvirus.org>,
        linux-btrfs@vger.kernel.org
References: <loom.20150825T151154-787@post.gmane.org>
 <55DC74E2.9000909@gmail.com> <loom.20150825T161809-326@post.gmane.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DC8151.1020203@gmail.com>
Date: Tue, 25 Aug 2015 10:53:05 -0400
MIME-Version: 1.0
In-Reply-To: <loom.20150825T161809-326@post.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040205090808070702030003"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040205090808070702030003
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-25 10:26, Miguel Negr=C3=A3o wrote:
> Austin S Hemmelgarn <ahferroin7 <at> gmail.com> writes:
>
>> One comment I would like to make about this: I have heard numerous
>> stories of OCZ brand SSD's having significant data corruption issues
>> (along the lines of writes returning successful when they really faile=
d,
>> and blocks that are in use getting randomly erased) that can cause
>> severe data loss and filesystem problems.  While I do think that btrfs=

>> needs to be improved when faced with such things, I would not at all b=
e
>> surprised if the SSD was the root cause of the issue.
>>
>>
>
>
> It did have some corruption through its 3 year life time. This was from=
 one
> month ago:
>
> sudo btrfs device stats /
>
> [/dev/sda5].write_io_errs   0
> [/dev/sda5].read_io_errs    0
> [/dev/sda5].flush_io_errs   0
> [/dev/sda5].corruption_errs 996
> [/dev/sda5].generation_errs 0
>
> On the latest scrub that I took note of the results though, it didn't h=
ave
> corruption:
>
> sudo btrfs scrub status /
> scrub status for f2e4e4d3-2d8e-4764-a818-de9176405c4b
> 	scrub started at Fri Apr 17 14:42:47 2015 and finished after 146 secon=
ds
> 	total bytes scrubbed: 66.10GiB with 0 errors
IIRC, scrub (or at least the old versions) only reports the errors it=20
finds, not cumulative ones (hence the device stats sub-command), so I'd=20
still suggest being cautious.



--------------ms040205090808070702030003
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI1MTQ1MzA1WjBPBgkq
hkiG9w0BCQQxQgRAs8OVmbGJabUbZoeBPo3rBrFFi9TZu3ixne+++hOOa82iFn/MXfua/sYP
ri9fxQGs0dJvG+gmP2aKihrPWJZw7TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBn5GtHhiVW/2Rd0Oe5CBbOZCs8OfTSR8KNyiNVcrHgUl/cfOV+
XOX1hnhtk9MP5ZLtOeJjombvWSvpgTtz+3TcKeRktg+DdXJrxTkGFEcLT64d6cPHw0bEiKfM
p+EYaTI0yqZJDFzKYfNq6iADC0yO337x5l3BPC7JgStNxqdoHY6926rhEkmEimY6cJbcCuxi
RfOcvljY+kb5aPOb6hQydzX9Yc6rlFenpRBW/QvPTpC5WopkdmmMhLsLBnSIWjkflSfTAtnX
KlRBUgRvXfFe5aiCFBaUbAfnfNEZOF96pENzaHYS9VXPsMZRKX/lbVaQeBNDa3QxMGxfbTYt
yx0YjV/6X7MA+ge2tg0RUY7ZBvAeJ8qE2pC3Q4mDxm8D/z1CIJU5ROtpqP+BcSzPdlz/vzbw
jpuCY+zfopj+ryJMKl49GTuvcQDPYMTAozr7bqRo3OeO0T5TCSnN2FvnA7YEhstuDGtBq1KQ
Gc/eXhFvRA8NCXeaibcbc3x8VzudiIWuRX8wW61iQPIZ4e5zCN0SsFYWbiPEUrxVmIkR7Xe9
NY0N2VyAEMyUbiqWTFoCbZyoyHVNLj3Dr1gEnzQEGVEP1LpO5K9rZhDxNqzCCBXTqJn3wVNZ
/8ccGF5Ehg1O2VqY7/73opzzOXeoTMpM6zvhQIlmhUO/yjJfRkdeMYtWpgAAAAAAAA==
--------------ms040205090808070702030003--
