Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49419 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbeFEURJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 16:17:09 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one
 root
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20180508180436.716-1-mfasheh@suse.de>
 <20180508233840.GM10363@dastard>
 <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
 <20180509064103.GP10363@dastard>
Message-ID: <5b2ae799-1595-c262-7b65-41b10c11906d@suse.com>
Date: Tue, 5 Jun 2018 16:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <20180509064103.GP10363@dastard>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="naFM2qwHarzPfF7uR9gikdldvfKhsQ5wk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--naFM2qwHarzPfF7uR9gikdldvfKhsQ5wk
Content-Type: multipart/mixed; boundary="SGFaQDxJ1Y0JeFjQQt3pAGGIBD9YSHrdo";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <5b2ae799-1595-c262-7b65-41b10c11906d@suse.com>
Subject: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one
 root
References: <20180508180436.716-1-mfasheh@suse.de>
 <20180508233840.GM10363@dastard>
 <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
 <20180509064103.GP10363@dastard>
In-Reply-To: <20180509064103.GP10363@dastard>

--SGFaQDxJ1Y0JeFjQQt3pAGGIBD9YSHrdo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Sorry, just getting back to this.

On 5/9/18 2:41 AM, Dave Chinner wrote:
> On Tue, May 08, 2018 at 10:06:44PM -0400, Jeff Mahoney wrote:
>> On 5/8/18 7:38 PM, Dave Chinner wrote:
>>> On Tue, May 08, 2018 at 11:03:20AM -0700, Mark Fasheh wrote:
>>>> Hi,
>>>>
>>>> The VFS's super_block covers a variety of filesystem functionality. =
In
>>>> particular we have a single structure representing both I/O and
>>>> namespace domains.
>>>>
>>>> There are requirements to de-couple this functionality. For example,=

>>>> filesystems with more than one root (such as btrfs subvolumes) can
>>>> have multiple inode namespaces. This starts to confuse userspace whe=
n
>>>> it notices multiple inodes with the same inode/device tuple on a
>>>> filesystem.
>>>
>>> Devil's Advocate - I'm not looking at the code, I'm commenting on
>>> architectural issues I see here.
>>>
>>> The XFS subvolume work I've been doing explicitly uses a superblock
>>> per subvolume. That's because subvolumes are designed to be
>>> completely independent of the backing storage - they know nothing
>>> about the underlying storage except to share a BDI for writeback
>>> purposes and write to whatever block device the remapping layer
>>> gives them at IO time.  Hence XFS subvolumes have (at this point)
>>> their own unique s_dev, on-disk format configuration, journal, space
>>> accounting, etc. i.e. They are fully independent filesystems in
>>> their own right, and as such we do not have multiple inode
>>> namespaces per superblock.
>>
>> That's a fundamental difference between how your XFS subvolumes work a=
nd
>> how btrfs subvolumes do.
>=20
> Yup, you've just proved my point: this is not a "subvolume problem";
> but rather a "multiple namespace per root" problem.

Mark framed it as a namespace issue initially.  The btrfs subvolume
problem is the biggest one we're concerned with.  More below.

>> There is no independence among btrfs
>> subvolumes.  When a snapshot is created, it has a few new blocks but
>> otherwise shares the metadata of the source subvolume.  The metadata
>> trees are shared across all of the subvolumes and there are several
>> internal trees used to manage all of it.
>=20
> I don't need btrfs 101 stuff explained to me. :/

No offense meant.  This was crossposted to a few lists.

>> a single transaction engine.  There are housekeeping and maintenance
>> tasks that operate across the entire file system internally.  I
>> understand that there are several problems you need to solve at the VF=
S
>> layer to get your version of subvolumes up and running, but trying to
>> shoehorn one into the other is bound to fail.
>=20
> Actually, the VFS has provided everything I need for XFS subvolumes
> so far without requiring any sort of modifications. That's the
> perspective I'm approaching this from - if the VFS can do what we
> need for XFS subvolumes, as well as overlay (which are effectively
> VFS-based COW subvolumes), then lets see if we can make that work
> for btrfs too.

