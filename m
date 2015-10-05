Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36345 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbJELyf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 07:54:35 -0400
Received: by qkcf65 with SMTP id f65so67210095qkc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 04:54:34 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Lionel Bouton <lionel-subscription@bouton.name>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <55F88ECC.1040604@menke.ac>
 <201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
 <201510031832.17802.russell@coker.com.au>
 <pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net> <56111598.2080403@bouton.name>
 <56125BF3.10700@bouton.name>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <561264F0.4030207@gmail.com>
Date: Mon, 5 Oct 2015 07:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <56125BF3.10700@bouton.name>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090105080006010400080302"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090105080006010400080302
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-05 07:16, Lionel Bouton wrote:
> Hi,
>
> Le 04/10/2015 14:03, Lionel Bouton a =C3=A9crit :
>> [...]
>> This focus on single reader RAID1 performance surprises me.
>>
>> 1/ AFAIK the kernel md RAID1 code behaves the same (last time I checke=
d
>> you need 2 processes to read from 2 devices at once) and I've never se=
en
>> anyone arguing that the current md code is unstable.
>
> To better illustrate my point.
>
> According to Phoronix tests, BTRFS RAID-1 is even faster than md RAID1
> most of the time.
>
> http://www.phoronix.com/scan.php?page=3Darticle&item=3Dbtrfs_raid_mdadm=
&num=3D1
>
> The only case where md RAID1 was noticeably faster is sequential reads
> with FIO libaio.
Part of this is because BTRFS's built-in raid functionality is designed=20
for COW workloads, whereas mdraid isn't.  On top of that, I would be=20
willing to bet that they were using the dup profile for metadata when=20
testing mdraid (which is the default when using a single disk), which=20
isn't a fair comparison because it stores more data in that case than=20
the BTRFS raid.

If you do the same thing with ZFS, I'd expect that you would see similar =

results (although probably with a bigger difference between ZFS and=20
mdraid).  A much better comparison (which _will_ sway in mdraid's favor) =

would be running XFS or ext4 (or even JFS) on top of mdraid, as that is=20
the regular usage of mdraid.

Furthermore, there is no sane reason to be running BTRFS on top of a=20
single mdraid device, thus this was even less of a reasonable=20
comparison.  It is worth noting however, that using BTRFS raid1 on top=20
of two md RAID0 devices is significantly faster than BTRFS RAID10.
> So if you base your analysis on Phoronix tests when serving large files=

> to a few clients maybe md could perform better. In all other cases BTRF=
S
> RAID1 seems to be a better place to start if you want performance.
> According to the bad performance -> unstable logic, md would then be th=
e
> less stable RAID1 implementation which doesn't make sense to me.
No reasonable person should be basing their analysis on results from=20
someone else's testing without replicating said results themselves,=20
especially when those results are based on benchmarks and not real=20
workloads.  This goes double for Phoronix, as they are essentially paid=20
to make whatever the newest technology on Linux is look good.
> I'm not even saying that BTRFS performs better than md for most
> real-world scenarios (these are only benchmarks), but that arguing that=

> BTRFS is not stable because it has performance issues still doesn't mak=
e
> sense to me. Even synthetic benchmarks aren't enough to find the best
> fit for real-world scenarios, so you could always find a very
> restrictive situation where any filesystem, RAID implementation, volume=

> manager could look bad even the most robust ones.
>
> Of course if BTRFS RAID1 was always slower than md RAID1 the logic migh=
t
> make more sense. But clearly there were design decisions and performanc=
e
> tuning in BTRFS that led to better or similar performance in several
> scenarios, if the remaining scenarios don't get attention it may be
> because they represent a niche (at least from the point of view of the
> developers) not a lack of polishing.
Like I said above, a large part of this is probably because BTRFS raid=20
was designed for COW workloads, and mdraid wasn't.



--------------ms090105080006010400080302
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA1MTE1NDI0WjBPBgkq
hkiG9w0BCQQxQgRA8+i5Q8lsd794W6tyK2modsN6aKoma8bN2uLBm3REXlpdZhNtjns2ArfI
FrDEoNEOOBQ4HbtQl/37ra7DfzaxNjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA/xv6qAFWegQOj5D4REQ3CYe9crcsaUlMMSM0h3hW1ftAGXDru
xXlxTxHXBQRR1Mbx9Dfw6LwZpFhZiIGm+E39jAXynsUmLJ8gTdBRpLhD4qJllksopuaFOai5
p2zzDIPTHNnil9oSEfBTTMO9E6O22RX1Tdevv+NYSCce9W9rktM/GZTok6J4JQ5i+9+SBbh3
LM6Q0P9ZDHpJTLGA9giFzhD5ZXaCT5fgMxk/is79a0dfejv9IC1N+DeYQtc+wI8SDYZH8ynC
UxOvMG3rMZ7uYnd5n5Z/wveda3tA+q3NVqkMHYfxBOtoJ5DmmM+PRXEYNSfGICd/ngsoR/X2
P85OHw9v5Pn4/+QdhH7Pn5fwsSJ0Xk71r3BoglwqYGbwS5VsoE6Ufx1/lT6VIB6U3Igftrvr
wAl95nt1UQDUy4Z7OTnsEzcpCdTRF+t6cF4KdvQF1X7zc7vUqjb6/THzkC+6bf1lpCnnOoYl
Xym4vH/h05YkLiCC7LgNgYigSYXHs/X3FAMgoRChpT8SriwkH57PJItwge1Erq/oPMPqa04K
RBqThORUh2IJw8uroUulCoqyxEwRpOQnrTy1X9S0nTVJG0hbUKoGrwXkewgDb4h1X4tu67X3
QeVDg91EIuhVkz7DxiKccWsao/rXCmhUGcKo9Gp+cj8Y394ikQVXCIUXJAAAAAAAAA==
--------------ms090105080006010400080302--
