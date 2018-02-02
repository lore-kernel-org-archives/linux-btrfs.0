Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61395 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751796AbeBBBhK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 20:37:10 -0500
Subject: Re: [PATCH v2 0/3] btrfs-progs: Split lowmem mode check to its own
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201160527.GL18553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <02cbb5ec-e3a0-96ba-41c0-a08e4a8c1a7b@gmx.com>
Date: Fri, 2 Feb 2018 09:36:54 +0800
MIME-Version: 1.0
In-Reply-To: <20180201160527.GL18553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iAYnlYr5KvOhh2KLhEvIAgsjx7JUcsvlk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iAYnlYr5KvOhh2KLhEvIAgsjx7JUcsvlk
Content-Type: multipart/mixed; boundary="gjwdp0CrjefnVNg5yNmR7W8KOD3M8tbX9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <02cbb5ec-e3a0-96ba-41c0-a08e4a8c1a7b@gmx.com>
Subject: Re: [PATCH v2 0/3] btrfs-progs: Split lowmem mode check to its own
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201160527.GL18553@twin.jikos.cz>
In-Reply-To: <20180201160527.GL18553@twin.jikos.cz>

--gjwdp0CrjefnVNg5yNmR7W8KOD3M8tbX9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8802=E6=97=A5 00:05, David Sterba wrote:
> On Thu, Feb 01, 2018 at 02:45:38PM +0800, Qu Wenruo wrote:
>> As usual, the main part is over 500K so the biggest patch won't reach
>> mail list.
>> Please fetch the whole branch from github:
>> https://github.com/adam900710/btrfs-progs/tree/split_check
>=20
> Thanks, patches added to devel, with some more adjustments.
>=20
>> Despite the update, a new patch is introduced, to address the tons of
>> BORING errors and warning from checkpatch.pl.
>=20
> The checkpatch script can report lots of things to fix, but please note=

> that not all of them match the style we use. I've updated the patch 3/3=

> and undone some of the line splits, because it's the example where the
> code looks worse after fixing.

Yep, some 81/82 chars modification is not that elegant.

>=20
> We'd probably have to host our modified version of checkpatch so the
> warnings don't get reported repeatedly.

That would be the best case, I could take some spare time to port
checkpatch to btrfs-progs.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--gjwdp0CrjefnVNg5yNmR7W8KOD3M8tbX9--

--iAYnlYr5KvOhh2KLhEvIAgsjx7JUcsvlk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpzwLYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgZVgf/QYDMuz1HijUDJ2sfEfAkBLIv
mPG0bSRttJn6ZkemMWhdiSV5GrucrdzqSrlsHC57oQWitLEtiPUy8Nr42Qi5tIe4
yS4tk5snLIhImcx909XUBTEiKpuap/V2BXMAP8cpRmQhCgfECBJOWyrsr314YA5A
7pFHPurpIfkTeArRcAzTLQkdtTrFwBZiDaRbSJY9pFZZGAKSodX8VUWmcrvC1b98
DrG4xcaEMfbv0CraQaLQqQ3MWVER7tl6tNKbyLStOytzrRV86C1TRsQ21TvJ1Sy6
P9Zbew8BmbtYd/F515uhdHqJsVj7wpZ+VEEuSqmFJXWTQrE36OBbQ3qNa140gg==
=Z/dL
-----END PGP SIGNATURE-----

--iAYnlYr5KvOhh2KLhEvIAgsjx7JUcsvlk--
