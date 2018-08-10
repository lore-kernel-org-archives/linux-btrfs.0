Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:46911 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbeHJNV0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 09:21:26 -0400
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
 <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
 <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com>
Date: Fri, 10 Aug 2018 18:51:59 +0800
MIME-Version: 1.0
In-Reply-To: <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GiiOSPlKmWa1A6NyVxXy6lhihhkkiW5Zl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GiiOSPlKmWa1A6NyVxXy6lhihhkkiW5Zl
Content-Type: multipart/mixed; boundary="41scca5xmBfAO200ripTTcN5E85xLilXB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
 <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
 <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
In-Reply-To: <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>

--41scca5xmBfAO200ripTTcN5E85xLilXB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/10/18 6:42 PM, Dan Merillat wrote:
> On Fri, Aug 10, 2018 at 6:05 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>=20
>>
>> Although not sure about the details, but the fs looks pretty huge.
>> Tons of subvolume and its free space cache inodes.
>=20
> 11TB, 3 or so subvolumes and two snapshots I think.  Not particularly
> large for NAS.
>=20
>> But only 3 tree reloc trees, unless you have tons of reflinked files
>> (off-line deduped), it shouldn't cause a lot of problem.
>=20
> There's going to be a ton of reflinked files.  Both cp --reflink and
> via the wholefile dedup.
>=20
> I freed up ~1/2 TB last month doing dedup.
>=20
>> At least, we have some progress dropping tree reloc tree for subvolume=
 6482.
>=20
> Is there a way to get an idea of how much work is left to be done on
> the reloc tree?

You could inspect by the level.
But each level change is a huge step forward.

>  Can I walk it
> with btrfs-inspect?

Of course you can. Using -b <bytenr> could show the remaining tree.

>=20
> dump-tree -t TREE_RELOC is quite enormous (13+ million lines before I g=
ave up)

No wonder, since it's kind of snapshot of your subvolume.

>=20
>> If you check the dump-tree output for the following data, the "drop ke=
y"
>> should change during mount: (inspect dump-tree can be run mounted)
>>         item 175 key (TREE_RELOC ROOT_ITEM 6482) itemoff 8271 itemsize=
 439
>>                 <snip>
>>                 drop key (2769795 EXTENT_DATA 12665933824) level 2
>>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> So for the worst case scenario, there is some way to determine whether=

>> it's processing.
>=20
> I'll keep an eye on that.
>=20
>> And according to the level (3), which is not small for each subvolume,=
 I
>> doubt that's the reason why it's so slow.
>>
>> BTW, for last skip_balance mount, is there any kernel message like
>> "balance: resume skipped"?
>=20
> No, the only reference to balance in kern.log is a hung
> btrfs_cancel_balance from the first reboot.

That's strange.

But considering your amount of block groups, mount itself may take some
time (before trying to resume balance).

Thanks,
Qu

>=20
>> Have you tried mount the fs readonly with skip_balance? And then remou=
nt
>> rw, still with skip_balance?
>=20
> No, every operation takes a long time.  It's still running the btrfs
> check, although I'm
> going to cancel it and try mount -o ro,skip_balance before I go to
> sleep and see where it is tomorrow.
>=20
> Thank you for taking the time to help me with this.
>=20


--41scca5xmBfAO200ripTTcN5E85xLilXB--

--GiiOSPlKmWa1A6NyVxXy6lhihhkkiW5Zl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlttbk8ACgkQwj2R86El
/qgiUAgAq1Yl2SVKMGIZ5+PFHyDrBd705mG6vRe+3E0KH6i1YJnxBPWGdxH+iVR9
IjysQ9yrF8ciTRLyiKvUocMiSk659/yKHtkm3XxQDnD0gT6TvdJaKYJf9Ld9BH0o
u3eNYl6qZXK3YMGzo1bJDERZLQ0GQUu5fDNqDMQCFIgvqlsMCqGKhjzlkYHZ7H1x
jrMCzfT2ny+PEFeKeFHykx5oryC1OIPE8GVXDqXR9yh8MMk440gOEdMvkAxVkf79
gCV7fZUv8fXPt/Mz65XhNdD/M2EYLnHV8QF7U68GwR2JnCYHy6+j4DCjVTvo2d3K
nUaxnCRBJLQRD0OCV/F/YnQSCRC68A==
=HQR8
-----END PGP SIGNATURE-----

--GiiOSPlKmWa1A6NyVxXy6lhihhkkiW5Zl--
