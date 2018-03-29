Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:34149 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbeC2AHN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 20:07:13 -0400
Subject: Re: [PATCH 1/2] btrfs: tests/qgroup: Fix wrong tree backref level
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180327124419.28398-1-wqu@suse.com>
 <20180328153227.GN30422@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a215dafe-deb3-2fc4-1be2-e74f1d81407f@gmx.com>
Date: Thu, 29 Mar 2018 08:06:59 +0800
MIME-Version: 1.0
In-Reply-To: <20180328153227.GN30422@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XhnvijDU58Pj6OQwhJXYgFYhaXaXxuLXY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XhnvijDU58Pj6OQwhJXYgFYhaXaXxuLXY
Content-Type: multipart/mixed; boundary="xdGaiPhRN6ozsP9lknVQvmIi17AVhgCen";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a215dafe-deb3-2fc4-1be2-e74f1d81407f@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: tests/qgroup: Fix wrong tree backref level
References: <20180327124419.28398-1-wqu@suse.com>
 <20180328153227.GN30422@twin.jikos.cz>
In-Reply-To: <20180328153227.GN30422@twin.jikos.cz>

--xdGaiPhRN6ozsP9lknVQvmIi17AVhgCen
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8828=E6=97=A5 23:32, David Sterba wrote:
> On Tue, Mar 27, 2018 at 08:44:18PM +0800, Qu Wenruo wrote:
>> The extent tree of the test fs is like the following:
>>
>>  BTRFS info (device (null)): leaf 16327509003777336587 total ptrs 1 fr=
ee space 3919
>>   item 0 key (4096 168 4096) itemoff 3944 itemsize 51
>>           extent refs 1 gen 1 flags 2
>>           tree block key (68719476736 0 0) level 1
>>                                            ^^^^^^^
>>           ref#0: tree block backref root 5
>>
>> And it's using an empty tree for fs tree, so there is no way that its
>> level can be 1.
>>
>> For REAL (created by mkfs) fs tree backref with no skinny metadata, th=
e
>> result should look like:
>>
>>  item 3 key (30408704 EXTENT_ITEM 4096) itemoff 3845 itemsize 51
>>          refs 1 gen 4 flags TREE_BLOCK
>>          tree block key (256 INODE_ITEM 0) level 0
>>                                            ^^^^^^^
>>          tree block backref root 5
>>
>> Fix the level to 0, so it won't break later tree level checker.
>>
>> Fixes: faa2dbf004e8 ("Btrfs: add sanity tests for new qgroup accountin=
g code")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> So this is just a bug in the self-tests and does not have any other
> impact, right?

Yep, until we're implementing level check for backref (and all other
tree block reader)

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--xdGaiPhRN6ozsP9lknVQvmIi17AVhgCen--

--XhnvijDU58Pj6OQwhJXYgFYhaXaXxuLXY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq8LiMACgkQwj2R86El
/qgmkQgAsDSobcLuACOrC7B4wDA7ZFh1YfHFT40A2lB1kC0nQcXLvSP86+4jp8dh
DRTInJOQy0Zm7JzxFKTtnROCxoX4D1KtSCFn8i8PKLjsbdB3GES/A3SCtKPWNIea
aRXdJNx7EFTYsGZOzd0eptCBZZsZVDGaqQjAkjL+uzoFJqJQ2KrAhWWhTrw+c4oW
93PFvqOSGnJ0qfuPVXtM1vhmAh6Ca5n/5fui7wMx+z2y+zt9ZIsLhb4s97B8CvXv
nn1EyhecB++pSkCNhtVw/o78M2ryYyLCstfaC7H061k4c7bXyxzeFSIfQjO0Ve18
2lxcSDYuqy5Rl4HNDd4zzazpz2fjbw==
=QdC8
-----END PGP SIGNATURE-----

--XhnvijDU58Pj6OQwhJXYgFYhaXaXxuLXY--
