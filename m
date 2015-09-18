Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33091 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbIRNGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 09:06:16 -0400
Received: by iofh134 with SMTP id h134so55465856iof.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 06:06:15 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: Martin Steigerwald <martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>,
        Zia Nayamuth <zedestructor@gmail.com>, linux-btrfs@vger.kernel.org
References: <20150916144355.GA1285@invalid> <55F9BE3B.6070309@gmail.com>
 <20150916232930.GD28645@carfax.org.uk> <5147353.qIsJnOkqhM@merkaba>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55FC0C3A.9080702@gmail.com>
Date: Fri, 18 Sep 2015 09:06:02 -0400
MIME-Version: 1.0
In-Reply-To: <5147353.qIsJnOkqhM@merkaba>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080702060902050805090605"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080702060902050805090605
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-17 11:57, Martin Steigerwald wrote:
> Am Mittwoch, 16. September 2015, 23:29:30 CEST schrieb Hugo Mills:
>>> but even then having write-barriers
>>> turned off is still not as safe as having them turned on.  Most of
>>> the time when I've tried testing with 'nobarrier' (not just on BTRFS
>>> but on ext* as well), I had just as many issues with data loss when
>>> the system crashed as when it (simlated via killing the virtual
>>> machine) lost power.  Both journaling and COW filesystems need to
>>> ensure ordering of certain write operations to be able to maintain
>>> consistency.  For example, the new/updated data blocks need to be on
>>> disk before the metadata is updated to point to them, otherwise you
>>> database can end up corrupted.
>>
>>     Indeed. The barriers are an ordering condition. The FS relies on
>> (i.e. *requires*) that ordering condition, in order to be truly
>> consistent. Running with "nobarrier" is a very strong signal that you
>> really don't care about the data on the FS.
>>
>>     This is not a case of me simply believing that because I've been
>> using btrfs for so long that I've got used to the peculiarities. The
>> first time I heard about the nobarrier option, something like 6 years
>> ago when I was first using btrfs, I thought "that's got to be a really=

>> silly idea". Any complex data structure, like a filesystem, is going
>> to rely on some kind of ordering guarantees, somewhere in its
>> structure. (The ordering might be strict, with a global clock, or
>> barrier-based, or lattice-like, as for example a vector clock, but
>> there's going to be _some_ concept of order). nobarrier allows the FS
>> to ignore those guarantees, and even without knowing anything about
>> the FS at all, doing so is a big red DANGER flag.
>
> Official recommendation for XFS differs from that:
>
>   Q. Should barriers be enabled with storage which has a persistent wri=
te
> cache?
>
> Many hardware RAID have a persistent write cache which preserves it acr=
oss
> power failure, interface resets, system crashes, etc. Using write barri=
ers in
> this instance is not recommended and will in fact lower performance.
> Therefore, it is recommended to turn off the barrier support and mount =
the
> filesystem with "nobarrier", assuming your RAID controller is infallibl=
e and
> not resetting randomly like some common ones do. But take care about th=
e hard
> disk write cache, which should be off.
>
> http://xfs.org/index.php/
> XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persiste=
nt_write_cache.
> 3F
There's a difference there still, XFS isn't quite as dependent on=20
ordering as BTRFS is, and they're also giving some other strict=20
rquirements (hard-disk write-cache being off (which I see a rather large =

number of people ignore), and a high-end RAID controller).



--------------ms080702060902050805090605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE4MTMwNjAyWjBPBgkq
hkiG9w0BCQQxQgRAD3/bY11MdoFkHzH+SFlH1EEPvfVtcOyxc+j/gdt/LtH2BzTdDwRYKjFr
ZpBwAlsP32PkGf0P7TEZt/vygVWZtTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAUVteoSmvCSISqw3+b3WpMtxGjtGSpuNNVchQv72HAbf8AGVYU
ku9cbZ1WI1PtQpKje67UpYHD5Q1LKN+0WVTiA+VnLZ51PTsQshaVtLvCjfVZE5E81r0IYH2P
wbFHzT3WOFGAatvLe9IkD1uoJQHv0ELIfQ/JjmxdbUqSn+WnkVx07onEkvVI3/5wMkHW0NqI
joeOxKdskQzItNNCX7GhIwEMMIM4miS7LYxlY0zYUA8AeOFBPP2Cd2oRGY4ipCr72X9bfVP4
jL164VUw1Yb8nlFNfH0p4CovSloim713yr9V3HpeudgdnQiUt1QIfjLN9bO+XhXrjyfP6k/T
llOz10ltMvZIZap/u02JtNrAblrArHXwouXGlBDqtiH7Y8MoqZVhbTMEbfwIT6rznjO1AkkQ
LDbblV/qbJqmJzmavYZaCPgJzytcdETXE5pAEKjAqQ4mg1gzQ30EJlp7NHFExXVr5bMzNSaM
QeadrCeQmtCKC7C8XL1AcM+zFXsp1pcQMamUcxlnwK50xX8vUT5bspPKFjbvhlYKBLEGfpNa
5x9qQRMupRwdO4vvsiEa1Dagqeb7n9zR6MhHM+QOl/0hJ5xDmb24UTL63ds/L9f44/vMdgkD
ccUya18A+67uOjm1SPi4kEBtSN9iuTJ/LcLqHDNd4G/cjiZ0D1psCH+k/AAAAAAAAA==
--------------ms080702060902050805090605--
