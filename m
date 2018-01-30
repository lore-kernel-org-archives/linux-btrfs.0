Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbeA3BYS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 20:24:18 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
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
 <44af6e3e-c580-2174-9a9c-14b7cea3a904@gmx.com>
 <CAAxOLF_45qefY7d8zz3LzbPGXY_xt5D9YS5H6m1e0FcRE_iBMA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <47ee25a7-f0fd-e342-fc99-7bd0fd91af48@gmx.com>
Date: Tue, 30 Jan 2018 09:24:10 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF_45qefY7d8zz3LzbPGXY_xt5D9YS5H6m1e0FcRE_iBMA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tS7AEcuXTO57YnAPjcRdEGpCN9dGLwUqt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tS7AEcuXTO57YnAPjcRdEGpCN9dGLwUqt
Content-Type: multipart/mixed; boundary="cEiPbHdwrZfNBDco3EYvTWOVQeYNLzX4r";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <47ee25a7-f0fd-e342-fc99-7bd0fd91af48@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
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
 <44af6e3e-c580-2174-9a9c-14b7cea3a904@gmx.com>
 <CAAxOLF_45qefY7d8zz3LzbPGXY_xt5D9YS5H6m1e0FcRE_iBMA@mail.gmail.com>
In-Reply-To: <CAAxOLF_45qefY7d8zz3LzbPGXY_xt5D9YS5H6m1e0FcRE_iBMA@mail.gmail.com>

--cEiPbHdwrZfNBDco3EYvTWOVQeYNLzX4r
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8830=E6=97=A5 02:16, ^m'e wrote:
> Thanks!
>=20
> Got these
>=20
>   # ./btrfs.static inspect dump-super -fFa /dev/sdb3 |grep
> backup_tree_root: | sort -u
>         backup_tree_root:    180410073088    gen: 463765    level: 1
>         backup_tree_root:    180415758336    gen: 463766    level: 1
>         backup_tree_root:    180416364544    gen: 463767    level: 1
>         backup_tree_root:    4194304    gen: 463764    level: 1
>=20
> but, nada: all have transid failures...

That's why I call it "small chance"

>=20
> The backup snapshots are OK as per original check.

Then you should be OK to restore.

Thanks,
Qu

>=20
>=20
> On Mon, Jan 29, 2018 at 3:09 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 22:49, ^m'e wrote:
>>> On Mon, Jan 29, 2018 at 2:04 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>> On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 21:58, ^m'e wrote:
>>>>> Thanks for the advice, Qu!
>>>>>
>>>>> I used the system for a while, did some package upgrades -- writing=
 in
>>>>> the suspect corrupted area. Then tried a btrfs-send to my backup vo=
l,
>>>>> and it failed miserably with a nice kernel oops.
>>>>>
>>>>> So I went for a lowmem repair:
>>>>> -------------------------------------------------------------------=
---------------------
>>>>> # ./btrfsck.static check --repair --mode=3Dlowmem /dev/sdb3 2>&1 | =
tee
>>>>> /mnt/custom/rescue/btrfs-recovery/btrfs-repair.BTR-POOL.1.log
>>>>> WARNING: low-memory mode repair support is only partial
>>>>> Fixed 0 roots.
>>>>> checking extents
>>>>> checking free space cache
>>>>> checking fs roots
>>>>> ERROR: failed to add inode 28891726 as orphan item root 257
>>>>> ERROR: root 257 INODE[28891726] is orphan item
>>>>
>>>> At least I need dig the kernel code further to determine if the orph=
an
>>>> inode handling in btrfs-progs is correct or not.
>>>>
>>>> So there won't be more dirty fix soon.
>>>>
>>>> Hopefully you could get some good backup and restore the system.
>>>>
>>>> At least the problem is limited to a very small range, and it's
>>>> something we could handle easily.
>>>>
>>>> Thanks for all your report,
>>>> Qu
>>>>
>>>>
>>>
>>> Right.
>>>
>>> Meanwhile, could you please suggest the best course of action? btrfs
>>> rescue or restore?
>>> I have snapshots of my two subvols (rootfs, home -- now fs-checking
>>> them  just in case...)
>>
>> Don't run --repair any more.
>> It seems to make the case worse.
>>
>> While the RW mount with orphan cleanup abort seems to screwed up the
>> filesystem.
>>
>> In this case, it's pretty hard to recover, but still has small chance.=

>>
>> Use btrfs inspec dump-super to get backup roots:
>>
>> # btrfs inspect dump-super -fFa <device> |grep backup_tree_root: | sor=
t
>> | uniq
>>
>> And try all the 4 numbers in the following commands:
>>
>> # btrfs check --tree-root <number> <device>
>>
>> To see if is there any good one without transid error.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Cheers,
>>>
>>>   Marco
>>>
>>
>=20
>=20
>=20


--cEiPbHdwrZfNBDco3EYvTWOVQeYNLzX4r--

--tS7AEcuXTO57YnAPjcRdEGpCN9dGLwUqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpvyToXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh7Ggf/RCNlX4Toyxao5p7xEPvw0VOL
SOPeXFO7gyZ4Qoz7K50tGWGx2TR1FnY4SV9EvjRAO1TeQOKF1W45PQbgxjYtQI/r
AX6nVbMnINQhkSv8khki1m8iR49WvAcG0hTjQRneY5J80vPvtOO1CoMwsyLIaIo6
bz5zJvmjEqutrpcalpKYa7uiPuNT2+yGHeUt+y+uW1Jo4d7fI1Wzq6xSbdxe4tQk
I7N2ksZnFW5T6eos/mE/SO9xEwcUjqlih2i7VJ5xzgNaSSltwIcWp4BcD7HwmDm5
u1vKxOrl5uJ/Y/hLxjiIzDHQ7Bnwv0UEpG7Hrk2nm00xv41/BPxijGlRSXEKCw==
=y+zx
-----END PGP SIGNATURE-----

--tS7AEcuXTO57YnAPjcRdEGpCN9dGLwUqt--
