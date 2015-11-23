Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33145 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbKWM72 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 07:59:28 -0500
Received: by iouu10 with SMTP id u10so188442353iou.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 04:59:28 -0800 (PST)
Subject: Re: btrfs: poor performance on deleting many large files
To: Mitch Fossen <msfossen@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56530DAD.9080607@gmail.com>
Date: Mon, 23 Nov 2015 07:59:25 -0500
MIME-Version: 1.0
In-Reply-To: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020709000902080701080109"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020709000902080701080109
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-22 20:43, Mitch Fossen wrote:
> Hi all,
>
> I have a btrfs setup of 4x2TB HDDs for /home in btrfs RAID0 on Ubuntu
> 15.10 (kernel 4.2) and btrfs-progs 4.3.1. Root is on a separate SSD
> also running btrfs.
>
> About 6 people use it via ssh and run simulations. One of these
> simulations generates a lot of intermediate data that can be discarded
> after it is run, it usually ends up being around 100GB to 300GB spread
> across dozens of files 500M to 5GB apiece.
>
> The problem is that, when it comes time to do a "rm -rf
> ~/working_directory" the entire machine locks up and sporadically
> allows other IO requests to go through, with a 5 to 10 minute delay
> before other requests seem to be served. It can end up taking half an
> hour or more to fully remove the offending directory, with the hangs
> happening frequently enough to be frustrating. This didn't seem to
> happen when the system was using ext4 on LVM.
Based on this description, this sounds to me like an issue with=20
fragmentation.
>
> Is there a way to fix this performance issue or at least mitigate it?
> Would using ionice and the CFQ scheduler help? As far as I know Ubuntu
> uses deadline by default which ignores ionice values.
This depends on a number of factors.  If you are on a new enough kernel, =

you may actually be using the blk-mq code instead of one of the=20
traditional I/O schedulers, which does honor ionice values, and is=20
generally a lot better than CFQ or deadline at actual fairness and=20
performance.  If you aren't running on that code path, then whether=20
deadline or CFQ is better is pretty hard to determine.  In general, CFQ=20
needs some serious effort and benchmarking to get reasonable performance =

out of it.  CFQ can beat deadline in performance when properly tuned to=20
the workload (except if you have really small rotational media (smaller=20
than 32G or so), or if you absolutely need deterministic scheduling),=20
but when you don't take the time to tune CFQ, deadline is usually better =

(except on SSD's, where CFQ is generally better than deadline even=20
without performance tuning).
>
> Alternatively, would balancing and defragging data more often help?
> The current mount options are compress=3Dlzo and space_cache, and I wil=
l
> try it with autodefrag enabled as well to see if that helps.
Balance is not likely to help much, but defragmentation might.  I would=20
suggest running the defrag when nobody has any other data on the=20
filesystem, as it will likely cause a severe drop in performance the=20
first time it's run.  Autodefrag might help, but it may also make=20
performance worse while writing the files in the first place.  You might =

also try with compress=3Dnone, depending on your storage hardware, using =

in-line compression can actually make things go significantly slower (I=20
see this a lot with SSD's, and also with some high-end storage=20
controllers, and especially when dealing with large data-sets that=20
aren't very compressible).
>
> For now I think I'll recommend that everyone use subvolumes for these
> runs and then enable user_subvol_rm_allowed.
As Duncan said, this is probably the best option short term.  It is=20
worth noting however that removing a subvolume still has some overhead=20
(which appears to scale linearly with the amount of data in the=20
subvolume).  This overhead isn't likely to be an issue however unless a=20
bunch of subvolumes get removed in bulk however.



--------------ms020709000902080701080109
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIzMTI1OTI1WjBPBgkq
hkiG9w0BCQQxQgRADZk402SkR1TjPw8vWO4oPSp+OmKFrZpkFbzDffwC0ts/9ksR9QFELaP7
+5YsuKldZRNjfmMTnOORiE4dQQhC8jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA+2gEkrCYH64nJib53n8ltvaEYXHt/nSU8WSwcWbEwyEA/11Xb
+qiYoqsv/TEXcxDxbpIsNJ3GvujYP7LVZI3JJem4mcpN/nuA9OJxcnXZqootoaNoZRcn4a4u
oVCTS28gBhwVfie3iaaNn6c1lr7D2hqdKxt1BdF3Xuh+4sAUZ/kbuE1taETLZneoEMStFzAA
LHf4OUoJYexfrhrmR96p+AUmybW4zR2+b3d2oK5Ofsbxj89Dp80Zj3kYgBbQVDnVpR3iZ6r1
1XQTuhEnv87eRgXv9+0u8NR9xbCSToJoTH29Pq7+A0+mY0/9had8SEGQv9zGS4CagJDQYVVn
/vocv2ZBpwp1Y0OiPGGHWfh48e2GHPvpC8YGWdq7/BQQtiwTawZ2De0ldV1sKw5WYjcLDYEl
2NSwbf6Mfhwd/zLdhRlsxeKOGaBLf1ylnXFIcsr4tZnLatF/YhamR1VXGDuL+jCjeTNr/rR1
NW58Ew0utG1GqQJnjQXXzUX0tYfZ+6qW7r29NpkwJATFoRTkbqG1GMs1AJ2dSkPtXED79iWM
pN2qXo0Pgp1DXhsCFiCH71ijaujxAHiySt/aM1gjG0DO2pwh4bJdVXoGKtdkOL6/Jzp+s+kw
8/GsOGOb+6ymffbwF1aqQ6VaENGge5FIMMqa+ug19ZYGgLcd5rm1dp/6uAAAAAAAAA==
--------------ms020709000902080701080109--
