Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3J2U0d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 16:26:33 -0400
Message-ID: <527019EF.5040608@suse.com>
Date: Tue, 29 Oct 2013 16:26:23 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [patch 00/13] sysfs publishing patchset
References: <20131021211940.432195222@suse.com> <526FFDB2.3040301@gmail.com>
In-Reply-To: <526FFDB2.3040301@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="m4RriLfVttslxM18bIIpQ6oSTLxI4w20B"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m4RriLfVttslxM18bIIpQ6oSTLxI4w20B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/29/13, 2:25 PM, Goffredo Baroncelli wrote:
> Hi Jeff,
>=20
> On 2013-10-21 23:19, Jeff Mahoney wrote:
>> This patchset implements the stubbed-out sysfs interface for btrfs. Or=

>> at least begins to do so.
>>
>> We publish:
>> - Features supported by the file system implementation
>> - Features enabled on the file system, including features unknown to
>>   the implemenation. These attributes can also be used to enable or
>>   disable features at runtime, subjecting to a safety mask.
>> - Uses the attribute names to print feature names when declining to
>>   mount a file system.
>> - The allocation data: global metadata reservation size and reserved,
>>   space_infos, and sums of the block groups total and used bytes.
>> - Device membership via links to the block devices.
>> - FS label, which is writeable.
>>
>> - I've also added matching ioctls for some of the functionality here s=
o
>>   that btrfsprogs can use the information without jumping through hoop=
s
>>   to read/parse the sysfs files. There are ioctls to query the support=
ed
>>   features and to query/set features on a particular file system. Ther=
e's
>>   also one to export the size of the global metadata reservation. I ha=
ve
>>   a patch for btrfs-progs that uses this to print useful info in 'btrf=
s
>>   fi df' output.
>>
>> Ultimately, the tree structure looks like the following, under /sys/fs=
/btrfs.
>> This is from a test file system, using two devices in raid1. You'll no=
tice
>> the 'single' and 'raid1' directories under the {data,metadata,system} =
dirs.
>> The raid profiles are created and removed as the first/last block grou=
p
>> of a certain profile is added and removed.

Hi Goffredo -

> I really appreciate your work. In the past I tried to push a similar
> patch set but without success [*]

Thanks. Sysfs work can be touchy since it becomes part of the ABI like
an ioctl does.

> I hope that it is not too late, but I have a request:
> it is possible to move the filesystems under a fs/ directory ? Somethin=
g
> like
>=20
> [...]
> fs/<fsid>/allocation/system/disk_used
> fs/<fsid>/features/mixed_backref
> fs/<fsid>/features/extended_iref
> features/compress_lzo
> features/big_metadata
> features/compress_lzov2
> [...]
>=20
> This for two reasons:
> 1) so it would be possible to show also the disks informations under a
> dev/ directory. It would be possible to handle the case that some disks=

> are registered in btrfs but the related filesystems aren't mounted (lik=
e
> after a "btrfs dev scan" command)
>
> 2) it would help the browsing of the /sys/btrfs/ hierarchy: every
> directory under /sys/btrfs/fs/ represents a filesystem. With the curren=
t
> structure not all the directory under /sys/btrfs are related to a
> filesystem (like the features/ one, but I am sure that other directorie=
s
> sooner or later will appear)

I'd like to define /sys/fs/btrfs/<fsid> as filesystem-specific and
anything else as btrfs-wide. This is what ext4 already does with the
exception that they use block device names instead of fsids. Your device
use case is interesting, but a tough one to implement well since it is a
cache that can be wrong as soon as the user decides to mkfs a device
(either as btrfs or anything else) without calling btrfs dev scan
afterward. I wouldn't necessarily oppose such a feature; I just don't
think it merits moving the primary case of per-filesystem information
deeper into the hierarchy.

Outside of /sys/fs/, we can see something similar in /sys/block/<dev>.
You'll find "holders", "queue", a bunch of partition directories, and
regular files. They all have different purposes and that's fairly
obvious by their naming. Having a "partitions" directory in there would
make the hierarchy "cleaner" but at the cost of a kobject that's
essentially useless otherwise.

But the broader point is well taken. If there's a discussion to be had
here, I'd like to have it now, especially WRT to the hierarchy. You're
the first person to have any feedback on it, and I've generally been
taking the silence as tacit approval while waiting for it to land. Most
of this patchset is in the openSUSE 13.1 kernel already, which will be
released soon. We need the ability to enable extended_iref while online
to handle upgrades smoothly due to some packages overflowing the
hardlink limit. (So technically, it also needs to be added to a 12.3
update release too.) It's a limitation no other file system has, so our
packagers are rightly saying it should be fixed there. It's easier to
use the sysfs interface but I suppose we could back off to the ioctl
interface that's already been discussed. I don't want to introduce a
one-off sysfs ABI with openSUSE 13.1, so if there are other objections
or comments, please raise them now.

