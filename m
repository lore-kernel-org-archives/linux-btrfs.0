Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43451 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbeGSIJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 04:09:22 -0400
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <88531904-288b-f73e-1157-560845f8e72d@gmx.com>
Date: Thu, 19 Jul 2018 15:27:17 +0800
MIME-Version: 1.0
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="b5yMuofN6GHGA9HfwHhukpcg72MTFpCJP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b5yMuofN6GHGA9HfwHhukpcg72MTFpCJP
Content-Type: multipart/mixed; boundary="SFR3yLLsAJIrxN5p2bJDd7sYkYmcnKpYm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <88531904-288b-f73e-1157-560845f8e72d@gmx.com>
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
References: <cover.1531503452.git.dsterba@suse.com>
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>

--SFR3yLLsAJIrxN5p2bJDd7sYkYmcnKpYm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8814=E6=97=A5 02:46, David Sterba wrote:
> Hi,
>=20
> I have some goodies that go into the RAID56 problem, although not
> implementing all the remaining features, it can be useful independently=
=2E
>=20
> This time my hackweek project
>=20
> https://hackweek.suse.com/17/projects/do-something-about-btrfs-and-raid=
56
>=20
> aimed to implement the fix for the write hole problem but I spent more
> time with analysis and design of the solution and don't have a working
> prototype for that yet.
>=20
> This patchset brings a feature that will be used by the raid56 log, the=

> log has to be on the same redundancy level and thus we need a 3-copy
> replication for raid6. As it was easy to extend to higher replication,
> I've added a 4-copy replication, that would allow triple copy raid (tha=
t
> does not have a standardized name).

So this special level will be used for RAID56 for now?
Or it will also be possible for metadata usage just like current RAID1?

If the latter, the metadata scrub problem will need to be considered more=
=2E

For more copies RAID1, it's will have higher possibility one or two
devices missing, and then being scrubbed.
For metadata scrub, inlined csum can't ensure it's the latest one.

So for such RAID1 scrub, we need to read out all copies and compare
their generation to find out the correct copy.
At least from the changeset, it doesn't look like it's addressed yet.

And this also reminds me that current scrub is not as flex as balance, I
really like we could filter block groups to scrub just like balance, and
do scrub in a block group basis, other than devid basis.
That's to say, for a block group scrub, we don't really care which
device we're scrubbing, we just need to ensure all device in this block
is storing correct data.

Thanks,
Qu

>=20
> The number of copies is fixed, so it's not N-copy for an arbitrary N.
> This would complicate the implementation too much, though I'd be willin=
g
> to add a 5-copy replication for a small bribe.
>=20
> The new raid profiles and covered by an incompatibility bit, called
> extended_raid, the (idealistic) plan is to stuff as many new
> raid-related features as possible. The patch 4/4 mentions the 3- 4- cop=
y
> raid1, configurable stripe length, write hole log and triple parity.
> If the plan turns out to be too ambitious, the ready and implemented
> features will be split and merged.
>=20
> An interesting question is the naming of the extended profiles. I picke=
d
> something that can be easily understood but it's not a final proposal.
> Years ago, Hugo proposed a naming scheme that described the
> non-standard raid varieties of the btrfs flavor:
>=20
> https://marc.info/?l=3Dlinux-btrfs&m=3D136286324417767
>=20
> Switching to this naming would be a good addition to the extended raid.=

>=20
> Regarding the missing raid56 features, I'll continue working on them as=

> time permits in the following weeks/months, as I'm not aware of anybody=

> working on that actively enough so to speak.
>=20
> Anyway, git branches with the patches:
>=20
> kernel: git://github.com/kdave/btrfs-devel dev/extended-raid-ncopies
> progs:  git://github.com/kdave/btrfs-progs dev/extended-raid-ncopies
>=20
> David Sterba (4):
>   btrfs: refactor block group replication factor calculation to a helpe=
r
>   btrfs: add support for 3-copy replication (raid1c3)
>   btrfs: add support for 4-copy replication (raid1c4)
>   btrfs: add incompatibility bit for extended raid features
>=20
>  fs/btrfs/ctree.h                |  1 +
>  fs/btrfs/extent-tree.c          | 45 +++++++-----------
>  fs/btrfs/relocation.c           |  1 +
>  fs/btrfs/scrub.c                |  4 +-
>  fs/btrfs/super.c                | 17 +++----
>  fs/btrfs/sysfs.c                |  2 +
>  fs/btrfs/volumes.c              | 84 ++++++++++++++++++++++++++++++---=

>  fs/btrfs/volumes.h              |  6 +++
>  include/uapi/linux/btrfs.h      | 12 ++++-
>  include/uapi/linux/btrfs_tree.h |  6 +++
>  10 files changed, 134 insertions(+), 44 deletions(-)
>=20


--SFR3yLLsAJIrxN5p2bJDd7sYkYmcnKpYm--

--b5yMuofN6GHGA9HfwHhukpcg72MTFpCJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltQPVUACgkQwj2R86El
/qiIzAgAp+7xd1qjw9oK2DCv3MikI38n/TPNEGhBj0Jv6lRSUZWwfez+FuGEDcTU
JG9Kil9llmC1QhZ75ECOCte+lcb2yvzjPVCBl5nuFoHUhStOBo9lRCS3A0TPksep
IB5NPce02eStpiXeT17n1rKjG6Lcj+yxwS/yaMzJXbJlpoydEQp4KRX1fTB1KOZw
vAXlOZxBR7ZbUVuwgWHNNcCe4cBGLoR4rEzIm2ocs8TDRbJNhFVXom+KB7DHmRsk
N5dJnSNNiBWRc+6zxc7nAkHFUpBWjYAyEzgaRENpj7YxYWZRzEugQXs0SzlcvXu0
ayOqqWLFUxCcCpsXrgqXOBXq3/cnsA==
=M/HL
-----END PGP SIGNATURE-----

--b5yMuofN6GHGA9HfwHhukpcg72MTFpCJP--
