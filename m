Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3KTSGN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 13:06:13 -0500
Message-ID: <528CF9D6.1000903@suse.com>
Date: Wed, 20 Nov 2013 13:05:10 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Kees Cook <keescook@chromium.org>, Josef Bacik <JBacik@fusionio.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: fs/btrfs/extent-tree.c:8430:9: error: format not a string literal
 and no format arguments
References: <528c09f9.S0ecVwNN2c+fnUkv%fengguang.wu@intel.com> <CAGXu5jLoG00u2svBW6W5h9QsfYw1zZwYhZ1k4HG2UsvcWPHxuQ@mail.gmail.com> <20131120040551.GB4201@localhost> <20131120173044.5312.44850@localhost.localdomain>
In-Reply-To: <20131120173044.5312.44850@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9RD1iNGNF1a8xlQ9XPpLIPii55DGAITAK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9RD1iNGNF1a8xlQ9XPpLIPii55DGAITAK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/20/13, 12:30 PM, Chris Mason wrote:
> Quoting Fengguang Wu (2013-11-19 23:05:51)
>> On Tue, Nov 19, 2013 at 07:56:35PM -0800, Kees Cook wrote:
>>> Hi!
>>>
>>> Which tree is 'devel-snb'? I don't see that on the kernel.org trees.
>>
>> It's my local merge branch, based on the latest upstream release.
>>
>> Let's CC the btrfs developers for this warning. :)
>>
>> Thanks,
>> Fengguang
>>
>>> On Tue, Nov 19, 2013 at 5:01 PM, kbuild test robot
>>> <fengguang.wu@intel.com> wrote:
>>>> tree:    devel-snb-x86_64-201311200240
>>>> head:   1a985a0807ea34f37a4c5287089abd1cd2f65049
>>>> commit: a9b93a3684dd6ebfb7cfa173f78a79c09de81207 Merge 'kees/format-=
security' into devel-snb-x86_64-201311200240
>>>> date:   6 hours ago
>>>> config: make ARCH=3Dx86_64 allmodconfig
>>>>
>>>> All error/warnings:
>>>>
>>>>    fs/btrfs/extent-tree.c:6201:12: sparse: symbol 'get_raid_name' wa=
s not declared. Should it be static?
>>>>    fs/btrfs/extent-tree.c:2469:28: sparse: context imbalance in 'run=
_clustered_refs' - unexpected unlock
>>>>    fs/btrfs/extent-tree.c:8304:9: sparse: context imbalance in 'btrf=
s_put_block_group_cache' - wrong count at exit
>>>>    fs/btrfs/extent-tree.c: In function '__link_block_group':
>>>>>> fs/btrfs/extent-tree.c:8430:9: error: format not a string literal =
and no format arguments [-Werror=3Dformat-security]
>>>>             get_raid_name(index));
>=20
> This comes from the btrfs-next tree, with Jeff's sysfs patches, so I've=

> added Jeff.

Thanks for the heads up. I have a few other fixes that need to go into
that patch set WRT cleanup too.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--9RD1iNGNF1a8xlQ9XPpLIPii55DGAITAK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSjPnXAAoJEB57S2MheeWyOy4P/2+o3fHo3oNjp9QGRiLsqpWt
s2cT25TeFOe78rptUuWdikSaWRwyFDecx68KZBY6c/WO47X14/EIWlhZ4SOzrQBZ
IO2o7NGp1zn03KcPlTrcYYx1OQNHRuUAty02Co75uMb5VBZV3E5tf8453yUY5hNm
BwTscgibpSVKMsvj0Vdeo8KUFzrWn2V8Byy7HQoqE6R894YJBMuA0uBGZfyEx/z2
ILPT8gWBgBISeSqO+GFFqFWTeN2i/bdMrByI636scP4AB8n/vYbHgil3a3gZ1GZo
lKTk7ieSiaer7hsl0IluI4mnQB1zhCJohN1T76cIch33sHdtDPFOBAQ6NboqfR6I
LJqv1bfXkRDHAGT7mCl389roOjQzdqcdqIzrZTCuCJL0vY653OilJvZGPlcHexCH
FA6YtifUs7TZStkp8K3h+Wymbzo3/o+L6JLJUMfsSOLOqHI1Qy2JA9TBLt9Pmd0Q
9uC0A8s0gVleLblJIe5DKdNBq2TL2YTiUAMavHEp4SOcAmLSwK6VO0OZFEgtlF8F
W4rqmPRtuNa3KxhOVQO7P4qQxjJUrBL7n/hoyugyIrvnwkYwfnIXZPCUmHB7Bamk
tcHPewKjHRj9//Pc0ZFUJRYZVDwd408f+OdzEBWZAj/W5PKvQPrsBmHe3DFJibhc
CzK/Kjl3xVFL17w3JEyT
=dReL
-----END PGP SIGNATURE-----

--9RD1iNGNF1a8xlQ9XPpLIPii55DGAITAK--
