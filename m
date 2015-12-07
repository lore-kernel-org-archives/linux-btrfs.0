Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35047 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbbLGM6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 07:58:19 -0500
Received: by ioc74 with SMTP id 74so179475648ioc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 04:58:17 -0800 (PST)
Subject: Re: Very various speed of grep operation on btrfs partition
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CABXGCsMYdfSpZeUbWut1p542XA-L99iXM0Ero8tAFVhU9xhzkw@mail.gmail.com>
 <56618E4A.2000905@gmail.com>
 <CABXGCsONoHDYX-deg=2s5xNsQ1XjrL=o1t4CbRJqEt=TR4y5Zw@mail.gmail.com>
 <pan$32096$b80946db$17712ee2$b02a79d4@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56658265.2000109@gmail.com>
Date: Mon, 7 Dec 2015 07:58:13 -0500
MIME-Version: 1.0
In-Reply-To: <pan$32096$b80946db$17712ee2$b02a79d4@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070504090000050608000804"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070504090000050608000804
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-06 22:32, Duncan wrote:
> FWIW, I build kde without the semantic-desktop stuff even enabled at
> build-time (gentoo offers that option) here.  All the kdepim stuff (kma=
il,
> etc) uses it, so I dumped the several kdepim related apps (kmail,
> akregator, kaddressbook) I used here and found alternatives.  I don't
> normally need the indexing, which only takes space for the index and
> lowers performance, so it's all turned off at build-time.
Personally, I just avoid both KDE and GNOME.  For me efficiency is most=20
important, and XFCE beats both at that (I've done testing between the=20
three on my laptop with equivalent settings, and XFCE gives me about=20
50-70% more battery life than either KDE or GNOME, and a much smaller=20
memory footprint), followed closely by lack of lock-in (both GNOME and=20
KDE have a very 'all or nothing' feel to them, and in the case of GNOME, =

it really is all or nothing).  I do have to say though, Okular is by far =

the best document viewer available for Linux.
>
>> A day later noticed that the effect of the cache is missing:
>> real 4m33.940s user 0m0.862s sys 0m1.711s
>
> That's probably due to something knocking it out of cache overnite.  If=

> you have a cronjob running nitely to update the locate-variant database=
,
> for example, as many distros do by default, that'd do it, as that scans=

> pretty much the entire filesystem, typically many times the size of RAM=
,
> thus trashing cache.
>
> The indexer could potentially wipe out cache too, particularly on lower=

> memory machines, if it's actively indexing files, as that would normall=
y
> pull what it's indexing into cache, throwing something else that hasn't=

> been used for awhile away, unless the indexer is smart enough to do
> direct access and thus not disturb cache, since it's single-time access=

> and caching it isn't going to do anything but force stuff from cache yo=
u
> use more frequently.
Somehow I doubt that the indexer is using O_DIRECT, while that bypasses=20
cache, it also makes things really slow, which is directly counter to=20
their intent to finish indexing as fast as possible (supposedly to=20
minimize performance impact, but that's at odds with their behavior of=20
trashing the cache).  That, and the slowest part of indexing is calling=20
stat() on everything (stat is one of the slowest filesystem related=20
system calls, and is in general usually near the top of the list of=20
calls to avoid when doing real-time work, or for that matter anything=20
that needs to be fast).
>
>> As I understand to solve my problem just need to do the cache is alway=
s
>> effective, even if memory occupied by other applications.
>>
>> Is possible to specify minimal size of disk cache?
>
> AFAIK, not directly.  What happens is that rather than leave the memory=

> empty, the kernel caches stuff as it reads it.  If the memory is needed=

