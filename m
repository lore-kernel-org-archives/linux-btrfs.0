Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:34937 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbeHCB7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 21:59:51 -0400
Subject: Re: [PATCH v2 0/6] btrfs: Enhanced validation check for fuzzed images
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180801023721.32143-1-wqu@suse.com>
 <20180802164004.GR3218@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7fd25e4c-32a0-14bb-2b46-18455694abde@gmx.com>
Date: Fri, 3 Aug 2018 08:06:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180802164004.GR3218@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pPYsNvkEfdFG6rO0TiBcIHlS2rC4UCMBa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pPYsNvkEfdFG6rO0TiBcIHlS2rC4UCMBa
Content-Type: multipart/mixed; boundary="biX3uayL9sgUh3TnwgMBFSA93JIOo937X";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <7fd25e4c-32a0-14bb-2b46-18455694abde@gmx.com>
Subject: Re: [PATCH v2 0/6] btrfs: Enhanced validation check for fuzzed images
References: <20180801023721.32143-1-wqu@suse.com>
 <20180802164004.GR3218@twin.jikos.cz>
In-Reply-To: <20180802164004.GR3218@twin.jikos.cz>

--biX3uayL9sgUh3TnwgMBFSA93JIOo937X
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8803=E6=97=A5 00:40, David Sterba wrote:
> On Wed, Aug 01, 2018 at 10:37:15AM +0800, Qu Wenruo wrote:
>> The branch can be fetched from the following git repo:
>> https://github.com/adam900710/linux/tree/tree_checker_enhance
>>
>> It's based on v4.18-rc1, with 3 patches already merged into misc-next.=

>>
>> This patchset introduced the following enhanced validation check:
>> 1) chunk/block group/dev extent cross check
>>    Unlike extent tree, such cross check can be implemented pretty easy=

>>    with minimal mount time impact.
>>    Now the kernel could do chunk/bg/dev extent check as good as btrfs
>>    check.
>>
>> 2) Locking test to avoid possible deadlock due to extent tree corrupti=
on
>>    Unfortunately, for extent tree we can't do really much cross check.=

>>    Instead we use the selftest from btrfs_tree_lock() to detect and
>>    avoid deadlock caused by corrupted extent tree.
>=20
> Great, thanks.
>=20
>> The 3rd patch "btrfs: Remove unused function btrfs_account_dev_extents=
_size()"
>> has also been merged into misc-next.
>>
>> changelog:
>> v2:
>>   Added reviewed-by tags from Gu and Nikolay.
>>   Address comment from David for the 4th patch
>>   Address comment from Gu for the 2nd patch.
>=20
> Please rather write what did you fix and not who suggested that. There
> are many patches and iterations and I don't remember everything.

Sorry for that.

And for this patchset, the changelog should be:
  Added reviewed-by tags.
  Fixed unused variable and Link: tag.
  Moved checks to find_first_block_group() to reduce duplication.

>=20
>>
>> Qu Wenruo (6):
>>   btrfs: Check each block group has corresponding chunk at mount time
>>   btrfs: Verify every chunk has corresponding block group at mount tim=
e
>>   btrfs: Remove unused function btrfs_account_dev_extents_size()
>>   btrfs: Introduce mount time chunk <-> dev extent mapping check
>>   btrfs: Exit gracefully when failed to add chunk map
>=20
> The above merged, with some adjustments of changelogs or the error
> messages.
>=20
>>   btrfs: locking: Allow btrfs_tree_lock() to return error to avoid
>>     deadlock
>=20
> I need to read and understand the explanation you posted, so this patch=

> is not in misc-next, I'll add it to for-next after I'll do the first
> pass review.

Feel free to ask if there is anything unclear.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--biX3uayL9sgUh3TnwgMBFSA93JIOo937X--

--pPYsNvkEfdFG6rO0TiBcIHlS2rC4UCMBa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltjnG8ACgkQwj2R86El
/qgOewf/Qs24iY2YZjD7ULzqj9t5a0ggqNOjIi4bVoDR53W1iyd/5sPehBNa/CJb
IXL4J9YCdtXXElT7O458u7Agr664S754qSdQ4SId3QzyfUJFVTD3cYDrsx+wXf+C
SckYaBO+TrzmBZKYL1PSRFOLo02M+o6+fRk5fxczfcoSbucLcrHJ1giRWgRjdI0L
whkQYD1e/FQ7eqY/rA/whTAITKGZ/DweX5/ougZKCCjYEevxe7x5ckR3dILjpAFR
NhkKPr0E9K6bbc5Cea6oKXHncjKYJhCfyhO7ijCEGUVpnkxwFoyT/qwQcvWj9ur7
C+08B02JCXW3ULw+R7/jmuOJ36U5vA==
=vVPG
-----END PGP SIGNATURE-----

--pPYsNvkEfdFG6rO0TiBcIHlS2rC4UCMBa--
