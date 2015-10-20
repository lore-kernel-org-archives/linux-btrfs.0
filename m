Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33252 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbbJTTsP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 15:48:15 -0400
Received: by iodv82 with SMTP id v82so34400626iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 12:48:14 -0700 (PDT)
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
 <pan$312c1$94a948da$df1250c5$4706911@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56269A77.1080709@gmail.com>
Date: Tue, 20 Oct 2015 15:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <pan$312c1$94a948da$df1250c5$4706911@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040504000607060609070600"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040504000607060609070600
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-20 14:54, Duncan wrote:
> But tho I'm a user not a dev and thus haven't actually checked the sour=
ce
> code itself, my believe here is with Russ and disagrees with Austin, as=

> based on what I've read both on the wiki and seen here previously, btrf=
s
> runtime (that is, not during scrub) actually repairs the problem on-
> hardware as well, from that second copy, not just fetching it for use
> without the repair, the distinction between normal runtime error
> detection and scrub thus being that scrub systematically checks
> everything, while normal runtime on most systems will only check the
> stuff it reads in normal usage, thus getting the stuff that's regularly=

> used, but not the stuff that's only stored and never read.
>
> *WARNING*:  From my experience at least, at least on initial mount, btr=
fs
> isn't particularly robust when the number of read errors on one device
> start to go up dramatically.  Despite never seeing an error in scrub th=
at
> it couldn't fix, twice I had enough reads fail on a mount that the moun=
t
> itself failed and I couldn't mount successfully despite repeated
> attempts.  In both cases, I was able to use btrfs restore to restore th=
e
> contents of the filesystem to some other place (as it happens, the
> reiserfs on spinning rust I use for my media filesystem, since being fo=
r
> big media files, that had enough space to recover the as I said above
> reasonably small btrfs into), and ultimate recreating the filesystem
> using mkfs.btrfs.
>
> But given that despite not being able to mount, neither SMART nor dmesg=

> ever mentioned anything about the "good" device having errors, I'm left=

> to conclude that btrfs itself ultimately crashed on attempt to mount th=
e
> filesystem, even tho only the one copy was bad.  After a couple of thos=
e
> events I started scrubbing much more frequently, thus fixing the errors=

> while btrfs could still mount the filesystem and /let/ me run a scrub.
> It was actually those more frequent scrubs that quickly became the hass=
le
> and lead me to give up on the device.  If btrfs had been able to fall
> back to the second/valid copy even in that case, as it really should ha=
ve
> done, then I would have very possibly waited quite a bit longer to
> replace the dying device.
>
> So on that one I'd say to be sure, get confirmation either directly fro=
m
> the code (if you can read it) or from a dev who has actually looked at =
it
> and is basing his post on that, tho I still /believe/ btrfs still runti=
me-
> corrects checksumming issues actually on-device, if there's a validatin=
g
> second copy it can use to do so.
>
FWIW, my assessment is based on some testing I did a while back (kernel=20
3.14 IIRC) using a VM.  The (significantly summarized of course)=20
procedure I used was:
1. Create a basic minimalistic Linux system in a VM (in my case, I just=20
used a stage3 tarball for Gentoo, with a paravirtuaized Xen domain)=20
using BTRFS as the root filesystem with a raid1 setup.  Make sure and=20
verify that it actually boots.
2. Shutdown the VM, use btrfs-progs on the host to find the physical=20
location of an arbitrary file (ideally one that is not touched at all=20
during the boot process, IIRC, I think I used one of the e2fsprogs=20
binaries), and then intentionally clear the CRC in one of the copies of=20
a block from the file.
3. Boot the VM, read the file.
4. Shutdown the VM again.
5. Verify whether the file block you cleared the checksum on has a valid =

checksum now.

I repeated this more than a dozen times using different files and=20
different methods of reading the file, and each time the CRC I had=20
cleared was untouched.  Based on this, unless BTRFS does some kind of=20
deferred re-write that doesn't get forced during a clean unmount of the=20
FS, I felt it was relatively safe to conclude that it did not=20
automatically fix corrupted blocks.  I did not however, test corrupting=20
the block itself instead of the checksum, but I doubt that that would=20
impact anything in this case.

As I mentioned, many veteran sysadmins would want to disable=20
automatically fixing this in the FS driver without having some kind of=20
notification.  This preference largely dates back to traditional RAID1,=20
where the system has no way to know for certain which copy is correct in =

the case of a mismatch, and therefore to safely fix mismatches, the=20
admin needs to intervene.  While it is possible to fix this safely=20
because of how BTRFS is designed, there is still the possibility of it=20
getting things wrong.  There was one time I had a BTRFS raid1 filesystem =

where one copy of a block got corrupted but miraculously had a correct=20
CRC (which is statistically impossible), and the other copy of the block =

was correct, but the CRC for it was wrong (which, while unlikely, is=20
very much possible).  In such a case (which was a serious pain to=20
debug), automatically 'fixing' the supposedly bad block would have=20
resulted in data loss.  Of course, the chance that happening more than=20
once in a lifetime is astronomically small, but it is still possible.

It's also worth noting that ZFS has been considered mature for more than =

a decade now, and the ZFS developers _still_ aren't willing to risk=20
their user's data with something like this, which should be an immediate =

red flag for anyone developing a filesystem with features like ZFS.


--------------ms040504000607060609070600
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIwMTk0ODA3WjBPBgkq
hkiG9w0BCQQxQgRAQ2pIxodQbRmdHnH1FXSSlHU4ufvXwDpzVYlaJFNDErbCQjoikZJVFp9s
9YrLARxoriVQCFp2DlbZCQO7Zv3rmzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAXQQ9vAM/VHXXjucURc6R53Lh/hzT1F5GQqOg008SxXup8L/SV
x7b24eLGnFlxD3Jize4m8w7glt47cvKnEKANUhUdZ1aF2ZWavZdXrWYt3FqLfLdHoOB0aucw
UnVkUTS4HtI0eWgU8iT+ysd2qhBPhz2U3HOMAKWCTKiLtoqk0OOSK0c/OONSwTyUbF1l+lJc
OTLiIK7SXcbG/eziSNwneIOlBKPwlN10HTcXsXLdMxGlnavypOKxmrqMYco2fjAh7t+OVMeo
Ox3C8u94oV/NbgCWCPTrotsoJwhaKDDRMMtW8ahfdrGD3LY3u4d5xWytXNoKoXiloFryDyYh
8Oli82VhFFAOi+czcX12BSEm1YByuVmg4ULXN5G05LQQS39GjnZIx9fdaZer3I3L40YO0GYJ
mdge3obj6tl/jv1g3E6F0sI6AO4cMalxRK55HqXP+NQBU/JCt1YX8p3IMJJyYul+DxdT4ZNF
Z9p2AVjydZaNBzlv5jJljStWARDaDLtZ7t3Cccx1NEp5TJmLi3NcR1x4pKQKFivX7Tyz5hqc
bPZZF2LZ7QlrK5Omle0IHu/X4t24/vB0UZ2YaNVDvggp2Gv3Kn1OULuGxG/L2kphAeYBNX8H
RUxuo8Nszt662MZXmtRMDMHiKE0M/P69niDBJXk2goYGT9B3rfp8VXfgggAAAAAAAA==
--------------ms040504000607060609070600--
