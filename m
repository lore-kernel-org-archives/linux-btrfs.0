Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36649 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbKINu0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 08:50:26 -0500
Received: by iofh3 with SMTP id h3so18486494iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 05:50:26 -0800 (PST)
Subject: Re: btrfs-progs send | receive error: no such file or directory
To: Glen H <glen.hertz@gmail.com>, linux-btrfs@vger.kernel.org
References: <CABtZWNH4rzzTtBwvt6Xs+nf=8aiJrbsCAVZB3QzPEnEfi-Cs5A@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5640A497.2060701@gmail.com>
Date: Mon, 9 Nov 2015 08:50:15 -0500
MIME-Version: 1.0
In-Reply-To: <CABtZWNH4rzzTtBwvt6Xs+nf=8aiJrbsCAVZB3QzPEnEfi-Cs5A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070305000901060708060401"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070305000901060708060401
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-08 16:28, Glen H wrote:
> Hi,
>
> I really enjoy the features of btrfs but send|receive is failing me so
> my backups are not working.  I'm using "btrbk" to backup my drives
> (all local) and one of the three subvolumes errors out.  When I run
> this command from the terminal it errors out:
>
>> btrfs send /mnt/ssd/_btrbk_snap/@.20151108 | btrfs receive /mnt/backup=
2tb/
> At subvol /mnt/ssd/_btrbk_snap/@.20151108
> At subvol @.20151108
> ERROR: send ioctl failed with -2: No such file or directory
> ERROR: unexpected EOF in stream.
Have you ever run any kind of data deduplication (bedup, duperemove, or=20
something else) on the source filesystem?  I've seen errors like this in =

the past when trying to send from a filesystem that I had run=20
deduplication on (and I don't think that the patches to fix it made into =

the version of Mint you're using).

That aside, there are two things that I've found that can fix some (but=20
not all) send/receive errors:
1. Run a balance on the filesystem (either a full balance, or use=20
filters to select just the block in question).
2. Force the file that it's choking on to be re-written (you can use=20
'btrfs receive -vv' to see what files it's processing, although be=20
prepared for _a lot_ of output).



--------------ms070305000901060708060401
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTA5MTM1MDE1WjBPBgkq
hkiG9w0BCQQxQgRAeVGMzpIit0oUJK4gPHe4R1sJgtRbl6zusmX/m1lK0Kv7SssBXvu9gyiO
yS+oWxlg7iRAHKYuYaofLnTlg0DiwDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBBiQUaU850hq8rTz2dZyRXg2ZPtBOIG1B+suMeq95uFgxowYhh
SJajEUu+smYQD/reyQ4rVa6iAkFdcAw4T8wIQslaT7xiu97q0lYmkGxi1436Ox5fYrBUzi/B
HWo5V6jeb3lzl4mq9psxy9rzLu4pquWZFkuGoac1/qmbIU6IzywYKPOEeh8QFDnSgX1LmHZT
uchUG3TQffVOAzWrSRnmk6QgEblW2eZtWwyUknDUB2el/moEmcJfOvTSc7DNfsXz/dTHExqV
whSMk5fU0mETdG2rMrHuhlo/J4amarVj/fhRW055K0WxWfjsiRRbj1EzwxWxwIBfKQq4Q3Ok
WUlh3pvGFVWr+X3rXawr43mhfLMkxas8uAJ/TNMpV/poVTPbYLAXo4e6gyD2lNoinRESsrKE
JMbWFrlLowmz38DuUACO8VgKQfAwZipvodNy6O/NyiEJXv6VjGcX3KcCCVZ/VzyeoP3qa0r+
l3yAAopPn0OnkcXSInNBNbhkxXcosLmycEGfHEzpLgpvzJk0oSCaEF7UUEM+Wc7TDyrUNI1e
KsPwpReYQUJRMFuDA3N2V8XkJtHReJPB5Da1I57+t5BOJUwli7+huFpH+3QwckCWfmDTskov
xrhJrOOjzQB73pS8e2FtLZD2Y9HTfbAzjWDdN4dHP74jg7r8RFneA9taswAAAAAAAA==
--------------ms070305000901060708060401--