David already gave some review for the feature ioctl parts, which I've
integrated. I did some review on my own of the sysfs portions and ripped
out the kobj_completion stuff as unnecessary and switched to using
attribute_groups for features instead of creating files explicitly.
Josef asked for xfstests, and after a few false starts, those have been
posted in their (hopefully) final revision. If we can agree on this
implementation, great. If not, I'd like to at least agree on the
hierarchy so that I can get those changes integrated before openSUSE
13.1 is released in early November.

Thanks.

-Jeff

> BR
> G.Baroncelli
>=20
> [*] http://lwn.net/Articles/513706/
>=20
>>
>> <fsid>/devices/sdc1
>> <fsid>/devices/sdd1
>> <fsid>/label
>> <fsid>/allocation/data/flags
>> <fsid>/allocation/data/raid1/used_bytes
>> <fsid>/allocation/data/raid1/total_bytes
>> <fsid>/allocation/data/bytes_pinned
>> <fsid>/allocation/data/bytes_may_use
>> <fsid>/allocation/data/total_bytes_pinned
>> <fsid>/allocation/data/bytes_reserved
>> <fsid>/allocation/data/bytes_used
>> <fsid>/allocation/data/single/used_bytes
>> <fsid>/allocation/data/single/total_bytes
>> <fsid>/allocation/data/total_bytes
>> <fsid>/allocation/data/disk_total
>> <fsid>/allocation/data/disk_used
>> <fsid>/allocation/metadata/flags
>> <fsid>/allocation/metadata/raid1/used_bytes
>> <fsid>/allocation/metadata/raid1/total_bytes
>> <fsid>/allocation/metadata/bytes_pinned
>> <fsid>/allocation/metadata/bytes_may_use
>> <fsid>/allocation/metadata/total_bytes_pinned
>> <fsid>/allocation/metadata/bytes_reserved
>> <fsid>/allocation/metadata/bytes_used
>> <fsid>/allocation/metadata/single/used_bytes
>> <fsid>/allocation/metadata/single/total_bytes
>> <fsid>/allocation/metadata/total_bytes
>> <fsid>/allocation/metadata/disk_total
>> <fsid>/allocation/metadata/disk_used
>> <fsid>/allocation/global_rsv_size
>> <fsid>/allocation/global_rsv_reserved
>> <fsid>/allocation/system/flags
>> <fsid>/allocation/system/raid1/used_bytes
>> <fsid>/allocation/system/raid1/total_bytes
>> <fsid>/allocation/system/bytes_pinned
>> <fsid>/allocation/system/bytes_may_use
>> <fsid>/allocation/system/total_bytes_pinned
>> <fsid>/allocation/system/bytes_reserved
>> <fsid>/allocation/system/bytes_used
>> <fsid>/allocation/system/single/used_bytes
>> <fsid>/allocation/system/single/total_bytes
>> <fsid>/allocation/system/total_bytes
>> <fsid>/allocation/system/disk_total
>> <fsid>/allocation/system/disk_used
>> <fsid>/features/mixed_backref
>> <fsid>/features/extended_iref
>> features/compress_lzo
>> features/big_metadata
>> features/compress_lzov2
>> features/default_subvol
>> features/mixed_backref
>> features/raid56
>> features/mixed_groups
>> features/skinny_metadata
>> features/extended_iref
>>
>> -Jeff
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--m4RriLfVttslxM18bIIpQ6oSTLxI4w20B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJScBnzAAoJEB57S2MheeWy6fYQAKDAyjOENmLUsRKg/rp9NX86
a8Z/ICS4n8NPIkGsY5iYxZXBxVQ2L1omH2lYcG8shhRvgwpVs71/N+dPrjdHxmkB
Ep70OcupeD2z/qTRLLOrKX7m+5LC9klirzm0lPh6CWganZ/d9NAg2uDzKCFDrYk2
DkW/57W6alv/XhDvISuD1zULQVzopPiZLc6XurEQNAB9DG8Evgib8ALgWghoKcwQ
/NSZNORffsbMuw5RHUwlYbYuPSa/IEKmeB8bx5tgh4uBZ+S54gQ+2yFmV2bgvQJQ
sJ2cJ9AHL6HRdm7Etak4YQtx12MyKX9ZlbtU+p4OyZuBM8J+MvZOpPeLuzUfqgQi
HyauyFLhYsZQhu3UgU1aUC0zGqqGHnQ1zZatACgmw8dT/wRt+FIciaDgC2WngqOO
mykL+QRRBVOUSAjkI2HpVx/JPVC4epGrVSEhtAVE9nigKDBb1mPtpPan/qQSOKTk
bTttzYgzWvseoIxuwX+mW6xYg3Oy4tQRwiQ7PAxbUlgOES59JG7BV0pxO8dQze8q
lKE/8po0teWpIAnO5yQIdU81QHxlbzRsVNy0lHQPLzHWubxBFliphTwJFGtPYQPl
t5oPjcZsMzzUP/iG4FqTm/HnXWmmaP0WSolNxpbomsBsUodxwYX4WTRT4Nked/Ke
1rih5k5qDT1DKG6De79V
=EGgz
-----END PGP SIGNATURE-----

--m4RriLfVttslxM18bIIpQ6oSTLxI4w20B--
