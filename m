Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49137 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750791AbeDXXoi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 19:44:38 -0400
Subject: Re: [PATCH v2] btrfs: print-tree: Add locking status output for debug
 build
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180424050313.32740-1-wqu@suse.com>
 <20180424144452.GJ21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bfa4ebf4-295f-2af1-f001-3287b4b6d51c@gmx.com>
Date: Wed, 25 Apr 2018 07:44:24 +0800
MIME-Version: 1.0
In-Reply-To: <20180424144452.GJ21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ned6o5xB1UaoYbzBNReLyNuBZwXNgiznB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ned6o5xB1UaoYbzBNReLyNuBZwXNgiznB
Content-Type: multipart/mixed; boundary="AlAd0GUcgdMPllaBw5goIHg3BPYnaSMtX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <bfa4ebf4-295f-2af1-f001-3287b4b6d51c@gmx.com>
Subject: Re: [PATCH v2] btrfs: print-tree: Add locking status output for debug
 build
References: <20180424050313.32740-1-wqu@suse.com>
 <20180424144452.GJ21272@twin.jikos.cz>
In-Reply-To: <20180424144452.GJ21272@twin.jikos.cz>

--AlAd0GUcgdMPllaBw5goIHg3BPYnaSMtX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 22:44, David Sterba wrote:
> On Tue, Apr 24, 2018 at 01:03:13PM +0800, Qu Wenruo wrote:
>> It's pretty handy if we can get debug output for locking status of an
>> extent buffer, specially for race related debugging.
>>
>> So add the following output for btrfs_print_tree() and
>> btrfs_print_leaf():
>> - refs
>> - write_locks (as w:%d)
>> - read_locks (as r:%d)
>> - blocking_writers (as bw:%d)
>> - blocking_readers (as br:%d)
>> - spinning_writers (as sw:%d)
>> - spinning_readers (as sr:%d)
>> - lock_owner
>> - current->pid
>=20
> This is fine
>=20
>> +	btrfs_info(eb->fs_info,
>=20
> I'd rather make that btrfs_debug, but info is fine as long as it's unde=
r
> CONFIG_BTRFS_DEBUG.
>=20
>> +"refs %u lock(w:%u r:%u bw:%u br:%u sw:%u sr:%u) lock_owner %u curren=
t %u",
>=20
> This is not :) but I'll fix that according to the above.

Not again...
I forgot to commit the change, no wonder everything is the same and need
to modify the patch commit message.
Sorry for the inconvenience.

Thanks,
Qu

>=20
> Reviewed-by: David Sterba <dsterba@suse.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--AlAd0GUcgdMPllaBw5goIHg3BPYnaSMtX--

--Ned6o5xB1UaoYbzBNReLyNuBZwXNgiznB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrfwVgACgkQwj2R86El
/qgSjgf/UXXnBBrELI6PBAhKVR8s3M/QJDBMLlu9mdsWMdbO+rBpam04s81MrLSR
KNq5yHTgs5O8Ieuev4CNFim2hGFEZUAFA405Zp29689CgHdTRfW7Mn5jj7VYyTEJ
a5JdZPqTinHvN/P/ZV/mh34Fa/E9wGF1u9hwWAjWby7lw5tUNwMm+JJSEid6ed6m
cmpcaUqC1rxBMpHhGRDBJYdabM5Cwh3CBuffHWWKvFBu+kf0ffQJ4To6f3E/ZHqZ
wVQpb9+n4WQyy2b6ryN1LtrVmx8nhnCQzK9QEHo+8tVAxX59RQCravVN4/LBf1IK
H7mTfRX3+vG0m1pOQXcePbrRnwru2Q==
=1Jbz
-----END PGP SIGNATURE-----

--Ned6o5xB1UaoYbzBNReLyNuBZwXNgiznB--
