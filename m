Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37589 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbbK3Uil (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 15:38:41 -0500
Received: by igcto18 with SMTP id to18so80313080igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 12:38:40 -0800 (PST)
Subject: Re: [RFC] Btrfs device and pool management (wip)
To: Chris Murphy <lists@colorremedies.com>
References: <565C01F1.5030108@oracle.com> <565C625C.7060503@gmail.com>
 <CAJCQCtQPdzQG0She3yjxAmDmXSAphdMriW11Pe=BMrBRXYTh6Q@mail.gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565CB3A2.30705@gmail.com>
Date: Mon, 30 Nov 2015 15:37:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQPdzQG0She3yjxAmDmXSAphdMriW11Pe=BMrBRXYTh6Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040700090901010402030207"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040700090901010402030207
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-30 15:17, Chris Murphy wrote:
> On Mon, Nov 30, 2015 at 7:51 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> General thoughts on this:
>> 1. If there's a write error, we fail unconditionally right now.  It wo=
uld be
>> nice to have a configurable number of retries before failing.
>
> I'm unconvinced. I pretty much immediately do not trust a block device
> that fails even a single write, and I'd expect the file system to
> quickly get confused if it can't rely on flushing pending writes to
> that device. Unless Btrfs gets into the business of tracking bad
> sectors (failed writes), the block device is a gonor upon a single
> write failure, although it could still be reliable for reads.
I've had multiple cases of disks that got one write error then were fine =

for more than a year before any further issues.  My thought is add an=20
option to retry that single write after some short delay (1-2s maybe),=20
and if it still fails, then mark the disk as failed.  This will provide=20
an option for people like me who don't want to need to immediately=20
replace a disk when it hits a write error.  (Possibly add some counter=20
in and if we get another write error within a given period of time, we=20
just kick the disk instead of retrying).  Transient errors do happen,=20
and in some cases more often than people would expect.  We should=20
reasonably account for this.

This discussion actually brings to mind the rather annoying behavior of=20
some of the proprietary NAS systems we have where I work.  They check=20
SMART attributes on a regular basis, and if anything the disk firmware=20
marks as pre-failure changes at all, it kicks the disk from the RAID=20
array.  It only kicks on a change though, so you can just disconnect and =

reconnect the disk itself, and it accepts it as a new disk as long as=20
the attribute didn't cross the threshold the disk firmware lists.  (I=20
discovered this rather short-sighted behavior by accident, but I've used =

the old disks in other systems just fine for months with no issue=20
whatsoever).
>
> Possibly reasonable, is the user indicting a preference for what
> happens after the max number of write failures is exceeded:
>
> - Volume goes degraded: Faulty block device is ignored entirely,
> degraded writes permitted.
> - Volumes goes ro: Faulty block device is still used for reads,
> degraded writes not permitted.
>
> As far as I know, md and lvm only do the former. And md/mdadm did
> recently get the ability to support bad block maps so it can continue
> using drives lacking reserve sectors (typically that's the reason for
> write failures on conventional rotational drives).
>
>
>
>> 2. Similar for read errors, possibly with the ability to ignore them b=
elow
>> some threshold.
>
> Agreed. Maybe it would be an error rate (set by ratio)?
>
I was thinking of either:
a. A running count, using the current error counting mechanisms, with=20
some max number allowed before the device gets kicked.
b. A count that decays over time, this would need two tunables (how long =

an error is considered, and how many are allowed).



--------------ms040700090901010402030207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTMwMjAzNzU0WjBPBgkq
hkiG9w0BCQQxQgRA1vuemwxTnTdyWW0n0PJK8DedWWG/9sfM09HagxPD5nKc5EYaIuDyPscK
+423ilUohaIAgwFvX/eLqU69oRscDjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBt8tWuPfHRaQYUZ7IhM1kIQkdHWjq3f2NRPbPwR3vjTpYvcPcv
ha3Haz4qT2rCx/wcJonWcn6q7xNEaRxfWRI9sW5xJCjz5HaJLjangyNqmVQQu3RqR48TIctX
BGX5bQTDPVbQOrJ/0oxAwD3rXtMCSjCbAHSEQSBDZTqb3bvwdrI6CfKKjj7sK9OYyrl+FrTA
qqcldMeCan4xk8HCLtuTFpOBtr6vt87H8rFrjVHBqpF3U/O+HirsmLys55kHMp7hI3ojidEe
I6D3QX9DrMoReVcVyPOysY2C1HZFLaAp9TkjFMIBGMzKhj2h8c28zhkz2zUZJ4gMwUXnhSxY
jvPDo6AsFbFz/hgZ+0H0YpFf0j6xZ8PJeDZ4BThXmsMwdBhJ+SqQu0E6bb+t0/wDRn41U5Oj
jOmoUDizRvmjlJ9zzkmyGMST1FguxLv/ozbzn3xygbHainPlBp3lw6GpVu1R75c+eBvF1O2a
QA6kq1k+P5I1jAqZrL47I/As0CsLH0XSmNo26f0mE/cUiYmEQcv2ShfJU01yf0wTYWjWhebt
KEA7YCmkG08x4QGV5pJYsgSgkrfySByCRUGLWPXKyaCEtQ+2Er7HU+2ohgigUwy2kM+BzO8C
8HcQyArEO7Aa75GORH45J51QwApLCIvu5Na4CJrjCYuvGBTCAygZmq9vvAAAAAAAAA==
--------------ms040700090901010402030207--
