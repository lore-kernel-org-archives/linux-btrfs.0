Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752579AbeFFVTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 17:19:13 -0400
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one
 root
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>
References: <20180508180436.716-1-mfasheh@suse.de>
 <20180508233840.GM10363@dastard>
 <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
 <20180509064103.GP10363@dastard>
 <5b2ae799-1595-c262-7b65-41b10c11906d@suse.com>
 <CAOQ4uxjUwi7dhTbNk1mK6_=rb_+L0JB1GG_mkGSDrudtocXScg@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <7e983476-df86-2624-ee6d-7c5415ea349a@suse.com>
Date: Wed, 6 Jun 2018 17:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjUwi7dhTbNk1mK6_=rb_+L0JB1GG_mkGSDrudtocXScg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q1Ej8VbHEAiJJRdoTwqH5SNlYqt4AgiJE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q1Ej8VbHEAiJJRdoTwqH5SNlYqt4AgiJE
Content-Type: multipart/mixed; boundary="3rlAACrR3TWVLZFtt4tO4jUviWoeoDI9Z";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.de>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 Linux Btrfs <linux-btrfs@vger.kernel.org>, Miklos Szeredi
 <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>,
 Jan Kara <jack@suse.cz>
Message-ID: <7e983476-df86-2624-ee6d-7c5415ea349a@suse.com>
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one
 root
References: <20180508180436.716-1-mfasheh@suse.de>
 <20180508233840.GM10363@dastard>
 <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
 <20180509064103.GP10363@dastard>
 <5b2ae799-1595-c262-7b65-41b10c11906d@suse.com>
 <CAOQ4uxjUwi7dhTbNk1mK6_=rb_+L0JB1GG_mkGSDrudtocXScg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjUwi7dhTbNk1mK6_=rb_+L0JB1GG_mkGSDrudtocXScg@mail.gmail.com>

--3rlAACrR3TWVLZFtt4tO4jUviWoeoDI9Z
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Amir -

Mark's answered some of your questions already, so I'll skip those.

On 6/6/18 5:49 AM, Amir Goldstein wrote:
> On Tue, Jun 5, 2018 at 11:17 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> Sorry, just getting back to this.
>>
>> On 5/9/18 2:41 AM, Dave Chinner wrote:
>>> On Tue, May 08, 2018 at 10:06:44PM -0400, Jeff Mahoney wrote:
>>>> On 5/8/18 7:38 PM, Dave Chinner wrote:
>>>>> On Tue, May 08, 2018 at 11:03:20AM -0700, Mark Fasheh wrote:
>>>>>> Hi,
>>>>>>
>>>>>> The VFS's super_block covers a variety of filesystem functionality=
=2E In
>>>>>> particular we have a single structure representing both I/O and
>>>>>> namespace domains.
>>>>>>
>>>>>> There are requirements to de-couple this functionality. For exampl=
e,
>>>>>> filesystems with more than one root (such as btrfs subvolumes) can=

>>>>>> have multiple inode namespaces. This starts to confuse userspace w=
hen
>>>>>> it notices multiple inodes with the same inode/device tuple on a
>>>>>> filesystem.
>>>>>
>=20
> Speaking as someone who joined this discussion late, maybe years after
> it started, it would help to get an overview of existing problems and h=
ow
> fs_view aims to solve them.
>=20
> I do believe that both Overlayfs and Btrfs can benefit from a layer of
> abstraction
> in the VFS, but I think it is best if we start with laying all the
> common problems
> and then see how a solution would look like.
>=20
> Even the name of the abstraction (fs_view) doesn't make it clear to me =
what
> it is we are abstracting (security context? st_dev? what else?). probab=
ly best
> to try to describe the abstraction from user POV rather then give spora=
dic
> examples of what MAY go into fs_view.
>=20
> While at it, need to see if this discussion has any intersections with =
David
> Howell's fs_context work, because if we consider adding sub volume supp=
ort
> to VFS, we may want to leave some reserved bits in the API for it.
>=20
> [...]
>=20
>> One thing is clear: If we want to solve the btrfs and overlayfs proble=
ms
>> in the same way, the view approach with a simple static mapping doesn'=
t
>> work.  Sticking something between the inode and superblock doesn't get=

>> the job done when the belongs to a different file system.  Overlayfs
>> needs a per-object remapper, which means a callback that takes a path.=

>> Suddenly the way we do things in the SUSE kernel doesn't seem so hacky=

>> anymore.
>>
>=20
> And what is the SUSE way?
>=20
>> I'm not sure we need the same solution for btrfs and overlayfs.  It's
>> not the same problem.  Every object in overlayfs as a unique mapping
>> already.  If we report s_dev and i_ino from the inode, it still maps t=
o
>> a unique user-visible object.  It may not map back to the overlayfs
>> name, but that's a separate issue that's more difficult to solve.  The=

>> btrfs issue isn't one of presenting an alternative namespace to the
>> user.  Btrfs has multiple internal namespaces and no way to publish th=
em
>> to the rest of the kernel.
>>
>=20
> FYI, the Overlayfs file/inode mapping is about to change with many
> VFS hacks queued for removal, so stay tuned.
>=20
> [...]

I have to admit I'm curious how this will work.  I've heard rumor of
using overlayfs inodes and calling the underlying file system's
inode_operations.  If part of that work removes the danger of overlayfs
inode numbers colliding with xino mode, I'm definitely interested.

