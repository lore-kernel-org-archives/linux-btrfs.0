Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51659 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaAKR2m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 12:28:42 -0500
Date: Sat, 11 Jan 2014 17:28:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS over LVM remounts read-only
Message-ID: <20140111172841.GW15634@carfax.org.uk>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>
 <20140111150454.GV15634@carfax.org.uk>
 <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0LFOk513GRb+T2w"
In-Reply-To: <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--i0LFOk513GRb+T2w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 11, 2014 at 06:10:35PM +0100, MegaBrutal wrote:
> 2014/1/11 Hugo Mills <hugo@carfax.org.uk>:
> >
> > [60631.481913] attempt to access beyond end of device
> > [60631.481935] dm-1: rw=1073, want=42917896, limit=42917888
> > [60631.481941] btrfs_dev_stat_print_on_error: 34 callbacks suppressed
> > [60631.481949] btrfs: bdev /dev/mapper/vmhost--vg-vmhost--rootfs errs: wr 311347, rd 0, flush 0, corrupt 0, gen 0
> >
> >    This is the problem.
> >
> >    It looks like you've shrunk the LV without first shrinking the
> > filesystem. Depending on how much you shrunk it by, the odds are
> > fairly good that significant chunks of the FS are now toast.
> >
> >    Hugo.
> >
> 
> Thank you very much! Strange, I indeed shrinked the LV, but only by a
> few megabytes to make space for /boot (as turned out, GRUB2 can't boot
> from LVM), and I think I did shrink the FS too... But maybe not. As it
> started out as a test system, I intentionally wanted to test some
> obscure situations here. Thankfully I don't have considerable data
> loss and I don't think any valuable data was on the space that was cut
> off. Strange that the system was running like this for a month with
> this problem being undetected.
> 
> How can I shrink the FS to the correct size right now, ensuring that I
> really shrink it to the exact LV size?

   In the current state, I'm not sure that you can -- the FS metadata
still thinks that there's some data stored at an address that's off
the end of the LV, and it'll try to read it if you attempt to shrink
the FS.

   You may be able to enlarge the LV up to the size it was before, and
then shrink, but you'll probably get EIO from the filesystem because
the checksums for the (un)dead area don't match any more (assuming
that the data in question has been overwritten by something else in
the mean time).

   I suspect that we need some kind of "yes, I know the data's
buggered, but carry on regardless" option for a lot of commands, like
resize(shrink), device delete, device replace. This would help in the
case where a lo-fi recovery is acceptable.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "Your problem is that you have a negative personality." ---     
                             "No,  I don't!"                             

--i0LFOk513GRb+T2w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUtF/SFheFHXiqx3kAQL6WBAAo24zLrXhtxbd3vzd//vIgc59HvOPUXk+
gAK1uDlNSQbnXo5eOp+Odzkmf3h7vkHwfLmWHjcbEoBGnKss6RNL4n2ZaROaa1aT
+9zf+DBNp83QMNmooPyjLGTAGZfk9OR6rVneU6hlk5OeK5C8AvkUtqmaCTm+/V8Y
bUkD+sd/Cv+Ag/E/PdRUicnMMq8GFQHpI0Ba8+BKkaLsuNj1P02Djw4MPDVXP3Bu
Y3GAxHGeZnarGt2mDrMKpt4BqzuXRENZ644y8n4zPEvaUfLXJR3dyNfpOgAU9XYT
VoIsRQ5E45dTXQc/xvR+9MBaWPtLZP8vYYsTh+6L5FPYEyXfJYVS/8tL55E/1dHZ
x2IavtYXIcHqMV1DX4lHM6wf3Uo+3z1lXEt+zmJzq1hN8J/jisYxZptQoWvBSTts
vU5QW0dvPfg6mh+nOqJ+4WnCOmfNWvHA1PozUE2SXSlr0NQBI6+JGP3Kc6FS7xiM
MKWUqDOFhz5jv/20h9bAqR+AHbPrWWtYRgdxJkRMq1J3sUl0AnL1HV015eXhmjQT
DT9NN/euR8+WP5IQfjrdtH2V0E8mKBkDTX3hfkNKCR865Q/w+QhxtabxAHM/qS8T
ivq9N5hZe9oRMn8U5d3qmlhjwkx3LTUT/XTUklrY+hQNyiHmmBdTaN4QWpRNmfyP
eU4xGk5Jys4=
=0kjz
-----END PGP SIGNATURE-----

--i0LFOk513GRb+T2w--
