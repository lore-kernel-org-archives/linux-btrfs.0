Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54415 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaK3L7K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 06:59:10 -0500
Date: Sun, 30 Nov 2014 11:59:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: root subvol id is 0 or 5?
Message-ID: <20141130115908.GF32735@carfax.org.uk>
References: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LsnByradU3Ze6UwI"
In-Reply-To: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LsnByradU3Ze6UwI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 30, 2014 at 09:01:37AM +0530, Shriramana Sharma wrote:
> I am confused with this: should I call it the "root subvol" or
> "top-level subvol" or "default subvol" or doesn't it matter? Are all
> subvols equal, or some are more equal than others [hark to Orwell's
> Animal Farm ;-)]?

   I try to use "top level" for subvolid=5.

   "root subvol" is hugely confusing, as it could be one of several
things. If you mean the subvol mounted at /, then I call that "/" or
"the / subvol".

   "default subvol" is the one marked as default. This starts out as
subvolid=5, but can be set to any other subvol.

> And more importantly, is the ID of the root subvol 0 or 5?

   In the data structures on disk, it's 5. The kernel aliases 0 to
mean subvolid 5.

> The Oracle guide
> (https://docs.oracle.com/cd/E37670_01/E37355/html/ol_use_case3_btrfs.html)
> seems to say it's 0 :
> 
> "By default, the operating system mounts the parent btrfs volume,
> which has an ID of 0"
> 
> but the BtrFS wiki (and btrfs subvol manpage) reads 5:
> 
> "every btrfs filesystem has a default subvolume as its initially
> top-level subvolume, whose subvolume id is 5(FS_TREE)."
> 
> as also the Ubuntu Wiki:
> 
> "The default subvolume to mount is always the top of the btrfs tree
> (subvolid=5)."

   As above, both are correct here.

> Now this Oracle page
> http://www.oracle.com/technetwork/articles/servers-storage-admin/advanced-btrfs-1734952.html
> says:
> 
> "The only clean way to destroy the default subvolume is to rerun the
> mkfs.btrfs command, which would destroy existing data."

   OK, this is actually wrong. It's not the default subvolume if
someone's run set-default on the FS. They're correct that you can't
delete the top-level subvol. You can't delete the subvol marked as
default, either. Assuming (or implying) that the two are the same is
just plain wrong.

> So from what I've (confusedly) understood so far, 0 refers to the
> superstructure (or whatchamacallit) of the entire BtrFS-based contents
> of the device(s) and hence cannot be deleted but only reset by a
> mkfs.btrfs, but 5 is only the default subvol (mounted when the FS as a
> whole is mounted without subvol spec) provided by mkfs.btrfs, and
> subvol set-default can have another subvol mounted as default instead,
> after which 5 can actually be deleted?

   You can't delete subvolid=5. It's part of the "fundamental
whatchamacallit" of the FS (a good name). Even if you change the
default subvol, you still can't delete it.

   Hugo.

-- 
Hugo Mills             | People are too unreliable to be replaced by
hugo@... carfax.org.uk | machines.
http://carfax.org.uk/  |
PGP: 65E74AC0          |                              Nathan Spring, Star Cops

--LsnByradU3Ze6UwI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUewaMAAoJEFheFHXiqx3kPLIQALXv7OyKihSZow1UT+M0oVDP
nHLDX1n/M4nr5LsNDsM7OPNwFxRHixWz5YgWIOQJkeyJfFNskFY8/fgS65ZtGpqm
yQYFp92nrgeKOphr/t24UXq9bfPSYYSVT4J1QlyDzNEcqIIa0CODYZ5eleLrHbgi
4NjIuppwb55Hzy5TK6v2CZtkU8XoX1JmOLX5jXrGKsBRR5o3uZI7Y4vvtjy74Htb
L0NY/QJhqhV8gjYkDzYSxygbahY7fA34eYVkBZ1TsoXYllPHMCCpd02FhzMwGl36
RynH4KXhELcN/AmV6T8uBdZNqr171QE0llqnHW5yWeLp0WzjKSr4txQcx3uARuO8
6hKsx+v/4bV75Ksk9K0YH/PO65n3xNeICylaDARvBSuBMAv5TW0HNsBFmiVOkqgm
BE06PVRXjSifP0NqdKG1txQgKg1g6IPNAnrKHoFTvipZfWI2CK8/cvMvZ9kkItii
270cXvx0rhjnIAc5UPKRkZEVkVnqCGqDtHgrBcFmCmN5zRUqZCLQgbO5LYwGorx6
Qu97Vp+ULLmq73fPk5AI8kMR8+9KT7gb7CkBalY5cAliEY/oj2TtD8hBezUPoCYK
n4xb6LNrb7aS9JZPsbPQ2lxRiYK2u9rCgq9ATDlm7SDZGTKx73AyE7oaiA5XveW5
mnds7urayZ5fsMJYE2Ru
=1jQL
-----END PGP SIGNATURE-----

--LsnByradU3Ze6UwI--
