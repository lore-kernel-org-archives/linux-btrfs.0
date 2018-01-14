Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36469 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbeANKkn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 05:40:43 -0500
Date: Sun, 14 Jan 2018 10:40:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ilan Schwarts <ilan84@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: Fwd: Question regarding to Btrfs patchwork /2831525
Message-ID: <20180114104039.GH3807@carfax.org.uk>
References: <20170301180817.GJ4662@suse.cz>
 <CAJUuSvHpP-GV50P9dDJxX-WyzqtoHZLiuOVdLTMvR8k9EL_08w@mail.gmail.com>
 <CAJUuSvFUFnxuoXDE0+ykTXYN4B4GOWps7rAYAiHom6NKMX2nFA@mail.gmail.com>
 <e9ccb880-dfb3-aba6-d05a-869c53ec69d8@gmx.com>
 <CAJUuSvFCNmCiXwPdswsBdofs2UmtuTJA-xTnhvPKwu6OT9+9Zw@mail.gmail.com>
 <60b03797-ff8b-0e51-f72c-66e0ada596b7@suse.com>
 <CAJUuSvGcx3oMMmj=goXurrMRsYpmxjSA8aPmGvrgMTjYbSGz+A@mail.gmail.com>
 <CAJUuSvF51_ZTpQk7QjFC5_o=y5DLAn--4=Kmyy3ei-A0DQuRjQ@mail.gmail.com>
 <1431a38e-f7ec-3286-a468-50bce9a952da@gmx.com>
 <CAJUuSvGSG4nM5Cie_vwXg3p95Wfu1rRsCKft6cqvuiWpvOW=kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtJ+CqYNzKB4ukR4"
In-Reply-To: <CAJUuSvGSG4nM5Cie_vwXg3p95Wfu1rRsCKft6cqvuiWpvOW=kg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vtJ+CqYNzKB4ukR4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 14, 2018 at 12:32:25PM +0200, Ilan Schwarts wrote:
> Thank you for clarification.
> Just 2 quick questions,
> 1. Sub volumes - 2 sub volumes cannot have 2 same inode numbers ?

   Incorrect. You can have two subvolumes of the same filesystem, and
you can have files with the same inode number in each subvolume. Each
subvolume has its own inode number space. So an inode number on its
own is not enough to uniquely identify a file -- you also need the
subvolid to uniquely identify a specific file in the filesystem.

   Hugo.

> 2. Why fsInfo fsid return u8 and the traditional file system return
> dev_t, usually 32 integer ?
>=20
>=20
> On Sun, Jan 14, 2018 at 12:22 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
> >
> >
> > On 2018=E5=B9=B401=E6=9C=8814=E6=97=A5 18:13, Ilan Schwarts wrote:
> >> both btrfs filesystems will have same fsid ?
> >>
> >>
> >> On Sun, Jan 14, 2018 at 12:06 PM, Ilan Schwarts <ilan84@gmail.com> wro=
te:
> >>> But both filesystems will have same fsid?
> >>>
> >>> On Jan 14, 2018 12:04, "Nikolay Borisov" <nborisov@suse.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 14.01.2018 12:02, Ilan Schwarts wrote:
> >>>>> First of all, Thanks for response !
> >>>>> So if i have 2 btrfs file system on the same machine (not your
> >>>>> everyday scenario, i know)
> >
> > Not a problem, the 2 filesystems will have 2 different fsid.
> >
> > (And it's my everyday scenario, since fstests neeeds TEST_DEV and
> > SCRATCH_DEV_POOL)
> >
> >>>>> Lets say a file is created on device A, the file gets inode number X
> >>>>> is it possible on device B to have inode number X also ?
> >>>>> or each device has its own Inode number range ?
> >
> > Forget the mess about device.
> >
> > Inode is bounded to a filesystem, not bounded to a device.
> >
> > Just traditional filesytems are normally bounded to a single device.
> > (Although even traditional filesystems can have external journal device=
s)
> >
> > So there is nothing to do with device at all.
> >
> > And you can have same inode numbers in different filesystems, but
> > BTRFS_I(inode)->root->fs_info will point to different fs_infos, with
> > different fsid.
> >
> > So return to your initial question:
> >> both btrfs filesystems will have same fsid ?
> >
> > No, different filesystems will have different fsid.
> >
> > (Unless you're SUUUUUUUUUUUUUUUUUUUPER lucky to have 2 filesystems with
> > same fsid)
> >
> > Thanks,
> > Qu
> >
> >
> >>>>
> >>>> Of course it is possible. Inodes are guaranteed to be unique only ac=
ross
> >>>> filesystem instances. In your case you are going to have 2 fs instan=
ces.
> >>>>
> >>>>>
> >>>>> I need to create unique identifier for a file, I need to understand=
 if
