Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35017 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbHMJzM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 05:55:12 -0400
Date: Thu, 13 Aug 2015 09:55:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: David Seikel <onefang@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Oddness with phantom device replacing real device.
Message-ID: <20150813095510.GP12976@carfax.org.uk>
References: <20150813133322.369c10af.onefang@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qndya+I13rh6QJ0p"
In-Reply-To: <20150813133322.369c10af.onefang@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qndya+I13rh6QJ0p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 13, 2015 at 01:33:22PM +1000, David Seikel wrote:
> I don't actually think that this is a BTRFS problem, but it's showing
> symptoms within BTRFS, and I have no other clues, so maybe the BTRFS
> experts can help me figure out what is actually going wrong.
> 
> I'm a sysadmin working for a company that does scientific modelling.
> They have many TBs of data.  We use two servers running Ubuntu 14.04 LTS
> to backup all of this data.  One of them includes 16 spinning rust
> disks hooked to a RAID controller running in JBOD mode (in other words,
> as far as Linux is concerned, they are just 16 ordinary disks).  They
> are /dev/sdc to /dev/sdr, all being used as a single BTRFS file system.
> 
> I have been having no end of trouble with this system recently.  Keep
> in mind that due to the huge amount of data we deal with, doing
> anything takes a long time.  So "recently" means "in the last several
> months".
> 
> My latest attempt to beat some sense into this server was to upgrade it
> to the latest officially backported kernel from Ubuntu, and compile my
> own copy of btrfs-progs from source code (latest release from github).
> Then I recreated the 16 disk BTRFS file system, and started the backup
> software running again, from scratch.  The next day, /dev/sdc has
> vanished, to be replaced be a phantom /dev/sds.  There's no such disk
> as /dev/sds.  /dev/sds is now included in the BTRFS file system
> replacing /dev/sdc.  In /dev sdc does indeed vanish, and sds does
> indeed appear.  This was happening before.  /dev/sds then starts to
> fill up with errors, since no such disk actually exists.

   Sounds like the kind of behaviour when the disk has vanished from
the system for long enough to drop out and be recreated by the
driver. The renaming may (possibly) be down to a poor error-handling
path in btrfs -- we see this happening on USB sometimes, where the
original device node is still hung on to by the FS on a hardware
error, and so when the device comes back it's given a different name.

> I don't know what is actually causing the problem.  The disks are in a
> hot swap backplane, and if I actually pulled sdc out, then it would
> still be listed as part of the BTRFS file system, wouldn't it?

   With btrfs fi show, no, you'd get ** some devices missing ** in the
output.

>  If I
> then where to plug some new disk into the same spot, it would not be
> recognised as part of the file system?

   Correct... Unless the device had a superblock with the same UUID in
it (like, say, the new device is just the old one reappearing
again). In that case, udev would trigger a btrfs dev scan, and the
"new" device would rejoin the FS -- probably a little out of date, but
that would be caught by checksums and be fixed if you have redundancy
in the storage.

>  So assuming that the RAID
> controller is getting confused and thinking that sdc has been pulled,
> then replaced by sds, it should not be showing up as part of the BTRFS
> file system?  Or maybe there's a signature on sdc that BTRFS notices
> makes it part of the file system, even though BTRFS is now confused
> about it's location?

   See above.

> After a reboot, sdc returns and sds is gone again.

   Expected.

> The RAID controller has recently been replaced, but there where similar
> problems with the old one as well.  A better model of RAID controller
> was chosen this time.
> 
> I've also not been able to complete a scrub on this system recently.
> The really odd thing is that I get messages that the scrub has aborted,
> yet the scrub continues, then much later (days later) the scrub causes
> a kernel panic.  The "aborted" happens some random time into the scrub,
> but usually in the early part of the scrub.  Mind you, if BTRFS is
> completely confused due to a problem elsewhere, then maybe this can be
> excused.

   I think that means that it's aborting on one device but continuing
on all the others.

> The other backup server is almost identical, though it has less disks
> in the array.  It doesn't have any issues with the BTRFS file system.
> 
> Can any one help shed some light on this please?  Hopefully some
> "quick" things to try, given my definition of "recently" above means
> that most things take days or weeks, or even months for me to try.
> 
> I have attached the usual debugging info requested.  This is after the
> bogus sds replaces sdc.
> 

   The first thing would be to check your system logs for signs of
hardware problems (ATA errors). This sounds a lot like you've got a
dodgy disk that needs to be replaced.

   Hugo.

-- 
Hugo Mills             | A gentleman doesn't do damage unless he's paid for
hugo@... carfax.org.uk | it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                            Juri Papay

--qndya+I13rh6QJ0p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVzGl9AAoJEFheFHXiqx3kBrQP/jWA3WbRN1lNBXBlIFZfg32j
YRGU3PFW1Em3Jf5E5PE1DMPS9FGPNs+ONCGC3UUlJaStfv+ZtrDwrjTyYsozkXho
/HlzPOc6sC34DqsMqh9FRLvURgcc7nHAP1HBhV3Hy9br0cgzVpU6q0k58s+3ghj8
I17oqeqnJDOSCaCKoNUpLKNrv2JDZbP/E7Ndl4RCC5ZQ21mRhWji/iT36T8hpSny
yc4wym5983haGX9RPYrjXjenG5xIZwyiQLmxMSryGamlqrZLi5S6ZYmYKgG22Xp0
Ofd/+uyuf5oXuSYoNzrHgu3txKUHxSsIZBXng5V5FOuKrYsu7a7gFb4uvZGXntVV
QJAEi+qJ/w51eWvOWGmOal982XqOZX/T248YAjyzjbrSuiXgzVt3cQNe8o3KSlU0
lbOJwzWLabeyIMLYfquiuIichepRmCF4tF/Gz4Is3/HnWHvaLX6TZR8i2mzoYX/Z
a3KXl4eoz/Ok7lWzvZqQSTckw2BW6JLY+HhVFah2fvfDKwUnJLrQnb8ZW3VQsx/V
67d2vbnvuUdTFajhDPXs4rnwVEhZ0Xytvv5dAhSPA4b+TG86Msff2Dc/gd308+s1
NxpdBOz+AtXOKIZZZX8dPA9AiWk31/of0RdRf0Y3puk1uk/I9PofSmyXuZ4ltwfn
eELxzFdeos/NgNPUgOAT
=536X
-----END PGP SIGNATURE-----

--qndya+I13rh6QJ0p--
