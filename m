Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63879 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751252AbeAOBfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 20:35:02 -0500
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
 <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
 <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
 <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
 <C376D549-BE55-4B02-A681-39180F63E372@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <618575b8-419e-3d09-add0-e42d2c0bb7b2@gmx.com>
Date: Mon, 15 Jan 2018 09:34:56 +0800
MIME-Version: 1.0
In-Reply-To: <C376D549-BE55-4B02-A681-39180F63E372@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="16kFDBM25L8ueRO9Sz1KIlAE4riNAlpoy"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--16kFDBM25L8ueRO9Sz1KIlAE4riNAlpoy
Content-Type: multipart/mixed; boundary="mOQjLeJF6ZIfn2oeb7aIAz5mjqG21GfXn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <618575b8-419e-3d09-add0-e42d2c0bb7b2@gmx.com>
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
 <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
 <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
 <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
 <C376D549-BE55-4B02-A681-39180F63E372@gmail.com>
In-Reply-To: <C376D549-BE55-4B02-A681-39180F63E372@gmail.com>

--mOQjLeJF6ZIfn2oeb7aIAz5mjqG21GfXn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8815=E6=97=A5 08:58, Johannes Ernst wrote:
>>> INFO: task systemd-journal:20876 blocked for more than 120 seconds.
>>> [ 5037.962603]       Tainted: G         C O    4.14.9-1-ARCH #1
>>> [ 5037.962609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
>>> [ 5037.962616] systemd-journal D    0 20876  20860 0x00000100
>>> [ 5037.962622] Call Trace:
>>> [ 5037.962635]  ? __schedule+0x290/0x890
>>> [ 5037.962640]  ? __slab_free+0x14e/0x300
>>> [ 5037.962645]  ? _copy_to_iter+0x8f/0x3d0
>>> [ 5037.962651]  schedule+0x2f/0x90
>>> [ 5037.962704]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
>>
>> Still some tree write is blocking all incoming read.
>>
>> BTW, did your tests include any send and relocation operations?
>>
>> IIRC there is a bug that makes send and relocation (I'm not sure thoug=
h)
>> will cause similar problem.
>=20
> No. I=E2=80=99m doing nothing btrfs-specific at all, it=E2=80=99s just =
whatever systemd-nspawn =E2=80=94ephemeral does.

So, only systemd-nspwan --ephemeral, and nothing else at all?

Even nothing happened inside the container?

Thanks,
Qu

>=20
> Cheers,
>=20
>=20
>=20
> Johannes.--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--mOQjLeJF6ZIfn2oeb7aIAz5mjqG21GfXn--

--16kFDBM25L8ueRO9Sz1KIlAE4riNAlpoy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpcBUAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjX/Qf+KHc7dkZOKm6ZOYfZfWomVlOT
sfYfMml7Ydb5TVYXrFKkQxt/mEYuRMy3TzQNs0kKVJyMToPcXwKRAtfLcd15k2u2
SRFVCjtCdNKrufQruqf/ouHSs48tq+nAejvWBDnqfNl3c/AXUc7f81kKUocT4WiY
/kx9so9oHetABJFm+Q9k3j/2CQnncid5+Zvh2b9pB3HNZ20Bh7CW6LaaBnDa3SVF
2uVhp9UEuJw0Wsis5/p39YLpDdA8ZBEBVGf5zuskz0Dic/X1OrE59/ibv9/fzaMx
uK0+a5lzCKFlyOZQT+OZsNhtohUAm4mwBhDq83IsZ8Udk4KmkReIBWVZAvPG3w==
=uO59
-----END PGP SIGNATURE-----

--16kFDBM25L8ueRO9Sz1KIlAE4riNAlpoy--
