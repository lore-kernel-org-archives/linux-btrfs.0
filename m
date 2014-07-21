Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from omr-m09.mx.aol.com ([64.12.143.82]:50497 "EHLO
	omr-m09.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGUSC4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 14:02:56 -0400
Message-ID: <53CD55CB.5050105@aol.de>
Date: Mon, 21 Jul 2014 20:02:51 +0200
From: Karl-Philipp Richter <krichter722@aol.de>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: `btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
 & 1)' failed.` in `btrfsck`
References: <53C90CA8.2000104@aol.de> <0BC9DE69-A088-4B5A-95F5-DF863C87C803@gmail.com>
In-Reply-To: <0BC9DE69-A088-4B5A-95F5-DF863C87C803@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VBU7elsDNe9bRoFRdPCjhncODgrR6eq9F"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VBU7elsDNe9bRoFRdPCjhncODgrR6eq9F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
I could `btrfsck --repair` the sparse file with Linux 3.15.6-utopic from
http://kernel.ubuntu.com/~kernel-ppa/mainline/ and btrfsck 3.12-1 (from
btrfs-tools package in Ubuntu 14.04).

Thanks for your hints, Wang!

All the best,
Karl

Am 18.07.2014 14:13, schrieb Wang Shilong:
>=20
> Hi,
>=20
> There are some patches for fsck flighting, they  are integrated  in Dav=
id's branches.
> You can pull from David's latest branch, and see if it helps:
>=20
> https://github.com/kdave/btrfs-progs  integration-20140704
>=20
> Have a try and see if it helps anyway.
>=20
> Thanks,
> Wang
>=20
>> Hi together,
>> I'm experiencing the following issues when I invoke `btrfsck` on a
>> sparse file image with a GPT and one (the only) btrfs partition attach=
ed
>> to a loop device
>>
>>    $ sudo btrfsck --repair --init-csum-tree --init-extent-tree -b
>> /dev/loop0p1
>>    Incorrect local backref count on 128510738432 root 5 owner 3849475
>> offset 0 found 1 wanted 0 back 0xbab41270
>>    backpointer mismatch on [128510738432 4096]
>>    ref mismatch on [128510742528 12288] extent item 0, found 1
>>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flag=
s
>> & 1)' failed.
>>
>>    $ sudo btrfsck --repair --init-csum-tree --init-extent-tree /dev/lo=
op0p1
>>    Incorrect local backref count on 128510726144 root 5 owner 3849470
>> offset 0 found 1 wanted 0 back 0xbbcb9500
>>    backpointer mismatch on [128510726144 12288]
>>    ref mismatch on [128510738432 4096] extent item 0, found 1
>>    adding new data backref on 128510738432 root 5 owner 3849475 offset=

>> 0 found 1
>>    Backref 128510738432 root 5 owner 3849475 offset 0 num_refs 0 not
>> found in extent tree
>>    Incorrect local backref count on 128510738432 root 5 owner 3849475
>> offset 0 found 1 wanted 0 back 0xbbcb9630
>>    backpointer mismatch on [128510738432 4096]
>>    ref mismatch on [128510742528 12288] extent item 0, found 1
>>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flag=
s
>> & 1)' failed.
>>
>>    $ sudo btrfsck --repair /dev/loop0p1
>>    Incorrect local backref count on 130861096960 root 5 owner 22733727=

>> offset 0 found 1 wanted 0 back 0xc7c7d170
>>    backpointer mismatch on [130861096960 8192]
>>    ref mismatch on [130861105152 8192] extent item 0, found 1
>>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flag=
s
>> & 1)' failed.
>>
>>    $ sudo btrfsck --repair /dev/loop0p1
>>    Backref 130861096960 root 5 owner 22733727 offset 0 num_refs 0 not
>> found in extent tree
>>    Incorrect local backref count on 130861096960 root 5 owner 22733727=

>> offset 0 found 1 wanted 0 back 0xc7f31170
>>    backpointer mismatch on [130861096960 8192]
>>    ref mismatch on [130861105152 8192] extent item 0, found 1
>>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flag=
s
>> & 1)' failed.
>>
>> I'm using `btrfs-progs` 24cf4d8c3ee924b474f68514e0167cc2e602a48d on
>> Linux 3.16-rc5 (anything else, i.e. older versions, give me immediate
>> error after start because errornous file system)
>>
>> I'd like to know whether this (assertion) error is related to a bug or=

>> missing feature in btrfs-progs and might be fixed at some point or
>> whether this might indicate a completely messed up btrfs.
>>
>> Best regards,
>> Karl-P. Richter
>>
>=20


--VBU7elsDNe9bRoFRdPCjhncODgrR6eq9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTzVXLAAoJEGadKJ8eJ7ZGaVQH/18xhONHgmlnob1UU8gtib8J
hH0+WEVCwGE8j6PqD6af01KuiS2a0Cv5qQHmAKeI0idFLfgMPs3A6YU/k6oAA5Rg
gkVvZgnfwEgHYEKnyN8BUOdgydP/+MKC/uBjyYm6bW9YY6GGSAIxfOQ9eSMyg8wN
WAd1vjJnK7nNAUH1ZP+M/zzT/ILbjB95+Lfc4cVy7x5a6xx9+Qb6d0hlv9Mjcs3w
TM8JuN++fOM7iLn21oO6CS+NPYTJvJhI8s646v4lr1pGHS/Z7lDd4nBzDRij8MNR
7hKDSHl1bbyuppIkvJFf7qGzQX8gQOduVrs0FhmOszEVm6KA1/ujmSooR3sZx20=
=/uOa
-----END PGP SIGNATURE-----

--VBU7elsDNe9bRoFRdPCjhncODgrR6eq9F--
