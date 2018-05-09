Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:34253 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934895AbeEINM1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:12:27 -0400
Subject: Re: [PATCH] btrfs: qgroup: Finish rescan when hit the last leaf of
 extent tree
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180504055659.1862-1-wqu@suse.com>
 <20180509130030.GY6649@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <60ee3063-103b-bb15-b3b6-cc87d9f38aad@gmx.com>
Date: Wed, 9 May 2018 21:12:11 +0800
MIME-Version: 1.0
In-Reply-To: <20180509130030.GY6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eCR5zBTWdTdm33nsIw6eZUsBmiOTEWvxi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eCR5zBTWdTdm33nsIw6eZUsBmiOTEWvxi
Content-Type: multipart/mixed; boundary="mhIJxxKQCdwfs2tPwhxij7FwK5i7uixe2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <60ee3063-103b-bb15-b3b6-cc87d9f38aad@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Finish rescan when hit the last leaf of
 extent tree
References: <20180504055659.1862-1-wqu@suse.com>
 <20180509130030.GY6649@twin.jikos.cz>
In-Reply-To: <20180509130030.GY6649@twin.jikos.cz>

--mhIJxxKQCdwfs2tPwhxij7FwK5i7uixe2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8809=E6=97=A5 21:00, David Sterba wrote:
> On Fri, May 04, 2018 at 01:56:59PM +0800, Qu Wenruo wrote:
>> Under the following case, qgroup rescan can double account cowed tree
>> blocks:
>>
>> In this case, extent tree only has one tree block.
>>
>> -
>> | transid=3D5 last committed=3D4
>> | btrfs_qgroup_rescan_worker()
>> | |- btrfs_start_transaction()
>> | |  transid =3D 5
>> | |- qgroup_rescan_leaf()
>> |    |- btrfs_search_slot_for_read() on extent tree
>> |       Get the only extent tree block from commit root (transid =3D 4=
).
>> |       Scan it, set qgroup_rescan_progress to the last
>> |       EXTENT/META_ITEM + 1
>> |       now qgroup_rescan_progress =3D A + 1.
>> |
>> | fs tree get CoWed, new tree block is at A + 16K
>> | transid 5 get committed
>> -
>> | transid=3D6 last committed=3D5
>> | btrfs_qgroup_rescan_worker()
>> | btrfs_qgroup_rescan_worker()
>> | |- btrfs_start_transaction()
>> | |  transid =3D 5
>> | |- qgroup_rescan_leaf()
>> |    |- btrfs_search_slot_for_read() on extent tree
>> |       Get the only extent tree block from commit root (transid =3D 5=
).
>> |       scan it using qgroup_rescan_progress (A + 1).
>> |       found new tree block beyong A, and it's fs tree block,
>> |       account it to increase qgroup numbers.
>> -
>>
>> In above case, tree block A, and tree block A + 16K get accounted twic=
e,
>> while qgroup rescan should stop when it already reach the last leaf,
>> other than continue using its qgroup_rescan_progress.
>>
>> Such case could happen by just looping btrfs/017 and with some
>> possibility it can hit such double qgroup accounting problem.
>>
>> Fix it by checking the path to determine if we should finish qgroup
>> rescan, other than relying on next loop to exit.
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Is this something for 4.17-rc ?

No need to hurry.
It would be OK for next release since it's not some regression, but a
long existing bug.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--mhIJxxKQCdwfs2tPwhxij7FwK5i7uixe2--

--eCR5zBTWdTdm33nsIw6eZUsBmiOTEWvxi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlry86sACgkQwj2R86El
/qi6wQf8CWeLRgyY+roEhfe++dv2cOMxaqZLSU7dezFQt0M3+FCZlNylX7dz/W0j
BsewpREQVD72pgUuDsXc8m5N6ubyQhT3HCUvo578CJdcZU+JwkX7R2ceW/s9vf7o
WBrkt++e5AX/RbOqdBvae74j+sIvP1l0Z066neKEoZkXaTYoMr27teRLlAfkwM1y
/mpCjAqVudW0VFkjzfptM1Ig7MUgrF4hrvO8/96VP+TMSdgFYA4+NhqadWNlGUay
+PSiWp3A2DZ+hgANrdnmGTE/zrOmbX2ZiHbT0JJrHU7PRreeFSPaum3zyypKqq2f
gUi9d6HtU4IZbMB0BQ0bLAgPPaT/Nw==
=qfdp
-----END PGP SIGNATURE-----

--eCR5zBTWdTdm33nsIw6eZUsBmiOTEWvxi--
