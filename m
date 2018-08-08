Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37691 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbeHHI3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 04:29:41 -0400
Subject: Re: [RFC PATCH 0/4] undelete subvolume online version
To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
 <20180807163950.GP3218@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bd99bd51-5813-702e-b496-654fead1be41@gmx.com>
Date: Wed, 8 Aug 2018 14:11:24 +0800
MIME-Version: 1.0
In-Reply-To: <20180807163950.GP3218@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BYvgQdL5Lu43SZ4ZHMz4C4Atsjw7f3CIz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BYvgQdL5Lu43SZ4ZHMz4C4Atsjw7f3CIz
Content-Type: multipart/mixed; boundary="7quTrncPRaRxCK2qy8rMcjRClxdWS76cF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <bd99bd51-5813-702e-b496-654fead1be41@gmx.com>
Subject: Re: [RFC PATCH 0/4] undelete subvolume online version
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
 <20180807163950.GP3218@twin.jikos.cz>
In-Reply-To: <20180807163950.GP3218@twin.jikos.cz>

--7quTrncPRaRxCK2qy8rMcjRClxdWS76cF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8808=E6=97=A5 00:39, David Sterba wrote:
> On Sun, Aug 05, 2018 at 06:39:57PM +0800, Lu Fengqi wrote:
>> This patchset will add the BTRFS_IOC_SUBVOL_UNDELETE ioctl for online
>> btrfs subvolume undelete.
>>
>> And btrfs subvolume undelete subcommand was added to btrfs-progs.
>>
>> So user can use the following command to recover all the subolume that=

>> is left on the device. The recovered subvolume will be link to <dest> =
dir
>> named to <name_prefix><subvol_id>.
>=20
> Hm, I don't agree with the proposed interface - to recover all deleted
> subvolumes. IMO this should recover just one subvolume of a given id a
> to given directory.
>=20
> The ioctl structure has to be reworked, I've skimmed the code and saw
> some suspicious things but will have a look after the interface is
> settled.

My concern is, is such purpose really needed?

Yes, it's possible user made some mistake and want to get back the data.
But putting an ioctl for 'undelete', then user may consider btrfs is so
powerful that can undelete everything.
In short, this undelete feature gives user too high expectation.

And don't expect user really to read man pages. There are already tons
of reports where user execute btrfs check --repair without realizing
--repair is pretty dangerous (and thanks to the work done to repair, it
normally doesn't cause catastrophic result, but sometimes it indeed
causes extra damage)

And when user tried and failed due to deleted tree blocks, they will get
even more frustrated or even betrayed.

I prefer to put such undelete as an off-line rescue tool, instead of
making it online with an ioctl interface.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--7quTrncPRaRxCK2qy8rMcjRClxdWS76cF--

--BYvgQdL5Lu43SZ4ZHMz4C4Atsjw7f3CIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltqiYwACgkQwj2R86El
/qiUywf3bH5gdIeg4boVg5W/VhJyc2bkKdhd+jXQXTUCARUpNPFdzm+6AeokhvUY
MRwbnkpnOrdUjxkjgbLxtdpNXeBziyM3v7RGrfK7sM8pO2yO58Jl6bMteU+l6J4R
FqmuyA8G+wQq0zR1QgaQ1TJVEyF1nyEgabKjBBfo+ur+a+zfC3eHeXtEmz/1qf1+
pxcbKSSLQJzLlHX+VaFZQTOevKuIZxBXWsztK+773k3YgQKcyB3HeJ9Y0YerRhq9
aSE3J8jIKygNOYzS7KF15ftOqO9qjtAtgF6jkmM0LfnbXmXeQCX8R3fQYLPmKKoZ
C2iSQPTKcMYTIUG3AD9kjVBzYgQ9
=nQWt
-----END PGP SIGNATURE-----

--BYvgQdL5Lu43SZ4ZHMz4C4Atsjw7f3CIz--
