From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Thu, 1 Jul 2010 06:09:43 -0400
Message-ID: <20100701100943.GR25967@think>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
 <20100602155646.GA4041@flcl.lan>
 <loom.20100628T154422-48@post.gmane.org>
 <AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com>
 <87eifov564.fsf@mid.deneb.enyo.de>
 <AANLkTimVLjQfRjJFeHVI0NLEEE64iYtqLqYvZUQ6X_B7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Florian Weimer <fw@deneb.enyo.de>,
	Daniel Kozlowski <dan.kozlowski@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Rodrigo =?iso-8859-1?Q?E=2E_De_Le=F3n?= Plicet
	<rdeleonp@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimVLjQfRjJFeHVI0NLEEE64iYtqLqYvZUQ6X_B7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 30, 2010 at 10:38:18PM -0500, Rodrigo E. De Le=F3n Plicet w=
rote:
> On Wed, Jun 30, 2010 at 11:47 AM, Florian Weimer <fw@deneb.enyo.de> w=
rote:
> > ZFS doesn't need a fsck because you have throw away the file system
> > and restore from backup for certain types of corruption:
> >
> > | What can I do if ZFS file system panics on every boot?
> > [...]
> > | This will remove all knowledge of pools from your system. You wil=
l
> > | have to re-create your pool and restore from backup.
> >
> > <http://hub.opensolaris.org/bin/view/Community+Group+zfs/faq#HWhatc=
anIdoifZFSfilesystempanicsoneveryboot>
>=20
>=20
> They *do* make it clear when could something like that happen.
>=20
> >From the same URL:
>=20
> "ZFS is designed to survive arbitrary hardware failures through the
> use of redundancy (mirroring or RAID-Z). Unfortunately, certain
> failures in *non-replicated* configurations can cause ZFS to panic
> when trying to load the pool. This is a bug, and will be fixed in the
> near future (along with several other nifty features, such as
> background scrubbing)."
>=20
> "Non-replicated configuration" boils down to no mirroring or parity
> checking (basically RAID-0 or similar); such a thing implies:

Memory corruptions and other problems make it impossible to catch every
single class of error on commodity hardware.  fsck is the last line of
defense between you and restoring from backup, especially if the size o=
f
the corruption is relatively small in a large FS.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
