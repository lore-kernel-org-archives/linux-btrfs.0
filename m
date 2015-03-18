Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53078 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbbCRVJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 17:09:05 -0400
Date: Wed, 18 Mar 2015 21:09:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: K Richard Pixley <rpixley@graphitesystems.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: syntax for deleting subvolumes?
Message-ID: <20150318210903.GB31762@carfax.org.uk>
References: <5509E34F.6010504@graphitesystems.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
In-Reply-To: <5509E34F.6010504@graphitesystems.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 18, 2015 at 01:42:55PM -0700, K Richard Pixley wrote:
> I'm having trouble deleting a subvolume.
> 
> [root@new-alfred ~]# uname -a
> Linux new-alfred.corp.graphitesystems.com 3.10.0-123.el7.x86_64 #1
> SMP Mon May 5 11:16:57 EDT 2014 x86_64 x86_64 x86_64 GNU/Linux
> [root@new-alfred ~]#   btrfs --version
> Btrfs v3.16.2
> [root@new-alfred ~]#   btrfs fi show
> Label: 'rhel_bark'  uuid: d3c6c783-c190-4675-99f2-b83f3c462656
>         Total devices 2 FS bytes used 14.25GiB
>         devid    1 size 461.38GiB used 7.03GiB path /dev/sda2
>         devid    2 size 465.76GiB used 12.01GiB path /dev/sdb1
> 
> Btrfs v3.16.2
> [root@new-alfred ~]#   btrfs fi df /
> Data, single: total=15.01GiB, used=13.19GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=2.00GiB, used=1.07GiB
> Metadata, single: total=8.00MiB, used=0.00
> [root@new-alfred ~]# btrfs subvolume list /
> ID 257 gen 1483 top level 5 path root
> ID 258 gen 1466 top level 5 path home
> [root@new-alfred ~]# btrfs subvolume delete home
> Transaction commit: none (default)
> ERROR: error accessing 'home'
> [root@new-alfred ~]# btrfs subvolume delete /home
> Transaction commit: none (default)
> ERROR: error accessing '/home'
> 
> What format do I need to use to delete the "home" subvolume?

  I'm guessing you've got the home subvolume mounted, something like:

# mount /dev/sda2 /home -o subvol=home

   You can't delete that while it's mounted, because you'd be trying
to delete the subvolume out from under the mountpoint. So the first
thing is to unmount it.

   Then the syntax to delete a subvolume is:

# btrfs sub del /path/to/subvolume

... but at the moment, you can't see the subvolume, because it's not
mounted, and there's no way to see it. The trick here it to mount
something higher than the subvolume you want to operate on, and access
it through that mount path. So, mount the top level subvolume somewhere:

# mount /dev/sda2 /media/btrfs -o subvolid=0

then delete the subvolume through that:

# btrfs sub del /media/btrfs/home

   In fact, I'd recommend doing _all_ subvolume management operations
(and nothing else) through the top-level mount at /media/btrfs.

   Hugo.

-- 
Hugo Mills             | "There's a Martian war machine outside -- they want
hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
http://carfax.org.uk/  |
PGP: 65E74AC0          |                           Stephen Franklin, Babylon 5

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVCelvAAoJEFheFHXiqx3kWtwQAJnueCk5treH6BuGnarl7btn
B2KrIzMHSCsJjNVbBlJ5bwwhSCHpRnj/aq0h8k0KpNkUtxP5fBq/i2Qg3oLQ+LQB
y9SOMy1Ge1pElpFrAH8xCQ6o7psVUESKUuRm9csj37KPp20HewpiJAkl1QAG+kR1
ownO6Tjr05LBmV6KyjOy39DkHAB2LAZTofzxywMoCvt0KzBPSMFzg04WPgIMC485
h9dPKHBWEY1fZP8FeLI/B6DDOXmFj7HgxHuQjv0ibWjwHl6rQg0maSYbmYl/8Zfx
Wu4Qdaj6z5mMk4RBjyerh6McGGpvKXy4Cfwt+tHj9LoBmIvYm3uq9n0N4+FiwgSm
W0DlOuew+gPRh/tmnJVANOkMfi9ah0rFtocRePW0j1jY7vfGUAoXFvxS8boTqRsU
gZVHGeC7We0SjDWNsP2L7ffJ0ZmhPspCSnbsD2kX+nL3i54UXKb3h0LACUq9aPe2
5CeYrUiWMCAwX1MNNgs+yxefmHw6pOs6ixQpT4vCiuQuGKt2JWHCungLh3+ouq/H
7DC3GhtWRVG/qTipQJcpJOqTtGX4eUiwSZ+/XQIxAeJr1dToI7OnBtf7vWnwjEnB
BYyRlJzUTkgAEiOMWbvdv8KhEsVArhBTTEfZx4eiPJHHAswMFljQErvA1g1iXG9I
mrtKW7ZzrUft6pmJEBTu
=S7q6
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
