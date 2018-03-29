Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38070 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeC2BJm (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 28 Mar 2018 21:09:42 -0400
Subject: Re: [PATCH] btrfs-progs: mkfs/rootdir: Don't follow symbolic link
 when calcuating size
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180328063909.937-1-wqu@suse.com>
 <20180328145542.GM30422@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <4175c2e0-94cc-2a1f-0707-6c6be617eaf3@suse.com>
Date: Thu, 29 Mar 2018 09:09:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180328145542.GM30422@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yQ1RCW5IAVt1UR0oxzOuXOascYBGgjugI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yQ1RCW5IAVt1UR0oxzOuXOascYBGgjugI
Content-Type: multipart/mixed; boundary="v6iG02FXJfi9j1ShxN5sMHb341oGWT6eY";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <4175c2e0-94cc-2a1f-0707-6c6be617eaf3@suse.com>
Subject: Re: [PATCH] btrfs-progs: mkfs/rootdir: Don't follow symbolic link
 when calcuating size
References: <20180328063909.937-1-wqu@suse.com>
 <20180328145542.GM30422@twin.jikos.cz>
In-Reply-To: <20180328145542.GM30422@twin.jikos.cz>

--v6iG02FXJfi9j1ShxN5sMHb341oGWT6eY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8828=E6=97=A5 22:55, David Sterba wrote:
> On Wed, Mar 28, 2018 at 02:39:09PM +0800, Qu Wenruo wrote:
>> [BUG]
>> If we have a symbolic link in rootdir pointing to non-existing locatio=
n,
>> mkfs.btrfs --rootdir will just fail:
>> ------
>> $ mkfs.btrfs  -f --rootdir /tmp/rootdir/ /dev/data/btrfs
>> btrfs-progs v4.15.1
>> See http://btrfs.wiki.kernel.org for more information.
>>
>> ERROR: ftw subdir walk of /tmp/rootdir/ failed: No such file or direct=
ory
>> ------
>>
>> [CAUSE]
>> Commit 599a0abed564 ("btrfs-progs: mkfs/rootdir: Use over-reserve meth=
od
>> to make size estimate easier") add extra ftw walk to estimate the
>> filesystem size.
>>
>> Such default ftw walk will follow symbolic link and gives ENOENT error=
=2E
>>
>> [FIX]
>> Use nftw() to specify FTW_PHYS so we won't follow symbolic link for si=
ze
>> calculation.
>>
>> Reported-by: Alexander Kanavin <alexander.kanavin@intel.com>
>> Fixes: 599a0abed564 ("btrfs-progs: mkfs/rootdir: Use over-reserve meth=
od to make size estimate easier")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Applied, thanks. Can you please write a testcase for that?
>=20
Sorry, I planned but forgot that.

Will come soon.

Thanks,
Qu


--v6iG02FXJfi9j1ShxN5sMHb341oGWT6eY--

--yQ1RCW5IAVt1UR0oxzOuXOascYBGgjugI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq8PM4ACgkQwj2R86El
/qiPAwf/bUU3bMWMNNbZQrqNJa2CwV8ESzhjeOQVWygwwS9vhFMZLdjkW5v1HoQn
Q1a8OZWaH6RiRfieEINvDwG6V+Df+spMKzGDLHknmdNnIDR//yyIfE/6uhybZHG9
p9xSY3Mzuf0Q/LY3uEAjT7ihlOBqsZJo3SqNvBJahSPYK8RgrjmhCy7eXUNGY2Mu
PjHaa2nAiZ/9k1nNkvNgJe+O++nQQLEDTbfKSTPUb4F4iUhLPPF3XOeTD3jo3FUl
mVsiqGi9LrpHfmrmkMSxiW1jj2GYxkPY8rNlx3FtygGChYHb7pBn5bl2P1NARJBF
NidaTiBcLRR691u3TKGwDrX8cGrNuQ==
=C/W6
-----END PGP SIGNATURE-----

--yQ1RCW5IAVt1UR0oxzOuXOascYBGgjugI--
