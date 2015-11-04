Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35294 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030966AbbKDSqA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Nov 2015 13:46:00 -0500
Received: by iofz202 with SMTP id z202so63869591iof.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2015 10:45:59 -0800 (PST)
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
To: "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <g7loe3red3ksp64hmb0vsbs2.1445476794489@email.android.com>
 <CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <563A5251.70300@gmail.com>
Date: Wed, 4 Nov 2015 13:45:37 -0500
MIME-Version: 1.0
In-Reply-To: <CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020302050400070306030901"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020302050400070306030901
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-04 13:01, Janos Toth F. wrote:
> But the worst part is that there are some ISO files which were
> seemingly copied without errors but their external checksums (the one
> which I can calculate with md5sum and compare to the one supplied by
> the publisher of the ISO file) don't match!
> Well... this, I cannot understand.
> How could these files become corrupt from a single disk failure? And
> more importantly: how could these files be copied without errors? Why
> didn't Btrfs gave a read error when the checksums didn't add up?
If you can prove that there was a checksum mismatch and BTRFS returned=20
invalid data instead of a read error or going to the other disk, then=20
that is a very serious bug that needs to be fixed.  You need to keep in=20
mind also however that it's completely possible that the data was bad=20
before you wrote it to the filesystem, and if that's the case, there's=20
nothing any filesystem can do to fix it for you.
>
> Isn't Btrfs supposed to constantly check the integrity of the file
> data during any normal read operations and give an error instead of
> spitting out corrupt data as if it was perfectly legit?
> I thought that's how it is supposed to work.
Assuming that all of your hardware is working exactly like it's supposed =

to, yes it should work that way.  If however, you have something that=20
corrupts the data in RAM before or while BTRFS is computing the checksum =

prior to writing the data, the it's fully possible for bad data to get=20
written to disk and still have a perfectly correct checksum.  Bad RAM=20
may also explain your issues mentioned above with not being able to copy =

stuff off of the filesystem.

Also, if you're using NOCOW files (or just the mount option), those very =

specifically do not store checksums for the blocks, because there is no=20
way to do it without significant risk of data corruption.
> What's the point of full data checksuming if only an explicitly
> requested scrub operation might look for errors? I thought's it's the
> logical thing to do if checksum verification happens during every
> single read operation and passing that check is mandatory in order to
> get any data out of the filesystem (might be excluding the Direct-I/O
> mode but I never use that on Btrfs - if that's even actually
> supported, I don't know).
>
>
> Now I am really considering to move from Linux to Windows and from
> Btrfs RAID-5 to Storage Spaces RAID-1 + ReFS (the only limitation is
> that ReFS is only "self-healing" on RAID-1, not RAID-5, so I need a
> new motherboard with more native SATA connectors and an extra HDD).
> That one seemed to actually do what it promises (abort any read
> operations upon checksum errors [which always happens seamlessly on
> every read] but look at the redundant data first and seamlessly
> "self-heal" if possible). The only thing which made Btrfs to look as a
> better alternative was the RAID-5 support. But I recently experienced
> two cases of 1 drive failing of 3 and it always tuned out as a smaller
> or bigger disaster (completely lost data or inconsistent data).
Have you considered looking into ZFS?  I hate to suggest it as an=20
alternative to BTRFS, but it's a much more mature and well tested=20
technology than ReFS, and has many of the same features as BTRFS (and=20
even has the option for triple parity instead of the double you get with =

RAID6).  If you do consider ZFS, make a point to look at FreeBSD in=20
addition to the Linux version, the BSD one was a much better written=20
port of the original Solaris drivers, and has better performance in many =

cases (and as much as I hate to admit it, BSD is way more reliable than=20
Linux in most use cases).

You should also seriously consider whether the convenience of having a=20
filesystem that fixes internal errors itself with no user intervention=20
is worth the risk of it corrupting your data.  Returning correct data=20
whenever possible is one thing, being 'self-healing' is completely=20
different.  When you start talking about things that automatically fix=20
internal errors without user intervention is when most seasoned system=20
administrators start to get really nervous.  Self correcting systems=20
have just as much chance to make things worse as they do to make things=20
better, and most of them depend on the underlying hardware working=20
correctly to actually provide any guarantee of reliability.  I cannot=20
count the number of stories I've heard of 'self-healing' hardware RAID=20
controllers destroying data.


--------------ms020302050400070306030901
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTA0MTg0NTM3WjBPBgkq
hkiG9w0BCQQxQgRAgAE8HBLwvfLV6/rkmnRtHY3+aTn/4RgC4fGKnlQJ0xCi9aXznxx6Mw6h
GBS7sDBLUYIkeH+YJag6ZzFtLZP9MDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAwm2QSuLrGwwwreBgEh9jnIYlLPJ7G/gRigRnriAQY2xMrXZ8E
lTG3/1Nb3aNSPRFa9Il80apZZqjG5bm4kenm8aCJTtZHvJFzzF0mgeYD/M5XE+xQOzW5Rbn2
0NzntbDzZ62O4BsB2crTPnw65wVUFhMSj59mgBa7B4LP7qFONjJsEdIhia1oS0Exh/7I1Yvw
Lvm9zsgSz3tiZNEmVBq9A9HeAFEfwTDOGLptak9MxpD7PjZtYb93fZ6n7DDjafMNi1RcUBRG
dKMO3dFVpxQbYuevbYp/19WhWn7EV2yvvbIALB28xXIUY4uQ+4U+A2JtZM0fRE8PLu05/MlT
fuiqpqZiBbl8305r49xDri7fruwaB+pDf29cMapC0ozJzaxJOQ86+JRytPXKCblNWoUuwkex
lfUQ376H3oeXISQHnMrHtaatyVdEuYX0pmGjp12VAnD+yIhA3y+eq4+O1p2kTZDR1nhHZlwa
ZUCL9UzMYIYwTp6FSyvR+xNsiN+dIDHLlqse5Ih8awZ+QfyGRvdCk8Ce9gl3sMhhryJvQ5+a
M5fFv0wNfoOs3eoOLRrUrnV/g7R5E/iy7ZfVrxpLeaLg+k4MYL1O1BEKc+tBDCDiCERnEs1W
Z4em6MKfODr+lUIu6qnEATCO96I6hoP7/nTKimdW4jFKGzz7Megp0cb+wQAAAAAAAA==
--------------ms020302050400070306030901--
