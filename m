Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64456 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753441AbeAOEXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 23:23:20 -0500
Subject: Re: invalid files names, btrfs check can't repair it
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115015952.GA523@fnst.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <920c8582-a871-c10f-5222-16be9f14de52@gmx.com>
Date: Mon, 15 Jan 2018 12:23:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180115015952.GA523@fnst.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C6620TacQwMGCDYgGP5eTUON4PrtHOyhn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C6620TacQwMGCDYgGP5eTUON4PrtHOyhn
Content-Type: multipart/mixed; boundary="7x077sNbdI6sXmoyZZA0qCOR1qSi01Z4b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
 Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <920c8582-a871-c10f-5222-16be9f14de52@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115015952.GA523@fnst.localdomain>
In-Reply-To: <20180115015952.GA523@fnst.localdomain>

--7x077sNbdI6sXmoyZZA0qCOR1qSi01Z4b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8815=E6=97=A5 09:59, Lu Fengqi wrote:
> On Mon, Jan 15, 2018 at 09:26:27AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8815=E6=97=A5 00:38, Sebastian Andrzej Siewio=
r wrote:
>>> On 2018-01-14 08:36:41 [+0800], Qu Wenruo wrote:
>>>> Still needs more. (and maybe even more depending on the output)
>>>>
>>>> The original mode doesn't report error clear enough, so it would hel=
p if
>>>> --mode=3Dlowmem can be used.
>>>>
>>>> # btrfs check --mode=3Dlowmem /dev/sdb4
>>>
>>> ~# btrfs check --mode=3Dlowmem /dev/sdb4
>>> Checking filesystem on /dev/sdb4
>>> UUID: b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
>>> checking extents
>>> checking free space cache
>>> Wanted bytes 4096, found 8192 for off 159178047488
>>> Wanted bytes 1073725440, found 8192 for off 159178047488
>>> cache appears valid but isn't 159178031104
>>> ERROR: errors found in free space cache
>>
>> A new bug is exposed for lowmem mode.
>> It doesn't check fs tree if space cache has any problem.
>>
>=20
> Just a reminder, the problem is not only for lowmem mode.

Right, I'll fix it soon.

And BTW what makes the the output different from the original one?

Sebastaian, did you do extra write or other operation to the fs after
previous btrfs check?

Thanks,
Qu

>=20
>         ret =3D check_space_cache(root);
>         err |=3D !!ret;
>         if (ret) {
>                 if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
>                         error("errors found in free space tree");
>                 else
>                         error("errors found in free space cache");
>                 goto out;
>                 ^^^
>         }
>=20
>         /*
>          * We used to have to have these hole extents in between our re=
al
>          * extents so if we don't have this flag set we need to make su=
re there
>          * are no gaps in the file extents for inodes, otherwise we can=
 just
>          * ignore it when this happens.
>          */
>         no_holes =3D btrfs_fs_incompat(root->fs_info, NO_HOLES);
>         ret =3D do_check_fs_roots(info, &root_cache);
>               ^^^
>         err |=3D !!ret;
>         if (ret) {
>                 error("errors found in fs roots");
>                 goto out;
>         }
>=20


--7x077sNbdI6sXmoyZZA0qCOR1qSi01Z4b--

--C6620TacQwMGCDYgGP5eTUON4PrtHOyhn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpcLKkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh/dQf9GOu9SYqYNqaLCCEQW+l1GqX+
ivLeg1VO2JA2XO/ANJTQFrQDtU5cX7Qg+RPPFVRQzkXjHqqpu59k959uktA0eh5x
JH8+FbHx38tjz39W/Gms5CChbqJL6vn8bD5G6DzLNFVqGn67z2kozdEIPjiacOHu
6DPUx++cj+QoysjfoIdb4+Z9Dl5mdML/cg7LYKFXYQN5d8uV3yWkgzBhq/0OiUhz
Fn4SuCo3aCrSw3TGWFbJi7PQHsje4l+qFTvC1W6b23HsAycguU8f66YpT9nZOBL/
cwEv14OWwL50Jusql2T9HzXtipyiD2B6JJwIdcuds5m1hVcJwcIDokI3IcKSqw==
=1NAf
-----END PGP SIGNATURE-----

--C6620TacQwMGCDYgGP5eTUON4PrtHOyhn--
