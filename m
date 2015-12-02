Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37187 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbbLBOtQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 09:49:16 -0500
Received: by igcto18 with SMTP id to18so32898449igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 06:49:15 -0800 (PST)
Subject: Re: compression disk space saving - what are your results?
To: Tomasz Chmielewski <tch@virtall.com>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
 <565EEC1F.7070600@gmail.com>
 <18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565F04E1.6000003@gmail.com>
Date: Wed, 2 Dec 2015 09:49:05 -0500
MIME-Version: 1.0
In-Reply-To: <18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070601040303060304090801"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070601040303060304090801
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 08:53, Tomasz Chmielewski wrote:
> On 2015-12-02 22:03, Austin S Hemmelgarn wrote:
>
>>>  From these numbers (124 GB used where data size is 153 GB), it appea=
rs
>>> that we save around 20% with zlib compression enabled.
>>> Is 20% reasonable saving for zlib? Typically text compresses much bet=
ter
>>> with that algorithm, although I understand that we have several
>>> limitations when applying that on a filesystem level.
>>
>> This is actually an excellent question.  A couple of things to note
>> before I share what I've seen:
>> 1. Text compresses better with any compression algorithm.  It is by
>> nature highly patterned and moderately redundant data, which is what
>> benefits the most from compression.
>
> It looks that compress=3Dzlib does not compress very well. Following
> Duncan's suggestion, I've changed it to compress-force=3Dzlib, and
> re-copied the data to make sure the file are compressed.
For future reference, if you run 'btrfs filesystem defrag -r -czlib' on=20
the top level directory, you can achieve the same effect without having=20
to deal with the copy overhead.  This has a side effect of breaking=20
reflinks, but copying the files off and back onto the filesystem does so =

also, and even then, I doubt that you're using reflinks.  There probably =

wouldn't be much difference in the time it takes, but at least you=20
wouldn't be hitting another disk in the process.
>
> Compression ratio is much much better now (on a slightly changed data s=
et):
>
> # df -h
> /dev/xvdb       200G   24G  176G  12% /var/log/remote
>
>
> # du -sh /var/log/remote/
> 138G    /var/log/remote/
>
>
> So, 138 GB files use just 24 GB on disk - nice!
>
> However, I would still expect that compress=3Dzlib has almost the same
> effect as compress-force=3Dzlib, for 100% text files/logs.
>
That's better than 80% space savings (it works out to about 83.6%), so I =

doubt that you'd manage to get anything better than that even with only=20
plain text files.  It's interesting that there's such a big discrepancy=20
though, that indicates that BTRFS really needs some work WRT deciding=20
what to compress.



--------------ms070601040303060304090801
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAyMTQ0OTA1WjBPBgkq
hkiG9w0BCQQxQgRAthJWzvIG6MFQBsrC5SGZlgM5ptjWVwaxVuSp4xzsaUMZOaIb/qboN+7A
QM70CReFE3WzNpmuvgFQOG/mfEHiHTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCZIo8XY4cutNrPvh9pxVioNgJ3VSv8kElO4JcHMt13Q/MAbgRW
aHPW2QdF/JMNgCzYzbXYBiToFWI2v57FWrNnidVp2rPDUGyUUNI4YH3Lh7Z6aWON/1URiGO9
RsQJyBwBZAxWILmyAoEO29I2FYkvjtfVszKqKj4spBCVbSr8TG1r0Sk1dsKtZFiZap3/hM22
jzuTKSZDgAJiwMq8nHydm6NAO9iyK016fMR1IYmDmktxQBcXB2hPU0uULFLyAfjZ76MGCppb
jk3dkhaaWLR9vOgWqMQzN+EBSJtC/1w7X60uMJv+pNUxAQBr4L75eSHoK8JGXsy7o0pHNk89
pfmCTl6VHVvhqtxpHkiTnO034YT4bGIOZx3Bsc/Dr+vWt8LezquSWa0eg8m7hEAu6yfPWcW0
GBv185Kc9Yxz6pQSa/fb1RzTbA0oQc6uJdQpo+jOZe4vPTsDxx/rNX6eNkNgXUFGMHGvsccf
liilKCcx0vF8V0vDgNRA0krxWuR6tktWZExlF4oZuBhHSaCtv6EQjOZbDg9BilK4v2hgve6V
f7ROBpeZzZsXH+qEZj5ZrEuz4cLg93j7o6c46UpCgkeoKw/Cl/ec12RC5gcRJz2Cwsb4Ctp3
x8FMvRFbDKWupMYQ8JKKT0S8rBcEI+idHUNZ7fmsqnbUWtKs0zSNHw5I9QAAAAAAAA==
--------------ms070601040303060304090801--
