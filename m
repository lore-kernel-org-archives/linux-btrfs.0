Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34219 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbbH1Mya (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 08:54:30 -0400
Received: by iofe124 with SMTP id e124so26103121iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 05:54:29 -0700 (PDT)
Subject: Re: Understanding BTRFS storage
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
 <20150826165024.05af044f@natsu> <55DDAB1C.90406@gmail.com>
 <pan$7fd63$2b2fd6ee$53e6fc05$7a0aab72@cox.net> <55DEFC36.5000608@gmail.com>
 <pan$9606c$9f08381a$d5df543d$2943921@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55E059EA.9040402@gmail.com>
Date: Fri, 28 Aug 2015 08:54:02 -0400
MIME-Version: 1.0
In-Reply-To: <pan$9606c$9f08381a$d5df543d$2943921@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010605030208090008050008"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010605030208090008050008
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-28 05:47, Duncan wrote:
> Austin S Hemmelgarn posted on Thu, 27 Aug 2015 08:01:58 -0400 as
> excerpted:
>
>>> Someone (IIRC it was Austin H) posted what I thought was an extremely=

>>> good setup, a few weeks ago.  Create two (or more) mdraid0s, and put
>>> btrfs raid1 (or raid5/6 when it's a bit more mature, I've been
>>> recommending waiting until 4.4 and see what the on-list reports for i=
t
>>> look like then) on top.  The btrfs raid on top lets you use btrfs' da=
ta
>>> integrity features, while the mdraid0s beneath help counteract the fa=
ct
>>> that btrfs isn't well optimized for speed yet, the way mdraid has bee=
n.
>>> And the btrfs raid on top means all is not lost with a device going b=
ad
>>> in the mdraid0, as would normally be the case, since the other
>>> raid0(s),
>>> functioning as the remaining btrfs devices, let you rebuild the missi=
ng
>>> btrfs device, by recreating the missing raid0.
>>>
>>> Normally, that sort of raid01 is discouraged in favor of raid10, with=

>>> raid1 at the lower level and raid0 on top, for more efficient rebuild=
s,
>>> but btrfs' data integrity features change that story entirely. =3D:^)=

>>>
>> Two additional things:
>> 1. If you use MD RAID1 instead of RAID0, it's just as fast for reads, =
no
>> slower than on top of single disks for writes, and get's you better da=
ta
>> safety guarantees than even raid6 (if you do 2 MD RAID 1 devices with
>> BTRFS raid1 on top, you can lose all but one disk and still have all
>> your data).
>
> My hesitation for btrfs raid1 on top of mdraid1, is that a btrfs scrub
> doesn't scrub all the mdraid component devices.
>
> Of course if btrfs scrub finds an error, it will try to rewrite the bad=

> copy from the (hopefully good) other btrfs raid1 copy, and that will
> trigger a rewrite of both/all copies on that underlying mdraid1, which
> should catch the bad one in the process no matter which one it was.
>
> But if one of the lower level mdraid1 component devices is bad while th=
e
> other(s) are good, and mdraid happens to pick the good device, it won't=

> even see and thus can't scrub the bad lower-level copy.
>
> To avoid that problem, one can of course do an mdraid level scrub
> followed by a btrfs scrub.  The mdraid level scrub won't tell bad from
> good but will simply ensure they match, and if it happens to pick the b=
ad
> one at that level, the followon btrfs level scrub will detect that and
> trigger a rewrite from its other copy, which again, will rewrite both/a=
ll
> the underlying mdraid1 component devices on that btrfs raid1 side, but
> that still wouldn't ensure that the rewrite actually happened properly,=

> so then you're left redoing both levels yet again, to ensure that.
>
> Which in theory can work, but in practice, particularly on spinning rus=
t,
> you pretty quickly reach a point when you're running 24/7 scrubs, which=
,
> again particularly on spinning rust, is going to kill throughput for
> pretty much any other IO going on at the same time.
Well yes, but only if you are working with large data sets.  In my use=20
case, the usage amounts to write once, read at most twice, and the data=20
sets are both less than 32G, so scrubbing the lower level RAID1 takes=20
about 10 minutes as of right now.  In particular, the array's get=20
written to at most once a day, and only read when the primary data=20
sources fail.  In my use case, performance isn't as important as up-time.=

>
> Which is one of the reasons I found btrfs raid1 on mdraid0 so appealing=

> in comparison -- raid0 has only the single copy, which is either correc=
t
> or incorrect, and if the btrfs scrub turns up a problem, it does the
> rewrite, and a single second pass of that btrfs scrub can verify that t=
he
> rewrite happened correctly, because there's no hidden copies being pick=
ed
> more or less randomly at the mdraid level, only the single copy, which =
is
> either correct or incorrect.  I like that determinism! =3D:^)
>



--------------ms010605030208090008050008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI4MTI1NDAyWjBPBgkq
hkiG9w0BCQQxQgRASNqvfXx0eTZnFBkm81vdVdPrnSCRPWz5iUX5FVAdyUF1+exIPDETFmau
joCboXbxm7o+5Qjzig1xeV3prLe6vTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgB2H/J/wqO1/jnwraC7+DnII0Wi1XQQXRX9BE+Us/Oq5FN5nQWD
j4P7VU1s4xtwEssOWvJ78PhLc1NlPHA/z3+jrqSdErx26YQAULxwS2zQ/8hxV+2NPdzZ0/tS
3Gcs3MEBdKw2xChONtVLorpaPhvId8XulGA5LsYEvIeSTBmDgg8nAhR+yrf4CuCbXRPswPvb
CmfiUmuPzqeqa10Tu5715QTsS1HNpAEyoQpKcQmPJLN7lcT4aYHXhUyyZoSr9hnDDu3fl9RI
v/yt72rtU1t0XSNWSdxpfxXPXZcGOQAsAZJEb4V0a4yLgoGvIas/VkFSkfmLZv/5vkEJz7S4
/vplubSLV4WXQ0nVVADXHi4KLBKsvLiTLO/nWhA3iCR3h0DrdHTIxpv6Ink5QCOZ379QgQBO
mb1NaGhB2WYn0N5m2uE5CSlxgKcda8DuJXRTVSI3TScwP+jGPbL1fvbtCKM968t1uCpxgUKE
m4l/d+0lCrKE1vEnRDs4+pFjfTyP7N/hPHhoLZ1dlJIoq+P9cOkt5bDm49EUbIGl3BXf8LP5
vjuN0m5hnxQFYbKYwLaNAG2KC9aUngTNn5ODOsd2/QgMTjd3ICECYUlcPUivPhi/XP+nH4EZ
2uX1GOgdSqXUIprlnfs5furvLJtQB2fWGUEsoKmsVeeRcrO6uY4ehl7DXQAAAAAAAA==
--------------ms010605030208090008050008--
