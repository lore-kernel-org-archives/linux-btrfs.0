Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbcKTRyR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Nov 2016 12:54:17 -0500
Subject: Re: [PATCH] btrfs: Ensure proper sector alignment for
 btrfs_free_reserved_data_space
To: bo.li.liu@oracle.com
References: <af6462e2-abaf-746a-6f69-1c83e549c059@suse.com>
 <20161120155044.GA16057@localhost.localdomain>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <14991e0f-e496-5445-4d7b-9b6cd1fdb07f@suse.com>
Date: Sun, 20 Nov 2016 12:54:08 -0500
MIME-Version: 1.0
In-Reply-To: <20161120155044.GA16057@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wBJv9BXah7EC7FMQ8iXAbwMuM4Wc2P6UD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wBJv9BXah7EC7FMQ8iXAbwMuM4Wc2P6UD
Content-Type: multipart/mixed; boundary="wDl3iDBrltHgGquPh0481KDqgS9l5MocI";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <14991e0f-e496-5445-4d7b-9b6cd1fdb07f@suse.com>
Subject: Re: [PATCH] btrfs: Ensure proper sector alignment for
 btrfs_free_reserved_data_space
References: <af6462e2-abaf-746a-6f69-1c83e549c059@suse.com>
 <20161120155044.GA16057@localhost.localdomain>
In-Reply-To: <20161120155044.GA16057@localhost.localdomain>

--wDl3iDBrltHgGquPh0481KDqgS9l5MocI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/20/16 10:50 AM, Liu Bo wrote:
> On Fri, Nov 18, 2016 at 09:52:40PM -0500, Jeff Mahoney wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>> Subject: btrfs: Ensure proper sector alignment for
>>  btrfs_free_reserved_data_space
>> References: bsc#1005666
>> Patch-mainline: Submitted 18 Nov 2016, linux-btrfs
>>
>> This fixes the WARN_ON on BTRFS_I(inode)->reserved_extents in
>> btrfs_destroy_inode and the WARN_ON on nonzero delalloc bytes on umoun=
t
>> with qgroups enabled.
>>
>> I was able to reproduce this by setting up a small (~500kb) quota limi=
t
>> and writing a file one byte at a time until I hit the limit.  The warn=
ings
>> would all hit on umount.
>>
>> The root cause is that we would reserve a block-sized range in both
>> the reservation and the quota in btrfs_check_data_free_space, but if w=
e
>> encountered a problem (like e.g. EDQUOT), we would only release the si=
ngle
>> byte in the qgroup reservation.  That caused an iotree state split, wh=
ich
>> increased the number of outstanding extents, in turn disallowing relea=
sing
>> the metadata reservation.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -3822,6 +3822,13 @@ void btrfs_free_reserved_data_space_noqu
>>   */
>>  void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u=
64 len)
>>  {
>> +	struct btrfs_root *root =3D BTRFS_I(inode)->root;
>> +
>> +	/* Make sure the range is aligned to sectorsize */
>> +	len =3D round_up(start + len, root->sectorsize) -
>> +	      round_down(start, root->sectorsize);
>> +	start =3D round_down(start, root->sectorsize);
>> +
>>  	btrfs_free_reserved_data_space_noquota(inode, start, len);
>>  	btrfs_qgroup_free_data(inode, start, len);
>=20
> The patch looks reasonable, but I'm afraid btrfs_fallocate can be
> affected since in btrfs_fallocate(), btrfs_qgroup_reserve_data() takes
> 'cur_offset' and 'last_byte - cur_offset' which are possible unaligned
> to root->sectorsize, but if any errors occur during allocation,
> btrfs_qgroup_free_data() in btrfs_free_reserved_data_space() is gonna
> free aligned range and it ends up a negative qgroup value.

Ok, yeah.  I was thinking about this later that evening but hadn't
gotten a chance to dig back into it.  I think the biggest thing is that
the handling of space reservation and qgroups is way too complicated.
It seems nearly impossible for new bugs *not* to sneak in whenever we
touch them.

For this particular bit, though, both cur_offset and last_byte are
sector aligned in btrfs_fallocate, at least in the current mainline
HEAD.  I think fixing up the alignment in the reservation and qgroups
routines is probably the wrong way to do it.  Instead, we should expect
the callers to handle the alignment properly and complain very loudly if
they fail to do that.  I started in on patches to do that after I
submitted the one above, but wanted to get the fix sent first.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--wDl3iDBrltHgGquPh0481KDqgS9l5MocI--

--wBJv9BXah7EC7FMQ8iXAbwMuM4Wc2P6UD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJYMeNEAAoJEB57S2MheeWyHBoQAL8MjZsNopx1PvuvbLCZgsGM
4jkYkbnS2xxpPT3fI7jMtDOTRh+5m+LY5SrZ6u1RgUcm2gPvn1el4SEj2aoIzfOY
6gai6eIsyoFbuBAwGhQf0bwZQe9O+w2Lwp4+TR5EuoOokDvsThy+bviPrNCAF1gI
C/Nz5FofPv4nFDHAT0M9E4SLrLeUR8XQBq69T4WulmqwzuH6lIynrz+DVOE4ptgo
KsHGHgI+OdYRAEaPFiYoLCsef68oX9wlsfVyqq6HMAXlWNAOtobfm0wFc4TW9Li2
hM8qgbkPCEsN5F7ni/pufTnZGaqhQlu0b2C9l3RgbM/x+lWSvxQaI898u27h6vjt
//Ax7W4xe8Ad14mEOOGA20h7n6PPDRG7hy5Wn22yWXGjCoLIYo1RMEUnNTWfgPkx
gZB9fdD/xvpccwqlcfkcedF4atVdbNkCeAhqZl8/gVu6N3uOX5a7t7yI1IWYnSK6
Ngmj2gIO6NBVxlGqpmuNqIG/xud9wLgBiaYhs8onz/+HSrb5TvqLYEqJau/cv4Cp
/OvGJE+tbvjGoe2Ln5Bi5vTtaFKmZ6ljoyMAMzGrhEoYi/6aKaoRfDk9mJUHqo5o
LECF7g5SSuz1sHoKfS6MMNttbNDkbS9MNKNLDMxohH73smuRq8K95rpLtoz6RqSB
ehv6JVjIBSO5FHyuT+5A
=d2ZW
-----END PGP SIGNATURE-----

--wBJv9BXah7EC7FMQ8iXAbwMuM4Wc2P6UD--
