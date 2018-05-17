Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751468AbeEQOqi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 10:46:38 -0400
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
 <0ff3604a-4d67-4421-560f-40a87fe4001d@oracle.com>
 <157ec7fa-e271-ed60-d22b-290db8122734@gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <854f0e3c-9bc5-768b-1f85-b0de79ee5a73@suse.com>
Date: Thu, 17 May 2018 10:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <157ec7fa-e271-ed60-d22b-290db8122734@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DKKoYHlUCXJyTNITUmff191lt0n748EOf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DKKoYHlUCXJyTNITUmff191lt0n748EOf
Content-Type: multipart/mixed; boundary="Ux1ZTaTGWQVafa97MitNC4jL9ZEON5I2I";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Anand Jain <anand.jain@oracle.com>, dsterba@suse.cz,
 linux-btrfs@vger.kernel.org
Message-ID: <854f0e3c-9bc5-768b-1f85-b0de79ee5a73@suse.com>
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
 <0ff3604a-4d67-4421-560f-40a87fe4001d@oracle.com>
 <157ec7fa-e271-ed60-d22b-290db8122734@gmail.com>
In-Reply-To: <157ec7fa-e271-ed60-d22b-290db8122734@gmail.com>

--Ux1ZTaTGWQVafa97MitNC4jL9ZEON5I2I
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/17/18 8:25 AM, Austin S. Hemmelgarn wrote:
> On 2018-05-16 22:32, Anand Jain wrote:
>>
>>
>> On 05/17/2018 06:35 AM, David Sterba wrote:
>>> On Wed, May 16, 2018 at 06:03:56PM +0800, Anand Jain wrote:
>>>> Not yet ready for the integration. As I need to introduce
>>>> -o no_read_mirror_policy instead of -o read_mirror_policy=3D-<devid>=

>>>
>>> Mount option is mostly likely not the right interface for setting suc=
h
>>> options, as usual.
>>
>> =C2=A0=C2=A0I am ok to make it ioctl for the final. What do you think?=

>>
>>
>> =C2=A0=C2=A0But to reproduce the bug posted in
>> =C2=A0=C2=A0=C2=A0 Btrfs: fix the corruption by reading stale btree bl=
ocks
>> =C2=A0=C2=A0It needs to be a mount option, as randomly the pid can
>> =C2=A0=C2=A0still pick the disk specified in the mount option.
>>
> Personally, I'd vote for filesystem property (thus handled through the
> standard `btrfs property` command) that can be overridden by a mount
> option.=C2=A0 With that approach, no new tool (or change to an existing=
 tool)
> would be needed, existing volumes could be converted to use it in a
> backwards compatible manner (old kernels would just ignore the
> property), and you could still have the behavior you want in tests (and=

> in theory it could easily be adapted to be a per-subvolume setting if w=
e
> ever get per-subvolume chunk profile support).

Properties are a combination of interfaces presented through a single
command.  Although the kernel API would allow a direct-to-property
interface via the btrfs.* extended attributes, those are currently
limited to a single inode.  The label property is set via ioctl and
stored in the superblock.  The read-only subvolume property is also set
by ioctl but stored in the root flags.

As it stands, every property is explicitly defined in the tools, so any
addition would require tools changes.  This is a bigger discussion,
though.  We *could* use the xattr interface to access per-root or
fs-global properties, but we'd need to define that interface.
btrfs_listxattr could get interesting, though I suppose we could
simplify it by only allowing the per-subvolume and fs-global operations
on root inodes.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Ux1ZTaTGWQVafa97MitNC4jL9ZEON5I2I--

--DKKoYHlUCXJyTNITUmff191lt0n748EOf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlr9lcsACgkQHntLYyF5
5bK9Pw//Vudkk/hOH/j1okNMgYugqq9P24cIWwzZYTMLg/9Juf/G3Y4dBlXVz61N
TStr9auRKELyPx/uckUcWEocD8OlqPCRqCiUO+oefp/h5d8hw5HUWoChSPeB/VFZ
bZ+Gl3cgxAr60/CKEbry1ZgMrcQkBmkG9TiEOoRwFvXG0SOpYJJv2UufSAs/WHkv
9twu0IMc7wlxOp+uuQ46hJlo/zJGXbVD49d6fpiOYWvYUSFOJXqX+LLfPP++bqpK
4KjGt7lSM/a9Eq/v7v1cG4GctTJlKp1lhw74NwYwPsikaMvWf9DkW3YjIdVb6O84
9j6EvhsXifq1SBFPB1BVdxorEF9sDNj0QXArkhwzDoj/Rr04W078SCI1ZnLPJ2A7
gaUL2QnZgp8Fv0bxOKW/+tl3g7sjgqDQRwkD1/nP591/93NzJZV9V3mIy9Ejs3XL
wbz3T2hxUVHSgPzJ1slY0XT/AjcPlAuqXkJXwMJNMNZT98iXPgV4l9iOptMB5fYH
ORWZqCJ94Wen3KYqyAx4ILjX1qay2wnhIROMP+CLYtIFG7OhqgWU1CtnKbmVUjUX
VSsW2HfNWujVHbv1yR4jeg36CwbNhr1xnZZ1o5UsvAp+3Kw4eZXfE0/3xPjVL6p+
XfjKri5zrvUVBMjQOnao2rHDKtlTim9J3LDsHWdTeYINCP9y+0c=
=7ao1
-----END PGP SIGNATURE-----

--DKKoYHlUCXJyTNITUmff191lt0n748EOf--
