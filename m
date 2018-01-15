Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49773 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbeAOBzj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 20:55:39 -0500
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
 <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
 <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
 <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
 <C376D549-BE55-4B02-A681-39180F63E372@gmail.com>
 <618575b8-419e-3d09-add0-e42d2c0bb7b2@gmx.com>
 <A1CD808B-DBAD-47E7-BE50-B376021C27FB@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e8224f15-436a-e9a9-4087-cfc90391564c@gmx.com>
Date: Mon, 15 Jan 2018 09:55:33 +0800
MIME-Version: 1.0
In-Reply-To: <A1CD808B-DBAD-47E7-BE50-B376021C27FB@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DgZWmrRzOZFUDYWCtyO3l04DERFaXleNc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DgZWmrRzOZFUDYWCtyO3l04DERFaXleNc
Content-Type: multipart/mixed; boundary="hZWmWgPCn1YWJxTQwXuvThjwfXomRQEFc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <e8224f15-436a-e9a9-4087-cfc90391564c@gmx.com>
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
 <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
 <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
 <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
 <C376D549-BE55-4B02-A681-39180F63E372@gmail.com>
 <618575b8-419e-3d09-add0-e42d2c0bb7b2@gmx.com>
 <A1CD808B-DBAD-47E7-BE50-B376021C27FB@gmail.com>
In-Reply-To: <A1CD808B-DBAD-47E7-BE50-B376021C27FB@gmail.com>

--hZWmWgPCn1YWJxTQwXuvThjwfXomRQEFc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8815=E6=97=A5 09:47, Johannes Ernst wrote:
>>>>> INFO: task systemd-journal:20876 blocked for more than 120 seconds.=

>>>>> [ 5037.962603]       Tainted: G         C O    4.14.9-1-ARCH #1
>>>>> [ 5037.962609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>>>> [ 5037.962616] systemd-journal D    0 20876  20860 0x00000100
>>>>> [ 5037.962622] Call Trace:
>>>>> [ 5037.962635]  ? __schedule+0x290/0x890
>>>>> [ 5037.962640]  ? __slab_free+0x14e/0x300
>>>>> [ 5037.962645]  ? _copy_to_iter+0x8f/0x3d0
>>>>> [ 5037.962651]  schedule+0x2f/0x90
>>>>> [ 5037.962704]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
>>>>
>>>> Still some tree write is blocking all incoming read.
>>>>
>>>> BTW, did your tests include any send and relocation operations?
>>>>
>>>> IIRC there is a bug that makes send and relocation (I'm not sure tho=
ugh)
>>>> will cause similar problem.
>>>
>>> No. I=E2=80=99m doing nothing btrfs-specific at all, it=E2=80=99s jus=
t whatever systemd-nspawn =E2=80=94ephemeral does.
>>
>> So, only systemd-nspwan --ephemeral, and nothing else at all?
>>
>> Even nothing happened inside the container?
>=20
>=20
> Gotcha. (Sorry for missing that)
>=20
> Inside the container, snapper might be invoked. Here are the snippets:
>=20
> snapper -c root create-config -t ubos-default /
> snapper setup-quota
> snapper -c root create --type pre --print-number
> snapper -c root create --type post --pre-number <n>
>=20
> Here is the snapper config:
>=20
> # Snapper default configuration for UBOS.
> #
> # subvolume to snapshot
> SUBVOLUME=3D"/"
>=20
> # filesystem type
> FSTYPE=3D"btrfs"
>=20
> # btrfs qgroup for space aware cleanup algorithms
> QGROUP=3D""

What about disabling qgroup here?

And since I'm not familiar with snapper, I'm not pretty sure what it
will do.

But what about disabling snapper and try again to see if the btrfs hangs?=


Thanks,
Qu

>=20
> # fraction of the filesystems space the snapshots may use
> SPACE_LIMIT=3D"0.2"
>=20
> # users and groups allowed to work with config
> ALLOW_USERS=3D""
> ALLOW_GROUPS=3D""
>=20
> # sync users and groups from ALLOW_USERS and ALLOW_GROUPS to .snapshots=

> # directory
> SYNC_ACL=3D"no"
>=20
> # start comparing pre- and post-snapshot in background after creating
> # post-snapshot
> BACKGROUND_COMPARISON=3D"no"
>=20
> # run daily number cleanup
> NUMBER_CLEANUP=3D"yes"
>=20
> # limit for number cleanup; unit is seconds
> NUMBER_MIN_AGE=3D"1800"
> NUMBER_LIMIT=3D"50"
> NUMBER_LIMIT_IMPORTANT=3D"10"
>=20
> # create hourly snapshots
> TIMELINE_CREATE=3D"no"
>=20
> # cleanup hourly snapshots after some time
> TIMELINE_CLEANUP=3D"yes"
>=20
> # limits for timeline cleanup; unit is seconds
> TIMELINE_MIN_AGE=3D"1800"
> TIMELINE_LIMIT_HOURLY=3D"12"
> TIMELINE_LIMIT_DAILY=3D"7"
> TIMELINE_LIMIT_WEEKLY=3D"0"
> TIMELINE_LIMIT_MONTHLY=3D"6"
> TIMELINE_LIMIT_YEARLY=3D"0"
>=20
> # cleanup empty pre-post-pairs
> EMPTY_PRE_POST_CLEANUP=3D"yes"
>=20
> # limits for empty pre-post-pair cleanup
> EMPTY_PRE_POST_MIN_AGE=3D"1800"
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--hZWmWgPCn1YWJxTQwXuvThjwfXomRQEFc--

--DgZWmrRzOZFUDYWCtyO3l04DERFaXleNc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpcChUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjyzAgAhPtNdFh2k9TN2wglrxuQwISG
J7EEXdz9+zs80thQ3/PrKBMiFTUMjevov/TrF29zD3UX4h066XYLw6Azu5gzFIcu
oezmvCbDV3bttcriZOXdp+YAEHKFV/0UImBy4FWrTYMxd7haFqEgHjvx05I60XvY
C06EnYyCGXau8W42VGCc0dH/K6/EGHRAIcnz/5nyyWC7D5IJgAMmTgpJw+3AR1FH
2+naGPqAP1tM/miWhof9N1ZgKCMWzK2j6lPW2rXTviD38Jvq3/aALRA2WCm9Qm7l
Z7VXJJNHoK2cg8QezgKk89+9889WE4Kcmd7bYrbLPWT7tXAPK9f8WatriXVj+A==
=ZUGb
-----END PGP SIGNATURE-----

--DgZWmrRzOZFUDYWCtyO3l04DERFaXleNc--
