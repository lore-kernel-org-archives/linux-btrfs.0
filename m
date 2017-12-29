Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58113 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751253AbdL2AWc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 19:22:32 -0500
Subject: Re: Hand Patching a BTRFS Superblock?
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
Date: Fri, 29 Dec 2017 08:22:24 +0800
MIME-Version: 1.0
In-Reply-To: <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bT8b2pnHnTqXqgxk2vHECICjSyl4Sfqsm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bT8b2pnHnTqXqgxk2vHECICjSyl4Sfqsm
Content-Type: multipart/mixed; boundary="H696qh79qHM0vbg5ddaWpmINgHENgMkvR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
Subject: Re: Hand Patching a BTRFS Superblock?
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
In-Reply-To: <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>

--H696qh79qHM0vbg5ddaWpmINgHENgMkvR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8829=E6=97=A5 07:09, Stirling Westrup wrote:
> Using "btrfs rescue super-recover" is of no use since there are no
> valid superblocks on the disk I need to fix.

Btrfs has normally 1 primary superblock and 1 or 2 backup superblocks.

super-recover is going to read the backup superblocks and use them as
the base to recover primary superblock.

If super-recover can't even find the backups, then the disk is more
damaged than you have expected.

> In fact, it's even worse,
> because the only even partly valid superblock is a copy of the one
> from drive sdd, which is a perfectly valid drive. What I need to do
> (as far as I can tell) is:
>=20
> 1) Patch the UUID_SUB and device number of sdf to make it distinct
> from sdd. Or just generate an entirely new superblock for sdf which
> indicates it is device 2 in the 4-device BTRFS (rather than device 1
> which it now thinks it is).

You need your device UUID, which can be found in device tree.
(Only if you could mount the fs in RO and degraded mode, then you're
still OK to read it out)

You're looking for this part of "btrfs ins dump-super" output:
------
=2E..
cache_generation	8
uuid_tree_generation	8
dev_item.uuid		f1d9b288-7865-463f-a65c-ca8b1fbde09b <<<<<
dev_item.fsid		1dd513fb-45f8-404f-ae23-979e3acb78ad [match]
dev_item.type		0
dev_item.total_bytes	10737418240
=2E..
------

>=20
> 2) Recover (somehow) whatever other information from the superblock
> that is missing.
>=20

Just as I said, if your backup super is also corrupted, there is little
chance to recover.

To verify if the backups are still alive, please paste the output of
"btrfs ins dump-super -fa".
(Even you think super-recover is of no use, the output can still help)

Thanks,
Qu

>=20
>=20
> On Thu, Dec 28, 2017 at 7:11 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 19:41, Nikolay Borisov wrote:
>>>
>>>
>>> On 28.12.2017 03:53, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 09:46, Stirling Westrup wrote=
:
>>>>> Here's my situation: I have a network file server containing a 12TB=

>>>>> BTRFS spread out over four devices (sda-sdd) which I am trying to
>>>>> recover. I do have a backup, but it's about 3 months old, and while=
 I
>>>>> could certainly rebuild everything from that if I really had to, I
>>>>> would far rather not have to rerip my latest DVDs. So, I am willing=
 to
>>>>> experiment if it might save me a few hundred hours of reconstructio=
n.
>>>>> I don't currently have another 12 TB of space anywhere for making a=

>>>>> scratch copy.
>>>>>
>>>>> A few days ago sdb developed hard errors and I can no longer mount =
the
>>>>> filesystem. sdb is no longer even recognized as a valid btrfs drive=
=2E
>>>>> However, when I ran ddrescue over the drive I managed to make a clo=
ne
>>>>> (sdf) which contains all but 12K of the original drive. However, th=
ose
>>>>> missing 12K are all in the various superblocks, so the cloned drive=
 is
>>>>> still unreadable.
>>>>>
>>>>> In the hopes that I was only missing a few bits of the superblocks,=
 I
>>>>> started out by dd-ing the first 4M of sdd into sdf in the hopes tha=
t
>>>>> ddrescue would overwrite much of the superblocks, and the final bit=
s
>>>>> from sdd would make things usable.
>>>>>
>>>>> No such luck. I now have a drive sdf which claims to be identical t=
o
>>>>> sdd but which is a clone of sdb. In case it matters, sda and sdc ar=
e
>>>>> each 4TB while sdb and sdd are each 2TB drives; sde is my boot driv=
e
>>>>> and sdf is a 2TB clone of sdb.
>>>>>
>>>>> What I need to do is to somehow patch sdf's primary superblock so i=
t
>>>>> contains the correct device number and UUID_SUB for sdb, so that I =
can
>>>>> attempt some sort of recovery. Right now my linux is (understandabl=
y)
>>>>> quite confused by the situation:
>>>>
>>>> Did you tried "btrfs rescue super-recover"?
>>>>
>>>> Remember to use the devel branch from git, as there is a small bug
>>>> prevent it report correct result.
>>>
>>> Unforutnately my patchset which fixes super-recover is still not merg=
ed,
>>> so he needs to grab the patches from the mailing list and compile the=

>>> btrfs tools himself. The patch in question can be found here:
>>>
>>> https://patchwork.kernel.org/patch/10092471/
>>
>> And just in-case, "btrfs insp dump-super -fa" output could greatly hel=
p
>> us to check if the backup superblocks are really good.
>>
>=20
>=20


--H696qh79qHM0vbg5ddaWpmINgHENgMkvR--

--bT8b2pnHnTqXqgxk2vHECICjSyl4Sfqsm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpFisAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhpOQf+KRWlex0dc+8cjVsBv2hGpuQP
f3BtISJbI5Jn/+7/z46BQMcT95ewiomZ8A8uzH1jpBmAqaR2VSdM53vr30uTKnop
CtdllIT69GogSi6uK9Pe76vC5gUtnUC/cn98zPutI/QZyTCleNZfk8He45QDDlQs
zz4kO6gQNJ63jJnPr3s0masGAw6bIS1WbVHuRyV+Au7H9s8pyMpRIdEIBuMR3FX+
Bm5NSakqNN60Ktsg5Kn3bcmoLVJC+FL2Gjxmby9YNvkwlhror1NzQD4AGn/4kGkp
uDwAnl9xTlTh8myB8zdTVeCyfaT8nCI+mOxXceya4MAIV7WVPHrG3Mu4bQ0KEg==
=jHGQ
-----END PGP SIGNATURE-----

--bT8b2pnHnTqXqgxk2vHECICjSyl4Sfqsm--
