From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Wiki update request: source repo page   Was: [PATCH] Btrfs: use
 i_version instead of our own sequence
Date: Thu, 12 Apr 2012 22:55:46 +0100
Message-ID: <20120412215546.GB4856@carfax.org.uk>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
 <CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
 <20120412133107.GC1924@localhost.localdomain>
 <pan.2012.04.12.21.41.17@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.04.12.21.41.17@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 09:41:17PM +0000, Duncan wrote:
> Josef Bacik posted on Thu, 12 Apr 2012 09:31:07 -0400 as excerpted:
> 
> >> BTW.
> >> 1. where is BTRFS devel git tree?
> >> 2. when this is coming to mainline?
> >> 
> >> 
> > There's a bunch, my personal tree with just my patches is here
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git
> > 
> > a tree with all outstanding mailinglist patches is here
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> > 
> > and Chris's tree which is where all things go through to get to mainline
> > is here
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> > 
> > It will probably be in the next merge window.  Thanks,
> 
> 
> Could this list be added to the btrfs wiki, source repositories page?

   Well, it _is_ a wiki... Knock yourself out.

> http://btrfs.ipv5.de/index.php?title=Btrfs_source_repositories
> 
> While there, please review the dkms information:
[snip dkms]
> 2) Is Chris's tree STILL based on old 2.6.32 without further updates 
> except to btrfs?  If so, the link to it in the earlier btrfs kernel 
> module git repository section should probably have a BIG WARNING TO THAT 
> EFFECT, instead of simply saying it downloads a complete Linux kernel 
> tree.

   No, it's generally based on some recent linux-kernel (usually not
more than one revision out). Possibly some instructions on using git
merge to combine Chris's tree with Linus's would be useful (although I
think it's generally assumed that if you're using git to pull some
arbitrary repo to build from that you know how to drive git to that
degree anyway).

> 3) Further down there's a step that says Patch version script, noting 
> 2.6.27, which is older still.  Has cmason merged that patch?
> 
> 4) The instructions appear to assume a kernel module an initr* based 
> setup.  What about people who configure and build a custom monolithic 
> kernel, with module loading disabled?

   Then in general, they're stuffed.

   If you want to mount a multi-device filesystem, you have to run
btrfs dev scan before it's mounted. If that filesystem is your root
filesystem, then you have to do it before root is mounted. This
requires an initramfs/initrd.

   It is possible to supply a full list of explicit device names for
the root FS to the kernel at boot time with the device= mount
parameter, but this is unreliable at best. We certainly had a very
hard time getting it to work last time the issue came up on IRC.

   The general advice is -- use a single-device root filesystem, or an
initramfs. These are simple, supported, and will generally get good
help. Any other configuration will cause you to be told to use an
initramfs. So far, I've not heard any concrete reason why one
shouldn't be used except "ooh, I don't understand them, and they're
scary!".

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- This year,  I'm giving up Lent. ---                 

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD4DBQFPh09iIKyzvlFcI40RAu7zAKC/vqUiNVIX7qWMvC67+Sxc0gKsyQCXbC2R
mRm2HT1Tcc0L4oCMUNWaGA==
=gV3B
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