I'm glad that the VFS provides what you need for XFS subvolumes, but
you're effectively creating independent file systems using a backend
storage remapping technique.  That's pretty much exactly what the VFS is
already designed to do.  Overlayfs is definitely not just VFS-based CoW
subvolumes.  I ended up having to wade more deeply into overlayfs than I
would've liked to respond to your email.  I'd say it's better described
as Overlayfs can abuse what the VFS offers just enough to work well in
common cases.  It has a similar disconnect between the superblock and
inode to btrfs except that it's not as easily resolved since the dentry
belongs to overlayfs and the inode belongs to the underlying file
system. There are still places getting this wrong in the kernel.  In
order to reliably present the right inode/dev pair for overlayfs, we
need the dentry to go with it.  We don't always have it and, even if we
did, we'd need both the dentry and inode.

At any rate, anything with a ->getattr that modifies dev or ino so that
it's different from inode->i_sb->s_dev or inode->i_ino will misbehave
somehow.  The question is just how badly, which depends on the context.
It could be something simple like /proc/pid/maps not showing the right
device/ino pair.  Many file systems that use 64-bit inode numbers
already remap them on 32-bit systems, which can already cause collisions
(even inside the kernel) when comparisons are made.  There's no excuse
to not use 64-bit inode numbers everywhere inside the kernel now,
especially since we have the capability to export them as 64-bit inode
numbers on 32-bit systems now via statx.

One thing is clear: If we want to solve the btrfs and overlayfs problems
in the same way, the view approach with a simple static mapping doesn't
work.  Sticking something between the inode and superblock doesn't get
the job done when the belongs to a different file system.  Overlayfs
needs a per-object remapper, which means a callback that takes a path.
Suddenly the way we do things in the SUSE kernel doesn't seem so hacky
anymore.

I'm not sure we need the same solution for btrfs and overlayfs.  It's
not the same problem.  Every object in overlayfs as a unique mapping
already.  If we report s_dev and i_ino from the inode, it still maps to
a unique user-visible object.  It may not map back to the overlayfs
name, but that's a separate issue that's more difficult to solve.  The
btrfs issue isn't one of presenting an alternative namespace to the
user.  Btrfs has multiple internal namespaces and no way to publish them
to the rest of the kernel.

>>> So this doesn't sound like a "subvolume problem" - it's a "how do we
>>> sanely support multiple independent namespaces per superblock"
>>> problem. AFAICT, this same problem exists with bind mounts and mount
>>> namespaces - they are effectively multiple roots on a single
>>> superblock, but it's done at the vfsmount level and so the
>>> superblock knows nothing about them.
>>
>> In this case, you're talking about the user-visible file system
>> hierarchy namespace that has no bearing on the underlying file system
>> outside of per-mount flags.
>=20
> Except that it tracks and provides infrastructure that allows user
> visible  "multiple namespace per root" constructs. Subvolumes - as a
> user visible namespace construct - are little different to bind
> mounts in behaviour and functionality.=20
>=20
> How the underlying filesystem implements subvolumes is really up to
> the filesystem, but we should be trying to implement a clean model
> for "multiple namespaces on a single root" at the VFS so we have
> consistent behaviour across all filesystems that implement similar
> functionality.
>=20
> FWIW, bind mounts and overlay also have similar inode number
> namespace problems to what Mark describes for btrfs subvolumes.
> e.g. overlay recently introduce the "xino" mount option to separate
> the user presented inode number namespace for overlay inode from the
> underlying parent filesystem inodes. How is that different to btrfs
> subvolumes needing to present different inode number namespaces from
> the underlying parent?
>=20
> This sort of "namespace shifting" is needed for several different
> pieces of information the kernel reports to userspace. The VFS
> replacement for shiftfs is an example of this. So is inode number
> remapping. I'm sure there's more.

Djalal's work?  That rightfully belongs above the file system layer.
The only bit that's needed within the file system is the part that sets
the super flag to enable it.  The different namespaces have nothing to
do with the file system below it.