> >>>>> the identifier would be: GlobalFSID_DeviceID_Inode or DeviceID_Inode
> >>>>> is enough.
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>>
> >>>>>
> >>>>>
> >>>>>
> >>>>> On Sun, Jan 14, 2018 at 11:13 AM, Qu Wenruo <quwenruo.btrfs@gmx.com>
> >>>>> wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 2018=E5=B9=B401=E6=9C=8814=E6=97=A5 16:33, Ilan Schwarts wrote:
> >>>>>>> Hello btrfs developers/users,
> >>>>>>>
> >>>>>>> I was wondering regarding to fetching the correct fsid on btrfs f=
rom
> >>>>>>> the context of a kernel module.
> >>>>>>
> >>>>>> There are two IDs for btrfs. (in fact more, but you properly won't=
 need
> >>>>>> the extra ids)
> >>>>>>
> >>>>>> FSID: Global one, one fs one FSID.
> >>>>>> Device ID: Bonded to device, each device will have one.
> >>>>>>
> >>>>>> So in case of 2 devices btrfs, each device will has its own device=
 id,
> >>>>>> while both of the devices have the same fsid.
> >>>>>>
> >>>>>> And I think you're talking about the global fsid instead of device=
 id.
> >>>>>>
> >>>>>>> if on suse11.3 kernel 3.0.101-0.47.71-default in order to get fsi=
d, I
> >>>>>>> do the following:
> >>>>>>> convert inode struct to btrfs_inode struct (use btrfsInode =3D
> >>>>>>> BTRFS_I(inode)), then from btrfs_inode struct i go to root field,=
 and
> >>>>>>> from root i take anon_dev or anon_super.s_dev.
> >>>>>>>         struct btrfs_inode *btrfsInode;
> >>>>>>>         btrfsInode =3D BTRFS_I(inode);
> >>>>>>>        btrfsInode->root->anon_super.s_dev    or
> >>>>>>>        btrfsInode->root->anon_dev    - depend on kernel.
> >>>>>>
> >>>>>> The most directly method would be:
> >>>>>>
> >>>>>> btrfs_inode->root->fs_info->fsid.
> >>>>>> (For newer kernel, as I'm not familiar with older kernels)
> >>>>>>
> >>>>>> Or from superblock:
> >>>>>> btrfs_inode->root->fs_info->super_copy->fsid.
> >>>>>> (The most reliable one, no matter which kernel version you're usin=
g, as
> >>>>>> long as the super block format didn't change)
> >>>>>>
> >>>>>> For device id, it's not that commonly used unless you're dealing w=
ith
> >>>>>> chunk mapping, so I'm assuming you're referring to fsid.
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Qu
> >>>>>>
> >>>>>>>
> >>>>>>> In kernel 3.12.28-4-default in order to get the fsid, i need to go
> >>>>>>> to the inode -> superblock -> device id (inode->i_sb->s_dev)
> >>>>>>>
> >>>>>>> Why is this ? and is there a proper/an official way to get it ?

--=20
Hugo Mills             | Gentlemen! You can't fight here! This is the War
hugo@... carfax.org.uk | Room!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        Dr Strangel=
ove

--vtJ+CqYNzKB4ukR4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaWzOnAAoJEFheFHXiqx3k/mUQALzZwE8m3SXnp6fYuAtg0/eO
+fDPwCFEmoQBFvmcr3yx1NVkq7hdwoPN/YWVaEyXwT4+O6tmYx5+l2H8bd2VADV2
sadglvnVjVvjFg5ZnRpeRM754/meDsiLjPzQ/97sxSCUFo2jbwd8IrkRMjz7rRRD
IH/7tFQ4iAfwZaYBnTqV49WPv2P5W3DCjO/4cjfiqkf6KGVgDZYLQRyCJSlHFHzg
N9vVumfd+2UFuF6ZeVNE+MTQZYLajcH8ZIpUHAvmqy2T3EjkdudPu5DZr8ID8i7O
gtGY5fuZCJjF74vQFhgXEsPMQv4lbhGIHtqPoi3n7Ne1CTLMqMYBmPqaqT1+pe6P
3f9fChCtKMM+hEO+IgfjRTfMPGtugAqt1zmvePisK2SbL1NAZPVQXJZqSBukT3aB
cVjfiM5QwM7yi5R/FR9hL/IOyb4ZvbmgKmzCnOW33yEEp6G9OtGITN1y9TVg2etj
/FjAW6feFVDBUgzaXLifSSf66he70LOnTQuy7nTu5S/rF2D8M45jisce9UAtjXDp
l3P87bTJumHbNBIK7J+6Ji2Tttn600QqhH0FNfqRl3ArY0+4gFBjRdYUoL3Kg5ZT
L+bCoCflH7gGnD0KthQ5UmTYA+em2Fw8P1DeYsmIIWSZ2WZEH2zrl0JxLaVBTua/
TSGpH+Xy6fegq0me+WWQ
=HCAZ
-----END PGP SIGNATURE-----

--vtJ+CqYNzKB4ukR4--
