Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36853 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbbIPTVd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 15:21:33 -0400
Received: by ioii196 with SMTP id i196so240418042ioi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 12:21:32 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: Martin Tippmann <martin.tippmann@gmail.com>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
 <CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F9C136.3080800@gmail.com>
Date: Wed, 16 Sep 2015 15:21:26 -0400
MIME-Version: 1.0
In-Reply-To: <CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080004020807080104080500"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080004020807080104080500
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-16 12:45, Martin Tippmann wrote:
> Hi,
>
> 2015-09-16 17:20 GMT+02:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
> [...]
>> 3. He's testing it for a workload is a known and documented problem fo=
r
>> BTRFS, and claiming that that means that it isn't worth considering as=
 a
>> general usage filesystem.  Most people don't run RDBMS servers on thei=
r
>> systems, and as such, such a workload is not worth considering for mos=
t
>> people.
>>
>> His points about the degree of performance jitter are valid however, a=
s are
>> the complaints of apparent CPU intensive stalls in the BTRFS code, and=
 I
>> occasionally see both on my own systems.
>
> Are there any conceptual or design properties that make btrfs perform
> worse in this workload compared to ZFS or F2FS that both do CoW and
> share some similarity?
ZFS has been around for much longer, it's been mature and feature=20
complete for more than a decade, and has had a long time to improve=20
performance wise.  It is important to note though, that on low-end=20
hardware, BTRFS can (and often does in my experience) perform better=20
than ZFS, because ZFS is a serious resource hog (I have yet to see a=20
stable ZFS deployment with less than 16G of RAM, even with all the fancy =

features turned off).

As for F2FS, it was designed from the ground up for high performance and =

efficiency.  BTRFS started (from what I understand) as more of an=20
experiment, and as such the original code was not particularly optimized.=

>
> If not then I still think (from a user perspective) it it still
> interesting too look where the difference is coming from? There is
> also a quite old talk with some unfortunate numbers for btrfs from the
> XFS developer Dave Chinner:
> https://www.youtube.com/watch?v=3DFegjLbCnoBw - is this already
> resolved? 2012 is 3 years ago.
That depends on what you mean by resolved.  In every test I've done that =

wasn't a specialized benchmark designed to simulate a particular=20
workload, I've gotten roughly equal performance between XFS and BTRFS=20
(YMMV of course, especially because my usecase is not very typical of=20
most people (primarily building software and running BOINC projects)).=20
I use BTRFS mostly because it makes online reprovisioning much easier=20
(you can't migrate an XFS filesystem to a new block device online, and=20
you also can't shrink one).

It's also worth noting that Dave Chinner usually comes forth with=20
numbers extolling the value of XFS when a new filesystem gets proposed.=20
  In my experience, for small scale usage, ext* gets better performance=20
than almost anything else, including XFS.
>
>  From reading the list I understand that btrfs is still very much work
> in progress and performance is not a top priority at this stage but I
> don't see why it shouldn't perform at least equally good as ZFS/F2FS
> on the same workloads. Is looking at performance problems on the
> development roadmap?
Performance is on the roadmap, but the roadmap is notoriously=20
short-sighted when it comes to time-frame for completion of something.=20
You have to understand also that the focus in BTRFS has also been more=20
on data safety than performance, because that's the intended niche, and=20
the area most people look to ZFS for.


--------------ms080004020807080104080500
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE2MTkyMTI2WjBPBgkq
hkiG9w0BCQQxQgRAlX/P/cGuejz7YrnJEv3/CgaQg5n+OPHU4+LwZzJWcNZGr19ukfWofqwI
NcuFNvgU1seFCBu9pZkEIoTvmJffKjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgCLozXZeezWlkq7kDHqL6/AV5FBqdpQ8z89SYILbB0PP2CCtCD9
LTVDtjD3jTurE7hmJiIO10Ef6eMylLCMuU4TyJbO9N5r0sZ015WNPoaAoVTLMmIhYLQ1CYiw
Rp/b7Kt3jq7gIgiA9tYMcW10/JTpK2IJKvSnrafdJZuULDZ5RpHs9u1gCMje033BroGgdQYX
Wp7aURkhcLV+ouBGxvaiBUpSTFGzhx1bkATg460f5IZl6BogJWZJ+3VGpwZK5HISsLX8LSpz
oWYS5uPZK+fwOLDtaXTtGpPhVNuImcNjlC2t683aBVpCaCv1x4hEsZIynARO6UwXICbV/fLM
k6qZsEAc/RrCx7tWmVjDkU6DswXf2MDiQ+KZIEHIjcTb7sZRszEK9mweAwCW7YqBtt2U6V38
mKPU9KshNQqm/6nPMPNWE+eHwV7XY7iAQQru8iiB5o9l0eNqBgQy/oK9RD5E6Mes9/sce8ZV
a+OpSb5bzVGe/jdI0NgyLe2nXnPMAOeP0hYwiDU9bly2wW2LL2imqgthWrQ3WebTqglcAqbp
ducLLOns1+XP7LZPecyyjoiKVzZ67P0O1VXQgxLGOcLUAOfnRYWwxgAi8YJ7TU4C+pT2LEfQ
ZU9/nEkUcYqXHl22pR8RM2Hiqshoee5WIc7SFiWsSWEIm0qy8vgVIkCYogAAAAAAAA==
--------------ms080004020807080104080500--