> My point is that if we are talking about infrastructure to remap
> what userspace sees from different mountpoint views into a
> filesystem, then it should be done above the filesystem layers in
> the VFS so all filesystems behave the same way. And in this case,
> the vfsmount maps exactly to the "fs_view" that Mark has proposed we
> add to the superblock.....

It's proposed to be above the superblock with a default view in the
superblock.  It would sit between the inode and the superblock so we
have access to it anywhere we already have an inode.  That's the main
difference.  We already have the inode everywhere it's needed.  Plumbing
a vfsmount everywhere needed means changing code that only requires an
inode and doesn't need a vfsmount.

The two biggest problem areas:
- Writeback tracepoints print a dev/inode pair.  Do we want to plumb a
vfsmount into __mark_inode_dirty, super_operations->write_inode,
__writeback_single_inode, writeback_sb_inodes, etc?
- Audit.  As it happens, most of audit has a path or file that can be
used.  We do run into problems with fsnotify.  fsnotify_move is called
from vfs_rename which turns into a can of worms pretty quickly.

>> It makes sense for that to be above the
>> superblock because the file system doesn't care about them.  We're
>> interested in the inode namespace, which for every other file system c=
an
>> be described using an inode and a superblock pair, but btrfs has anoth=
er
>> layer in the middle: inode -> btrfs_root -> superblock.=20
>=20
> Which seems to me to be irrelevant if there's a vfsmount per
> subvolume that can hold per-subvolume information.

I disagree.  There are a ton of places where we only have access to an
inode and only need access to an inode.  It also doesn't solve the
overlayfs issue.

>>> So this kinda feel like there's still a impedence mismatch between
>>> btrfs subvolumes being mounted as subtrees on the underlying root
>>> vfsmount rather than being created as truly independent vfs
>>> namespaces that share a superblock. To put that as a question: why
>>> aren't btrfs subvolumes vfsmounts in their own right, and the unique
>>> information subvolume information get stored in (or obtained from)
>>> the vfsmount?
>>
>> Those are two separate problems.   Using a vfsmount to export the
>> btrfs_root is on my roadmap.  I have a WIP patch set that automounts t=
he
>> subvolumes when stepping into a new one, but it's to fix a longstandin=
g
>> UX wart.
>=20
> IMO that's more than a UX wart - th elack of vfsmounts for internal
> subvolume mount point traversals could be considered the root cause
> of the issues we are discussing here. Extending the mounted
> namespace should trigger vfs mounts, not be hidden deep inside the
> filesystem. Hence I'd suggest this needs changing before anything
> else....

I disagree.  Yes, it would be nice if btrfs did this, but it doesn't get
us the dev/ino pair to places where we need one, like the depths of audit=
=2E

>>>> During the discussion, one question did come up - why can't
>>>> filesystems like Btrfs use a superblock per subvolume? There's a
>>>> couple of problems with that:
>>>>
>>>> - It's common for a single Btrfs filesystem to have thousands of
>>>>   subvolumes. So keeping a superblock for each subvol in memory woul=
d
>>>>   get prohibively expensive - imagine having 8000 copies of struct
>>>>   super_block for a file system just because we wanted some separati=
on
>>>>   of say, s_dev.
>>>
>>> That's no different to using individual overlay mounts for the
>>> thousands of containers that are on the system. This doesn't seem to
>>> be a major problem...
>>
>> Overlay mounts are indepedent of one another and don't need coordinati=
on
>> among them.  The memory usage is relatively unimportant.  The importan=
t
>> part is having a bunch of superblocks that all correspond to the same
>> resources and coordinating them at the VFS level.  Your assumptions
>> below follow how your XFS subvolumes work, where there's a clear
>> hierarchy between the subvolumes and the master filesystem with a
>> mapping layer between them.  Btrfs subvolumes have no such hierarchy.
>> Everything is shared.=20
>=20
> Yup, that's the impedence mismatch between the VFS infrastructure
> and btrfs that I was talking about. What I'm trying to communicate
> is that I think the proposal is attacking the impedence mismatch
> from the wrong direction.
>=20
> i.e. The proposal is to modify btrfs code to propagate stuff that
> btrfs needs to know to deal with it's internal "everything is
> shared" problems up into the VFS where it's probably not useful to
> anything other than btrfs. We already have the necessary construct
> in the VFS - I think we should be trying to use the information held
> by the generic VFS infrastructure to solve the solve the specific
> btrfs issue at hand....

