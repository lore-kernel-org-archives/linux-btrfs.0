From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Stupid newb tricks: making a subvolume of root.
Date: Fri, 11 Nov 2011 19:13:09 +0000
Message-ID: <20111111191309.GM28749@carfax.org.uk>
References: <6c5dc86169d45cbc1001d0daa2d51a08@www.jots.org>
 <20111110145944.GK28749@carfax.org.uk>
 <68365841c0d5cfbc86aff3e90dc407eb@www.jots.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XlS4q8O07AKt4+K1"
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <68365841c0d5cfbc86aff3e90dc407eb@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>


--XlS4q8O07AKt4+K1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 11, 2011 at 02:06:42PM -0500, Ken D'Ambrosio wrote:
> On Thu, 10 Nov 2011 14:59:44 +0000 Hugo Mills <hugo@carfax.org.uk> wrote
> 
> >    Alternatively, if you want the top level to be simply a container
> > for subvolumes (and to use a default subvolume to mount / ), then you
> > could do the switch-over by making a snapshot of your current /,
> > remounting with the snapshot as / (possibly using "btrfs sub
> > set-default"), and then mounting subvolid=0 on /media/btrfs-management
> > to delete the old contents of /
> 
> So, I did this.  I think correctly:
> mkdir /tmp/foo
> mount /dev/sda1 /tmp/foo -o subvolid=0
> And lo!  I did an ls, and everything was there.  And then the kernel panic'd. 
> I rebooted, re-mounted, and it was there again.  And then the kernel panic'd. 

   I'm starting to see a pattern forming here. ;)

> Last time, I didn't even try an ls -- I just did a "btrfs subvol list
> /tmp/foo", and yet another panic.  This is running 3.2rc1 (with tools built off
>  the git repository on kernel.org, if that makes any difference).

   The tools shouldn't make a difference to this. (Anything that makes
the kernel panic is a bug in the kernel, not in the thing that
triggers it).

> My system is, technically, working.  Any suggestions on how to get rid of my
> old root?

   I'd suggest reporting (on this mailing list) the panic message(s)
you got, and how you got to them. I know there's been quite a few
additional patches worked on since Chris pushed out the stack for
-rc1, so it's quite plausible that your particular problem has already
been fixed in someone's tree.

   The other thing you could try is dropping back to 3.1 and see if
that's stable for you with this.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Quidquid latine dictum sit,  altum videtur. ---           

--XlS4q8O07AKt4+K1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOvXPFIKyzvlFcI40RAvtVAKCt/cndcm26Y/K6zUelQcN8u+yw3wCeLk+Y
iuk4lE05pY41lpGfCEnZy9E=
=0Aj3
-----END PGP SIGNATURE-----

--XlS4q8O07AKt4+K1--
