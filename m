Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34275 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031223AbbKEMbG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 07:31:06 -0500
Received: by iody8 with SMTP id y8so87404233iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2015 04:31:04 -0800 (PST)
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <g7loe3red3ksp64hmb0vsbs2.1445476794489@email.android.com>
 <CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com>
 <563A5251.70300@gmail.com> <pan$f33d7$d1be1dd2$81273c9e$505ff3bb@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <563B4BEB.105@gmail.com>
Date: Thu, 5 Nov 2015 07:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <pan$f33d7$d1be1dd2$81273c9e$505ff3bb@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050202020103050908040409"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050202020103050908040409
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-04 23:06, Duncan wrote:
> (Tho I should mention, while not on zfs, I've actually had my own
> problems with ECC RAM too.  In my case, the RAM was certified to run at=

> speeds faster than it was actually reliable at, such that actually stor=
ed
> data, what the ECC protects, was fine, the data was actually getting
> damaged in transit to/from the RAM.  On a lightly loaded system, such a=
s
> one running many memory tests or under normal desktop usage conditions,=

> the RAM was generally fine, no problems.  But on a heavily loaded syste=
m,
> such as when doing parallel builds (I run gentoo, which builds from
> sources in ordered to get the higher level of option flexibility that
> comes only when you can toggle build-time options), I'd often have memo=
ry
> faults and my builds would fail.
>
> The most common failure, BTW, was on tarball decompression, bunzip2 or
> the like, since the tarballs contained checksums that were verified on
> data decompression, and often they'd fail to verify.
>
> Once I updated the BIOS to one that would let me set the memory speed
> instead of using the speed the modules themselves reported, and I
> declocked the memory just one notch (this was DDR1, IIRC I declocked fr=
om
> the PC3200 it was rated, to PC3000 speeds), not only was the memory the=
n
> 100% reliable, but I could and did actually reduce the number of wait-
> states for various operations, and it was STILL 100% reliable.  It simp=
ly
> couldn't handle the raw speeds it was certified to run, is all, tho it
> did handle it well enough, enough of the time, to make the problem far
> more difficult to diagnose and confirm than it would have been had the
> problem appeared at low load as well.
>
> As it happens, I was running reiserfs at the time, and it handled both
> that hardware issue, and a number of others I've had, far better than I=
'd
> have expected of /any/ filesystem, when the memory feeding it is simply=

> not reliable.  Reiserfs metadata, in particular, seems incredibly
> resilient in the face of hardware issues, and I lost far less data than=
 I
> might have expected, tho without checksums and with bad memory, I imagi=
ne
> I had occasional undetected bitflip corruption in files here or there,
> but generally nothing I detected.  I still use reiserfs on my spinning
> rust today, but it's not well suited to SSD, which is where I run btrfs=
=2E
>
> But the point for this discussion is that just because it's ECC RAM
> doesn't mean you can't have memory related errors, just that if you do,=

> they're likely to be different errors, "transit errors", that will tend=

> to be undetected by many memory checkers, at least the ones that don't
> tend to run full out memory bandwidth if they're simply checking that
> what was stored in a cell can be read back, unchanged.)
I've actually seen similar issues with both ECC and non-ECC memory=20
myself.  Any time I'm getting RAM for a system that I can afford to=20
over-spec, I get the next higher speed and under-clock it (which in turn =

means I can lower the timing parameters and usually get a faster system=20
than if I was running it at the rated speed).  FWIW, I also make a point =

of doing multiple memtest86+ runs (at a minimum, one running single=20
core, and one with forced SMP) when I get new RAM, and even have a=20
run-level configured on my Gentoo based home server system where it=20
boots Xen and fires up twice as many VM's running memtest86+ as I have=20
CPU cores, which is usually enough to fully saturate memory bandwidth=20
and check for the type of issues you mentioned having above (although=20
the BOINC client I run usually does a good job of triggering those kind=20
of issues fast, distributed computing apps tend to be memory bound and=20
use a lot of memory bandwidth).


--------------ms050202020103050908040409
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTA1MTIzMDM1WjBPBgkq
hkiG9w0BCQQxQgRAxs9eeWDFhsW8SkcLWZK5S19TuOAdbcaoKyiL3jHiM3aodMy9frME4i1Y
xP7G/55fFraue3bMma44YjcoW0OJLzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBinfdWP0lK4jqIj7VI14X68h8HLnXCbH7LNKi3VYzPf6YcEAQE
/m4+x/Q+fYDUKYZYTeEsHz5Zd6S2A8McExziXpGZpUxz0VoGgzA+y+FYRN6jiZhd7EGDug7J
EI+IBKQFWGfRbOowMM21aR/BoclKU/RIXKYlC3mX/GVZ0VJxnPKnTpa/30Yopu0uA8qMh5HB
8MjcNkzofN75qPHKTa8aECOgv/9TXiKImOAndxlZNWrz4Za5agxFRIDXqibRHkXkgjDuJAZS
CWJWa65Fq+3LhUWTuC6cp42gil7LJLP11EVSPwkJTxS7/K5RUF5rZU1YO2E48+cocEzBbi8O
2BCN34NinYNEbURApF9LVDYV441mUFnDuGfRLfAvnWmvjR41D1pTT+f5ENsHEglA7Rr8S7pv
0kn09bO4Wjm5epaMSx5DLnIGWzgPyzOw+nN8Dz+8Yej4AqfeEOCPPLgWoI7HP+YBGBtVRzqw
6RtZmeyNthM4mYHm9IQ79jN4jRquD+8tVcIGfPj6rdOszehbkQoJ04StyzrUJRJu5h5fPchO
zGgp3N/BVmxxke1BA1s+YgcbCTJ/1r/FLOX7zrRl/V5A1RvXQrm2VTyxtnJYMfZuOnVSDLwD
AQXgQM8TagECRjPRZF+sSPkg3WjQueQmNjxk1Hg/t4mUwucGjRq7g3wL6wAAAAAAAA==
--------------ms050202020103050908040409--