The many namespaces to one I/O domain relationship isn't a
btrfs-internal problem.  It's visible to the user and it's visible
inside the kernel.  The view implementation gives the VFS a generic
mechanism to allow it to represent that.  The plan isn't to only use the
view for that but to also allow separate security contexts for things
like containers.  Those have a similar issue to the inode availability
discussed above.  We have superblocks where we need them.  We could have
a view just as a easily.  Plumbing a vfsmount is the wrong approach.

>> So while we could use a writeback hierarchy to
>> merge all of the inode lists before doing writeback on the 'master'
>> superblock, we'd gain nothing by it.  Handling anything involving
>> s_umount with a superblock per subvolume would be a nightmare.
>> Ultimately, it would be a ton of effort that amounts to working around=

>> the VFS instead of with it.
>=20
> I'm not suggesting that btrfs needs to use a superblock per
> subvolume. Please don't confuse my statements along the lines of
> "this doesn't seem to be a problem for others" with "you must change
> btrfs to do this". I'm just saying that the problems arising from
> using a superblock per subvolume are not as dire as is being
> implied.

It's possible to solve the btrfs problem this way but it adds a bunch of
complexity for... what benefit, exactly? As I said, it's working around
the VFS instead of working with it.  As Mark initially stated, we handle
I/O and namespace domains.  Btrfs has many namespaces and only one I/O
domain.

-Jeff

--=20
Jeff Mahoney
SUSE Labs




--SGFaQDxJ1Y0JeFjQQt3pAGGIBD9YSHrdo--

--naFM2qwHarzPfF7uR9gikdldvfKhsQ5wk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlsW78AACgkQHntLYyF5
5bLkXg/+NqOXUVQUyvcTh+x+ygVVWHqp+/PLqJiWK2+J6SHEGoDvkCFLUv2FOXJA
jCMJLqeOF7dBjudzniCDGUGhk6jqx4UN4dsMudhHY5a5vNd+Kb7JrwimTXFjBqIy
IqHx/P4r3ZvucRRvb680AaV0YCsb+cxpgexIJwqwGra6AlQX5JPSDlTdjJG6b3bE
InEkUzQtoWkppHKDoat7+MhxGfMSFKl8Zcdf0AMfHyZ8OBz2WGTk/SaxuX8RdROZ
ZzCVQ6ibKE2HOFGrTqkVdr5xkj1N+tEt0vzX/n8kTfscRPTcsY2ZAG/TmXSa9U8i
bEKVclU8JBe8WwHx1Bp+p9GJLEcIh+x9Lm75iLJHU4PWj5RGJKaCOBv3d8u3Wtpb
vgSc8PL2LZgPEqalpDEpxIH24s8Icu+sONWaUBzfiPPtzj6tZ6Ak96z8b3pGjg5l
K1xuYIks45pn7drcpp9P/Q0aPtgQKvIZ4QBCi+wFLtcJO+ntyHVf/h/xUFymgKbD
BhB0avO+sKQ78KkOFbh9SW207fwo8gRhakl/xaxJPo50V8Arnj1BlXUYX8lcJcWw
jjoGcLyAtDQTcBcKAdsI0SxY7UpqW8NhMCCRNaFwQ5HRZRHM/+oCM+7z4VHL51ZU
+2QkVbkJ6m05ERFBvaKae62uY+hCloaO8MH8cXmjLZD3TN55QmM=
=WuoF
-----END PGP SIGNATURE-----

--naFM2qwHarzPfF7uR9gikdldvfKhsQ5wk--
