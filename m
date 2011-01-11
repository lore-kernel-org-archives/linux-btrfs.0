From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Synching a Backup Server
Date: Tue, 11 Jan 2011 22:25:10 +0000
Message-ID: <20110111222510.GD29572@carfax.org.uk>
References: <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
 <201101071720.08298.hka@qbs.com.pl>
 <4D29A033.7000803@chandlerfamily.org.uk>
 <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
 <4D29D508.6080006@chandlerfamily.org.uk>
 <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
 <20110109183030.GA29572@carfax.org.uk>
 <4D2A2128.2060508@chandlerfamily.org.uk>
 <20110109220101.GB29572@carfax.org.uk>
 <4D2A4584.4020901@chandlerfamily.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo-lkml@carfax.org.uk>
To: Alan Chandler <alan@chandlerfamily.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2A4584.4020901@chandlerfamily.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 09, 2011 at 11:32:20PM +0000, Alan Chandler wrote:
> On 09/01/11 22:01, Hugo Mills wrote:
> >>  I find the wiki
> >>also confusing because it talks about subvolumes having to be at the
> >>first level of the filesystem, but again further up this thread
> >>there is an example which is used for real of it not being at the
> >>first level, but at one level down inside a directory.
> >
> >    Try it, see what happens, and fix the wiki where it's wrong? :)
> >
> >    Or at least say what page this is on, and I can try the experiment
> >and fix it later...
> I don't have an account right now, but the page its on is here.
> 
> https://btrfs.wiki.kernel.org/index.php/Getting_started#Basic_Filesystem_Commands

   OK, I've just tried this. The page is actually accurate, but
doesn't tell the whole story. You can *create* subvolumes and
snapshots anywhere:

hrm@molinar:~ $ sudo btrfs sub list /mnt
ID 256 top level 5 path snap1
ID 257 top level 5 path foo/snap1
ID 258 top level 5 path snap1/snap2

   However, you can't *mount* one by name unless it's at the top
level:

hrm@molinar:~ $ sudo mount /dev/vdb /media/btr1 -o subvol=snap1
hrm@molinar:~ $ sudo mount /dev/vdb /media/btr2 -o subvol=foo/snap1
mount: block device /dev/vdb is write-protected, mounting read-only
mount: /dev/vdb already mounted or /media/btr2 busy
mount: according to mtab, /dev/vdb is mounted on /mnt

   Mounting by ID works, though:

hrm@molinar:~ $ sudo mount /dev/vdb /media/btr2 -o subvolid=257
hrm@molinar:~ $ ls /media/btr2/
foo  linux-image.deb  snap1  subdir

   This would seem to imply that the limitation is in mount, rather
than in the btrfs kernel implementation.

   I've clarified that particular piece of text on the wiki.

> ...
> >     From trying it a while ago, I don't think it is possible to create
> >a filesystem in degraded mode. Again, I'll try it again when I have
> >the time to do some experimentation and see what actually happens.
> 
> As I wondered before it might be possible to fake it by using
> something like a USB stick initially and then failing it, and
> replacing it with the real device when ready.
> 
> If thats possible, then perhaps functionality to do it without
> faking it could be added to the "to do" list. It sure would be
> useful in migrating from mdmadm/lvm setup.

   I haven't got to this one yet -- someone on IRC just asked the same
thing, though, so I'll probably have a stab at it tomorrow.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNLNjGIKyzvlFcI40RAhdfAKChoR99/uBFMv1Zbxo7+9SvUw2y7wCdGzfG
u+DPj4EX4OraT+pa2/LckDQ=
=u77G
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
