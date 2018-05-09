Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932115AbeEICGv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 22:06:51 -0400
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one
 root
To: Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20180508180436.716-1-mfasheh@suse.de>
 <20180508233840.GM10363@dastard>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
Date: Tue, 8 May 2018 22:06:44 -0400
MIME-Version: 1.0
In-Reply-To: <20180508233840.GM10363@dastard>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LIeLDhPSQa2KAquPhyHsN7QZ7yfqa74xQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LIeLDhPSQa2KAquPhyHsN7QZ7yfqa74xQ
Content-Type: multipart/mixed; boundary="zsB5icuZ3H4ASx2EupoFxkV98NtelKG0B";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Message-ID: <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one
 root
References: <20180508180436.716-1-mfasheh@suse.de>
 <20180508233840.GM10363@dastard>
In-Reply-To: <20180508233840.GM10363@dastard>

--zsB5icuZ3H4ASx2EupoFxkV98NtelKG0B
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/8/18 7:38 PM, Dave Chinner wrote:
> On Tue, May 08, 2018 at 11:03:20AM -0700, Mark Fasheh wrote:
>> Hi,
>>
>> The VFS's super_block covers a variety of filesystem functionality. In=

>> particular we have a single structure representing both I/O and
>> namespace domains.
>>
>> There are requirements to de-couple this functionality. For example,
>> filesystems with more than one root (such as btrfs subvolumes) can
>> have multiple inode namespaces. This starts to confuse userspace when
>> it notices multiple inodes with the same inode/device tuple on a
>> filesystem.
>=20
> Devil's Advocate - I'm not looking at the code, I'm commenting on
> architectural issues I see here.
>=20
> The XFS subvolume work I've been doing explicitly uses a superblock
> per subvolume. That's because subvolumes are designed to be
> completely independent of the backing storage - they know nothing
> about the underlying storage except to share a BDI for writeback
> purposes and write to whatever block device the remapping layer
> gives them at IO time.  Hence XFS subvolumes have (at this point)
> their own unique s_dev, on-disk format configuration, journal, space
> accounting, etc. i.e. They are fully independent filesystems in
> their own right, and as such we do not have multiple inode
> namespaces per superblock.

That's a fundamental difference between how your XFS subvolumes work and
how btrfs subvolumes do.  There is no independence among btrfs
subvolumes.  When a snapshot is created, it has a few new blocks but
otherwise shares the metadata of the source subvolume.  The metadata
trees are shared across all of the subvolumes and there are several
internal trees used to manage all of it.  It's a single storage pool and
a single transaction engine.  There are housekeeping and maintenance
tasks that operate across the entire file system internally.  I
understand that there are several problems you need to solve at the VFS
layer to get your version of subvolumes up and running, but trying to
shoehorn one into the other is bound to fail.

> So this doesn't sound like a "subvolume problem" - it's a "how do we
> sanely support multiple independent namespaces per superblock"
> problem. AFAICT, this same problem exists with bind mounts and mount
> namespaces - they are effectively multiple roots on a single
> superblock, but it's done at the vfsmount level and so the
> superblock knows nothing about them.

In this case, you're talking about the user-visible file system
hierarchy namespace that has no bearing on the underlying file system
outside of per-mount flags.  It makes sense for that to be above the
superblock because the file system doesn't care about them.  We're
interested in the inode namespace, which for every other file system can
be described using an inode and a superblock pair, but btrfs has another
layer in the middle: inode -> btrfs_root -> superblock.  The lifetime
rules for e.g. the s_dev follow that middle layer and a vfsmount can
disappear well before the inode does.

> So this kinda feel like there's still a impedence mismatch between
> btrfs subvolumes being mounted as subtrees on the underlying root
> vfsmount rather than being created as truly independent vfs
> namespaces that share a superblock. To put that as a question: why
> aren't btrfs subvolumes vfsmounts in their own right, and the unique
> information subvolume information get stored in (or obtained from)
> the vfsmount?

Those are two separate problems.   Using a vfsmount to export the
btrfs_root is on my roadmap.  I have a WIP patch set that automounts the
subvolumes when stepping into a new one, but it's to fix a longstanding
UX wart.  Ultimately, vfsmounts are at the wrong level to solve the
inode namespace problem.  Again, there's the lifetime issue.  There are
also many places where we only have an inode and need the s_dev
associated with it.  Most of these sites are well removed from having
access to a vfsmount and pinning one and passing it around carries no
other benefit.

>> In addition, it's currently impossible for a filesystem subvolume to
>> have a different security context from it's parent. If we could allow
>> for subvolumes to optionally specify their own security context, we
>> could use them as containers directly instead of having to go through
>> an overlay.
>=20
> Again, XFS subvolumes don't have this problem. So really we need to
> frame this discussion in terms of supporting multiple namespaces
> within a superblock sanely, not subvolumes.
>=20
>> I ran into this particular problem with respect to Btrfs some years
>> ago and sent out a very naive set of patches which were (rightfully)
>> not incorporated:
>>
>> https://marc.info/?l=3Dlinux-btrfs&m=3D130074451403261&w=3D2
>> https://marc.info/?l=3Dlinux-btrfs&m=3D130532890824992&w=3D2
>>
>> During the discussion, one question did come up - why can't
>> filesystems like Btrfs use a superblock per subvolume? There's a
>> couple of problems with that:
>>
>> - It's common for a single Btrfs filesystem to have thousands of
>>   subvolumes. So keeping a superblock for each subvol in memory would
>>   get prohibively expensive - imagine having 8000 copies of struct
>>   super_block for a file system just because we wanted some separation=

