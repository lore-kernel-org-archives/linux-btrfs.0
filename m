Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37726 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbbHRLeY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 07:34:24 -0400
Received: by igui7 with SMTP id i7so77272777igu.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 04:34:23 -0700 (PDT)
Subject: Re: The performance is not as expected when used several disks on
 raid0.
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
 <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
 <55CE4682.3080106@gmail.com>
 <CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
 <55CE4866.6060207@gmail.com> <pan$82931$bcf5ef1b$88d8d18$c8aa5770@cox.net>
 <55D1C7A5.7050204@gmail.com> <pan$9af23$4fb7d57c$d76038f$6f4281af@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D31831.1000404@gmail.com>
Date: Tue, 18 Aug 2015 07:34:09 -0400
MIME-Version: 1.0
In-Reply-To: <pan$9af23$4fb7d57c$d76038f$6f4281af@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070702090704030400010005"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070702090704030400010005
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-17 19:06, Duncan wrote:
> Austin S Hemmelgarn posted on Mon, 17 Aug 2015 07:38:13 -0400 as
> excerpted:
>
>> I've also found that BTRFS raid5/6 on top of MD RAID0 mitigates (to a
>> certain extent that is) the performance penalty of doing raid5/6 if yo=
u
>> aren't on ridiculously fast storage, probably not something that shoul=
d
>> be used in production yet, but it's how I've got the near-line backups=

>> setup on my home server system.
>
> As should be clear from my previous posts on the subject, I'm
> conservative enough not to be comfortable with the btrfs raid56
> implementation yet.  My recommendation has been, and remains, unless
> you're deliberately testing it in ordered to help find/report/workout
> bugs, give it a year after the nominally full implementation (3.19, so
> until 4.4), before expecting it to be reasonably as stable as the rest =
of
> btrfs (which itself isn't fully stable yet).
>
> But the almost-released 4.2 does seem to be past the initial nominally
> btrfs raid56 full-code bugs, and I'd call an intermediate level backup,=

> with working copies in front and itself backed up in back, a reasonable=

> first working (as opposed to testing) deployment.
Yeah, I've been ridiculously luck to have not hit _any_ of the raid56=20
related bugs.  In fact the only issue I've had with it was a result of a =

btrfs interaction with dm-thinp (if dm-thinp isn't set to zero newly=20
allocated blocks, btrfs sometimes loses it's mind during remount, which=20
in turn reminds me that I meant to check if this was fixed or not).

And the deployment you suggest is ironically how I use it, I've got my=20
root filesystem on btrfs raid1 across 2 SSD's, with a btrfs raid6 on top =

of LVM single volumes on a set of 4 1TB HDD's as a target for receive=20
(and configured such that I can directly boot any of the backups there), =

and then store compressed, encrypted tarballs of the Sunday backups on 3 =

different cloud storage services and an external 4TB HDD (It's wonderful =

how Gentoo lends itself so well to custom solutions).
>
> And yes, btrfs raid5/6 over mdraid0  would have the same general
> complementary nature as btrfs raid1/10 over mdraid0.
>
>> It may also be worth pointing out that
>> BTRFS raid6 lets you use 4 disks minimum, as opposed to most other rai=
d6
>> implementations that (unnecessarily, as a 4 disk RAID6 is not a
>> degenerate form) require 5.
>
> 4-device raid6, btrfs and mdraid both allow that, good point.  But of
> course mdraid6 doesn't have the data integrity, only rebuild-parity.
>
Huh, I didn't know that mdraid allowed that, I know dm-raid through LVM=20
doesn't (which in turn is a large part of what caused me to try btrfs=20
raid56 so soon, I had been going to do btrfs raid1 on top of LVM based=20
raid6).



--------------ms070702090704030400010005
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE4MTEzNDA5WjBPBgkq
hkiG9w0BCQQxQgRAMz0lV2BissYRE9mkDOe3aZt0xA9KHXmNAlTkZDFzdj0aVKvCzNWKb6tl
9B8/TNbDNaqmu1WPXk2yUhkCT4DmSTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBqe4+IIW6d6BZam2xTOL3WAN8rVh8tPfWB3CbUNmHIKhLdVKIs
jzYHH3m9BeyaA1ELeyh1Co60565PKMhAUpx4TVq7viZDfcsDpxSZNZBZ2VQq+6qM0nxtYUwL
KkJPgAVPV3hDI7G+Pubvgj2pS0/PAPp5mnWhn1bqSb5zUXkRWfzvK0jZAhBwu1nr85kO23Nc
aHZBmeeR3o2W68hEqT97gBK0PshX4jgXWsX3GzlFdP23HpfCJawb+LL5rfn/B/t6x0hdlHml
qvx9maLwfWoU7P/bWw61PfU0ZScUZKw780e7d+d3CONHbdFvSvE63QxzklfbXkyg7sDQI8Ns
WMpT903YscO6nbjWwlwZt8uw+Nqn5eKcxwC9Ev6Gk6dDed16zh4jvuSg3mnERzU2/O8FGIpR
bXXdn2k9JWgrWPIna6CtW+pMaXGUQdWjY0rhlttCOxzmJrm286IsdEiGHjX7cVjMH0Zp0NRt
s3AiNj5rpgUp4800mSCPT6Son/obryIZnX9oQn4N6kRZBs+ga523lralYz/yHoKRJsHr6m3d
YlZV+5FL8o5i0TXcOA5d7ZQxNKFpDNpBCjQgMQTmrqKpTvNG7Qit+clG7+IclYhWfyeqSCDC
WTohiHroqHUS4IEfPXkHedInL6n5SrAHZNQr3xy3uFtX0ra9qB1S2KeQnwAAAAAAAA==
--------------ms070702090704030400010005--
