From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: 800 GByte free, but "no space left"
Date: Sun, 5 Dec 2010 11:22:08 +0000
Message-ID: <20101205112208.GD4087@carfax.org.uk>
References: <AANLkTimJ3dDdOFiQb8G=rrjCk2h68Y59oWdKEGH-80jN@mail.gmail.com>
 <BbJOCYcD1uB@helmut.hullen.de>
 <AANLkTim9nJrfHeFqLp4d+KYs4jX3hQBV_JTuSBCzFmu3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: Evert Vorster <evorster@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim9nJrfHeFqLp4d+KYs4jX3hQBV_JTuSBCzFmu3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 05, 2010 at 04:08:26AM -0700, Evert Vorster wrote:
> On Sun, Dec 5, 2010 at 12:48 AM, Helmut Hullen <Hullen@t-online.de> wrote:
> > Hallo, Evert,
> >
> > Du meintest am 04.12.10 zum Thema Re: 800 GByte free, but "no space left":
> >
> >> I am not an expert on this by a long shot, but it looks like you
> >> added these two disks in raid0.

   Nope -- btrfs will spread out its allocations across both disks.

> >> This means that the total space cannot exceed the space of the
> >> smallest disk.
[...]
> > Especially: no RAID definition.
> >
> > If the smallest device defines the capacity then I should use 2*1.35
> > TiByte, but my system tells "no space left" at about 2.4 TiByte - where
> > are (at least) 300 GiByte hidden?
> 
> >>>       devid    2 size 1.35TB used 1.35TB path /dev/sdc3
> >>>       devid    1 size 1.81TB used 1.35TB path /dev/sdf2
> 
> Here devid 2 is at 100%, and hence you are getting the no more space
> left errors. So, the 300 TB is on the bigger disk, and not usable for
> you right now.

   I _think_ that a balance is all that's needed at this point. It
can't hurt, anyway (other than taking quite a long time).

> I know of the disk mode you speak.. an old raid card of mine called it
> "Just a bunch of disks" and it literally filled up the first disk
> before carrying on to the second one until that was full under
> windows... under UNIX it had the effect of just adding all the sectors
> to each other, and stretching the file system over the disks in a
> linear fashion. Most UNIX file systems writes files in the middle of
> the largest contiguous free space, which meant that some files got
> written on the first disk, and some on the second. As far as I know,
> btrfs does not support this raid mode.

   It does support it: that's what the "single" RAID profile in
mkfs.btrfs is. It attempts to use the disk space marginally more
intelligently than traditional linear mode, though, as it allocates
block groups (in chunks of about 1G) to each disk in turn. This isn't
the same as RAID-0, which stripes within block groups with a much
smaller stripe size.

> Another thing to keep in mind is that as far as I know you cannot
> remove devid 1 from a btrfs volume. This is due to be fixed, but I
> have no idea on the status of that.

   I've done it (I have a filesystem with IDs 7, 8, 9, 12, 13, 14).
Looks like that particular problem has been fixed.

> You could, if you really wanted to use all of two differently sized
> disks in a btrfs, subdivide the disks in equal sized partitions, and
> just put all of those partitions in a btrfs raid0...
[...]

   That would be a really bad idea, as your disks would thrash
horribly, reading stripes from different locations on the disk.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Nostalgia isn't what it used to be. ---               

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM+3XgIKyzvlFcI40RAsIHAJ9RrwwVG7Ux5EojCDqEkLjiwP5AEgCfZ17N
85zfwCIxIEEItj3v9Yi69YY=
=l+PI
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
