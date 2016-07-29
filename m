Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbcG2QUM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 12:20:12 -0400
Subject: Re: Transaction aborted in btrfs_rename2
To: Adam Borowski <kilobyte@angband.pl>
References: <20160606114732.GA30582@angband.pl>
 <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
 <9373294e-c59b-0360-8481-328f03216926@suse.com>
 <20160729161311.GA15356@angband.pl>
Cc: linux-btrfs@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <f37b1272-8744-b22a-f1eb-57953aec52f4@suse.com>
Date: Fri, 29 Jul 2016 12:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <20160729161311.GA15356@angband.pl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Nhiq30ImAQECpRVoNCmlmn2TWH6r30C9K"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nhiq30ImAQECpRVoNCmlmn2TWH6r30C9K
Content-Type: multipart/mixed; boundary="ShE77ujbKIH0K1nGMAKfVdN91AjOg6oSf"
From: Jeff Mahoney <jeffm@suse.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <f37b1272-8744-b22a-f1eb-57953aec52f4@suse.com>
Subject: Re: Transaction aborted in btrfs_rename2
References: <20160606114732.GA30582@angband.pl>
 <bded73ce-3b5c-3ba0-0785-79d3ffaca34c@suse.com>
 <9373294e-c59b-0360-8481-328f03216926@suse.com>
 <20160729161311.GA15356@angband.pl>
In-Reply-To: <20160729161311.GA15356@angband.pl>

--ShE77ujbKIH0K1nGMAKfVdN91AjOg6oSf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 7/29/16 12:13 PM, Adam Borowski wrote:
> On Fri, Jul 29, 2016 at 11:43:29AM -0400, Jeff Mahoney wrote:
>> On 6/6/16 10:13 AM, Jeff Mahoney wrote:
>>> On 6/6/16 7:47 AM, Adam Borowski wrote:
>>>> Hi!
>>>> I just got this thrice, in 4.7-rc1 and 4.7-rc2:
>>>>
>>>> [ 1836.672368] ------------[ cut here ]------------
>>>> [ 1836.672382] WARNING: CPU: 1 PID: 16348 at fs/btrfs/inode.c:9820 b=
trfs_rename2+0xcd2/0x2a50
>>>> [ 1836.672385] BTRFS: Transaction aborted (error -2)
>>>> [ 1836.672396] CPU: 1 PID: 16348 Comm: gcc-6 Tainted: P           O =
   4.7.0-rc2-debug+ #3
>>>> [ 1836.672415] Call Trace:
>>>> [ 1836.672423]  [<ffffffff8165be6d>] dump_stack+0x4e/0x71
>>>> [ 1836.672429]  [<ffffffff81110c1c>] __warn+0x10c/0x150
>>>> [ 1836.672433]  [<ffffffff81110caa>] warn_slowpath_fmt+0x4a/0x50
>>>> [ 1836.672437]  [<ffffffff814f4842>] btrfs_rename2+0xcd2/0x2a50
>>>> [ 1836.672443]  [<ffffffff814dfcfb>] ? btrfs_permission+0x5b/0xc0
>>>> [ 1836.672448]  [<ffffffff81d288c8>] ? down_write+0x18/0x60
>>>> [ 1836.672453]  [<ffffffff8133a0cc>] vfs_rename+0x7cc/0xc30
>>>> [ 1836.672457]  [<ffffffff8133dc8b>] SyS_rename+0x32b/0x420
>>>> [ 1836.672461]  [<ffffffff81d2ab9f>] entry_SYSCALL_64_fastpath+0x17/=
0x93
>>>> [ 1836.672464] ---[ end trace 6405b6e3d0e6c945 ]---
>>>> [ 1836.672468] BTRFS warning (device sda1): btrfs_rename:9820: Abort=
ing unused transaction(No such entry).
>>>> [ 1836.675505] BTRFS warning (device sda1): btrfs_rename:9820: Abort=
ing unused transaction(No such entry).
>>>> <repeated 1152 times>
>>>
>>> Oh, interesting.  We're seeing this on our 4.4-based kernels as well =
but
>>> only on arm64.  That it's triggering on x86_64 is a good data point.
>>> I'm hunting this one today.
>>
>> I was finally able to track down what this was on arm64, and I'm afrai=
d
>> the news won't help you much.  It was a bug in gcc 4.8.5 instruction
>> scheduling around function return that caused the stack pointer to be
>> restored to the position at the beginning of the function while the
>> stack was still being used via a separate register.  If an interrupt
>> arrived between those two instructions, you'd get stack corruption tha=
t
>> would present as bad hash values.
>>
>> Are you still able to reproduce this on x86_64?
>=20
> Nope, not in quite a while.  I haven't used middle 4.7 rcs so I don't k=
now
> when it went away.
>=20
> I use gcc-6, too.
>=20

Ok, thanks.  I've not been able to reproduce it anywhere but on ARM64,
so I'm trying to find out if it has, potentially, multiple vectors to
reproduce that might be platform agnostic.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--ShE77ujbKIH0K1nGMAKfVdN91AjOg6oSf--

--Nhiq30ImAQECpRVoNCmlmn2TWH6r30C9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXm4I2AAoJEB57S2MheeWyo/MP/jMwfeP3rTcQWaUXLbMA2prH
jbAvkc09DlkSInPTQ4D6/hJ/KJCGlk5pp5+SMlvD3ePhzMrLre0qoHeVG7o32wb8
cpQKueO5Vm+bIiSGUsVGgkDu/MD4wiYw6Xpb0eT+SMhZ5QdhypqOUouaKvX60r++
1P59GOXspFRk2ohbvNxd64xWQ5AVeQQG7NqMOyq/efvm+sVg1w7gxxJ2y0P5eeF8
Mr9etHw8Z1SnwFjDovNFLyuibBEu0/eI/7FxHtHHSi1MQyUv3a2mb9Q2Ib31p9+2
9YQlMwvq+kAnLfaE6KdtWAXSLjqhZmjyPyJTSw96CB7Ej39haKEOYjygKaceLjCP
ldax3Z2+wUMyjv7/4GFma2mCkUXr7OUTyVhirx5gO96F/AKEFLEKq2gxerspCM2e
rNKEofHjjxD1vhuwPxhjoG+kQqDeEuUOEBsY02udVEC1Yzdr2LOZOqM/n/ClA9Z1
OKCKZTGxtfVGDfekzp+GXfuR1RDeFVunEDi7n7nYFK/ZHWWE1gLEP9uzrTkUkB8i
TVSpYMKi+0GZqS5cD6D5I+hZ0Mt7k4W/xxzBg4aof8OjtkJ28FgLDGTPu1aVvtRA
y1ZFMhxI31jQkQYaEhvwVgja8t2kkZSMTm1bpMT8f/t5yDN5NoJAyNlgTEYxMlpY
xkrP8hYN0E/4naGVMzDR
=qxtr
-----END PGP SIGNATURE-----

--Nhiq30ImAQECpRVoNCmlmn2TWH6r30C9K--
