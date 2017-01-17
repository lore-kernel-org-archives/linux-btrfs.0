Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:50458 "EHLO
        smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbdAQXcV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 18:32:21 -0500
From: Christoph Groth <christoph@grothesque.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unocorrectable errors with RAID1
References: <87o9z7dzvd.fsf@grothesque.org>
        <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
        <871sw2cbzb.fsf@grothesque.org>
        <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
        <87lgu9cu2v.fsf@grothesque.org>
        <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
Date: Wed, 18 Jan 2017 00:10:03 +0100
In-Reply-To: <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
        (Chris Murphy's message of "Tue, 17 Jan 2017 14:52:52 -0700")
Message-ID: <877f5tcmgk.fsf@grothesque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; format=flowed

Chris Murphy wrote:
> On Tue, Jan 17, 2017 at 1:25 PM, Christoph Groth
> <christoph@grothesque.org> wrote:
>> Any ideas on what could be done?  If you need help to debug the 
>> problem with
>> btrfs-image, please tell me what I should do.  I can keep the 
>> broken file
>> system around until an image can be created at some later time.
>
> Try 4.9, or even 4.8.5, tons of bugs have been fixed since 4.7.3
> although I don't know off hand if this particular bug is 
> fixed. I did
> recently do a btrfs-image with btrfs-progs v4.9 with -s and did 
> not
> get a segfault.

I compiled btrfs-image.static from btrfs-tools 4.9 (from git) and 
started it from Debian testing's initramfs.  The exact command 
that I use is:

/mnt/btrfs-image.static -c3 -s /dev/sda2 /mnt/mim-s.bim

It runs for a couple of seconds (enough to write 20263936 bytes of 
output) and then quits with

*** Error in `/mnt/btrfs-image.static`: double free or corruption 
    (!prev): 0x00000000009f0940 ***
====== Backtrace: ======
[0x45fb97]
[0x465442]
[0x465c1e]
[0x402694]
[0x402dcb]
[0x4031fe]
[0x4050ff]
[0x405783]
[0x44cb73]
[0x44cdfe]
[0x400b2a]

(I had to type the above off the other screen, but I double 
checked that there are no errors.)

The executable that I used can be downloaded from 
http://groth.fr/btrfs-image.static
Its md5sum is 48abbc82ac6d3c0cb88cba1e5edb85fd.

I hope that this can help someone to see what's going on.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUimQV/rXmWU8TwiKw/FH9ZgPNTUFAlh+pEsACgkQw/FH9ZgP
NTVUYA/+LFtHu6aR/7Pej85BoAByl5zWSWfetNNyrgLvCHDh4LzaL6v/w4DMHYI8
ARxL2ifp35TwwWosdpMDBEBQ2jusVEJTIB+wN/mB6hDtflbIyqeGR/OY4Japp8Qs
WYda944UVF1tj2PAXerrehN8/5nCKnmjKzj1IWmd3b94/ir6J++MHptCIPovTQC2
gok7IYUodvhNwdlEY5fcwn5WHsdhZLwLC34l/+8kjMb6BOh4XO/GuG/Ta162bFBC
wGCliUztHyA9CY362QW4iqBlB+YKBnLzfka8xXvYAUUc1CVtnTLaLsGZvJQe1jYQ
F76j78jkU1kjl2n5ad3RQCxnntKqJVwN084S3jakpLYipw0te//bgpF9PM9UAH1j
G7O0o3FDKJehpiWiNaiJUljmPm80w/+3EUnzG1kig8VvrsiBl3caWyo1r02EZP67
ceslGU8npS69RhwUoKMFLp+1sA5885K4EGSWE2sqaZiww4QeQPJEhPLP2pzuWyH2
BowNEMEb6Gr3VLrJOa+sYGl1wzg1z3GOMceretso7NWFpv0o9HSk6tMU+Uv0K/kT
FfJRlmdznliudUjWBTaiDBaYBA1ivyjPkrmr4wKvTFefDQFDsnX9XD/iyiz7tO3k
EEDqjblLsOg7bZ+MxxCV6J3xAod76ffAbYcndh4KtR1/NXVAf3Y=
=DjHx
-----END PGP SIGNATURE-----
--=-=-=--
