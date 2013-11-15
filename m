Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39031 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3KOMin (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 07:38:43 -0500
Date: Fri, 15 Nov 2013 12:38:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lutz Vieweg <lvml@5t9.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "btrfs: 1 enospc errors during balance" when balancing after
 formerly failed raid1 device re-appeared
Message-ID: <20131115123841.GP4315@carfax.org.uk>
References: <l650m2$njg$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMHqbYJb993HXwLR"
In-Reply-To: <l650m2$njg$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XMHqbYJb993HXwLR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2013 at 12:31:24PM +0100, Lutz Vieweg wrote:
> Hi again,
> 
> I just did another test on resilience with btrfs/raid1, this time I tested
> the following scenario: One out of two raid1 devices disappears. The filesystem
> is written to in degraded mode. The missing device re-appears (think of e.g.
> a storage device that temporarily became unavailable due to a cable or controller
> issue that is later fixed). User issues "btrfs filesystem balance".
> 
> Alas, this scenario ends in an effor "btrfs: 1 enospc errors during balance",
> with the raid1 staying degraded.
> 
> Here's the test procedure in detail:
> 
> Testing was done using vanilla linux-3.12 (x86_64)
> plus btrfs-progs at commit 9f0c53f574b242b0d5988db2972c8aac77ef35a9
> plus "[PATCH] btrfs-progs: for mixed group check opt before default raid profile is enforced"
> 
> Preparing two 100 MB image files:
> > # dd if=/dev/zero of=/tmp/img1 bs=1024k count=100
> > 100+0 records in
> > 100+0 records out
> > 104857600 bytes (105 MB) copied, 0.201003 s, 522 MB/s
> >
> > # dd if=/dev/zero of=/tmp/img2 bs=1024k count=100
> > 100+0 records in
> > 100+0 records out
> > 104857600 bytes (105 MB) copied, 0.185486 s, 565 MB/s

   For btrfs, this is *tiny*. I'm not surprised you've got ENOSPC
problems here -- it's got nowhere to move the data to, even if you are
using --mixed mode.

   I would recommend using larger sparse files for doing this,
otherwise you're going to keep hitting ENOSPC errors instead of
triggering actual bugs in device recovery:

$ dd if=/dev/zero of=/tmp/img1 bs=1M count=0 seek=10240

That will give you a small file with a large apparent size.

[...]

> So far, so good.
> Now since we know the filesystem is not really redundant,
> we start a "balance":
> 
> > # btrfs filesystem balance /mnt/tmp
> > ERROR: error during balancing '/mnt/tmp' - No space left on device
> > There may be more info in syslog - try dmesg | tail
> 
> Syslog shows:
> > kernel: btrfs: relocating block group 20971520 flags 21
> > kernel: btrfs: found 3 extents
> > kernel: btrfs: relocating block group 4194304 flags 5
> > kernel: btrfs: relocating block group 0 flags 2
> > kernel: btrfs: 1 enospc errors during balance
> 
> So the raid1 remains "degraded".
> 
> BTW: I wonder why "btrfs balance" seems to require additional space
> for writing data to the re-appeared disk.

   It's a copy-on-write filesystem: *every* modification of the FS
requires additional space to write the new copy to. In your example
here, the FS is so small, I'm surprised you could write anything to it
all, due to metadata overheads.

> I also wonder: Would btrfs try to write _two_ copies of
> everything to _one_ remaining device of a degraded two-disk raid1?

   No. It would have to degrade from RAID-1 to DUP to do that (and I
think we prevent DUP data for some reason).

   Hugo.

> (If yes, then this means a raid1 would have to be planned with
> twice the capacity just to be sure that one failing disk will
> not lead to an out-of-diskspace situation. Not good.)
> 
> Regards,
> 
> Lutz Vieweg
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Doughnut furs ache me, Omar Dorlin. ---               

--XMHqbYJb993HXwLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUoYV0FheFHXiqx3kAQKO7Q//Y66e9PUmyKzmg5UMXtOAJEczLFdr9ggv
bmUffOe/rfln0M5jDONRfNfl8RxwvBV8ZtIMtyR5R/39a+C0ycUOB+pJlkUqLE6Y
4k4F0Kd0wvVNgA//dm7+O21fJH1QpT8s8osCM0q5AzUd11ONINgBHETD3fSTYSKD
AlLb+0nWUjUjRsp5DuZ8bzHq9wkEGT9PSPmtzz5rVvPN9fjq9W7XitD8/tWOh4Cn
S80MjRLOHlxk5yorq4WxDNLX00YI21cVYHW0OfO7W7bucIz0p6G4duHdqx/kyUOR
9rxoC81pDCWRTVoNyH1ZEwl8HuNEehiOKT8v3fD4aD88UqBKEpsrpuUxX9Ak0YwE
PnTSFBwVWe3tBMuSl+RfBEE3cL/wViTbyP9CeF4Z35JwpLOwuvHTu2VkO2VGlmEX
VGb5t1EP7x63Ye1RxLUHrguUUnOJ66cvAquJ5WuIKNe90Fz0wuc2mUoF5G/DXUTV
2MuQU43Itt6F0LD01hTYRHKAr+YIIAklXrmqt/Cfct8XnekVriUcBc2wvdQ1SchJ
JVUlOkfjAA8BtJZcMyUk/TurpkaQXyI4hM+kS5ZVcr9rbyFXzqW+Dg0vnT5FA5co
ouA5EgZjTyozK1OawJ8Ham6FBdOnP3naO9tR8dE8GtHdQA4he+CcCxjZBSLCCOzo
AN+JCK9TkuU=
=b7HX
-----END PGP SIGNATURE-----

--XMHqbYJb993HXwLR--
