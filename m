Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65294 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751783AbeA2PJY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 10:09:24 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
 <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com>
 <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com>
 <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
 <365e746e-de87-2977-daee-7b2335c545b1@gmx.com>
 <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>
 <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com>
 <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <44af6e3e-c580-2174-9a9c-14b7cea3a904@gmx.com>
Date: Mon, 29 Jan 2018 23:09:18 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vJtMFZiGC0He6VfQZhe29VlOOmeSFtsnG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vJtMFZiGC0He6VfQZhe29VlOOmeSFtsnG
Content-Type: multipart/mixed; boundary="INSrzltRrzVF19XjcnBDNk1zDaHgZ7eRU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <44af6e3e-c580-2174-9a9c-14b7cea3a904@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
 <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com>
 <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com>
 <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
 <365e746e-de87-2977-daee-7b2335c545b1@gmx.com>
 <CAAxOLF82tDaCa8+MBNnyWXDTWX2v-H=7a9qwFtBoehGW8Q=TyA@mail.gmail.com>
 <f0a66bee-f648-9f00-b56b-b59646c06779@gmx.com>
 <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>
In-Reply-To: <CAAxOLF9NTd4TcDc1FW23CE=5nR-Kp62=OJz31XmG_LqZBZJmsg@mail.gmail.com>

--INSrzltRrzVF19XjcnBDNk1zDaHgZ7eRU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 22:49, ^m'e wrote:
> On Mon, Jan 29, 2018 at 2:04 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 21:58, ^m'e wrote:
>>> Thanks for the advice, Qu!
>>>
>>> I used the system for a while, did some package upgrades -- writing i=
n
>>> the suspect corrupted area. Then tried a btrfs-send to my backup vol,=

>>> and it failed miserably with a nice kernel oops.
>>>
>>> So I went for a lowmem repair:
>>> ---------------------------------------------------------------------=
-------------------
>>> # ./btrfsck.static check --repair --mode=3Dlowmem /dev/sdb3 2>&1 | te=
e
>>> /mnt/custom/rescue/btrfs-recovery/btrfs-repair.BTR-POOL.1.log
>>> WARNING: low-memory mode repair support is only partial
>>> Fixed 0 roots.
>>> checking extents
>>> checking free space cache
>>> checking fs roots
>>> ERROR: failed to add inode 28891726 as orphan item root 257
>>> ERROR: root 257 INODE[28891726] is orphan item
>>
>> At least I need dig the kernel code further to determine if the orphan=

>> inode handling in btrfs-progs is correct or not.
>>
>> So there won't be more dirty fix soon.
>>
>> Hopefully you could get some good backup and restore the system.
>>
>> At least the problem is limited to a very small range, and it's
>> something we could handle easily.
>>
>> Thanks for all your report,
>> Qu
>>
>>
>=20
> Right.
>=20
> Meanwhile, could you please suggest the best course of action? btrfs
> rescue or restore?
> I have snapshots of my two subvols (rootfs, home -- now fs-checking
> them  just in case...)

Don't run --repair any more.
It seems to make the case worse.

While the RW mount with orphan cleanup abort seems to screwed up the
filesystem.

In this case, it's pretty hard to recover, but still has small chance.

Use btrfs inspec dump-super to get backup roots:

# btrfs inspect dump-super -fFa <device> |grep backup_tree_root: | sort
| uniq

And try all the 4 numbers in the following commands:

# btrfs check --tree-root <number> <device>

To see if is there any good one without transid error.

Thanks,
Qu

>=20
> Cheers,
>=20
>   Marco
>=20


--INSrzltRrzVF19XjcnBDNk1zDaHgZ7eRU--

--vJtMFZiGC0He6VfQZhe29VlOOmeSFtsnG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpvOR4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjNiggAr9k9omWDT53jhI8hMyaXhOWt
xc7KavyAQtIZQLyUZTCUKVAMkl5CI1GIsPCpQWTtyf6v4/iUccgkIgpZ88n/UP3g
Fn042k5fcel4sfZ/nTNvWRDTDsYf6Wfn/W5b6I5HBFUvJ4PqOmwkgQHWJlBA9itR
Zj2rMwh6CO6aGJQfKDBv3+zKYmNWIQTYgBBg5OYKfCCo0UyUxPFQr/9bLD42fibv
Z9UL5K6p84aTVrWkiab0IvmXvB9HqNE5YSzbwddN3UrjAPUWKrixjvzK4GcyyEuU
P+tk4P2HKAKUgaSwXCBQLy39oRcj9vWY+GMwIGu1o7Lm3L0NwPq73z4DXzkiKA==
=u2oR
-----END PGP SIGNATURE-----

--vJtMFZiGC0He6VfQZhe29VlOOmeSFtsnG--
