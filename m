Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49655 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbeIKRyz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 13:54:55 -0400
Subject: Re: btrfs-progs: btrfs-convert: unable to find block group for 0
To: dsterba@suse.cz, Tucker Boniface <tucker@boniface.tech>,
        linux-btrfs@vger.kernel.org
References: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>
 <e92c69e8-1145-263f-dce1-f8a55dc15193@gmx.com>
 <20180911145258.GE2997@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <edd55e92-e45f-87e6-52a8-9a14b1ad45bb@gmx.com>
Date: Tue, 11 Sep 2018 20:55:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180911145258.GE2997@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hStPGtTOIIBl7Fu3yEYddsGdOBFc8TiiR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hStPGtTOIIBl7Fu3yEYddsGdOBFc8TiiR
Content-Type: multipart/mixed; boundary="hQt8gDWm2NMhzNiV9gPsgtEzEKucpH38M";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Tucker Boniface <tucker@boniface.tech>,
 linux-btrfs@vger.kernel.org
Message-ID: <edd55e92-e45f-87e6-52a8-9a14b1ad45bb@gmx.com>
Subject: Re: btrfs-progs: btrfs-convert: unable to find block group for 0
References: <afa83c87-df24-941a-348c-bb58cf7ac033@boniface.tech>
 <e92c69e8-1145-263f-dce1-f8a55dc15193@gmx.com>
 <20180911145258.GE2997@twin.jikos.cz>
In-Reply-To: <20180911145258.GE2997@twin.jikos.cz>

--hQt8gDWm2NMhzNiV9gPsgtEzEKucpH38M
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/11 =E4=B8=8B=E5=8D=8810:52, David Sterba wrote:
> On Tue, Aug 28, 2018 at 08:07:52AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018/8/28 =E4=B8=8A=E5=8D=886:33, Tucker Boniface wrote:
>>> Hello, I am trying to convert an ext4 partition to btrfs using
>>> btrfs-convert. I am running Arch Linux with kernel 4.18.5 and
>>> btrfs-progs 4.17.1. The full error is inline below.
>>>
>>> -> # btrfs-convert /dev/sda1
>>> create btrfs filesystem:
>>> =C2=A0=C2=A0=C2=A0=C2=A0blocksize: 4096
>>> =C2=A0=C2=A0=C2=A0=C2=A0nodesize:=C2=A0 16384
>>> =C2=A0=C2=A0=C2=A0=C2=A0features:=C2=A0 extref, skinny-metadata (defa=
ult)
>>> creating ext2 image file
>>> Unable to find block group for 0
>>> Unable to find block group for 0
>>> Unable to find block group for 0
>>> extent-tree.c:2743: alloc_tree_block: BUG_ON `ret` triggered, value -=
28
>>
>> This means ENOSPC.
>> Your ext* doesn't have enough free space to contain btrfs' metadata.
>=20
> Can we do something better than a crash? The BUG_ON is in
> alloc_tree_block, there's only one caller btrfs_alloc_free_block that
> handles errors, so it should be straightforward to fix.
>=20
Already submitted: (about one month ago)

https://patchwork.kernel.org/patch/10554575/

Thanks,
Qu


--hQt8gDWm2NMhzNiV9gPsgtEzEKucpH38M--

--hStPGtTOIIBl7Fu3yEYddsGdOBFc8TiiR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluXu0IACgkQwj2R86El
/qj9aQf/aaWKdDXDk9lsTspjul+RrqbH8r3Fuj7vPNnT9vwH/368X3ebFXYoN3q5
KFXPGF2QH6UCV/BNr7TUTTrVx1tI42yUasWDQtyTUsb10ANCp0AFSYqRy/2SX4Cf
nK44JIp0V9PrqIRXtHfWqp70DCwOY0trwA3yw31c8PVK7z2n8/Ao+nUcJ0QDfjbR
wYUOrqmmK9x2i9HmGUeTFI+xus7TrQ1XdK/BOdAWz7UU8Tg2p1bSnQjkHj9APAUj
Pl1XJdP05iYHf+dgvdJ+MC7sl4NKtgBlHdDEPKvLtTpA7K+DFeiXt7vU4/9Bs8cX
HEjwrevrF9rEmXQbqnC571hk5wFc3Q==
=pdpR
-----END PGP SIGNATURE-----

--hStPGtTOIIBl7Fu3yEYddsGdOBFc8TiiR--
