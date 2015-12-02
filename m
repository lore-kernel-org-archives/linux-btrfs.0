Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33411 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046AbbLBMZW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 07:25:22 -0500
Received: by iouu10 with SMTP id u10so44413829iou.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 04:25:21 -0800 (PST)
Subject: Re: utils version and convert crash
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
 <pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
 <CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
 <565E0356.9030006@gmail.com>
 <CA+WRLO-VSOH1QUHTXFGzCSUKW=mRoufmUpYG8xRB4N80+rHmjg@mail.gmail.com>
 <CA+WRLO_1bLpve50YkuGD4wDxyO_e=4u9xev8y4XxZT9L01KxDQ@mail.gmail.com>
 <pan$c5c73$162474d7$f06e12fa$496fb5f@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565EE329.3050902@gmail.com>
Date: Wed, 2 Dec 2015 07:25:13 -0500
MIME-Version: 1.0
In-Reply-To: <pan$c5c73$162474d7$f06e12fa$496fb5f@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020905030901050008050306"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020905030901050008050306
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 05:01, Duncan wrote:
> Gareth Pye posted on Wed, 02 Dec 2015 18:07:48 +1100 as excerpted:
>
>> Output from scrub:
>> sudo btrfs scrub start -Bd /data
>
> [Omitted no-error device reports.]
>
>> scrub device /dev/sdh (id 6) done
>>     scrub started at Wed Dec  2 07:04:08 2015 and finished after 06:47=
:22
>>     total bytes scrubbed: 1.09TiB with 2 errors
>>     error details: read=3D2
>>     corrected errors: 2, uncorrectable errors: 0, unverified errors: 3=
0
>
> Also note those unverified errors...
>
> I have quite a bit of experience with btrfs scrub as I ran with a faili=
ng
> ssd for awhile, using btrfs scrub on the multiple btrfs raid1 filesyste=
ms
> on parallel partitions on the failing ssd and another good one to corre=
ct
> the errors and continue operations.
>
> Unverified errors are, I believe[1], errors where a metadata block
> holding checksums itself has an error, so the blocks its checksums in
> turn covered are not checksum-verified.
>
> What that means in practice is that once the first metadata block error=

> has been corrected in a first scrub run, a second scrub run can now che=
ck
> the blocks that were recorded as unverified errors in the first run,
> potentially finding and hopefully fixing additional errors, tho unless
> the problem's extreme, most of the unverifieds should end up being
> correct once they can be verified, with only a few possible further
> errors found.
>
> Of course if some of these previously unverified blocks are themselves
> metadata blocks with further checksums, yet another run may be required=
=2E
>
> Fortunately, these trees are quite wide (121 items according to an old
> post from Hugo I found myself rereading a few hours ago) and thus don't=

> tend to be very deep -- I think I ended up rerunning scrub four times a=
t
> one point, before both read and unverified errors went to zero, tho
> that's on relatively small partitioned-up ssd filesystems of under 50 g=
ig
> usable capacity (pair-raid1, 50 gig per device), so I could see terabyt=
e-
> scale filesystems going to 6-7 levels.
>
> And, again on a btrfs raid1 with a known failing device -- several
> thousand redirected sectors by the time I gave up and btrfs replaced --=

> generally each successive scrub run would return an order of magnitude =
or
> so fewer errors (corrected and unverified both) than the previous run,
> tho occasionally I'd hit a bad spot and the number would go up a bit in=

> one run, before dropping an order of magnitude or so again on the next
> run.
>
> So with only two corrected read-errors and 30 unverified, I'd expect
> maybe another one or two corrected read-errors on a second run, and
> probably no unverifieds, in which case a third run shouldn't be necessa=
ry
> unless you just want the peace of mind of seeing that no errors found
> message.  Tho of course if you're unlucky, one of those 30 will turn ou=
t
> to be a a read error on a full 121-item metadata block, so your
> unverifieds will go up for that run, before going down again in
> subsequent runs.
>
> Of course with filesystems of under 50 gig capacity on fast ssds, a
> typical scrub ran in under a minute, so repeated scrubs to find and
> correct all errors wasn't a big deal, generally under 10 minutes
> including human response time.  On terabyte-scale spinning rust with
> scrubs taking hours, multiple scrubs could easily take a full 24-hour d=
ay
> or more! =3D:^(
>
> So now that you did one scrub and did find errors, you do probably want=

> to trace them down and correct the problem if possible, before running
> further scrubs to find and exterminate any errors still hiding behind
> unverified in the first run.  But once you're reasonably confident you'=
re
> running a reliable system again, you probably do want to run further
> scrubs until that unverified count goes to zero (assuming no
> uncorrectable errors in the mean time).
>
> ---
> [1] I'm not a dev and am not absolutely sure of the technical accuracy =
of
> this description, but from an admin's viewpoint it seems to be correct =
at
> least in practice, based on the fact that further scrubs as long as the=
re
> were unverified errors often did find additional errors, while once the=

> unverified count dropped to zero and the last read errors were correcte=
d,
> further scrubs turned up no further errors.
>
AFAICT from reading the code, that is a correct assessment.  It would be =

kind of nice though if there was some way to tell scrub to recheck up to =

X many times if there are unverified errors...


--------------ms020905030901050008050306
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAyMTIyNTEzWjBPBgkq
hkiG9w0BCQQxQgRAVauwPG6TmranSAHmat+5Yyl5z/fsg02q4Tx8UQgMq6ROns+TIjQDPhfq
Gk4xVXo98vXj2RwEy9hDCjRNfIiptjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBXwbvuoCXZHjfgZ+h/gOMCovsBiJRiUzaWSmtFkiowCqg7gtWp
c4fuVp9zqOMLAxnsbn0GcY1mHqJ4vWH3kLO1RBEG3BpmWFunHdQoF7lO+wMystMhpMemBUHu
WIrVv1Kx1QHWYOP//kQcSPWgnZvtqlG//eS5++CEy+T0kj5ywOp+gWc2smVrYBDM0c6twsMG
fE4l85sM1TQbjRyc60kjL6P3dWTSiOJGAnAkhOSXbWkXHyAlYU0TamEgEQrFmz7zjQBZHo3W
p+dPfI2sZ/48IAxm3RKbQ07S860TCo1i1bBAaTAmf9rHy1/5N3b3EGEuzbnp3tIhv3icSvEh
ItdU0fl1sNw3j7GxdgXj0DAL5yuAM43oH9g5rLfQJl6BPjCVm6GNqHUDQqUHR5QkJdKVWXye
0qQ5Nu0gUx9qLFMoPcLd7g2gkYtI0SZXH+n4cw/5rzHjobrIqI0MDIZy2L9dOEkQxNHiNF3T
gyOgdZoudxg8RDjwxN1m7yl7dEz9ip1Yf6F+BzbMnKouUbnTnl2exuQ2ukUth10vbnPaMJuT
LtW5RAu12PKy7kzbviSR2wlXE44IK6aC/7C1v4KKwiiZ2U/r9t86vArm6XoF1raau03HttFt
iGu9vmy1+HiVSW2fwOg9RpOE9BgiJWROPDYpkaqBdL/FDOQHnzNB4b+lZgAAAAAAAA==
--------------ms020905030901050008050306--
