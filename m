Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbcGHCTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 22:19:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 957FBAAF4
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 02:19:41 +0000 (UTC)
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
To: linux-btrfs@vger.kernel.org
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <ad2900c1-b7d6-6fe0-f455-06e936355cc6@suse.com>
Cc: David Sterba <DSterba@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <27f7d3ef-3537-0f27-f485-8e52f79d22d0@suse.com>
Date: Thu, 7 Jul 2016 22:19:37 -0400
MIME-Version: 1.0
In-Reply-To: <ad2900c1-b7d6-6fe0-f455-06e936355cc6@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Simhp6aN7JfTUMdh55tFkJhR88SoJ4Dqn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Simhp6aN7JfTUMdh55tFkJhR88SoJ4Dqn
Content-Type: multipart/mixed; boundary="XusR38uflJ2UMI668EN2Ll2uOPdboTCLX"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <DSterba@suse.com>
Message-ID: <27f7d3ef-3537-0f27-f485-8e52f79d22d0@suse.com>
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <ad2900c1-b7d6-6fe0-f455-06e936355cc6@suse.com>
In-Reply-To: <ad2900c1-b7d6-6fe0-f455-06e936355cc6@suse.com>

--XusR38uflJ2UMI668EN2Ll2uOPdboTCLX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 7/7/16 9:48 PM, Jeff Mahoney wrote:
> On 6/24/16 6:14 PM, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> One of the common complaints I've heard from new and experienced
>> developers alike about the btrfs code is the ubiquity of
>> struct btrfs_root.  There is one for every tree on disk and it's not
>> always obvious which root is needed in a particular call path.  It can=

>> be frustrating to spend time figuring out which root is required only
>> to discover that it's not actually used for anything other than
>> getting the fs-global struct btrfs_fs_info.
>>
>> The patchset contains several sections.
>>
>> 1) The fsid trace event patchset I posted earlier; I can rebase withou=
t this
>>    but I'd prefer not to.
>>
>> 2) Converting btrfs_test_opt and friends to use an fs_info.
>>
>> 3) Converting tests to use an fs_info pointer whenever a root is used.=

>>
>> 4) Moving sectorsize and nodesize to fs_info and cleaning up the
>>    macros used to access them.
>=20
> This change was a little overzealous in free-space-cache.c, which hit
> block_group->sectorsize as well as root->sectorsize by accident.  While=

> the change is fine for general btrfs usage, it breaks the sanity tests
> since dummy block groups now depend on a dummy fs_info as well.

There's also another error in btrfs_alloc_dummy_fs_info that doesn't
initialize sectorsize.

Clearly my test config got CONFIG_BTRFS_FS_RUN_SANITY_TESTS disabled at
some point. :(

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--XusR38uflJ2UMI668EN2Ll2uOPdboTCLX--

--Simhp6aN7JfTUMdh55tFkJhR88SoJ4Dqn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXfw26AAoJEB57S2MheeWyMjMQAK+MoNFZilmi/c8PbDTO0Hor
VSwPzfosIu/UAV435ErYzd4EPXlJplQjY0N64VChQwdPHuE4sOZ5O8FpB8XpBdAw
UMZlFwL+D53wTfGof92vAHacTgvXCjsiM63a0UYhI6cU9hqu67LBAUVKl0/7b2QU
w6KPp0AVmhXyF473DQWms1Y3sbpZGqdI0UFuKf6fEwidKxyTeo8Z/pgv2t4XWmP0
GHeRqBvloGjsoNqao+pSMzP3Co9eBvajPj/zkrhrxn3SScm0+zZs09gTYBu/6Byb
MXcSHr6+LNGoS7JW0vz0OdwW/N/kLC+skAd5Zc4AOwfaFaiffJ33pcfnPIYCtyll
mlqztxuIlufCnUz7E1EoZ4+4UlRnIVN6U7b+473f56EaUjSHUOv0tyFo1uDl+MV7
3ddGkI4XBx8QFofBRgW9OpiiL1PyKumCeWL9hwyivwyxl/mMmtWzOFVoWTlJ/nkn
u/pe8vp9gOSrmdsHA7XlDHd7sC3oCqv8BnhR0+Eoqr1pR1bGdWsk04WxF3P4KcYg
fqkTvowL+AeHJk5oLdDry8cm3YFP7CCiYyqxdhq3KeJRiea/IbMTJ2xy/pIWlnNT
kEM+pGT1ulqjCZTvx0eylmpivd2JwzvefofRbGeNld6p/43FjNTX4CbVlenkY1LG
esOcQ3ep//8aMhFbG/9J
=vUke
-----END PGP SIGNATURE-----

--Simhp6aN7JfTUMdh55tFkJhR88SoJ4Dqn--
