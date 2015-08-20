Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33963 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbbHTLws (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 07:52:48 -0400
Received: by iodb91 with SMTP id b91so42587755iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 04:52:48 -0700 (PDT)
Subject: Re: Btrfs is amazing! (a lack-of-bug report)
To: Tyler Bletsch <tyler.bletsch@gmail.com>, linux-btrfs@vger.kernel.org
References: <55D1567B.3030809@gmail.com> <55D1CA1E.1060103@gmail.com>
 <55D23397.6090404@gmail.com> <55D31A3C.3080208@gmail.com>
 <55D4BBBB.9000008@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D5BF80.500@gmail.com>
Date: Thu, 20 Aug 2015 07:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <55D4BBBB.9000008@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000600080708020103060304"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000600080708020103060304
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-19 13:24, Tyler Bletsch wrote:
> Thanks.  I'd consider raid6, but since I'll be backing up to a second
> btrfs raid5 array, I think I have sufficient redundancy, since
> equivalent to raid 5+1 on paper. I'm doing that rather than something
> like raid10 in a single box because I want the redundancy of a second
> physical server so I can failover in the event of a system-level
> component failure.
>
> (And of course, "failover" means "continue being able to watch TV shows=

> and stuff")
>
> A question about what you said -- when you say people have hit bugs in
> the raid56 code, which flavor do these bugs tend to be? Are they
> "minding my own business and suddenly it falls over" bugs or "I tried t=
o
> do something weird with btrfs and it screwed up" bugs?
More along the lines of 'I tried to do something that works fine with=20
the other raid profiles and it kind of messed up the filesystem'.  In=20
general, you should be safe as long as you are using at least Linux 4.0=20
and the most recent version of btrfs-progs.  It's been a while since I=20
saw any raid56 related bugs that caused actual data loss.  If you are=20
using this on SSD's though, I would wait, there are known issues with=20
DISCARD/TRIM not working correctly on btrfs right now (nothing involving =

data loss, just problems with it not properly trimming free space and=20
therefore causing issues with wear-leveling), and it looks like the fix=20
won't be in 4.2 as of right now.



--------------ms000600080708020103060304
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODIwMTE1MjMyWjBPBgkq
hkiG9w0BCQQxQgRAxtv20hS7eJajz/1m/xt2RMJoCDBXPa4RqbaMQrsKhSZQ5AUmH3wHFZw8
dL09kv08ZfciP6vS4UeSpEz7TfjEdzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAFGqoBqFD1N945k6ZaUC9L+RZK0H4gpHcLp0F8WxnV6ZrkzxS+
R7TSko06rOm6Kl4vWHdjkhj91h1IItAPo518hx/2oqWUzfB1oGVucqIBW4ZvsYAU1XXymE8E
u5eI88EgUM8aFbd/Lh5k+1KKcAF3VoXW5+p1QIUjGQYbBvqeA0wCnOcWo3/+VTjhFTTEN6jE
6gZgxwEG0lzWHmSvlEFGeBQZjEbBq/Bu9P/hIJo8FL+RxbW+C8EsByuxwBM1XItz/4UEBbCq
z+LyG00TERrW1HnHdyN2fNRfX4YVE8KbW7LvwN/8SFDOcMrfiB+CogTAM5QhiJrBNr8M9ss1
PvLVJmJ8pd2LmCpmrhseHv72x97BkDgwB+1NrZr6m3NIIoXgsP1j7TLmsXcDpDiXypWPvPwn
8jMK4ydlCm9cgQMtyXxJM9k94Y5nB3YUbyXu6hXhdIOrLhHHj0WsN9iABN9Zd3Az1k6f1WUX
uu8O3p8Tf8Hq8h9KotuN+nvjA0/+TtWpEhDTV1+9cUds8XRM9n/zXM6zstsUYJG5mVPRF/9d
v1prDCeGt2KPVIpGbRXeaOL0KTAsuCWWsWHOf+V2NUJasZzCRuylAofmz6USCs3NGU93icyV
6q69j9CXM1hNRelR/vxJu1m4+o9HhA9TRsiS6P3ZhlKhE8UxX7Dnrr97qQAAAAAAAA==
--------------ms000600080708020103060304--
