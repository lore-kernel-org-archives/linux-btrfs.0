Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58347 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbeITGfx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 02:35:53 -0400
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Martin Steigerwald <martin@lichtvoll.de>
Cc: Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
 <e712843a-d902-97c1-7270-84dfe56c83e1@mendix.com>
 <1646602.qIcv3L3msO@merkaba>
 <6d38300b-621c-a0e0-9bcc-6aafaa9d6f4e@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <92ceee76-3412-13d1-1329-a9ab166a4d62@gmx.com>
Date: Thu, 20 Sep 2018 08:55:00 +0800
MIME-Version: 1.0
In-Reply-To: <6d38300b-621c-a0e0-9bcc-6aafaa9d6f4e@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OYkqju89785NgkhzOY38CCOTshjFslLua"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OYkqju89785NgkhzOY38CCOTshjFslLua
Content-Type: multipart/mixed; boundary="9qR855S89qALp3w6AM1L2SvU7jzpnrWPr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Martin Steigerwald <martin@lichtvoll.de>
Cc: Tomasz Chmielewski <tch@virtall.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <92ceee76-3412-13d1-1329-a9ab166a4d62@gmx.com>
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
 <e712843a-d902-97c1-7270-84dfe56c83e1@mendix.com>
 <1646602.qIcv3L3msO@merkaba>
 <6d38300b-621c-a0e0-9bcc-6aafaa9d6f4e@mendix.com>
In-Reply-To: <6d38300b-621c-a0e0-9bcc-6aafaa9d6f4e@mendix.com>

--9qR855S89qALp3w6AM1L2SvU7jzpnrWPr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/20 =E4=B8=8A=E5=8D=884:11, Hans van Kranenburg wrote:
> On 09/19/2018 10:04 PM, Martin Steigerwald wrote:
>> Hans van Kranenburg - 19.09.18, 19:58:
>>> However, as soon as we remount the filesystem with space_cache=3Dv2 -=

>>>
>>>> writes drop to just around 3-10 MB/s to each disk. If we remount to
>>>> space_cache - lots of writes, system unresponsive. Again remount to
>>>> space_cache=3Dv2 - low writes, system responsive.
>>>>
>>>> That's a huuge, 10x overhead! Is it expected? Especially that
>>>> space_cache=3Dv1 is still the default mount option?
>>>
>>> Yes, that does not surprise me.
>>>
>>> https://events.static.linuxfound.org/sites/events/files/slides/vault2=
0
>>> 16_0.pdf
>>>
>>> Free space cache v1 is the default because of issues with btrfs-progs=
,
>>> not because it's unwise to use the kernel code. I can totally
>>> recommend using it. The linked presentation above gives some good
>>> background information.
>>
>> What issues in btrfs-progs are that?
>=20
> Missing code to make offline changes to a filesystem that has a free
> space tree. So when using btrfstune / repair / whatever you first need
> to remove the whole free space tree with a command, and then add it bac=
k
> on the next mount.
>=20
> For me personally that's not a problem (I don't have to make offline
> changes), but I understand that having that situation out of the box fo=
r
> every new user would be a bit awkward.
>=20
>> I am wondering whether to switch to freespace tree v2. Would it provid=
e=20
>> benefit for a regular / and /home filesystems as dual SSD BTRFS RAID-1=
=20
>> on a laptop?
>=20
> As shown in the linked presentation, it provides benefit on a largeish
> filesystem and if your writes are touching a lot of different block
> groups (since v1 writes out the full space cache for all of them on
> every transaction commit).

In fact that's the problem.

=46rom free space cache inode flags, it's
NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC.

But the fact is, if it's modified, the whole file just get CoWed.

If we could change it to follow the inode flags, we could reduce
overhead even smaller than v2 one.
(v1 needs at least (1 + n) * sectorsize(4K) one for the header which
contains the csum, while v2 needs metadata CoW which is at least
nodesize (default to 16K)).

Thanks,
Qu

> I'd say, it provides benefit as soon as you
> encounter filesystem delays because of it, and as soon as you see using=

> it eases the pain a lot. So, yes, that's your case.
>=20


--9qR855S89qALp3w6AM1L2SvU7jzpnrWPr--

--OYkqju89785NgkhzOY38CCOTshjFslLua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlui7+QACgkQwj2R86El
/qhizwgArcHMboz9i7K4jr8973wBQD+D5rlLJrkgbqM+nV0YWPPBssW5coLmA2RF
9RC9ebaj3cksIZ9xmi6bIn2lKdNohGaJCifbJmY1zPsDdYIMIbzvjxhb23uQvcuV
vwAMTeuwcetGnHqq7Wqux9gtW8MqyJLxc8LD06Hq2nSYbzkerjT0Vm1JAxPubDCJ
1qVteGt4V0af8DjncxAWrd3o1b0J3y9ytmfzqCmrHonKbJjpqVcZic7T42TC6Pk/
F9QoAVeI0LnCYrfWD7Z7MkZaGhbcaeuOjRNZD6aSwWSFBjBvgYKIgD/1s7AuOgaL
uwUd+HXj934+bpEVNWOwTFtNSph8Ew==
=pvm+
-----END PGP SIGNATURE-----

--OYkqju89785NgkhzOY38CCOTshjFslLua--