> for apps, it's reclaimed from cache and used for apps.  So Linux system=
s
> tend to run close to zero really free memory, unless you just dropped
> caches or rebooted, or you just used some memory hog and it's done and
> just freed its memory, and you haven't read enough files since then to
> fill that memory back up with cache.
Yep, there's no direct way to force it to a fixed size.  Personally I=20
would love to be able to reserve some fixed amount of RAM for disk=20
caching, but I also usually run with _a lot_ of swap (usually on the=20
order of 4 to 16 times physical RAM, I do work sometimes on really big=20
images).
>
> However, if you're running swap, there's an adjustment, file
> /proc/sys/vm/swappiness, but would be set on most distros using the
> sysctrl config (/etc/sysctl.conf and/or /etc/sysctl.d/*), 0-100, that
> normally controls the balance preference between swapping apps out to
> keep cache (nearer 100) vs. dumping cache to keep more apps in RAM
> instead of swapped out (near 0). IIRC the default is 60.
You may also want to look into /proc/sys/vm/vfs_cache_pressure as well,=20
the lower that is, the less likely it is that pages in the filesystem=20
cache will be reclaimed.  This tends to have a bigger impact if all you=20
care about is the filesystem cache.  Don't set it below about 50 though, =

otherwise it becomes very easy to run the system out of memory.
>
> Obviously if you're not running swap, all app memory must be kept in
> physical RAM as it can't be swapped out, and cache simply uses what's
> left.
>
>> Pity that I can't do 'echo 3 > /proc/sys/vm/drop_caches' on Windows
>> machine. It be interesting how fast grep would be work without cache.
>
> FWIW, I jumped off of MS when they started shipping malware[1] as part =
of
> the OS, with eXPrivacy.  So I've no idea if they've something similar,
> tho I'd be somewhat surprised if they didn't, at least as some obscure
> and possibly undocumented system call, so you'd have to call it from a
> program written for that purpose, instead of having it exposed such tha=
t
> any admin with suitable privs can do it with a single line command usin=
g
> only shell builtins, as Linux does.
Windows has no way that I know of outside of kernel mode to force the=20
filesystem cache to be dropped.  I'm not sure if installing Cygwin and=20
running sync from that works or not, but that's really the only thing I=20
know of that might do it.



--------------ms070504090000050608000804
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA3MTI1ODEzWjBPBgkq
hkiG9w0BCQQxQgRAXbfuGDLOonqJX/vfLVfhB6pmL3lFUL10cKtoxwwUPr8LwC1+EUoX4bMd
DglBGZ/E7vWmRmEvJ5mM0a/xrpvgWjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA7e5D3W1WIzK0nsrh9PqtlTohr7gBZq1oUqLrPtY3rnC5hI3qA
ETU0dTpWsavVAIhylvitVfXlreXy6F4ekvkKB+uMvsj5FIW3qurbgX3+hYDg8d84gDL0V4GZ
CNGkW2N3SRPXgh+CoWkd8OmxP/NFJmmPLu+m2TLXBQULhm1wNKXdmzMFrti6hqyKXyl3UjpZ
S4BHp5m/UJcXoAhsBUT8WGAIt7Rl+7L+lyHlLWZLprW+CvmUYCy/COQ6TskdTLVKPFbIiCby
NgT+Iq9e0149lFL/8+otxrGxAvUYoDTBsEiWDAEKY770CKLYc6/KAcDpQRlKEh5uOVu2uNYQ
3Lm4tqcfutoPNyhqJxxbDzpTh7rL8WFR9x4dZ0wCNTeZt8eoB3SY8PopxGrZZa6mu4O16gkK
4rb0dtsVdPPOCMutZneA48R3M6ZcSNMbJ6fhN1Y1TBAniEioMus9WAXa8OQ08IROyCoonttk
fVzMb4B/1VudwX8JGj01dtJw7S61vEXcD/I81RNyZIydFQwhD0RVt5cfDS152dcz0CXWbq8t
N9YazJIlKLGQ8jJx2j6Br87Lo0n9BvBjUUtElnf/CMqtMZ6k8SwIQmOYoooMmT4h72D27pqN
RhTtOCj/11MKI1ddPeLJ89EcDW+ndDa1Z7A2P3b8DwdI7jmRNIMVKNXhOQAAAAAAAA==
--------------ms070504090000050608000804--
