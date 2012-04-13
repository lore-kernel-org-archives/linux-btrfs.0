From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Wiki update request: source repo page   Was: [PATCH] Btrfs: use
 i_version instead of our own sequence
Date: Fri, 13 Apr 2012 14:16:32 +0100
Message-ID: <20120413131632.GG4856@carfax.org.uk>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
 <CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
 <20120412133107.GC1924@localhost.localdomain>
 <pan.2012.04.12.21.41.17@cox.net>
 <20120412215546.GB4856@carfax.org.uk>
 <pan.2012.04.12.22.56.00@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iJXiJc/TAIT2rh2r"
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.04.12.22.56.00@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>


--iJXiJc/TAIT2rh2r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 10:56:00PM +0000, Duncan wrote:
> Hugo Mills posted on Thu, 12 Apr 2012 22:55:46 +0100 as excerpted:
> > The general advice is -- use a single-device root filesystem, or an
> > initramfs. These are simple, supported, and will generally get good
> > help. Any other configuration will cause you to be told to use an
> > initramfs. So far, I've not heard any concrete reason why one shouldn't
> > be used except "ooh, I don't understand them, and they're scary!".
> 
> FWIW, device names appear to be reasonably stable, here.  Stable enough 
> that I currently have this built into the kernel as part of my kernel 
> command line:

   That's all well and good for you, but my point is that in the
general case, device names are *not* stable, and the kernel does *not*
claim to guarantee this. If you assume that they are stable, and your
system breaks as a result, then you get to keep both pieces. Your
choice, but your risk as well. The recommendation for a stable
reliable system is to run btrfs dev scan before mounting a btrfs
filesystem.

> md=3,/dev/sda6,/dev/sdb6,/dev/sdc6,/dev/sdd6 root=/dev/md3p1
> 
> When I need to override that to mount the primary backup/recovery root, 
> this as part of grub2's linux line extends/overrides the kernel builtin:
> 
> md=9,/dev/sda12,/dev/sdb12,/dev/sdc12,/dev/sdd12 root=/dev/md9p1

   So you're doing the same thing as btrfs's "device=" mount option.
Again, if this works, all well and good, but it'll break if devices
move around, requiring the manual step. If you want to avoid that and
have it all Just Work, use an initrd (for both MD and btrfs).

> When I boot from thumbdrive or otherwise might trigger device reordering, 
> grub's interactivity allows me to find the correct mds and substitute 
> device names as appropriate.  And yes, if you're wondering,
> init=/bin/bash is tested and known to work, too. =:^)
> 
> I don't see why btrfs would have additional kernel device naming or 
> finding problems that md doesn't already have.

   As far as I recall, MD also requires userspace help in order to
reassemble a device correctly, except when v0.9 superblocks are used
(which have limitations on the set of other features they support).

> So while I'd agree that multi-device noinitr* btrfs builtin might not be 
> appropriate as a general distro-wide solution, it does seem quite 
> reasonable (here) for sysadmins familiar enough with their own systems to 
> have custom-built no-module-loading kernels in general, to be able to do 
> the same with btrfs.

   I disagree. You could conceivably get the kernel to scan every
single block device it knows about as the device is discovered, but
then the kernel would take unnecessarily long to boot (consider
something with a stack of DVD drives -- you'd have to wait for each
one to spin up before scanning it). If you were to restrict the set of
devices scanned, you're putting policy into the kernel, which would
get rejected pretty much instantly by anyone upstream.

> That's one of a couple reasons I don't use lvm2, as well.  Both lvm2 and 
> an initr* add complexity and thus recovery failure risk due to admin fat-
> fingering or failure to anticipate and test all permutations of failure 
> mode, for little or no gain in my current deployments.

   Again, that's good for you, but all such attempts should be viewed
as unreliable workarounds, not as recommended and supported
approaches.

>  Because lvm2 requires an initr* to handle root, it's TWO such
> layers of additional complexity to test the failure modes for and be
> prepared to deal with at recovery time. The added complexity and
> risk is simply not a reasonable tradeoff, for me, and I sleep better
> with a tested confidence in my disaster recovery abilities. =:^)

   I have had my initrd (for root on LVM on MD) fail precisely once in
8 years or so, and that was down to my upgrading some LVM tools
manually and not rebuilding the initrd. If you stick to your
distribution's packages (at least for boot-critical things), then I
would think it highly unlikely you'll end up with a system that fails
to boot. If you muck around with it manually and it breaks, then I
would suggest you treat it as a learning experience.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Our so-called leaders speak/with words they try to jail ya/ ---   
        They subjugate the meek/but it's the rhetoric of failure.        
                                                                         

--iJXiJc/TAIT2rh2r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPiCcwIKyzvlFcI40RAqCAAJ9rTHmS8tjNJD/dMpVDE/PVSEJu1QCg12Jr
MoL3uBF9xnr2RSv66Q7wLFA=
=tQqI
-----END PGP SIGNATURE-----

--iJXiJc/TAIT2rh2r--
