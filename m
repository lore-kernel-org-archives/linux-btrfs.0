Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbcG2Png (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 11:43:36 -0400
Subject: Re: Transaction aborted in btrfs_rename2
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
References: <20160606114732.GA30582@angband.pl>
 <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9373294e-c59b-0360-8481-328f03216926@suse.com>
Date: Fri, 29 Jul 2016 11:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oK0Ll40IFnsNqeV1D9AOiIMIVhf1iDql2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oK0Ll40IFnsNqeV1D9AOiIMIVhf1iDql2
Content-Type: multipart/mixed; boundary="VFCJsgeITLfWAPIQGKR8DaGfgUo3Lk6an"
From: Jeff Mahoney <jeffm@suse.com>
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
Message-ID: <9373294e-c59b-0360-8481-328f03216926@suse.com>
Subject: Re: Transaction aborted in btrfs_rename2
References: <20160606114732.GA30582@angband.pl>
 <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
In-Reply-To: <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>

--VFCJsgeITLfWAPIQGKR8DaGfgUo3Lk6an
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/6/16 10:13 AM, Jeff Mahoney wrote:
> On 6/6/16 7:47 AM, Adam Borowski wrote:
>> Hi!
>> I just got this thrice, in 4.7-rc1 and 4.7-rc2:
>>
>> [ 1836.672368] ------------[ cut here ]------------
>> [ 1836.672382] WARNING: CPU: 1 PID: 16348 at fs/btrfs/inode.c:9820 btr=
fs_rename2+0xcd2/0x2a50
>> [ 1836.672385] BTRFS: Transaction aborted (error -2)
>> [ 1836.672387] Modules linked in: nvidia(PO) usb_storage
>> [ 1836.672396] CPU: 1 PID: 16348 Comm: gcc-6 Tainted: P           O   =
 4.7.0-rc2-debug+ #3
>> [ 1836.672399] Hardware name: System manufacturer System Product Name/=
M4A77T, BIOS 2401    05/18/2011
>> [ 1836.672402]  ffffffff81f8b504 ffff880062c47c78 ffffffff8165be6d 000=
0000000000007
>> [ 1836.672407]  ffff880062c47cd0 0000000000000000 ffff880062c47cc0 fff=
fffff81110c1c
>> [ 1836.672411]  ffff880062c47d20 0000265c814e8642 0000000000000000 000=
0000000a25ade
>> [ 1836.672415] Call Trace:
>> [ 1836.672423]  [<ffffffff8165be6d>] dump_stack+0x4e/0x71
>> [ 1836.672429]  [<ffffffff81110c1c>] __warn+0x10c/0x150
>> [ 1836.672433]  [<ffffffff81110caa>] warn_slowpath_fmt+0x4a/0x50
>> [ 1836.672437]  [<ffffffff814f4842>] btrfs_rename2+0xcd2/0x2a50
>> [ 1836.672443]  [<ffffffff814dfcfb>] ? btrfs_permission+0x5b/0xc0
>> [ 1836.672448]  [<ffffffff81d288c8>] ? down_write+0x18/0x60
>> [ 1836.672453]  [<ffffffff8133a0cc>] vfs_rename+0x7cc/0xc30
>> [ 1836.672457]  [<ffffffff8133dc8b>] SyS_rename+0x32b/0x420
>> [ 1836.672461]  [<ffffffff81d2ab9f>] entry_SYSCALL_64_fastpath+0x17/0x=
93
>> [ 1836.672464] ---[ end trace 6405b6e3d0e6c945 ]---
>> [ 1836.672468] BTRFS warning (device sda1): btrfs_rename:9820: Abortin=
g unused transaction(No such entry).
>> [ 1836.675505] BTRFS warning (device sda1): btrfs_rename:9820: Abortin=
g unused transaction(No such entry).
>> <repeated 1152 times>
>> [ 1837.935238] BTRFS warning (device sda1): btrfs_rename:9820: Abortin=
g unused transaction(No such entry).
>> [ 1837.937602] BTRFS: error (device sda1) in btrfs_rename:9820: errno=3D=
-2 No such entry
>> [ 1837.937607] BTRFS info (device sda1): forced readonly
>> [ 1838.086754] BTRFS warning (device sda1): Skipping commit of aborted=
 transaction.
>> [ 1838.086762] BTRFS: error (device sda1) in cleanup_transaction:1857:=
 errno=3D-2 No such entry
>> [ 1838.086782] BTRFS info (device sda1): delayed_refs has NO entry
>>
>> Didn't trigger during a week of other work, yet a kernel compile trigg=
ers
>> this reliably.
>>
>> Filesystem appears consistent (btrfs check, scrub).
>> Mount options: noatime,compress=3Dlzo,ssd,space_cache.
>>
>=20
> Oh, interesting.  We're seeing this on our 4.4-based kernels as well bu=
t
> only on arm64.  That it's triggering on x86_64 is a good data point.
> I'm hunting this one today.

Hi Adam -

I was finally able to track down what this was on arm64, and I'm afraid
the news won't help you much.  It was a bug in gcc 4.8.5 instruction
scheduling around function return that caused the stack pointer to be
restored to the position at the beginning of the function while the
stack was still being used via a separate register.  If an interrupt
arrived between those two instructions, you'd get stack corruption that
would present as bad hash values.

Are you still able to reproduce this on x86_64?

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--VFCJsgeITLfWAPIQGKR8DaGfgUo3Lk6an--

--oK0Ll40IFnsNqeV1D9AOiIMIVhf1iDql2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXm3miAAoJEB57S2MheeWyNnEQAJsySkvUloOdHOjuRREEKNCH
IvZ6nXe5NseE0Nkx5KK0KVuDB5ukAXj/IZR1BKMaxg9Sj+c7sqhVlY4WsPmOQXHi
m3ge3BaTGYWg+0Vx+zHFtxLh9Ws0M4BSykS+kw2iidbTMdQuyBiw4uHGnliE/QQs
ckekRfzI7AFNikSqQeDFp4vb97e21Mrs7REXE++Ey0tKnS7k3W360XgzC+XdZjjF
r7N4Hrjk4fK2HgCDdBw1cdusFZXRmcPVC3UDyAiVeUqpkBKWzDrXsXD8hvad50P5
cZl337ZZsx16/Fw9ZZ/ZAr/kx9UHpwZRxGRFs8glF1mNckAIVEZuwshNvNq+a6A7
i7kTOUcaXxdIcnw+kLnq9uSIQEkvXXhKRdVLjIraM+ao8RvGuqTnfY06qD9++KJK
Zgq4IB+FAvkwbA/ZCmYwjF1rlPbMi7KZ+sXib3uNm/bP2pQ61Km2a9z9D538LmcP
5saASeZDsC191kIOWHw0+Zy1shFWw3GW0nYjq3SUMuOxhaddMmXLZncs7CXKHI/N
WUrQKdfRdiNeSoGddaH3q0PVkrqNqB8IA0m5DlJldZ+WZBIzCJ/ZBKBxvHfoNZDP
7FdkvznWNoiFSjbAjZ6du16xB+K6z0BIaqsLD916uPvP2NgZxBcnbBgzZz33Mr9H
jke7hdpaeV6l1BWLApdD
=Y9Bm
-----END PGP SIGNATURE-----

--oK0Ll40IFnsNqeV1D9AOiIMIVhf1iDql2--