>>   of say, s_dev.
>=20
> That's no different to using individual overlay mounts for the
> thousands of containers that are on the system. This doesn't seem to
> be a major problem...

Overlay mounts are indepedent of one another and don't need coordination
among them.  The memory usage is relatively unimportant.  The important
part is having a bunch of superblocks that all correspond to the same
resources and coordinating them at the VFS level.  Your assumptions
below follow how your XFS subvolumes work, where there's a clear
hierarchy between the subvolumes and the master filesystem with a
mapping layer between them.  Btrfs subvolumes have no such hierarchy.
Everything is shared.  So while we could use a writeback hierarchy to
merge all of the inode lists before doing writeback on the 'master'
superblock, we'd gain nothing by it.  Handling anything involving
s_umount with a superblock per subvolume would be a nightmare.
Ultimately, it would be a ton of effort that amounts to working around
the VFS instead of with it.

>> - Writeback would also have to walk all of these superblocks -
>>   again not very good for system performance.
>=20
> Background writeback is backing device focussed, not superblock
> focussed. It will only iterate the superblocks that have dirty
> inodes on the bdi writeback lists, not all the superblocks on the
> bdi. IOWs, this isn't a major problem except for sync() operations
> that iterate superblocks.....
>=20
>> - Anyone wanting to lock down I/O on a filesystem would have to
>> freeze all the superblocks. This goes for most things related to
>> I/O really - we simply can't afford to have the kernel walking
>> thousands of superblocks to sync a single fs.
>=20
> Not with XFS subvolumes. Freezing the underlying parent filesystem
> will effectively stop all IO from the mounted subvolumes by freezing
> remapping calls before IO. Sure, those subvolumes aren't in a
> consistent state, but we don't freeze userspace so none of the
> application data is ever in a consistent state when filesystems are
> frozen.
>=20
> So, again, I'm not sure there's /subvolume/ problem here. There's
> definitely a "freeze heirarchy" problem, but that already exists and
> it's something we talked about at LSFMM because we need to solve it
> for reliable hibernation.

There's only a freeze hierarchy problem if we have to use multiple
superblocks.  Otherwise, we freeze the whole thing or we don't.  Trying
to freeze a single subvolume would be an illusion for the user since the
underlying file system would still be active underneath it.  Under the
hood, things like relocation don't even look at what subvolume owns a
particular extent until it must.  So it could be coordinating thousands
of superblocks to do what a single lock does now and for what benefit?

>> It's far more efficient then to pull those fields we need for a
>> subvolume namespace into their own structure.
>
> I'm not convinced yet - it still feels like it's the wrong layer to
> be solving the multiple namespace per superblock problem....

It needs to be between the inode and the superblock.  If there are
multiple user-visible namespaces, each will still get the same
underlying file system namespace.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--zsB5icuZ3H4ASx2EupoFxkV98NtelKG0B--

--LIeLDhPSQa2KAquPhyHsN7QZ7yfqa74xQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlryV7UACgkQHntLYyF5
5bK6hg//UMGhyq5BsPuJBFq3Qc1k1i4ppS6ZQkTwiLY4AwGRyEdgKc9nPFkNF5fx
mrtv2Sq/qJ4MSJhL+49vHLK+JAFyukiMvtPf6hVW+ie9+25Yub7oK3DJkzTQtyOv
GG3rJuzd5rnMTTPlaeZEacfycHToDPFgf3pR6d3jmTTwRhmSAYABvrkhDsQ8PetD
vTWWSGnAmdsSCAOcSqZmH0UYrHeEOMKP9L7vv1jj6Wy79vIK7dZqKQxsb4uyrzmv
mcYZGa1GJ5QzWhzuWSSMkUtXTzZzIAIb8OrsuDADPVzoEBDlKM8/R1aIgmxaYwPS
6J9UjCPcD0BixPoTVRK6cnlBaR8uXcqmQiGIOhv1M9hUmhPshd13aOaWOKCujW/j
Gi7t1bYUYNkTtEFYy5lpyJ6IM9UoVF8MANLEJQ7KjBv+RB3TeEx0Sstmp4SoYOhz
b5PKtcciyWPtOTNBqmn+8TrZ5PxDzPqOvVRO57L0rR7UPnXRQ8oFSgzztHKs9lY3
mEAHDJuCvjwni5DuvAO9GsH6itRVn71+dfu9vaWGgvGfWqhNl4fpLC1h9QUttzCX
2yOJYbG3JXdkqwhuheBe/yc41A3WPzUSZhJ9VYRf3Mv8Wk8OPJi8LohG7yeMWYCB
W6syDppZEEZvIpQ8pCVwpr4ggpPkAQYu5p5W9KOgJ8uWYbPH/pA=
=jWkd
-----END PGP SIGNATURE-----

--LIeLDhPSQa2KAquPhyHsN7QZ7yfqa74xQ--
