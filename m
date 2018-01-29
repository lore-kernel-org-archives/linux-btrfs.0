Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbeA2PKZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 10:10:25 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
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
 <CAAxOLF8f0RWtLQdsaMFYq=0q4yWZTo_d7zso9nBsVSp65Ekscg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f88e13d2-8e8b-8d16-0ed1-8b815ef7d766@gmx.com>
Date: Mon, 29 Jan 2018 23:10:18 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF8f0RWtLQdsaMFYq=0q4yWZTo_d7zso9nBsVSp65Ekscg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Rv9myVMuEWspWExRXUCLPzTpYL20n1jO5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Rv9myVMuEWspWExRXUCLPzTpYL20n1jO5
Content-Type: multipart/mixed; boundary="So0SLpdchuUtZg9qeu6Hsh3cJQBWcrOaH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <f88e13d2-8e8b-8d16-0ed1-8b815ef7d766@gmx.com>
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
 <CAAxOLF8f0RWtLQdsaMFYq=0q4yWZTo_d7zso9nBsVSp65Ekscg@mail.gmail.com>
In-Reply-To: <CAAxOLF8f0RWtLQdsaMFYq=0q4yWZTo_d7zso9nBsVSp65Ekscg@mail.gmail.com>

--So0SLpdchuUtZg9qeu6Hsh3cJQBWcrOaH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 23:08, ^m'e wrote:
> Lowmem check on my backup pool reports dozens of 'backref lost' on
> extents... Excerpt:
> ----------------------------------------------------------
> # ./btrfsck.static check --mode=3Dlowmem /dev/sda1
> checking extents
> ERROR: data extent[33866182656 4096] backref lost
> ERROR: data extent[37102219264 114688] backref lost
> ERROR: data extent[37090353152 45056] backref lost
> ERROR: data extent[37193342976 114688] backref lost
> ERROR: data extent[50151686144 53248] backref lost
> ERROR: data extent[49782943744 126976] backref lost
> ERROR: data extent[49718861824 77824] backref lost
> ERROR: data extent[33853538304 4096] backref lost
> ERROR: data extent[41170333696 692224] backref lost
> ERROR: data extent[37550239744 4096] backref lost
> ERROR: data extent[33866182656 4096] backref lost
> ERROR: data extent[37102219264 114688] backref lost
> ...
>=20
> ERROR: data extent[37193342976 114688] backref lost
> ERROR: data extent[50151686144 53248] backref lost
> ERROR: data extent[49782943744 126976] backref lost
> ERROR: data extent[49718861824 77824] backref lost
> ERROR: data extent[33853538304 4096] backref lost
> ERROR: data extent[41170333696 692224] backref lost
> ERROR: data extent[37550239744 4096] backref lost
> ERROR: data extent[44122832896 8192] backref lost
> ERROR: data extent[45874237440 40960] backref lost
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> block group 112772251648 has wrong amount of free space
> failed to load free space cache for block group 112772251648
> Wanted offset 127268339712, found 127268323328
> Wanted offset 127268339712, found 127268323328
> cache appears valid but isn't 127267766272
> block group 133173346304 has wrong amount of free space
> failed to load free space cache for block group 133173346304
> Wanted offset 142837039104, found 142837022720
> Wanted offset 142837039104, found 142837022720
> cache appears valid but isn't 142837022720
> ERROR: errors found in free space cache
> Checking filesystem on /dev/sda1
> UUID: 854e1bf5-7a98-4bcb-b971-0d9f2ac9452a
> found 200684883968 bytes used, error(s) found
> total csum bytes: 186712500
> total tree bytes: 40191000576
> total fs tree bytes: 39574110208
> total extent tree bytes: 359038976
> btree space waste bytes: 7605597010
> file data blocks allocated: 946099404800
>  referenced 1091731312640
> ----------------------------------------------------------
>=20
> Is that related to flawed snapshots of the ailing rootfs vol?

For that specific problem, lowmem is not that reliable.
Use original mode to make sure.

Thanks,
Qu

> Is it safe to try to rollback from it?
>=20
> Cheers,
>=20
>   M.
>=20
>=20
> On Mon, Jan 29, 2018 at 2:49 PM, ^m'e <marcoep@gmail.com> wrote:
>> On Mon, Jan 29, 2018 at 2:04 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>>
>>>
>>> On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 21:58, ^m'e wrote:
>>>> Thanks for the advice, Qu!
>>>>
>>>> I used the system for a while, did some package upgrades -- writing =
in
>>>> the suspect corrupted area. Then tried a btrfs-send to my backup vol=
,
>>>> and it failed miserably with a nice kernel oops.
>>>>
>>>> So I went for a lowmem repair:
>>>> --------------------------------------------------------------------=
--------------------
>>>> # ./btrfsck.static check --repair --mode=3Dlowmem /dev/sdb3 2>&1 | t=
ee
>>>> /mnt/custom/rescue/btrfs-recovery/btrfs-repair.BTR-POOL.1.log
>>>> WARNING: low-memory mode repair support is only partial
>>>> Fixed 0 roots.
>>>> checking extents
>>>> checking free space cache
>>>> checking fs roots
>>>> ERROR: failed to add inode 28891726 as orphan item root 257
>>>> ERROR: root 257 INODE[28891726] is orphan item
>>>
>>> At least I need dig the kernel code further to determine if the orpha=
n
>>> inode handling in btrfs-progs is correct or not.
>>>
>>> So there won't be more dirty fix soon.
>>>
>>> Hopefully you could get some good backup and restore the system.
>>>
>>> At least the problem is limited to a very small range, and it's
>>> something we could handle easily.
>>>
>>> Thanks for all your report,
>>> Qu
>>>
>>>
>>
>> Right.
>>
>> Meanwhile, could you please suggest the best course of action? btrfs
>> rescue or restore?
>> I have snapshots of my two subvols (rootfs, home -- now fs-checking
>> them  just in case...)
>>
>> Cheers,
>>
>>   Marco
>=20
>=20
>=20


--So0SLpdchuUtZg9qeu6Hsh3cJQBWcrOaH--

--Rv9myVMuEWspWExRXUCLPzTpYL20n1jO5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpvOVsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjrfAgAoJeYRuU3qpdvYdE6Z2u7Ps/J
SEfowXFAzX1ty9yom/fBG//3KZCseCJjHV0lzQWJ1U4QADv6Do01IYNUaCLP0EZz
qDaIq3Nz76RjmNshwGAXWdyZHtVAWYHs9kduyyrbnZrsTYJDKlki44A1X3eDUaDr
umUv8AjmYhGmYF4muvwUnlngovfrOy7LPJ9C78+cOHaOlOe9mhR6iT+lJJxCxfgY
UcPLh+c/pmENxzI9VaWlXblHNFtA34oll/OCBx8bGa+P/TfjeQYGr5uWZJ5b2UJu
kpTgQlGYi1QySIrzwqq3GVSpxvW4719yOoOxhU+aAl0Vq4/RtK53YaN/6g6BSg==
=R46G
-----END PGP SIGNATURE-----

--Rv9myVMuEWspWExRXUCLPzTpYL20n1jO5--