>>> My point is that if we are talking about infrastructure to remap
>>> what userspace sees from different mountpoint views into a
>>> filesystem, then it should be done above the filesystem layers in
>>> the VFS so all filesystems behave the same way. And in this case,
>>> the vfsmount maps exactly to the "fs_view" that Mark has proposed we
>>> add to the superblock.....
>>
>> It's proposed to be above the superblock with a default view in the
>> superblock.  It would sit between the inode and the superblock so we
>> have access to it anywhere we already have an inode.  That's the main
>> difference.  We already have the inode everywhere it's needed.  Plumbi=
ng
>> a vfsmount everywhere needed means changing code that only requires an=

>> inode and doesn't need a vfsmount.
>>
>> The two biggest problem areas:
>> - Writeback tracepoints print a dev/inode pair.  Do we want to plumb a=

>> vfsmount into __mark_inode_dirty, super_operations->write_inode,
>> __writeback_single_inode, writeback_sb_inodes, etc?
>> - Audit.  As it happens, most of audit has a path or file that can be
>> used.  We do run into problems with fsnotify.  fsnotify_move is called=

>> from vfs_rename which turns into a can of worms pretty quickly.
>>
>=20
> Can you please elaborate on that problem.
> Do you mean when watching a directory for changes, you need to
> be able to tell in which fs_view the directory inode that is being watc=
hed?

I was investigating whether Dave's suggestion of using a vfsmount was
feasible.  When following the audit call graph up, I found
fsnotify_move, called by vfs_rename.  Piping a vfsmount into the vfs_*
operations has historically been rejected by Al (see Apparmor
discussions, among others), and with good reason.  The file system
implementation shouldn't care about where it's mounted.  While piping it
into vfs_rename doesn't seem too invasive, it's called by various file
systems' ->rename callback, so then we're stuck piping vfsmounts into
inode_operations, which is what Al's been wanting to avoid for years.

>>>> It makes sense for that to be above the
>>>> superblock because the file system doesn't care about them.  We're
>>>> interested in the inode namespace, which for every other file system=
 can
>>>> be described using an inode and a superblock pair, but btrfs has ano=
ther
>>>> layer in the middle: inode -> btrfs_root -> superblock.
>>>
>>> Which seems to me to be irrelevant if there's a vfsmount per
>>> subvolume that can hold per-subvolume information.
>>
>> I disagree.  There are a ton of places where we only have access to an=

>> inode and only need access to an inode.  It also doesn't solve the
>> overlayfs issue.
>>
>=20
> I have an interest of solving another problem.
> In VFS operations where only inode is available, I would like to be abl=
e to
> report fsnotify events (e.g. fsnotify_move()) only in directories under=
 a
> certain subtree root. That could be achieved either by bind mount the s=
ubtree
> root and passing vfsmount into vfs_rename() or by defining an fs_view o=
n the
> subtree and mounting that fs_view.

I'm not sure there's a lot of overlap, but I expect that this will end
up running into the same review feedback that Al gave during the
AppArmor merge: vfsmounts have no business at the lower level and you
can get the same behavior by hooking in at a higher level.  See
security_path_* vs security_inode_* for how that was resolved.

What you're talking about isn't really what we had in mind for the
fs_view.  In our case, it sits between the inode and superblock, which
would be at too low a level for determining whether an inode is under a
certain subtree.  In any event, wouldn't you need a path instead of an
inode to do what you're proposing?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--3rlAACrR3TWVLZFtt4tO4jUviWoeoDI9Z--

--q1Ej8VbHEAiJJRdoTwqH5SNlYqt4AgiJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlsYT8kACgkQHntLYyF5
5bL05Q//SBuwroylj9DIyWLPNYBxoF7VwEE20tjeQsB2sY//xcpzN24XXfBH4Fdf
nT8MkLLAS5FPidaTBhKKvn/jwOW0qufX8ZCTa8jATZDfqMliiEEGuGKEWTvm6qEK
RRiaswJuvE25Sp8imaX1BNtBaXA61AAxNJI47Ez66uLiRQ7OZxHb4c8I1ojjnU6o
YODOeW6NMDw9nozERocFK+pUEkH/wCbFU18nIeqp3AhtIaaIwT3b6Cic5Tinu1t4
QUuiZ0yKpHT3p9NteSvvR8cVoUcErDkGiQ8/9/umpdi4nh07wYAMZmBYZ4liuRuG
vbbMee7pCCrO4zccMpBNNJ7zQqao4QcXhQjlx6hpPnyHNLBWj6H3sP237BgmnL5r
iJvkS6/jj3dI8kt1GFbUR91yOsqwvBzG8pdV53cHuQ0GJxKZBjJIDkOkOyP0pdb3
I2SCjb+W/wPNFbW1BXCTaeG+Ys3h2Ywxrg3qJKFG8cfXq9Y2gt/QfV0cXMFNWUtE
azAeEZsbHsb5O796+giCu55HvkWCl3hxInt0e3V7qzYH/Nsw2MMnv16c/iuugC8V
NgAARk0v7+VEfP8Ddq/9N6MlIh25GI7YqQnqtgKE32ssQHU/TKavln6rPmm4OTTQ
zHGVBzmp8Y1w6/yljmyPOOVorvq1koM+ISjC5orVjo8I4KQF6SQ=
=INwO
-----END PGP SIGNATURE-----

--q1Ej8VbHEAiJJRdoTwqH5SNlYqt4AgiJE--
