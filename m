Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43617 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2LCMC2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 07:02:28 -0500
Date: Mon, 3 Dec 2012 12:02:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Aastha Mehta <aasthakm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: basic questions regarding some btrfs features
Message-ID: <20121203120226.GD7289@carfax.org.uk>
References: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
 <20121202224635.GA7289@carfax.org.uk>
 <CAEx9m46ua1pQSUTeon6R0kBXoBq3iPxLtsrKjcXeafjT0Bor3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
In-Reply-To: <CAEx9m46ua1pQSUTeon6R0kBXoBq3iPxLtsrKjcXeafjT0Bor3Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 03, 2012 at 10:52:41AM +0100, Aastha Mehta wrote:
> On 2 December 2012 23:46, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sun, Dec 02, 2012 at 11:17:26PM +0100, Aastha Mehta wrote:
> >> I am looking at btrfs to understand some of its features. One of them
> >> is the snapshot feature. Please tell me if my following understanding
> >> about snapshots in btrfs is correct or not.
> >>
> >> Btrfs supports both readonly and writeable snapshots. Writeable
> >> snapshots are like clone volumes (or subvolumes as in btrfs). We get a
> >> point in time copy of the subvolume in both case.
> >>
> >> I looked through the kernel code and it seems that creating a
> >> subvolume and taking a snapshot (readonly and writeable) all have a
> >> common ioctl interface.
> >>
> >> What I am not completely clear about is whether snapshots get same
> >> fsid as the source subvolume fsid or different.
> >
> >    Yes, it's the same UUID, because they're all part of the same
> > filesystem.
> >
> Just to clarify, apart from UUID, is the FSID in the fs_info of the
> root also same for all snapshots of a subvolume?
> 
> >> Also, I do not understand what does it mean to be able to take
> >> snapshot of a snapshot.
> >
> >    Snapshots are completely equal partners with their original
> > subvolumes. This is not the case in, say, LVM.
> >
> >> What are benefits compared to say, being able to take snapshots only
> >> of the active subvolume and not of the snapshots?
> >
> >    Let's say you take a snapshot (B) of your root filesystem (A). Then
> > you decide to "roll back" to using the old version, so you mount B as
> > root instead of A. Later that night, your backup process starts up and
> > tries to take a temporary read-only snapshot (C) of your root
> > filesystem (which is now B) so that it can make a stable backup.
> > That's a snapshot of a snapshot.
> >
> Okay, but still the snapshot can be taken only for a subvolume in use.
> Is that correct?

   Well, it depends on what you mean by "in use". You can't snapshot
something which doesn't appear somewhere in your directory hierarchy.

> In your example, C is taken on B after file system
> was rolled back to version B. What happens when the file system
> version mounted is A (which contains snapshot B) and we take another
> snapshot D on this mounted version. Does the snapshot D contain B or
> only the active contents of A?

   Snapshots are not recursive. If you have a subvolume inside another:

subv1/subv2

and then snapshot that

# btrfs sub snap subv1 subv1-A

you will end up with a subvolume subv1-A, containing an empty
directory called subv2.

   Note that you don't have to have subvolumes inside subvolumes at
all, if you don't use the top level of your filesystem as anything
other than a place to store and manage subvolumes.

   Consider this btrfs filesystem layout:

/               subvolid=5 (=0)
    root        subvolid=256  (default subvol)
    home        subvolid=257
    snapshots   directory

With this in fstab:

/dev/sda	/				btrfs	subvolid=256
/dev/sda	/home			btrfs	subvolid=257
/dev/sda	/media/btrfs	btrfs	subvolid=5,noauto

We get this filesystem hierarchy:

/                 subvolid=256
    home          subvolid=257
    media         directory
		btrfs     subvolid=5

   Note that the mount of the full filesystem on /media/btrfs isn't
done automatically -- it only needs to be done when you're managing
subvolumes.

   So, we can take a snapshot of /, for example:

# mount /media/btrfs
# btrfs sub snap /media/btrfs/root /media/btrfs/snapshots/root.2012-12-03
# umount /media/btrfs

The FS (from its top level) now looks like this:

/                           subvolid=5 (=0)
    root                    subvolid=256  (default subvol)
    home                    subvolid=257
    snapshots               directory
        root.2012-12-03     subvolid=258

To "roll back" root temporarily to the earlier version, you can edit
your boot manager's config to supply "subvolid=258" as a mount
parameter. To do so permanently, you can set the default subvolume to
258, and optionally move the snapshot to /root within the btrfs
filesystem:

# mount /media/btrfs
# mv /media/btrfs/root /media/btrfs/root.old
# mv /media/btrfs/snapshots/root.2012-12-03 /media/btrfs/root
# umount /media/btrfs

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'm on a 30-day diet. So far I've lost 18 days. ---         

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBULyU0r9z9OVl50rAAQLQiQ/8CVZ75HYYxA0Sv/7sFOxQe295ndKmuQp4
nx9GaHTTUWJs97jY5BJDH+Y4GNGYb0gUC0xX0glUrcuVQwYY0oXaHSG9z5+WkM/q
9VrKDKd28zlJUHqj4sz3nl0bFtE297nsH3VyOQQMv8/KCvrZ5fkK2xlIk50KBxM9
mIXOO+QHW22mvNrbmnYptMVjvkUiPT0P3L9OSqaj0RcuWQL3RKbWzLETXdQVAvZg
tgmPPMDxEEJnOKqnCFvGU5yX6E5fOxurbQRa4ZbPu7PZU8HwZ/2XefiIvhk43CY0
t0s7nMbAZJFPkkLXge9fu9PamnFU4kruHFLBEYxvUrb+a9v9CbK0oaunmIgPVZc8
Y8JNdRtv8NiEqCbQneJwFhsROyGL9O96GGeT3sZevjvTLeIQU/Ja47vUnuY1M4vA
tYhBR9FCdPF8S7nte0Pwy9KrOF+W7Vx1LCM5pD+EVnKhvs4dGnY3SHuWhHWQDFf+
hZZ0KgB9Kt9iPipPbnUapM/ba2KqWpha7A6hDoovu6nb3HwA+0958JWc7pmpFbvR
o9R8YKRRTeZ0+Tl+ksZ/YKvxUmXWWQc62UJLSyDCJE80be1Wukd0xWNXS2AkR3La
tleb8VIjUDBQwQdw97Z/1nAGI0wjvAxBBmUnkCwapo0f5ozhanEVj1WNeDi/UozG
VEKfjYQTx8w=
=4qFt
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
