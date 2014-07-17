Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56124 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbaGQIl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 04:41:57 -0400
Date: Thu, 17 Jul 2014 09:41:53 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is it safe to mount subvolumes of already-mounted volumes (even
 with different options)?
Message-ID: <20140717084153.GG4834@carfax.org.uk>
References: <53C6FA3D.9010803@informatik.uni-bonn.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
In-Reply-To: <53C6FA3D.9010803@informatik.uni-bonn.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 17, 2014 at 12:18:37AM +0200, Sebastian Ochmann wrote:
> I'm sharing a btrfs-formatted drive between multiple computers and each of
> the machines has a separate home directory on that drive. The root of the
> drive is mounted at /mnt/tray and the home directory for machine {hostname}
> is under /mnt/tray/Homes/{hostname}. Up until now, I have mounted /mnt/tray
> like a normal volume and then did an additional bind-mount of
> /mnt/tray/Homes/{hostname} to /home.

   You've said you're not sharing it concurrently, which is good -- as
long as you've only got one machine accessing it at the same time,
you're fine there.

> Now I have a new drive and wanted to do things a bit more advanced by
> creating subvolumes for each of the machines' home directories so that I can
> also do independent snapshotting. I guess I could use the bind-mount method
> like before but my question is if it is considered safe to do an additional,
> "regular" mount of one of the subvolumes to /home instead, like
> 
> mount /dev/sdxN /mnt/tray
> mount -o subvol=/Homes/{hostname} /dev/sdxN /home
> 
> When I experimented with such additional mounts of subvolumes of
> already-mounted volumes, I noticed that the mount options of the additional
> subvolume mount might differ from the "original" mount. For instance, the
> root volume might be mounted with "noatime" while the subvolume mount may
> have "relatime".
> 
> So my questions are: Is mounting a subvolume of an already mounted volume
> considered safe

   Yes, absolutely:

hrm@amelia:~$ mount | grep btrfs
/dev/sda2 on /boot type btrfs (rw,noatime,space_cache)
/dev/sda2 on /home type btrfs (rw,noatime,space_cache)
/dev/sda2 on /media/video type btrfs (rw,noatime,space_cache)
/dev/sda2 on /media/pipeline type btrfs (rw,noatime,space_cache)
/dev/sda2 on /media/snarf type btrfs (rw,noatime,space_cache)
/dev/sda2 on /media/audio type btrfs (rw,noatime,space_cache)
/dev/sda2 on /srv/nfs/home type btrfs (rw,noatime,space_cache)
/dev/sda2 on /srv/nfs/video type btrfs (rw,noatime,space_cache)
/dev/sda2 on /srv/nfs/testing type btrfs (rw,noatime,space_cache)
/dev/sda2 on /srv/nfs/pipeline type btrfs (rw,noatime,space_cache)
/dev/sda2 on /srv/nfs/audio type btrfs (rw,noatime,space_cache)
/dev/sda2 on /srv/nfs/nadja type btrfs (rw,noatime,space_cache)

> and are there any combinations of possibly conflicting mount
> options one should be aware of (compression, autodefrag, cache clearing)? Is
> it advisable to use the same mount options for all mounts pointing to the
> same physical device?

   If you assume that the first mount options are the ones used for
everything, regardless of any different options provided in subsequent
mounts, then you probably won't go far wrong. It's not quite true:
some options do work on a per-mount basis, but most are
per-filesystem. I'm sure there was a list of them on the wiki at some
point, but I can't seem to track it down right now.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Try everything once,  except incest and folk-dancing. ---      

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU8eMUVheFHXiqx3kAQKaBhAArsECOjszt/RpXlRTQCxFxudDUNwe/NeO
K9E8KQ2hHbc+UZVmfKHKvE9fg0U139F1FP015mHZqSafmIfHrCNE/XagstOdURHU
m6jwOpqhaBxoTCTmgPkWmsk6tlymhX4R0zmWyd7QXSQn4/xeiVy9/bnN4FbqRhZR
SYcHIUWQSaTyuljhZUuUO2/yzYhClieF6VjOA+uUO1HV2TwNrKNSb2NSZqeLZhzE
ASAjEIOWZ83XSBU7f6cwx8Jsh9W9QBgYVMskr2ADNz7wl+FVEs8bIDrxOBq7G/x+
LHmEjtlTY+TQKFNuqUx73FhwY/SFrneBAPekDzrQlAxtTpCuyKcdsfEpBjGuvshk
kQ/KAtzC5cy6xnus6N3+4BA8oYgTSP/4tI5l1mpw3bFwjqV6oJEQrKuMlPLGCo/d
wd/LUhPLGrZPqdobvMO7fYc8vIQrfl3hRHiAjHmrepauZnihsRx1WWRWXRFyuJ36
mxdSAzZoMDtEYvjX3UAhUX6dh5cMKUsBJiwuoNDP3AqszPwLUQtN4Z29jD57sccX
U2ayEzrFeXuLpLruEgBRLfgTBOYgOYlIQO0b61Qf31eR0YaewednBCXTLy/xGVgQ
AczF4neugcVL32efPim4g6o4hlfr/aLunVD/OxOTdjZBhxbzGGb9ooP8SOZGwVQR
URWKmDOclts=
=Yhlc
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
