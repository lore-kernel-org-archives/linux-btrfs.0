From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 14:29:36 +0000
Message-ID: <20110124142936.GB3403@carfax.org.uk>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110124130104.GA7354@scooter>
 <20110124131341.GA3403@carfax.org.uk>
 <20110124135305.GB7354@scooter>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, kreijack@inwind.it,
	linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110124135305.GB7354@scooter>
List-ID: <linux-btrfs.vger.kernel.org>


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 24, 2011 at 02:53:05PM +0100, Felix Blanke wrote:
> On 24. January 2011 - 13:13, Hugo Mills wrote:
> > On Mon, Jan 24, 2011 at 02:01:04PM +0100, Felix Blanke wrote:
> > > Hi,
> > > 
> > > you were talking about the LOOP_GET_STATUS function. I'm not quite sure where does it
> > > came from. Is it part of the kernel? Or does it come from the util-linux package?
> > 
> >    It's an ioctl (number 0x4c03) that works on loop devices, and
> > returns information about the loop device. Being an ioctl, it's
> > implemented in the kernel. Unfortunately, since it's part of the
> > kernel API, the size of the name field is probably fixed for the rest
> > of time, and so the bug can't be fixed.
> >
> 
> That sounds great :/

   If you change the layout of the structure, then you have two
incompatible APIs: the one before, and the one after the change. Code
that's compiled to work with one version won't work with the other.
This will cause all manner of pain, and the kernel developers tend
(quite rightly) to come down hard on any attempts to do that kind of
thing.

> > > Btw: I tested it with util-linux-2.19-rc1. The strace still contains
> > > the truncated path, and no '*'. Therefore I think that ioctl is from
> > > the kernel.
> > 
> >    Indeed.
> > 
> >    What I find interesting is that my copy of losetup follows symlinks
> > from the /dev/disk/by-id/... path back to the original device node
> > (/dev/dm-7 in my test case) before setting up the loop, whereas yours
> > seems not to.
> > 
> >    I think that that's probably the easiest solution to this problem:
> > modify losetup to use realpath(3) on the device node it's given.

> I dont see where that helps with the problem. If I understand
> Goffredo correct mkfs.btrfs is using the ioctl to get the path.
> Letting losetup following the link will fix the output of "losetup
> /dev/loopX", but it will not fix the truncated path from the ioctl
> and therefore it will not fix the problem with mkfs.btrfs.

   What seems to be happening is that at the point that losetup
creates the loop device, it stores the pathname of the underlying
device node in the kernel. When you run losetup -a or mkfs.btrfs,
these use the LOOP_GET_STATUS ioctl to retrieve that pathname. The
pathname that LOOP_GET_STATUS returns is truncated to 64 bytes (63
ASCII characters, plus the zero terminator). losetup -a simply prints
it; mkfs.btrfs tries to use it as a parameter to realpath(3). It is at
this point that the symptoms of breakage occur, because the truncated
name doesn't exist, so realpath returns an error.

   If, instead, the initial losetup call tracked the symlinks back to
the original device node (i.e. something like "/dev/sdb3", or
"/dev/mapper/ruthven-btest" in my example), then the name that's
stored in the kernel would be shorter, and we'd be less likely to see
the truncation. This is what my copy of losetup seems to be doing. I
can't see any distribution-specific patches in the source for
util-linux that would do this, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNPYzQIKyzvlFcI40RAk/iAJ9BiC6NiJpzoyKM453D3QiDP/yLWACfVELg
Y9PGIsN6URv4iKl551azA5A=
=pC8p
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
