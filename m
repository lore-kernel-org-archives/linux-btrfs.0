From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: heterogeneous raid1
Date: Fri, 23 Mar 2012 10:20:07 +0000
Message-ID: <20120323102007.GA14080@carfax.org.uk>
References: <20120323061159.GA11099@mcelrath.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Cc: linux-btrfs@vger.kernel.org
To: Bob McElrath <bob@mcelrath.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120323061159.GA11099@mcelrath.org>
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 23, 2012 at 06:11:59AM +0000, Bob McElrath wrote:
> Greetings butter-heads,
> 
> I would like to implement a redundant (raid1) disk array on heterogeneous disks
> using btrfs.  A more detailed description of what I want to do can be found here:
> 
> http://superuser.com/questions/387851/a-zfs-or-lvm-or-md-redundant-heterogeneous-storage-proposal/388536
> 
> In a nutshell: organize your heterogenous disks into two "halves", the sum of
> which are of roughly equal size, and create a raid1 array across those two
> halves.
> 
> For various reasons I decided to go with btrfs over zfs.  What I have done is to
> create two lvm Logical Volumes, one using a single large disk, and another as a
> linear concatenation of several smaller disks.  It works, so far, and I could
> automate it with some scripts.

   btrfs doesn't quite do things this way. As well as the FAQ
suggested by Carey, you might want to look at the (rather misnamed)
SysadminGuide on the wiki at http://btrfs.ipv5.de/ .

> In the long term, I would like this to be something that btrfs could do by
> itself, without LVM.  Having absolutely no knowledge of the btrfs code, this
> seems easy, I'm sure you'll tell me otherwise.  ;)  But one needs:
> 
> 1) The ability to "group" a heterogeneous set of disks into the "halves" of a
> raid1.  I don't understand what btrfs is doing if you give it more than 2
> devices and ask for raid1.
> 
> 2) Intellegently rebalance when a new device is added or removed (e.g. rearrange
> the halves, and rebalance as necessary)

   A balance operation is incredibly expensive. It would be much
better to have a complex policy on when to rebalance. Think of trying
to add two new disks to a nearly-full 20TB array: you really don't
want to have to wait for 20TB of data to be rewritten before you add
the second drive. Such a complex policy doesn't belong in the kernel
(and probably doesn't belong in code, unless you've got some
mind-reading software, or a webcam and enough image-processing to
identify the stack of disks on the admin's desk).

   I'm not trying to argue that you shouldn't automatically rebalance
after a new device is added, but more that the feature probably
shouldn't be in the kernel.

   Hugo.

[snip]

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- UNIX: British manufacturer of modular shelving units. ---      

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPbE5XIKyzvlFcI40RAu4YAJ0Q4FzkiwLHXyJvG4Wm5WPgSpF4QgCeLXWW
3+Tph+yhJtHE0iX5r8EMdVw=
=LjQJ
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
