Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38867 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbHTMCU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 08:02:20 -0400
Received: by igfj19 with SMTP id j19so28665318igf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 05:02:20 -0700 (PDT)
Subject: Re: Btrfs is amazing! (a lack-of-bug report)
To: Tyler Bletsch <tyler.bletsch@gmail.com>, linux-btrfs@vger.kernel.org
References: <55D1567B.3030809@gmail.com> <55D1CA1E.1060103@gmail.com>
 <55D23397.6090404@gmail.com> <55D31A3C.3080208@gmail.com>
 <55D4BBBB.9000008@gmail.com> <55D5BF80.500@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D5C1BC.2080507@gmail.com>
Date: Thu, 20 Aug 2015 08:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <55D5BF80.500@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060904090309010402060807"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060904090309010402060807
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-20 07:52, Austin S Hemmelgarn wrote:
> On 2015-08-19 13:24, Tyler Bletsch wrote:
>> Thanks.  I'd consider raid6, but since I'll be backing up to a second
>> btrfs raid5 array, I think I have sufficient redundancy, since
>> equivalent to raid 5+1 on paper. I'm doing that rather than something
>> like raid10 in a single box because I want the redundancy of a second
>> physical server so I can failover in the event of a system-level
>> component failure.
>>
>> (And of course, "failover" means "continue being able to watch TV show=
s
>> and stuff")
>>
>> A question about what you said -- when you say people have hit bugs in=

>> the raid56 code, which flavor do these bugs tend to be? Are they
>> "minding my own business and suddenly it falls over" bugs or "I tried =
to
>> do something weird with btrfs and it screwed up" bugs?
> More along the lines of 'I tried to do something that works fine with
> the other raid profiles and it kind of messed up the filesystem'.  In
> general, you should be safe as long as you are using at least Linux 4.0=

> and the most recent version of btrfs-progs.  It's been a while since I
> saw any raid56 related bugs that caused actual data loss.  If you are
> using this on SSD's though, I would wait, there are known issues with
> DISCARD/TRIM not working correctly on btrfs right now (nothing involvin=
g
> data loss, just problems with it not properly trimming free space and
> therefore causing issues with wear-leveling), and it looks like the fix=

> won't be in 4.2 as of right now.
>
>
On second thought, you might want to wait until 4.3, I just saw this thre=
ad:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/47321/focus=3D47325=



--------------ms060904090309010402060807
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODIwMTIwMjA0WjBPBgkq
hkiG9w0BCQQxQgRAtSOuaQngBW/3O0WQcS0kttndD2xagnRbxHXhn5+IHo89W0qXK5R7qRN6
i3qJM47O6PWOlknrR3tCHOuja2vfEDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAJPoXxtAJF4yWt7zALhc4pSJa60F6D2xhqalPiA5ls6zBbV6lc
80A7YqFKrVyr4vVKyJZzyqRL0MJoYmHCLK+rGeTb07qoWCEJxyZUjshtcAin8GMm9v30J88c
/m74pkk52dZL4NqFbSx203r6CJ9gvt/wvk00R010mEBi0P2G8Pwxra8eGEU4CZfW6sbfprXU
eKHyRHPoMFWmBIQ9U+Z8D8fo/rBGHOFnfr4lS1Q+xLPiI+0SFc/PF6Nj85UrhoaLRPhHItMg
lDZVvKh+1SfSOHBtxNtMc1t0tLU+6wAEeHflv3xwxq5FQpV6NM0+jZ3fqUYPMm5vrJgKZETx
sIEG/vyYSO0+9daBitGkcttP295CeyaWtg4wxkvc6V9bgyxTvAvI0IrnmWi2h8qgIRcNgIfV
fh4/tetledtcNXk+zMPaO63630tBSiZFmheLCforBY+gxzuNQid24GVL6LU/roG+Yn0SMYab
9O4SbyBZ88GY0GahuwnH4KklUcNBiIRen0mg67vIGA2EgSHyz3au2VrSwx045ulyJFWF/uRL
G7Asf6Yc9nBDUF+6kg7EOOz/K9ZHqC977SCImqE4ouBtEE+ly1YN+Pblcr3R3Tanb5xs5qU0
1Scv2OwL4yUl+lD7rT99m/CW5ynldLxWTZAdz+mvphzEptT1/WEtdMSv+gAAAAAAAA==
--------------ms060904090309010402060807--
